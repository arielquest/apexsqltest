SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Autor:			<Roger Lara>  
-- Fecha Creación:	<23/10/2015>  
-- Descripcion:		<Modifica datos basicos de un  expediente.>  
-- ====================================================================================================================================================================================
-- Modificado:		<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a INT>  
-- Modificado:		<Donald Vargas><02/12/2016><Se corrige el nombre del campo TC_CodDelito y TC_CodClaseAsunto a TN_CodDelito y TN_CodClaseAsunto de acuerdo al tipo de dato>  
-- Modificación		<Jonathan Aguilar Navarro> <18/03/2019> <Se cambian los parametros y columnas con los cambios de Creación Expediente tabla Expediente>  
-- Modificación		<Xinia Soto V.> <03/08/2020> <Se cambia el tipo del parámetro monto de la cuantía pues estaba redondeando>  
-- Modificación		<Andrew Allen Dawson> <22/10/2020> <Se agrega la funcion COALESCE para evitar modificar datos que vienen nulos> 
-- Modificación		<Richard Zuñiga Segura> <03/06/2021> <Se agregan los parámetros @DescripcionHechos, @MontoAguinaldo y @MontoSalarioEscolar> 
-- Modificación		<Ronny Ramírez R.> <14/07/2021> <Se aplica corrección para permitir valores nulos en los nuevos campos agregados por Richard> 
-- Modificación:	<Aida Elena Siles R> <01/12/2021> <Se agrega el campo Carpeta. PBI 214544. Creación de expedientes con legajos existentes en SIAGPJ.>
-- Modificación:	<Karol Jiménez Sánchez> <04/10/2023> <Se agrega el campo TB_EmbargosFisicos. PBI 347798.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarExpediente]   
	 @NumeroExpediente		CHAR(14),   
	 @FechaInicio			DATETIME2,  
	 @CodDelito				INT,  
	 @EsConfidencial		BIT,  
	 @Contexto				VARCHAR(4),  
	 @ContextoCreacion		VARCHAR(4),  
	 @Descripcion			VARCHAR(255),  
	 @CasoRelevante			BIT,  
	 @Prioridad				INT,  
	 @TipoCuantia			INT,  
	 @Moneda				INT,  
	 @MontoCuantia			DECIMAL(18,2),  
	 @TipoViabilidad		INT,  
	 @FechaHechos			DATETIME2,  
	 @Canton				INT,  
	 @Distrito				INT,  
	 @Barrio				INT,  
	 @Provincia				INT,  
	 @Sennas				VARCHAR(500),
	 @DescripcionHechos		VARCHAR(255)	= NULL,
	 @MontoAguinaldo		DECIMAL(18,2)	= NULL,
	 @MontoSalarioEscolar	DECIMAL(18,2)	= NULL,
	 @Carpeta				VARCHAR(14)		= NULL,		
	 @EmbargosFisicos		BIT				= NULL
AS  
BEGIN  
	--VARIABLES LOCALES
	DECLARE @L_NumeroExpediente		CHAR(14)		= @NumeroExpediente,   
			@L_FechaInicio			DATETIME2		= @FechaInicio,  
			@L_CodDelito			INT				= @CodDelito,  
			@L_EsConfidencial		BIT				= @EsConfidencial,  
			@L_Contexto				VARCHAR(4)		= @Contexto,  
			@L_ContextoCreacion		VARCHAR(4)		= @ContextoCreacion,  
			@L_Descripcion			VARCHAR(255)	= @Descripcion,  
			@L_CasoRelevante		BIT				= @CasoRelevante,  
			@L_Prioridad			INT				= @Prioridad,  
			@L_TipoCuantia			INT				= @TipoCuantia,  
			@L_Moneda				INT				= @Moneda,  
			@L_MontoCuantia			DECIMAL(18,2)	= @MontoCuantia,  
			@L_TipoViabilidad		INT				= @TipoViabilidad,  
			@L_FechaHechos			DATETIME2		= @FechaHechos,  
			@L_Canton				INT				= @Canton,  
			@L_Distrito				INT				= @Distrito,  
			@L_Barrio				INT				= @Barrio,  
			@L_Provincia			INT				= @Provincia,  
			@L_Sennas				VARCHAR(500)	= @Sennas,
			@L_DescripcionHechos	VARCHAR(255)	= @DescripcionHechos,
			@L_MontoAguinaldo		DECIMAL(18,2)	= @MontoAguinaldo,
			@L_MontoSalarioEscolar	DECIMAL(18,2)	= @MontoSalarioEscolar,
			@L_Carpeta				VARCHAR(14)		= @Carpeta,
			@L_EmbargosFisicos		BIT				= @EmbargosFisicos
  
	 UPDATE	Expediente.Expediente	WITH(ROWLOCK)
	 SET	TF_Inicio				= COALESCE(@L_FechaInicio,TF_Inicio),  
			TN_CodDelito			= COALESCE(@L_CodDelito,TN_CodDelito),  
			TB_Confidencial			= COALESCE(@L_EsConfidencial,TB_Confidencial),   
			TC_CodContexto			= COALESCE(@L_Contexto,TC_CodContexto),  
			TC_CodContextoCreacion	= COALESCE(@L_ContextoCreacion,TC_CodContextoCreacion),  
			TC_Descripcion			= COALESCE(@L_Descripcion,TC_Descripcion),  
			TB_CasoRelevante		= COALESCE(@L_CasoRelevante,TB_CasoRelevante)  ,  
			TN_CodPrioridad			= COALESCE(@L_Prioridad,TN_CodPrioridad),  
			TN_CodTipoCuantia		= COALESCE(@L_TipoCuantia,TN_CodTipoCuantia),  
			TN_CodMoneda			= COALESCE(@L_Moneda,TN_CodMoneda),   
			TN_MontoCuantia			= COALESCE(@L_MontoCuantia,TN_MontoCuantia),  
			TN_CodTipoViabilidad	= COALESCE(@L_TipoViabilidad,TN_CodTipoViabilidad),   
			TF_Hechos				= COALESCE(@L_FechaHechos,TF_Hechos),  
			TN_CodCanton			= COALESCE(@L_Canton,TN_CodCanton),   
			TN_CodDistrito			= COALESCE(@L_Distrito,TN_CodDistrito),  
			TN_CodBarrio			= COALESCE(@L_Barrio,TN_CodBarrio),   
			TN_CodProvincia			= COALESCE(@L_Provincia,TN_CodProvincia),  
			TC_Señas				= COALESCE(@L_Sennas,TC_Señas),   
			TF_Actualizacion		= GETDATE(),
			TC_DescripcionHechos	= COALESCE(@L_DescripcionHechos,TC_DescripcionHechos),  
			TN_MontoAguinaldo		= COALESCE(@L_MontoAguinaldo,TN_MontoAguinaldo), 
			TN_MontoSalarioEscolar	= COALESCE(@L_MontoSalarioEscolar,TN_MontoSalarioEscolar),
			CARPETA					= COALESCE(@L_Carpeta, CARPETA),
			TB_EmbargosFisicos		= COALESCE(@L_EmbargosFisicos, TB_EmbargosFisicos)
	 WHERE	TC_NumeroExpediente		= @L_NumeroExpediente  
  
END  
  
GO
