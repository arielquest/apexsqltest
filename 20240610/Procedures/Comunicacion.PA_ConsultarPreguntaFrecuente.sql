SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:                 <1.0>
-- Creado por:              <Andrew Allen Dawson>
-- Fecha de creación:		<09/09/2019>
-- Descripción:             <Permite obtener las preguntas frecuentes>
-- ==================================================================================================================================================================================
-- Modificado por:			<Kirvin Bennett Mathurin>
-- Fecha de modificación	<05/12/2019>
-- Modificación				<Se actualiza para incluir filtrado sistema>
-- =================================================================================================================================================

CREATE PROCEDURE [Comunicacion].[PA_ConsultarPreguntaFrecuente]
       @CodPregunta			smallint			= NULL,
       @Pregunta			varchar(255)		= NULL,
	   @Respuesta			varchar(500)		= NULL,
	   @Sistema				varchar(3)			= NULL,
	   @Inicio_Vigencia		datetime2(7)		= NULL,
	   @Fin_Vigencia		datetime2(7)		= NULL
As
Begin
	--Variables
	Declare @L_TN_CodPregunta		SmallInt		=	@CodPregunta,
			@L_TC_Pregunta			VarChar(MAX)	=	Iif (@Pregunta Is Not Null, '%' + dbo.FN_RemoverTildes(@Pregunta) + '%', '%'),
			@L_TC_Respuesta			VarChar(MAX)	=	Iif (@Respuesta Is Not Null, '%' + dbo.FN_RemoverTildes(@Respuesta) + '%', '%'),
			@L_TC_Sistema			VarChar(3)		=	@Sistema,
			@L_TF_Inicio_Vigencia	Datetime2(7)	=	@Inicio_Vigencia,
			@L_TF_Fin_Vigencia		Datetime2(7)	=	@Fin_Vigencia

	--Lógica
	--Todos
	If @L_TN_CodPregunta Is Null And @L_TF_Inicio_Vigencia Is Null And @Pregunta Is Null And @L_TF_Fin_Vigencia Is Null And @Respuesta Is NULL And @L_TC_Sistema Is NULL 
	Begin
		SELECT [TN_CodPregunta] AS Codigo
			  ,[TC_Pregunta] AS Pregunta
			  ,[TC_Respuesta] AS Respuesta
			  ,[TC_Sistema] AS Sistema
			  ,[TF_Inicio_Vigencia] AS InicioVigencia
			  ,[TF_Fin_Vigencia] AS FinVigencia
		 FROM [Comunicacion].[PreguntasFrecuentes]
	End

	--Por activos
	Else If  @L_TF_Inicio_Vigencia Is Not Null And @L_TF_Fin_Vigencia Is Null
	Begin
		SELECT [TN_CodPregunta] AS Codigo
			  ,[TC_Pregunta] AS Pregunta
			  ,[TC_Respuesta] AS Respuesta
			  ,[TC_Sistema] AS Sistema
			  ,[TF_Inicio_Vigencia] AS InicioVigencia
			  ,[TF_Fin_Vigencia] AS FinVigencia
		 FROM [Comunicacion].[PreguntasFrecuentes]
		 Where TN_CodPregunta							=		Coalesce(@L_TN_CodPregunta,	TN_CodPregunta)
		 And [TF_Inicio_Vigencia]						<		GETDATE()
		 And   (
				[TF_Fin_Vigencia]						Is		Null 
				Or 
				[TF_Fin_Vigencia]						>=		GETDATE()
				)
		 And dbo.FN_RemoverTildes([TC_Respuesta])		LIKE	@L_TC_Respuesta 
		 AND dbo.FN_RemoverTildes([TC_Pregunta])		LIKE	@L_TC_Pregunta
		 AND TC_Sistema									=		Coalesce(@L_TC_Sistema, [TC_Sistema])
	End

	--Por inactivos
	Else IF @L_TF_Inicio_Vigencia Is Null And @L_TF_Fin_Vigencia Is Not Null
	Begin
		SELECT [TN_CodPregunta] AS Codigo
			  ,[TC_Pregunta] AS Pregunta
			  ,[TC_Respuesta] AS Respuesta
			  ,[TC_Sistema] AS Sistema
			  ,[TF_Inicio_Vigencia] AS InicioVigencia
			  ,[TF_Fin_Vigencia] AS FinVigencia
		 FROM [Comunicacion].[PreguntasFrecuentes]
		 Where TN_CodPregunta						=		Coalesce(@L_TN_CodPregunta,	TN_CodPregunta)
		 And	(
				[TF_Inicio_Vigencia]				>		GETDATE() 
				Or 
				[TF_Fin_Vigencia]					<		GETDATE()
				)
		 And dbo.FN_RemoverTildes([TC_Respuesta])	LIKE	@L_TC_Respuesta 
		 AND dbo.FN_RemoverTildes([TC_Pregunta])	LIKE	@L_TC_Pregunta
		 AND TC_Sistema								 =		Coalesce(@L_TC_Sistema, [TC_Sistema])
	End

	--Por rango de Fechas
	Else If  @L_TF_Inicio_Vigencia Is Not Null And @L_TF_Fin_Vigencia Is Not Null
	Begin
		SELECT [TN_CodPregunta] AS Codigo
			  ,[TC_Pregunta] AS Pregunta
			  ,[TC_Respuesta] AS Respuesta
			  ,[TC_Sistema] AS Sistema
			  ,[TF_Inicio_Vigencia] AS InicioVigencia
			  ,[TF_Fin_Vigencia] AS FinVigencia
		 FROM [Comunicacion].[PreguntasFrecuentes]
		 Where	TN_CodPregunta							=		Coalesce(@L_TN_CodPregunta,	TN_CodPregunta)
			And (TF_Inicio_Vigencia						>=		@L_TF_Inicio_Vigencia
			And	TF_Fin_Vigencia							<=		@L_TF_Fin_Vigencia)
			And dbo.FN_RemoverTildes([TC_Respuesta])	LIKE	@L_TC_Respuesta 
			AND dbo.FN_RemoverTildes([TC_Pregunta])		LIKE	@L_TC_Pregunta
			AND TC_Sistema								=		Coalesce(@L_TC_Sistema, [TC_Sistema])
	End
	Else If @L_TF_Inicio_Vigencia Is Null And  @L_TF_Fin_Vigencia Is Null
	Begin
		SELECT [TN_CodPregunta] AS Codigo
			  ,[TC_Pregunta] AS Pregunta
			  ,[TC_Respuesta] AS Respuesta
			  ,[TC_Sistema] AS Sistema
			  ,[TF_Inicio_Vigencia] AS InicioVigencia
			  ,[TF_Fin_Vigencia] AS FinVigencia
		 FROM [Comunicacion].[PreguntasFrecuentes]
		 Where TN_CodPregunta						=		Coalesce(@L_TN_CodPregunta,	TN_CodPregunta)
		 And dbo.FN_RemoverTildes([TC_Respuesta])	LIKE	@L_TC_Respuesta 
		 AND dbo.FN_RemoverTildes([TC_Pregunta])	LIKE	@L_TC_Pregunta
		 AND TC_Sistema								=		Coalesce(@L_TC_Sistema, [TC_Sistema])
	End
END
GO
