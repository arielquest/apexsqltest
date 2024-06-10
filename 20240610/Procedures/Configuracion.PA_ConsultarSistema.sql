SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<21/01/2021>
-- Descripción :			<Permite Consultar el sistema en la tabla Configuracion.Sistema> 
-- =================================================================================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarSistema]
	@CodSistema			smallint=0,
	@Descripcion		Varchar(150)=Null,
	@Siglas				Varchar(20)=Null,
	@FechaActivacion	datetime2=Null,
	@FechaDesactivacion	datetime2= Null
 AS
 BEGIN
  
	DECLARE	@ExpresionLike	varchar(200)
	SET		@ExpresionLike	= IIF(@Descripcion IS NOT NULL,'%' + @Descripcion + '%','%')
	if @CodSistema = 0 SET @CodSistema = null

	IF		@Descripcion	IS NOT NULL
		BEGIN
			--Todos
			IF  @FechaActivacion IS NULL AND @FechaDesactivacion IS NULL
				BEGIN
					SELECT		TN_CodSistema      	AS	Codigo,				
								TC_Descripcion		AS	Descripcion,
								TC_Siglas			AS	Siglas,
								TF_Inicio_Vigencia	AS	FechaActivacion,	
								TF_Fin_Vigencia		AS	FechaDesactivacion
					FROM		Configuracion.Sistema	With(Nolock) 	
					WHERE		TC_Descripcion		LIKE @ExpresionLike 
					AND			TN_CodSistema		= ISNULL(@CodSistema, TN_CodSistema)
					AND			TC_Siglas			= ISNULL(@Siglas, TC_Siglas)
					ORDER BY	TC_Descripcion;
				END
			--Por activos 
			ELSE IF  @FechaActivacion IS NOT NULL And @FechaDesactivacion IS NULL	
				BEGIN
					SELECT		TN_CodSistema      	AS	Codigo,				
								TC_Descripcion		AS	Descripcion,
								TC_Siglas			AS	Siglas,
								TF_Inicio_Vigencia	AS	FechaActivacion,	
								TF_Fin_Vigencia		AS	FechaDesactivacion
					FROM		Configuracion.Sistema	With(Nolock) 	
					WHERE		TC_Descripcion		LIKE @ExpresionLike 
					AND			TN_CodSistema		= ISNULL(@CodSistema, TN_CodSistema)
					AND			TC_Siglas			= ISNULL(@Siglas, TC_Siglas)
					AND			TF_Inicio_Vigencia  < GETDATE ()
					AND			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
					ORDER BY	TC_Descripcion;
				END
			--Por inactivos 
			ELSE IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL	
				BEGIN
					SELECT		TN_CodSistema      	AS	Codigo,				
								TC_Descripcion		AS	Descripcion,
								TC_Siglas			AS	Siglas,
								TF_Inicio_Vigencia	AS	FechaActivacion,	
								TF_Fin_Vigencia		AS	FechaDesactivacion
					FROM		Configuracion.Sistema	With(Nolock) 	
					WHERE		TC_Descripcion		LIKE @ExpresionLike 
					AND			TN_CodSistema		= ISNULL(@CodSistema, TN_CodSistema)
					AND			TC_Siglas			= ISNULL(@Siglas, TC_Siglas)
					AND			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
					ORDER BY	TC_Descripcion;
				END
		END
	ELSE
		BEGIN
			--Todos
			IF  @FechaActivacion IS NULL AND @FechaDesactivacion IS NULL
				BEGIN
					SELECT		TN_CodSistema      	AS	Codigo,				
								TC_Descripcion		AS	Descripcion,
								TC_Siglas			AS	Siglas,
								TF_Inicio_Vigencia	AS	FechaActivacion,	
								TF_Fin_Vigencia		AS	FechaDesactivacion
					FROM		Configuracion.Sistema	With(Nolock) 	
					WHERE		TN_CodSistema		= ISNULL(@CodSistema, TN_CodSistema)
					AND			TC_Siglas			= ISNULL(@Siglas, TC_Siglas)
					ORDER BY	TC_Descripcion;
				END
			--Por activos 
			ELSE IF  @FechaActivacion IS NOT NULL And @FechaDesactivacion IS NULL	
				BEGIN
					SELECT		TN_CodSistema      	AS	Codigo,				
								TC_Descripcion		AS	Descripcion,
								TC_Siglas			AS	Siglas,
								TF_Inicio_Vigencia	AS	FechaActivacion,	
								TF_Fin_Vigencia		AS	FechaDesactivacion
					FROM		Configuracion.Sistema	With(Nolock) 	
					WHERE		TN_CodSistema		= ISNULL(@CodSistema, TN_CodSistema)
					AND			TC_Siglas			= ISNULL(@Siglas, TC_Siglas)
					AND			TF_Inicio_Vigencia  < GETDATE ()
					AND			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
					ORDER BY	TC_Descripcion;
				END
			--Por inactivos 
			ELSE IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL	
				BEGIN
					SELECT		TN_CodSistema      	AS	Codigo,				
								TC_Descripcion		AS	Descripcion,
								TC_Siglas			AS	Siglas,
								TF_Inicio_Vigencia	AS	FechaActivacion,	
								TF_Fin_Vigencia		AS	FechaDesactivacion
					FROM		Configuracion.Sistema	With(Nolock) 	
					WHERE		TN_CodSistema		= ISNULL(@CodSistema, TN_CodSistema)
					AND			TC_Siglas			= ISNULL(@Siglas, TC_Siglas)
					AND			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
					ORDER BY	TC_Descripcion;
				END
		END
 END




GO
