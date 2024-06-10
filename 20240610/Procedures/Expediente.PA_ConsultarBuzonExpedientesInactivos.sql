SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Rafa Badilla Alvarado>
-- Fecha de creación:		<25/11/2022>
-- Descripción :			<Permite consultar los registro para del buzón de expedientes inactivos
-- ===============================================================================================================================================================================
-- Modificación:	<25/01/2023> Modificado: <Jefferson Parker>  Descripción : Se  agrega oficina de le catalogo para retornar la oficina donde esta el legajo o expediente.
-- Modificación:	<17/02/2023> Modificado: <Rafa Badilla A> Descripción : Se ajusta para mostrar datos únicamnente del estado más reciente del expediente o legajo.
-- Modificación:	<21/02/2023> Modificado: <Rafa Badilla A> Descripción : Se elimina el campo tiene escritos, debido a que se eliminó de la tabla [Expediente].[DetalleDepuracionInactivo].
-- Modificación:	<27/02/2023> Modificado: <Rafa Badilla A> Descripción : Se ajusta para mostrar datos únicamnente del estado más reciente del expediente o legajo.
-- Modificación:	<13/04/2023> Modificado: <Rafa Badilla A> Descripción : Agregar campo fecha de entrada a los datos que devuelve la consulta.
-- Modificación:	<18/05/2023> Modificado: <Jose Gabriel Cordero Soto> Descripción: Solucion a BUG 317499 por tema de que al indicar filtrado Con Error no se reflejaban 
--					registros, por lo que se determino realizar el condicional de @L_TieneErrores IS NULL
-- Modificación:	<24/05/2023> Modificado: <Jose Gabriel Cordero Soto> Descripción: Solucion a BUG 318069 se modifica consulta para obtener registros de expedientes y legajos
--					candidatos para obtener solo los que tienen registros en movimiento activo>
-- Modificación:	<19/06/2023> Modificado: <Rafa Badilla Alvarado> Descripción: Solucion a BUG 317499 se agregan algunos valores que hacian falta al friltro de estado, 
--					esto para incluir todos los tipos de estado que representan error.
-- Modificación:	<20/06/2023> Modificado: <Rafa Badilla Alvarado> Descripción: Se ajusta el ordenamiento para que sea por número de expediente descendente.
-- Modificación:	<06/10/2023> Modificado: <Karol Jiménez Sánchez><PBI 300119 - Se agrega filtro por Embargos Físicos>
--==============================================================================================================================================================================
CREATE     PROCEDURE [Expediente].[PA_ConsultarBuzonExpedientesInactivos]
  	@NumeroPagina				INT,
	@CantidadRegistros			INT,	
	@CodigoSolicitud			BIGINT,
	@NumeroExpediente			VARCHAR(14)	=	NULL,
	@TieneDepositos				BIT			=	NULL,
	@TieneMandamientos			BIT			=	NULL,
	@TieneEmbargosFisicos		BIT			=	NULL,
	@TieneErrores				CHAR		=	NULL,
	@EsCargaInicial				BIT			=   NULL
AS 
BEGIN
	--VARIABLES
	DECLARE	  @L_CodSolicitud			BIGINT		=   @CodigoSolicitud,
			  @L_NumeroPagina			INT			=	@NumeroPagina,
			  @L_CantidadRegistros		INT			=	@CantidadRegistros,
			  @L_NumeroExpediente		VARCHAR(14)	=	@NumeroExpediente,
			  @L_TieneDepositos			BIT			=	@TieneDepositos,
			  @L_TieneMandamientos		BIT			=	@TieneMandamientos,
			  @L_TieneEmbargosFisicos	BIT			=	@TieneEmbargosFisicos,
			  @L_TieneErrores			CHAR		=	@TieneErrores,
			  @L_EsCargaInicial			BIT			=	@EsCargaInicial


	DECLARE @ExpedientesInactivos AS TABLE
		(	CodigoDepuracionInactivo		INT,
			CodigoSolicitud					INT,
			NumeroExpediente				CHAR(14),
			CodigoLegajo					UNIQUEIDENTIFIER,
			FechaUltimoAcontecimiento		DATETIME2(2),
			TipoUltimoAcontecimiento		CHAR(1),					--Es un enumerable
			TieneDepositos					BIT,
			TieneMandamientos				BIT,
			TieneEmbargos					BIT,
			EstadoMigracion					CHAR(1),					--Estado de la migración de datos 
			ResultadoMigracion				VARCHAR(200),				--Resultado de la migración
			Clase							VARCHAR(200),
			Asunto							VARCHAR(200),
			ClaseAsunto						VARCHAR(100),
			Fase							VARCHAR(255),
			Estado							VARCHAR(200),				--Estado legajo o expediente
			FechaEntrada					DATETIME2(2),				--Fecha de entrada del  legajo o expediente
			Observaciones					VARCHAR(255),				--Observaciones del legajo o expediente
			CodigoUbicacion					INT,
			Ubicacion						VARCHAR(255),
			CodigoTarea						UNIQUEIDENTIFIER,
			DescripcionTarea				VARCHAR(255),
			MensajeTarea					VARCHAR(255),
			UsuarioRedTarea					VARCHAR(50),
			TecnicoTarea					VARCHAR(150),
			CodigoOficina					VARCHAR(4))

	IF( @L_NumeroPagina is null) SET @L_NumeroPagina=1;

	IF( @L_EsCargaInicial = 1) 
	BEGIN
		SET @L_TieneDepositos		=	NULL 
		SET @L_TieneMandamientos	=	NULL
		SET	@L_TieneErrores			=	NULL;
	END

	IF(@L_TieneErrores IS NULL)
	BEGIN
		--CONSULTA DE LEGAJOS
		INSERT INTO @ExpedientesInactivos(
					CodigoDepuracionInactivo,
					CodigoSolicitud,
					NumeroExpediente,
					CodigoLegajo,
					FechaUltimoAcontecimiento,
					TipoUltimoAcontecimiento,			--Es un enumerable
					TieneDepositos,
					TieneMandamientos,
					TieneEmbargos,
					EstadoMigracion,					--Estado de la migración de datos 
					ResultadoMigracion,					--Resultado de la migración
					Clase,
					Asunto,
					ClaseAsunto,
					Fase,
					Estado,								--Estado legajoo expediente
					FechaEntrada,						--Fecha de entrada del  legajo o expediente
					Observaciones,						--Observaciones del legajo o expediente
					CodigoUbicacion,
					Ubicacion,
					CodigoTarea,
					DescripcionTarea,
					MensajeTarea,
					UsuarioRedTarea,
					TecnicoTarea,
					CodigoOficina)
		SELECT	     [TN_CodDetalleDepuracion]												 as CodigoDepuracionInactivo       
					,[TN_CodSolicitud]														 as CodigoSolicitud 
					,A.[TC_NumeroExpediente]												 as NumeroExpediente
					,A.[TU_CodLegajo]														 as CodigoLegajo              
					,[TF_UltimoAcontecimiento]												 as FechaUltimoAcontecimiento
					,[TC_TipoAcontecimiento]												 as TipoUltimoAcontecimiento	--Es un enumerable
					,[TB_TieneDepositos]													 as TieneDepositos
					,[TB_TieneMandamientos]													 as TieneMandamientos
					,[TB_TieneEmbargos]														 as TieneEmbargos						
					,[TC_Estado]															 as EstadoMigracion				--Estado de la migración de datos 
					,[TC_Resultado]															 as ResultadoMigracion			--Resultado de la migración
					,null           														 as Clase   --F.TC_Descripcion
					,D.TC_Descripcion														 as Asunto
					,E.TC_Descripcion														 as ClaseAsunto
					,H.TC_Descripcion														 as Fase
					,SUBSTRING(A.TC_DescripcionEstado, 0, 200)								 as Estado						--Estado Legajo
					,B.TF_Entrada															 as FechaEntrada				--Fecha de entrada del  legajo o expediente
					,C.TC_Descripcion														 as Observaciones				--Observaciones del legajo
					,K.TN_CodUbicacion														 as CodigoUbicacion
					,K.TC_Descripcion														 as Ubicacion
					,I.CodigoTarea															 as CodigoTarea
					,I.Descripcion															 as DescripcionTarea
					,SUBSTRING(I.Mensaje, 0, 254)											 as MensajeTarea
					,I.UsuarioRed															 as UsuarioRedTarea
					,I.Nombre + ' ' + I.PrimerApellido	+ ' ' + I.SegundoApellido			 as TecnicoTarea
					,M.TC_CodOficina														 as CodigoOficina
	   FROM			[Expediente].[DetalleDepuracionInactivo]							     A WITH (NOLOCK)
	   INNER JOIN	[Expediente].[LegajoDetalle]										     B WITH (NOLOCK) 
	   ON			B.TU_CodLegajo														     = A.TU_CodLegajo
	   INNER JOIN	[Expediente].[Legajo]												     C WITH (NOLOCK) 
	   ON			C.TU_CodLegajo														     = A.TU_CodLegajo
	   INNER JOIN	[Catalogo].[Contexto]												     M WITH (NOLOCK) 
	   ON			M.TC_CodContexto													     = C.TC_CodContexto
	   INNER JOIN   [Catalogo].[Asunto]													     D WITH (NOLOCK) 
	   ON			D.TN_CodAsunto														     = B.TN_CodAsunto
	   INNER JOIN   [Catalogo].ClaseAsunto												     E WITH (NOLOCK) 
	   ON			E.TN_CodClaseAsunto													     = B.[TN_CodClaseAsunto]
   
	   --OBTIENE INFORMACION DEL EXPEDIENTE DETALLE
	   OUTER APPLY	 ( SELECT TOP 1 TC_NumeroExpediente, 
									TN_CodClase, 
									TN_CodFase, 
									TC_CodContexto
					   FROM			[Expediente].[ExpedienteDetalle]	WITH (NOLOCK)
					   WHERE		TC_NumeroExpediente					= A.TC_NumeroExpediente
					   ORDER BY		TF_Entrada DESC
					 ) G
	   INNER JOIN    [Catalogo].Fase													     H WITH (NOLOCK) 
	   ON			 H.TN_CodFase														     = G.TN_CodFase

	   --OBTIENE INFORMACION DE LA DESCRIPCION DE LA TAREA
		OUTER APPLY	(	SELECT TOP 1	X.TN_CodTarea						Codigo,
										W.TC_Descripcion					Descripcion,
										X.TU_CodTareaPendiente				CodigoTarea,
										X.TC_Mensaje						Mensaje,
										V.TC_UsuarioRed						UsuarioRed,
										V.TC_Nombre							Nombre,
										V.TC_PrimerApellido					PrimerApellido,
										V.TC_SegundoApellido				SegundoApellido
						FROM			Expediente.TareaPendiente			X WITH(NOLOCK)
						INNER JOIN		Catalogo.Tarea						W WITH(NOLOCK)	
						ON				W.TN_CodTarea						= X.TN_CodTarea
						INNER JOIN		Catalogo.PuestoTrabajoFuncionario	Y WITH(NOLOCK)	
						ON				Y.TC_CodPuestoTrabajo				= X.TC_CodPuestoTrabajoDestino
						INNER JOIN		Catalogo.Funcionario				V WITH(NOLOCK)	
						ON				V.TC_UsuarioRed						= Y.TC_UsuarioRed
						WHERE			X.TU_CodLegajo						= A.TU_CodLegajo
						ORDER BY		X.TF_Actualizacion	DESC
					) I 
	
		--OBTIENE LA UBICACION DEL LEGAJO 
		OUTER APPLY	(
						SELECT TOP 1	R.TN_CodUbicacion
										,C.TC_Descripcion
						FROM			Historico.LegajoUbicacion			R WITH(NOLOCK)
						INNER JOIN		Catalogo.Ubicacion					C WITH(NOLOCK)
						ON				C.TN_CodUbicacion					= R.TN_CodUbicacion
						WHERE			R.TC_NumeroExpediente				= A.TC_NumeroExpediente
						AND				R.TU_CodLegajo						= A.TU_CodLegajo
						AND				R.TC_CodContexto					= B.TC_CodContexto
						ORDER BY		TF_FechaUbicacion	DESC
					) K	

	   WHERE		[TN_CodSolicitud]				= @L_CodSolicitud
					AND A.[TC_NumeroExpediente]		=	ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)	
					AND A.[TB_TieneDepositos]		=	ISNULL(@L_TieneDepositos, [TB_TieneDepositos])
					AND A.[TB_TieneMandamientos]	=	ISNULL(@L_TieneMandamientos, [TB_TieneMandamientos])
					AND A.[TC_Estado]				=	ISNULL(@L_TieneErrores, [TC_Estado])	
					AND	A.TB_TieneEmbargos			=	ISNULL(@L_TieneEmbargosFisicos, A.TB_TieneEmbargos)

	   UNION

	--CONSULTA DE EXPEDIENTES
	   SELECT	 [TN_CodDetalleDepuracion]														as CodigoDepuracionInactivo     
				,[TN_CodSolicitud]																as CodigoSolicitud 
				,A.[TC_NumeroExpediente]														as NumeroExpediente
				,A.[TU_CodLegajo]																as CodigoLegajo
				,[TF_UltimoAcontecimiento]														as FechaUltimoAcontecimiento
				,[TC_TipoAcontecimiento]														as TipoUltimoAcontecimiento	--Es un enumerable
				,[TB_TieneDepositos]															as TieneDepositos
				,[TB_TieneMandamientos]															as TieneMandamientos
				,[TB_TieneEmbargos]																as TieneEmbargos
				,[TC_Estado]																	as EstadoMigracion				--Estado de la migración de datos 
				,[TC_Resultado]																	as ResultadoMigracion			--Resultado de la migración
				,F.TC_Descripcion																as Clase
				,null																			as Asunto
				,null																			as ClaseAsunto
				,H.TC_Descripcion																as Fase
				,SUBSTRING(A.TC_DescripcionEstado, 0, 200)										as Estado						--Estado Expediente
				,B.TF_Entrada																	as FechaEntrada					--Fecha de entrada del  legajo o expediente
				,C.TC_Descripcion																as Observaciones				--Observaciones del Expediente
				,K.TN_CodUbicacion																as CodigoUbicacion
				,K.TC_Descripcion																as Ubicacion
				,I.CodigoTarea																	as CodigoTarea
				,I.Descripcion																	as DescripcionTarea
				,SUBSTRING(I.Mensaje, 0, 254)													as MensajeTarea
				,I.UsuarioRed																	as UsuarioRedTarea
				,I.Nombre + ' ' + I.PrimerApellido	+ ' ' + I.SegundoApellido					as TecnicoTarea
				,M.TC_CodOficina																as CodigoOficina
			
	  FROM		[Expediente].[DetalleDepuracionInactivo]										A WITH (NOLOCK)
		--OBTIENE INFORMACION DEL EXPEDIENTE DETALLE
		OUTER APPLY	 ( SELECT TOP 1 TC_NumeroExpediente, 
									TN_CodClase, 
									TN_CodFase, 
									TC_CodContexto, 
									TF_Entrada
					   FROM			[Expediente].[ExpedienteDetalle]	WITH(NOLOCK)
					   WHERE		TC_NumeroExpediente					= A.TC_NumeroExpediente
					   ORDER BY		TF_Entrada DESC
					 ) B
		INNER JOIN	[Expediente].[Expediente]													C WITH (NOLOCK)  
		ON			C.TC_NumeroExpediente														= B.TC_NumeroExpediente
		INNER JOIN	[Catalogo].Clase															F WITH (NOLOCK)  
		ON			F.TN_CodClase																= B.TN_CodClase
		INNER JOIN  [Catalogo].Fase																H WITH (NOLOCK)  
		ON			H.TN_CodFase																= B.TN_CodFase
		INNER JOIN	[Catalogo].[Contexto]														M WITH (NOLOCK)  
		ON			M.TC_CodContexto															= C.TC_CodContexto

	   --OBTIENE INFORMACION DE LA DESCRIPCION DE LA TAREA
		OUTER APPLY	( SELECT TOP 1	X.TN_CodTarea						Codigo,
									W.TC_Descripcion					Descripcion,
									X.TU_CodTareaPendiente				CodigoTarea,
									X.TC_Mensaje						Mensaje,
									V.TC_UsuarioRed						UsuarioRed,
									V.TC_Nombre							Nombre,
									V.TC_PrimerApellido					PrimerApellido,
									V.TC_SegundoApellido				SegundoApellido
						FROM		Expediente.TareaPendiente			X WITH(NOLOCK)
						INNER JOIN	Catalogo.Tarea						W WITH(NOLOCK)	
						ON			W.TN_CodTarea						= X.TN_CodTarea
						INNER JOIN	Catalogo.PuestoTrabajoFuncionario	Y WITH(NOLOCK)	
						ON			Y.TC_CodPuestoTrabajo				= X.TC_CodPuestoTrabajoDestino
						INNER JOIN	Catalogo.Funcionario				V WITH(NOLOCK)	
						ON			V.TC_UsuarioRed						= Y.TC_UsuarioRed
						WHERE		X.TC_NumeroExpediente				= A.TC_NumeroExpediente
						AND			X.TU_CodLegajo						IS NULL
						ORDER BY	X.TF_Actualizacion desc
					) I 

		--OBTIENE LA UBICACION DEL EXPEDIENTE 
		OUTER APPLY	(	SELECT TOP 1	R.TN_CodUbicacion
										,C.TC_Descripcion
						FROM			Historico.ExpedienteUbicacion	R WITH(NOLOCK)
						INNER JOIN		Catalogo.Ubicacion				C WITH(NOLOCK)
						ON				C.TN_CodUbicacion				= R.TN_CodUbicacion
						WHERE			R.TC_NumeroExpediente			= A.TC_NumeroExpediente
						AND				R.TC_CodContexto				= B.TC_CodContexto
						AND				R.TN_CodUbicacion				IS NOT NULL
						ORDER BY		TF_FechaUbicacion	DESC
					) K	

	   WHERE		[TN_CodSolicitud]				=	@L_CodSolicitud and A.TU_CodLegajo is null
					AND A.[TC_NumeroExpediente]		=	ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)	
					AND [TB_TieneDepositos]			=	ISNULL(@L_TieneDepositos, [TB_TieneDepositos])
					AND [TB_TieneMandamientos]		=	ISNULL(@L_TieneMandamientos, [TB_TieneMandamientos])
					AND A.[TC_Estado]				=	ISNULL(@L_TieneErrores, [TC_Estado])
					AND	A.TB_TieneEmbargos			=	ISNULL(@L_TieneEmbargosFisicos, A.TB_TieneEmbargos)
	END
	ELSE 
	BEGIN
		--CONSULTA DE LEGAJOS
		INSERT INTO @ExpedientesInactivos(
					CodigoDepuracionInactivo,
					CodigoSolicitud,
					NumeroExpediente,
					CodigoLegajo,
					FechaUltimoAcontecimiento,
					TipoUltimoAcontecimiento,			--Es un enumerable
					TieneDepositos,
					TieneMandamientos,
					TieneEmbargos,
					EstadoMigracion,					--Estado de la migración de datos 
					ResultadoMigracion,					--Resultado de la migración
					Clase,
					Asunto,
					ClaseAsunto,
					Fase,
					Estado,								--Estado legajoo expediente
					FechaEntrada,						--Fecha de entrada del  legajo o expediente
					Observaciones,						--Observaciones del legajo o expediente
					CodigoUbicacion,
					Ubicacion,
					CodigoTarea,
					DescripcionTarea,
					MensajeTarea,
					UsuarioRedTarea,
					TecnicoTarea,
					CodigoOficina)
		SELECT	 [TN_CodDetalleDepuracion]													as CodigoDepuracionInactivo       
				,[TN_CodSolicitud]															as CodigoSolicitud 
				,A.[TC_NumeroExpediente]													as NumeroExpediente
				,A.[TU_CodLegajo]															as CodigoLegajo              
				,[TF_UltimoAcontecimiento]													as FechaUltimoAcontecimiento
				,[TC_TipoAcontecimiento]													as TipoUltimoAcontecimiento	--Es un enumerable
				,[TB_TieneDepositos]														as TieneDepositos
				,[TB_TieneMandamientos]														as TieneMandamientos
				,[TB_TieneEmbargos]															as TieneEmbargos						
				,[TC_Estado]																as EstadoMigracion				--Estado de la migración de datos 
				,[TC_Resultado]																as ResultadoMigracion			--Resultado de la migración
				,null           															as Clase   --F.TC_Descripcion
				,D.TC_Descripcion															as Asunto
				,E.TC_Descripcion															as ClaseAsunto
				,H.TC_Descripcion															as Fase
				,SUBSTRING(L.Estado, 0, 200)												as Estado						--Estado Legajo
				,B.TF_Entrada																as FechaEntrada				--Fecha de entrada del  legajo o expediente
				,C.TC_Descripcion															as Observaciones				--Observaciones del legajo
				,K.TN_CodUbicacion															as CodigoUbicacion
				,K.TC_Descripcion															as Ubicacion
				,I.CodigoTarea																as CodigoTarea
				,I.Descripcion																as DescripcionTarea
				,SUBSTRING(I.Mensaje, 0, 254)												as MensajeTarea
				,I.UsuarioRed																as UsuarioRedTarea
				,I.Nombre + ' ' + I.PrimerApellido	+ ' ' + I.SegundoApellido				as TecnicoTarea
				,M.TC_CodOficina															as CodigoOficina

	  FROM			[Expediente].[DetalleDepuracionInactivo]								A WITH (NOLOCK)
	  INNER JOIN	[Expediente].[LegajoDetalle]											B WITH (NOLOCK) 
	  ON			B.TU_CodLegajo															= A.TU_CodLegajo
	  INNER JOIN	[Expediente].[Legajo]													C WITH (NOLOCK) 
	  ON			C.TU_CodLegajo															= A.TU_CodLegajo
	  INNER JOIN	[Catalogo].[Contexto]													M WITH (NOLOCK) 
	  ON			M.TC_CodContexto														= C.TC_CodContexto
	  INNER JOIN    [Catalogo].[Asunto]														D WITH (NOLOCK) 
	  ON			D.TN_CodAsunto															= B.TN_CodAsunto
	  INNER JOIN    [Catalogo].ClaseAsunto													E WITH (NOLOCK) 
	  ON			E.TN_CodClaseAsunto														= B.[TN_CodClaseAsunto]
	  --OBTIENE INFORMACION DEL EXPEDIENTE DETALLE
	  OUTER APPLY	 ( SELECT TOP 1 TC_NumeroExpediente, 
									TN_CodClase, 
									TN_CodFase, 
									TC_CodContexto
					   FROM			[Expediente].[ExpedienteDetalle]
					   WHERE TC_NumeroExpediente = A.TC_NumeroExpediente
					   ORDER BY TF_Entrada DESC) G
	  INNER JOIN    [Catalogo].Fase								H  ON H.TN_CodFase				=   G.TN_CodFase

	   --OBTIENE INFORMACION DE LA DESCRIPCION DE LA TAREA
		OUTER APPLY	( SELECT TOP 1	X.TN_CodTarea				Codigo,
									W.TC_Descripcion			Descripcion,
									X.TU_CodTareaPendiente      CodigoTarea,
									X.TC_Mensaje				Mensaje,
									V.TC_UsuarioRed				UsuarioRed,
									V.TC_Nombre					Nombre,
									V.TC_PrimerApellido			PrimerApellido,
									V.TC_SegundoApellido		SegundoApellido
						FROM		Expediente.TareaPendiente			X WITH(NOLOCK)
						INNER JOIN	Catalogo.Tarea						W WITH(NOLOCK)	ON			W.TN_CodTarea				= X.TN_CodTarea
						INNER JOIN	Catalogo.PuestoTrabajoFuncionario	Y WITH(NOLOCK)	ON			Y.TC_CodPuestoTrabajo		= X.TC_CodPuestoTrabajoDestino
						INNER JOIN	Catalogo.Funcionario				V WITH(NOLOCK)	ON			V.TC_UsuarioRed		        = Y.TC_UsuarioRed
						WHERE		X.TU_CodLegajo		        = A.TU_CodLegajo
						ORDER BY X.TF_Actualizacion DESC) I 
	
		--OBTIENE LA UBICACION DEL LEGAJO 
		OUTER APPLY	(
						SELECT TOP 1	R.TN_CodUbicacion
										,C.TC_Descripcion
						FROM			Historico.LegajoUbicacion	R WITH(NOLOCK)
						INNER JOIN		Catalogo.Ubicacion          C ON C.TN_CodUbicacion = R.TN_CodUbicacion
						WHERE			R.TC_NumeroExpediente		= A.TC_NumeroExpediente
						AND				R.TU_CodLegajo				= A.TU_CodLegajo
						AND				R.TC_CodContexto			= B.TC_CodContexto
						ORDER BY		TF_FechaUbicacion			DESC) K

		--OBTIENE EL ESTADO DEL LEGAJO
		OUTER APPLY	(SELECT top 1	hme.TC_NumeroExpediente,	hme.TU_CodLegajo,
					hme.TF_Fecha AS FechaMovimientoCirculante,
					hme.TC_CodContexto,			hme.TC_Movimiento,
					ce.TN_CodEstado,			ce.TC_Descripcion AS Estado 
			FROM Historico.LegajoMovimientoCirculante  hme WITH (NOLOCK) INNER join(
																	SELECT  e.TC_NumeroExpediente, e.TC_CodContexto, e.TU_CodLegajo, max(e.TF_Fecha) AS Fecha
																	FROM Historico.LegajoMovimientoCirculante e WITH (NOLOCK)
																	GROUP BY  e.TC_NumeroExpediente, e.TC_CodContexto, e.TU_CodLegajo) ume
																	ON ume.Fecha=hme.TF_Fecha AND ume.TC_CodContexto=hme.TC_CodContexto 
																	AND ume.TC_NumeroExpediente=hme.TC_NumeroExpediente AND ume.TU_CodLegajo=hme.TU_CodLegajo
			INNER JOIN Catalogo.Estado ce WITH (NOLOCK) ON hme.TN_CodEstado= CE.TN_CodEstado--AND  ce.TC_Circulante='A'
			where hme.TU_CodLegajo = A.TU_CodLegajo 
			order by hme.TF_Fecha desc) L

	   WHERE		[TN_CodSolicitud] = @L_CodSolicitud
					AND A.[TC_NumeroExpediente]		=	ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)	
					AND A.[TB_TieneDepositos]		=	ISNULL(@L_TieneDepositos, [TB_TieneDepositos])
					AND A.[TB_TieneMandamientos]	=	ISNULL(@L_TieneMandamientos, [TB_TieneMandamientos])
					AND A.[TC_Estado]				IN  ('D','M','I','E','S','R','X')
					AND	A.TB_TieneEmbargos			=	ISNULL(@L_TieneEmbargosFisicos, A.TB_TieneEmbargos)
	   UNION

	--CONSULTA DE EXPEDIENTES
	   SELECT			 [TN_CodDetalleDepuracion]       as CodigoDepuracionInactivo     
						,[TN_CodSolicitud]				as CodigoSolicitud 
						,A.[TC_NumeroExpediente]		as NumeroExpediente
						,A.[TU_CodLegajo]				as CodigoLegajo
						,[TF_UltimoAcontecimiento]		as FechaUltimoAcontecimiento
						,[TC_TipoAcontecimiento]		as TipoUltimoAcontecimiento	--Es un enumerable
						,[TB_TieneDepositos]			as TieneDepositos
						,[TB_TieneMandamientos]			as TieneMandamientos
						,[TB_TieneEmbargos]				as TieneEmbargos
						,[TC_Estado]					as EstadoMigracion				--Estado de la migración de datos 
						,[TC_Resultado]					as ResultadoMigracion			--Resultado de la migración
						,F.TC_Descripcion				as Clase
						,null							as Asunto
						,null							as ClaseAsunto
						,H.TC_Descripcion				as Fase
						,SUBSTRING(L.Estado, 0, 200)	as Estado						--Estado Expediente
						,B.TF_Entrada                   as FechaEntrada					--Fecha de entrada del  legajo o expediente
						,C.TC_Descripcion				as Observaciones				--Observaciones del Expediente
						,K.TN_CodUbicacion				as CodigoUbicacion
						,K.TC_Descripcion				as Ubicacion
						,I.CodigoTarea					as CodigoTarea
						,I.Descripcion					as DescripcionTarea
						,SUBSTRING(I.Mensaje, 0, 254)	as MensajeTarea
						,I.UsuarioRed					as UsuarioRedTarea
						,I.Nombre + ' ' + I.PrimerApellido	+ ' ' + I.SegundoApellido			 as TecnicoTarea
						,M.TC_CodOficina				as CodigoOficina
			
		FROM			[Expediente].[DetalleDepuracionInactivo]	A WITH (NOLOCK)
		--OBTIENE INFORMACION DEL EXPEDIENTE DETALLE
		OUTER APPLY	 ( SELECT TOP 1 TC_NumeroExpediente, TN_CodClase, TN_CodFase, TC_CodContexto, TF_Entrada
					   FROM [Expediente].[ExpedienteDetalle]
					   WHERE TC_NumeroExpediente = A.TC_NumeroExpediente
					   ORDER BY TF_Entrada DESC) B
		INNER JOIN	[Expediente].[Expediente]			        C WITH (NOLOCK)  ON  C.TC_NumeroExpediente		= B.TC_NumeroExpediente
		INNER JOIN	[Catalogo].Clase							F WITH (NOLOCK)  ON F.TN_CodClase				= B.TN_CodClase
		INNER JOIN    [Catalogo].Fase								H WITH (NOLOCK)  ON H.TN_CodFase				= B.TN_CodFase
		INNER JOIN	[Catalogo].[Contexto]						M WITH (NOLOCK)  ON M.TC_CodContexto			= C.TC_CodContexto

	   --OBTIENE INFORMACION DE LA DESCRIPCION DE LA TAREA
		OUTER APPLY	( SELECT TOP 1	X.TN_CodTarea				Codigo,
									W.TC_Descripcion			Descripcion,
									X.TU_CodTareaPendiente      CodigoTarea,
									X.TC_Mensaje				Mensaje,
									V.TC_UsuarioRed				UsuarioRed,
									V.TC_Nombre					Nombre,
									V.TC_PrimerApellido			PrimerApellido,
									V.TC_SegundoApellido		SegundoApellido
						FROM		Expediente.TareaPendiente			X WITH(NOLOCK)
						INNER JOIN	Catalogo.Tarea						W WITH(NOLOCK)	ON			W.TN_CodTarea				= X.TN_CodTarea
						INNER JOIN	Catalogo.PuestoTrabajoFuncionario	Y WITH(NOLOCK)	ON			Y.TC_CodPuestoTrabajo		= X.TC_CodPuestoTrabajoDestino
						INNER JOIN	Catalogo.Funcionario				V WITH(NOLOCK)	ON			V.TC_UsuarioRed		        = Y.TC_UsuarioRed
						WHERE		X.TC_NumeroExpediente		        = A.TC_NumeroExpediente
									and X.TU_CodLegajo is null
						ORDER BY X.TF_Actualizacion desc) I 

		--OBTIENE LA UBICACION DEL EXPEDIENTE 
		OUTER APPLY	(	SELECT TOP 1	R.TN_CodUbicacion
										,C.TC_Descripcion
						FROM			Historico.ExpedienteUbicacion	R WITH(NOLOCK)
						INNER JOIN		Catalogo.Ubicacion          C ON C.TN_CodUbicacion = R.TN_CodUbicacion
						WHERE			R.TC_NumeroExpediente		= A.TC_NumeroExpediente
						AND				R.TC_CodContexto			= B.TC_CodContexto
						AND				R.TN_CodUbicacion			IS NOT NULL
						ORDER BY		TF_FechaUbicacion			DESC
					) K

		--OBTIENE EL ESTADO DEL EXPEDIENTE
		OUTER APPLY	(SELECT TOP 1	hme.TC_NumeroExpediente,	hme.TF_Fecha AS FechaMovimientoCirculante,
					hme.TC_CodContexto,			hme.TC_Movimiento,
					ce.TN_CodEstado,			ce.TC_Descripcion AS Estado 
					FROM Historico.ExpedienteMovimientoCirculante hme WITH (NOLOCK) 
					INNER join(SELECT  e.TC_NumeroExpediente, e.TC_CodContexto,max(e.TF_Fecha) AS Fecha
						FROM Historico.ExpedienteMovimientoCirculante e WITH (NOLOCK)
						GROUP BY  e.TC_NumeroExpediente, e.TC_CodContexto) ume
						ON ume.Fecha=hme.TF_Fecha AND ume.TC_CodContexto=hme.TC_CodContexto AND ume.TC_NumeroExpediente=hme.TC_NumeroExpediente
					INNER JOIN Catalogo.Estado ce WITH (NOLOCK) ON hme.TN_CodEstado= CE.TN_CodEstado --AND ce.TC_Circulante='A'
					where hme.TC_NumeroExpediente = A.TC_NumeroExpediente
					order by hme.TF_Fecha desc) L

	   WHERE		[TN_CodSolicitud] = @L_CodSolicitud and A.TU_CodLegajo is null
					AND A.[TC_NumeroExpediente]		=	ISNULL(@L_NumeroExpediente, A.TC_NumeroExpediente)	
					AND [TB_TieneDepositos]			=	ISNULL(@L_TieneDepositos, [TB_TieneDepositos])
					AND [TB_TieneMandamientos]		=	ISNULL(@L_TieneMandamientos, [TB_TieneMandamientos])
					AND A.[TC_Estado]				IN  ('D','M','I','E','S','R','X')
					AND	A.TB_TieneEmbargos			=	ISNULL(@L_TieneEmbargosFisicos, A.TB_TieneEmbargos)
	END

	--CANTIDAD DE REGISTROS DE LA CONSULTAS
	DECLARE @TotalRegistros AS INT = @@rowcount; 

	--RETORNA LA CONSULTA
	SELECT CodigoDepuracionInactivo,
		CodigoSolicitud,
		NumeroExpediente,
		CodigoLegajo,
		FechaUltimoAcontecimiento,
		TipoUltimoAcontecimiento,			--Es un enumerable
		TieneDepositos,
		TieneMandamientos,
		TieneEmbargos,
		EstadoMigracion,					--Estado de la migración de datos 
		ResultadoMigracion,					--Resultado de la migración
		Clase,
		Asunto,
		ClaseAsunto,
		Fase,
		Estado,								--Estado legajoo expediente
		FechaEntrada,						--Fecha de entrada del  legajo o expediente
		Observaciones,						--Observaciones del legajo o expediente
		CodigoUbicacion,
		Ubicacion,
		CodigoTarea,
		DescripcionTarea,
		MensajeTarea,
		UsuarioRedTarea,
		TecnicoTarea,
		@TotalRegistros				AS		TotalRegistros,	
		CodigoOficina
	FROM (
			SELECT		CodigoDepuracionInactivo,
			CodigoSolicitud,
			NumeroExpediente,
			CodigoLegajo,
			FechaUltimoAcontecimiento,
			TipoUltimoAcontecimiento,			--Es un enumerable
			TieneDepositos,
			TieneMandamientos,
			TieneEmbargos,
			EstadoMigracion,					--Estado de la migración de datos 
			ResultadoMigracion,					--Resultado de la migración
			Clase,
			Asunto,
			ClaseAsunto,
			Fase,
			Estado,								--Estado legajoo expediente
			FechaEntrada,						--Fecha de entrada del  legajo o expediente
			Observaciones,						--Observaciones del legajo o expediente
			CodigoUbicacion,
			Ubicacion,
			CodigoTarea,
			DescripcionTarea,
			MensajeTarea,
			UsuarioRedTarea,
			TecnicoTarea,
			CodigoOficina
			FROM		@ExpedientesInactivos
			ORDER BY	NumeroExpediente, FechaUltimoAcontecimiento	desc
			OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
			FETCH NEXT	@L_CantidadRegistros ROWS ONLY
		)	As T
	ORDER BY NumeroExpediente desc 

END
GO
