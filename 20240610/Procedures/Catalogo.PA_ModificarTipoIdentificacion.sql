SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Roger Lara>
-- Fecha Creación:		<20 de agosto de 2015.>
-- Descripcion:			<Permite Modificar un tipo de identificacion en la tabla Catalogo.TipoIdentificacion>
-- =================================================================================================================================================
-- Modificación:		<06/01/2016> <Alejandro Villalta> <Cambiar tipo de dato del codigo del catalogo tipo identificación>
-- Modificación:		<07/04/2016> <Esteban Cordero Benavides.> <Se agrega el campo TB_Nacional para indicar los tipos de identificación nacional.>
-- Modificación:		<12/08/2016> <Johan Acosta.> <Se agrega el campo TC_Formato para indicar el formato del tipo de identificación.>
-- Modificación:		<02/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN> 
-- Modificación:        <05-06-2017> <palvareze> <Se agrega la columna esjuridico para diferenciar los tipos que pertenecen a juridicos>
-- Modificación:	    <24/01/2018> <Jonathan Aguilar> <Se agrega la coolumna TB_EsIgnorado.>
-- Modificación:        <17/12/2020> <Aida Elena Siles R><Se agrega variables locales y se ajusta SP para agregar valor es ignorado.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoIdentificacion]
	@TC_CodTipoIdentificacion	SMALLINT,
	@TC_Descripcion				VARCHAR(100),
	@TF_Fin_Vigencia			DATETIME2,
	@TB_Nacional				BIT, 
	@TC_Formato					VARCHAR(25),
	@TB_EsJuridico				BIT,
	@TB_EsIgnorado				BIT
AS
BEGIN
--VARIABLES
DECLARE @L_TC_CodTipoIdentificacion		SMALLINT		= @TC_CodTipoIdentificacion,
		@L_TC_Descripcion				VARCHAR(100)	= @TC_Descripcion,
		@L_TF_Fin_Vigencia				DATETIME2		= @TF_Fin_Vigencia,
		@L_TB_Nacional					BIT				= @TB_Nacional, 
		@L_TC_Formato					VARCHAR(25)		= @TC_Formato,
		@L_TB_EsJuridico				BIT				= @TB_EsJuridico,
		@L_TB_EsIgnorado				BIT				= @TB_EsIgnorado
--LÓGICA
	UPDATE	Catalogo.TipoIdentificacion	WITH(ROWLOCK)
	SET		TC_Descripcion				= @L_TC_Descripcion,
			TF_Fin_Vigencia				= @L_TF_Fin_Vigencia,
			TB_Nacional					= @L_TB_Nacional,
			TC_Formato					= @L_TC_Formato,
			TB_EsJuridico               = @L_TB_EsJuridico,
			TB_EsIgnorado               = @L_TB_EsIgnorado
	WHERE	TN_CodTipoIdentificacion	= @L_TC_CodTipoIdentificacion
END;
GO
