SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================
-- Autor:				<Roger Lara>
-- Fecha Creación:		<20 de agosto de 2015>
-- Descripcion:			<Permite Agregar un tipo de identificacion.>
-- ================================================================================================================================================
-- Modificación:		<06/01/2016> <Alejandro Villalta> <Autogenerar el codigo del catalogo tipo identificación>
-- Modificación:		<07/04/2016> <Esteban Cordero Benavides.> <Se agrega el campo TB_Nacional para indicar los tipos de identificación nacional.>
-- Modificación:		<12/08/2016> <Se agrega el campo TC_Formato para indicar el formato del tipo de identificación.>
-- Modificación:		<2017/05/26> <Andrés Díaz><Se modifica el tamaño del parámetro descripción a 100.>
-- Modificación:        <05-06-2017> <palvareze><Se agrega la columna esjuridico para diferenciar los tipos que pertenecen a juridicos>
-- Modificación:        <24/01/2018> <Jonathan Aguilar><Se agrega la columna TB_EsIgnorado>
-- Modificación:        <17/12/2020> <Aida Elena Siles R><Se agrega variables locales y se ajusta SP para agregar valor es ignorado.>
-- ================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoIdentificacion]
	@TC_Descripcion		VARCHAR(100),
	@TF_Inicio_Vigencia	DATETIME2(7),
	@TF_Fin_Vigencia	DATETIME2(7),
	@TB_Nacional		BIT,
	@TC_Formato			VARCHAR(25),
	@TB_EsJuridico      BIT,
	@TB_EsIgnorado      BIT
AS
BEGIN
--VARIABLE
DECLARE	@L_TC_Descripcion		VARCHAR(100) = @TC_Descripcion,
		@L_TF_Inicio_Vigencia	DATETIME2(3) = @TF_Inicio_Vigencia,
		@L_TF_Fin_Vigencia		DATETIME2(3) = @TF_Fin_Vigencia,
		@L_TB_Nacional			BIT		     = @TB_Nacional,
		@L_TC_Formato			VARCHAR(25)	 = @TC_Formato,
		@L_TB_EsJuridico		BIT          = @TB_EsJuridico,
		@L_TB_EsIgnorado		BIT			 = @TB_EsIgnorado
--LÓGICA
	INSERT INTO	Catalogo.TipoIdentificacion WITH (ROWLOCK)
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia,	TB_Nacional, 
		TC_Formato,			TB_EsJuridico,			TB_EsIgnorado
	)
	VALUES
	(
		@L_TC_Descripcion,	@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia,	@L_TB_Nacional, 
		@L_TC_Formato,		@L_TB_EsJuridico,		@L_TB_EsIgnorado
	);
END;

GO
