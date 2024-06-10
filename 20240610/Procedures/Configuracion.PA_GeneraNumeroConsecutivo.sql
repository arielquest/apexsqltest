SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Jonathan Aguilar Navarro>
-- Fecha Creación:		<04/03/2019>
-- Descripcion:			<Se obtiene el número consecutivo según el tipo recibido
-- =================================================================================================================================================
-- Modificación:		<11/03/2019><Aida Elena Siles Rojas><Se modifica para generar consecutivo de carpetas para la defensa pública>
-- Modificación:		<08/08/2019><Ronny Ramírez Rojas><Se modifica para generar consecutivo de Comunicación>
-- Modificación:		<11/12/2019><Ronny Ramírez Rojas><Se modifica para generar consecutivo de Objeto.Objeto>
-- Modificación:		<24/02/2020><Daniel Ruiz Hernández><Se modifica para que se valide que el NUE generado por consecutivo no exista en la base de datos.>
-- Modificación:		<27/02/2020><Kirvin Bennett Mathurin><Se modifica para generar consecutivo de Entregas>
-- Modificación:		<26/06/2020><Wagner Vargas Sanabria><Se modifica el consecutivo de expediente para coincida con el estandar - BUG 122635>
-- Modificación:		<08/02/2021><Karol Jiménez Sánchez><Se agrega consecutivo para carpeta Gestión, para ligarlo en la creación de expedientes y legajos>
-- Modificación:		<09/02/2021><Karol Jiménez Sánchez><Se agrega consecutivo para IDINT Gestión, para ligarlo en la creación de INTervenciones>
-- Modificación:		<22/02/2021><Karol Jiménez Sánchez><Se ajusta consecutivo IDINT Gestión, para que no sea por periodo>
-- Modificación:		<23/07/2021><Xinia Soto><Se ajusta consecutivo Expediente para que use With(Rowlock) en el update>
-- Modificación:		<16/12/2022><Aaron Rios Retana><Se realiza ajuste para obtener consecutivos de manera parametrizada, se añaden como parametros 
--	opcionales para no afectar la antigua funcionalidad>
-- =================================================================================================================================================
CREATE PROCEDURE [Configuracion].[PA_GeneraNumeroConsecutivo]
	@CodContexto			VARCHAR(4),
	@TipoConsecutivo		CHAR(1) = NULL,
	@DesCodConsecutivo			VARCHAR(10) = NULL,
	@ConsecutivoDescripcion VARCHAR(150) = NULL
As
Begin

	DECLARE @Periodo INT
	DECLARE @Materia VARCHAR(2)
	DECLARE @Descripcion VARCHAR(150)
	DECLARE	@L_CodigoContexto VARCHAR(4) = @CodContexto
	DECLARE @L_CodigoConsecutivo VARCHAR(10) = @DesCodConsecutivo
	DECLARE	@L_ConsecutivoDescripcion VARCHAR(150)= @ConsecutivoDescripcion

	Set @Periodo = DATEPART(YEAR, GETDATE())	
	
	SELECT		@Materia				= B.TC_CodMateria
	FROM		Catalogo.Contexto		AS B WITH(NOLOCK)
	WHERE		B.TC_CodContexto		= @L_CodigoContexto	

	IF @L_CodigoConsecutivo IS NULL AND @L_ConsecutivoDescripcion IS NULL
	BEGIN 
		IF @TipoConsecutivo = 'E' 
		BEGIN
			DECLARE @ConsecutivoNue VARCHAR(6),		
			        @SumaConsecutivo INT = 1;
			SET @Descripcion = 'Consecutivo para administrar el número único de los expedientes (NUE) por contexto y periodo.';
			
			IF Not Exists(SELECT * FROM Configuracion.Consecutivo WITH(NOLOCK) WHERE TN_Periodo = @Periodo And TC_CodContexto = @L_CodigoContexto and TC_CodConsecutivo = 'Expediente')	
			BEGIN      	
				INSERT INTO Configuracion.Consecutivo WITH(ROWLOCK)
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				VALUES  ('Expediente',		@L_CodigoContexto,	@Periodo,	0, 				NULL,				@Descripcion,		GETDATE());
			END
			

			WHILE @SumaConsecutivo > 0 
			BEGIN
				SELECT @ConsecutivoNue = RIGHT('000000' + CONVERT(VARCHAR,TN_Consecutivo + @SumaConsecutivo) ,6) 
				FROM Configuracion.Consecutivo
				WHERE	TN_Periodo			= @Periodo		
				AND    	TC_CodContexto		= @L_CodigoContexto	
				And		TC_CodConsecutivo	= 'Expediente';
			
				IF (
					SELECT COUNT(*) +
						(SELECT COUNT(*) 
						FROM	Expediente.ExpedientePreasignado B WITH(NOLOCK) 
						WHERE	B.TC_NumeroExpediente	= CONVERT(VARCHAR, SUBSTRING(CONVERT(VARCHAR,@Periodo),3,4)) + @ConsecutivoNue + @L_CodigoContexto + @Materia 
						AND		B.TC_Estado			= 'R')
					FROM Expediente.Expediente A WITH(NOLOCK) 
					WHERE A.TC_NumeroExpediente = CONVERT(VARCHAR, SUBSTRING(CONVERT(VARCHAR,@Periodo),3,4)) + @ConsecutivoNue + @L_CodigoContexto + @Materia			
				) = 0 
				BEGIN 
					UPDATE	Configuracion.Consecutivo WITH(ROWLOCK)
					SET		TN_Consecutivo		= TN_Consecutivo + @SumaConsecutivo, 
							@ConsecutivoNue		= RIGHT('000000' + CONVERT(VARCHAR,TN_Consecutivo + @SumaConsecutivo) ,6),
							TF_Actualizacion	= GETDATE()
					WHERE	TN_Periodo			= @Periodo		
					AND    	TC_CodContexto		= @L_CodigoContexto	
					AND		TC_CodConsecutivo	= 'EXPEDIENTE';
					SET @SumaConsecutivo = 0;
				END
				ELSE
				BEGIN
					SET @SumaConsecutivo = @SumaConsecutivo + 1;
				END;
			END;

			SELECT CONVERT(VARCHAR, SUBSTRING(CONVERT(VARCHAR,@Periodo),3,4)) + @ConsecutivoNue + @L_CodigoContexto + @Materia;
		END;
		
		If @TipoConsecutivo = 'C' 
		Begin
			DECLARE @ConsecutivoNRD VARCHAR(6)		
			Set @Descripcion = 'Consecutivo para administrar el número único de carpetas (NRD) para la defensa pública por contexto y periodo.'
			If Not Exists(SELECT * From Configuracion.Consecutivo WITH(NOLOCK) WHERE TN_Periodo = @Periodo And TC_CodContexto = @CodContexto and TC_CodConsecutivo = 'C')	
			Begin      	
				Insert INTo Configuracion.Consecutivo
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				Values  ('C',				@CodContexto,	@Periodo,	0, 				NULL,				@Descripcion,		GETDATE())
			End

			Update	Configuracion.Consecutivo
			Set		TN_Consecutivo		= TN_Consecutivo + 1, 
					@ConsecutivoNRD		= right('000000' + Convert(VARCHAR,TN_Consecutivo + 1) ,6),
					TF_Actualizacion	= GETDATE()
			WHERE	TN_Periodo			= @Periodo		
			And    	TC_CodContexto		= @CodContexto	
			And		TC_CodConsecutivo	= 'C'

			SELECT Convert(VARCHAR, Convert(VARCHAR,@Periodo)) + @ConsecutivoNRD
		End
			
		-- Genera el número de comunicación Ejemplo: NOTI16PE0515000001, Tipo de comunicación. (I) Citación = CIT, (N) Notificación = NOT, (O) Comunicado = COM.
		If @TipoConsecutivo = 'I' OR @TipoConsecutivo = 'O' OR @TipoConsecutivo = 'N'
		Begin
			
			DECLARE @ConsecutivoNueC VARCHAR(6)
			DECLARE @CodConsecutivo VARCHAR(3)
			DECLARE @CodigoConsecutivo VARCHAR(10)	

			if @TipoConsecutivo = 'I'
				BEGIN		
					SET	 @CodConsecutivo='CIT'	 
					SET	 @CodigoConsecutivo='REG_COMCIT'
				END
				Else
				BEGIN
					if @TipoConsecutivo = 'O'		
					BEGIN
						SET  @CodConsecutivo='COM'	 
						SET  @CodigoConsecutivo='REG_COMCOM'
					END
					ElSE
					BEGIN
						if @TipoConsecutivo = 'N'	
							BEGIN
								SET @CodConsecutivo='NOT'	 
								SET @CodigoConsecutivo='REG_COMNOT'
							END	 
						ELSE
							THROW 60000, 'El tipo de comunicación no es válido', 1;
					END
				END

				--1.Si no existe o esta vencido crea el registro para el AÑO ACTUAL 
				If Not Exists(
								SELECT * 
								From Configuracion.Consecutivo  WITH(NOLOCK) 
								WHERE TN_Periodo				= @Periodo 
								And TC_CodContexto				= @CodContexto
								And TC_CodConsecutivo			= @CodigoConsecutivo
							 )
				Begin      	
					Insert INTo Configuracion.Consecutivo
					(
						TC_CodConsecutivo,	TC_CodContexto,	    
						TN_Periodo,			TN_Consecutivo,
						TC_Descripcion,     TF_Desactivacion,	
						TF_Actualizacion
					)
					Values  
					(
						'REG_COMCIT',@CodContexto,	@Periodo,	0, 	'Consecutivo para el registro de nuevas comunicaciones de tipo citación.',			NULL,				GETDATE()
					)

					Insert INTo Configuracion.Consecutivo
					(
						TC_CodConsecutivo,	TC_CodContexto,	    
						TN_Periodo,			TN_Consecutivo,
						TC_Descripcion,     TF_Desactivacion,	
						TF_Actualizacion
					)
					Values  
					(
						'REG_COMCOM',@CodContexto,	@Periodo,	0, 	'Consecutivo para el registro de nuevas comunicaciones de tipo comunicado.',		NULL,				GETDATE()
					)

					Insert INTo Configuracion.Consecutivo
					(
						TC_CodConsecutivo,	TC_CodContexto,	    
						TN_Periodo,			TN_Consecutivo,
						TC_Descripcion,     TF_Desactivacion,	
						TF_Actualizacion
					)
					Values  
					(
						'REG_COMNOT',@CodContexto,	@Periodo,	0, 	'Consecutivo para el registro de nuevas comunicaciones de tipo notificación.',		NULL,				GETDATE()
					)

				END            

				--2.Obtener consecutivo

				Update	Configuracion.Consecutivo	With(Rowlock)
				Set		TN_Consecutivo				= TN_Consecutivo + 1, 
						@ConsecutivoNueC				= right('000000' + Convert(VARCHAR,TN_Consecutivo + 1) ,6),
						TF_Actualizacion			= GETDATE()
				WHERE	TN_Periodo					= @Periodo		
				And    
						TC_CodContexto				= @CodContexto	
				And
						[TC_CodConsecutivo]			= @CodigoConsecutivo
			
			
				 --3. Obtiene el año en 2 digitos
				SELECT @CodConsecutivo + Convert(VARCHAR, Substring(Convert(VARCHAR,@Periodo),3,4)) + @Materia + @CodContexto + @ConsecutivoNueC    
		END
		
		-- Genera el número de consecutivo de Objeto.Objeto Ejemplo: 19-1.
		If @TipoConsecutivo = 'B'
		Begin
			DECLARE @ConsecutivoB SMALLINT,
					@L_CodContexto VARCHAR(4) = '0000'
			Set @Descripcion = 'Consecutivo para administrar el número único de objeto de la tabla Objeto.Objeto, por periodo.'
			If Not Exists(SELECT * From Configuracion.Consecutivo WITH(NOLOCK) WHERE TN_Periodo = @Periodo And TC_CodConsecutivo = 'OBJETO')	
			Begin      	
				Insert INTo Configuracion.Consecutivo
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				Values  ('OBJETO',			@L_CodContexto,			@Periodo,	0, 				NULL,				@Descripcion,		GETDATE())
			End

			Update	Configuracion.Consecutivo
			Set		TN_Consecutivo		= TN_Consecutivo + 1, 
					@ConsecutivoB		= TN_Consecutivo + 1,
					TF_Actualizacion	= GETDATE()
			WHERE	TN_Periodo			= @Periodo		
			And    	TC_CodContexto		= @L_CodContexto
			And		TC_CodConsecutivo	= 'OBJETO'

			SELECT Convert(VARCHAR, Substring(Convert(VARCHAR,@Periodo),3,4)) + '-' +  Convert(VARCHAR,@ConsecutivoB)
		END

		-- Genera el número de consecutivo de las Entregas Ejemplo: 19-2020.
		If @TipoConsecutivo = 'G'
		Begin
			DECLARE @ConsecutivoG SMALLINT,
					@L_CodContextoG VARCHAR(4) = '0000'
			Set @Descripcion = 'Consecutivo para administrar el número único de las entregas de escritos y demandas, por periodo.'
			If Not Exists(SELECT * From Configuracion.Consecutivo WITH(NOLOCK) WHERE TN_Periodo = @Periodo And TC_CodConsecutivo = 'ENTREGA')	
			Begin      	
				Insert INTo Configuracion.Consecutivo
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				Values  ('ENTREGA',			@L_CodContextoG,			@Periodo,	0, 				NULL,				@Descripcion,		GETDATE())
			End

			Update	Configuracion.Consecutivo
			Set		TN_Consecutivo		= TN_Consecutivo + 1, 
					@ConsecutivoG		= TN_Consecutivo + 1,
					TF_Actualizacion	= GETDATE()
			WHERE	TN_Periodo			= @Periodo		
			And    	TC_CodContexto		= @L_CodContextoG
			And		TC_CodConsecutivo	= 'ENTREGA'

			SELECT Convert(VARCHAR,@ConsecutivoG) + '-' +  Convert(VARCHAR, @Periodo)
		End

		--Genera el número de consecutivo de las carpetas de Gestión Ejemplo: 20210295000001 (Año + Código Contexto + Consecutivo 6 digitos).
		--Este campo se registra en los expedientes y legajos de SIAGPJ para la INTegración entre sistemas
		If @TipoConsecutivo = 'S' 
		Begin
			DECLARE @ConsecutivoCarpeta VARCHAR(6)		
			Set @Descripcion = 'Consecutivo para administrar el número único de carpeta, para los expedientes y legajos, por contexto y periodo.'
			If Not Exists(SELECT * From Configuracion.Consecutivo WITH(NOLOCK) WHERE TN_Periodo = @Periodo And TC_CodContexto = @CodContexto and TC_CodConsecutivo = 'CarpetaGes')	
			Begin      	
				Insert INTo Configuracion.Consecutivo
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				Values  ('CarpetaGes',		@CodContexto,	@Periodo,	0, 				NULL,				@Descripcion,		GETDATE())
			End

			Update	Configuracion.Consecutivo
			Set		TN_Consecutivo		= TN_Consecutivo + 1, 
					@ConsecutivoCarpeta	= right('000000' + Convert(VARCHAR,TN_Consecutivo + 1) ,6),
					TF_Actualizacion	= GETDATE()
			WHERE	TN_Periodo			= @Periodo		
			And    	TC_CodContexto		= @CodContexto	
			And		TC_CodConsecutivo	= 'CarpetaGes'

			SELECT Convert(VARCHAR, Convert(VARCHAR,@Periodo)) + @CodContexto + @ConsecutivoCarpeta
		End

		--Genera el número de consecutivo de las IDINT de Gestión Ejemplo: 2950000001 (numdej + Consecutivo).
		--Este campo se registra en las INTervenciones SIAGPJ para la INTegración entre sistemas
		If @TipoConsecutivo = 'A' 
		Begin
			DECLARE @L_ConsecutivoIdINT		VARCHAR(7),
					@L_NUMDEJ				VARCHAR(4),
					@L_LongitudConsecutivo	VARCHAR(7);

			SELECT	@L_NUMDEJ				= CONVERT(VARCHAR(4), NUMDEJ),
					@L_LongitudConsecutivo	=	CASE WHEN LEN(CONVERT(VARCHAR(4), NUMDEJ)) = 3 AND NUMDEJ < 213 
														THEN '0000000'
													ELSE '000000'
												END
			From	Catalogo.Contexto		WITH(NOLOCK) 
			WHERE	TC_CodContexto			= @CodContexto

			Set @Descripcion = 'Consecutivo para administrar el IDINT, para las INTervenciones y por contexto'
			If Not Exists(SELECT * From Configuracion.Consecutivo WITH(NOLOCK) WHERE TC_CodContexto = @CodContexto and TC_CodConsecutivo = 'IDINT')	
			Begin      	
				Insert INTo Configuracion.Consecutivo
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				Values  ('IDINT',			@CodContexto,	0,			0, 				NULL,				@Descripcion,		GETDATE())
			End

			Update	Configuracion.Consecutivo
			Set		TN_Consecutivo		= TN_Consecutivo + 1, 
					@L_ConsecutivoIdINT	= right(@L_LongitudConsecutivo + Convert(VARCHAR,TN_Consecutivo + 1),LEN(@L_LongitudConsecutivo)),
					TF_Actualizacion	= GETDATE()
			WHERE	TC_CodContexto		= @CodContexto	
			And		TC_CodConsecutivo	= 'IDINT'

			SELECT  @L_NUMDEJ + @L_ConsecutivoIdINT
		End
	END
	ELSE
	BEGIN
	--Se genera o crea el consecutivo de manera dinamica utilizando parametros para el codigo del consecutivo y su respectiva descripcion
		DECLARE @Consecutivo VARCHAR(6)		
			Set @Descripcion = @L_ConsecutivoDescripcion
			If Not Exists(	SELECT * 
							From Configuracion.Consecutivo WITH(NOLOCK) 
							WHERE TN_Periodo = @Periodo And TC_CodContexto = @CodContexto and TC_CodConsecutivo = @L_CodigoConsecutivo)	
			Begin      	
				Insert INTo Configuracion.Consecutivo
						(TC_CodConsecutivo, TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TC_Descripcion,		TF_Actualizacion)
				Values  (@L_CodigoConsecutivo,		@CodContexto,	@Periodo,	0, 				NULL,				@Descripcion,		GETDATE())
			End

			Update	Configuracion.Consecutivo
			Set		TN_Consecutivo		= TN_Consecutivo + 1, 
					@Consecutivo		= Convert(VARCHAR,TN_Consecutivo + 1),
					TF_Actualizacion	= GETDATE()
			WHERE	TN_Periodo			= @Periodo		
			And    	TC_CodContexto		= @CodContexto	
			And		TC_CodConsecutivo	= @L_CodigoConsecutivo

			SELECT Convert(VARCHAR,  @Consecutivo + ' Inventario '+ Convert(VARCHAR,@Periodo))
	END
End
GO
