SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Daniel Ruiz Hernández>
-- Fecha Creación:		<10/02/2021>
-- Descripcion:			<Procedimiento creado para ingresar las equivalencias entre catalogos del SIAGPJ y catálogos externos.>
-- =================================================================================================================================================
-- Modificación:		<Karol Jiménez Sánchez><20/09/2021><Se agrega a la consulta la materia, el tipo de oficina y el contexto>
-- =================================================================================================================================================
CREATE PROCEDURE [Configuracion].[PA_AgregarEquivalencia]
	@CodCodigo								uniqueidentifier,
	@CodCatalogo							smallint,
	@CodSistema								smallint,
	@ValorExterno							varchar(40),
	@DescripcionExterno						varchar(255),
	@ValorSIAGPJ							varchar(40),
	@DescripcionSIAGPJ						varchar(255),
	@CodTipoOficina							smallint,
	@CodMateria								varchar(5),
	@CodContexto							varchar(4)
AS

BEGIN
	DECLARE	@L_TU_Codigo					uniqueidentifier	= @CodCodigo
	DECLARE @L_TN_CodSistema				smallint			= @CodSistema
	DECLARE @L_TN_CodCatalogo				smallint			= @CodCatalogo
	DECLARE @L_TC_ValorExterno				varchar(40)			= @ValorExterno
	DECLARE @L_TC_DescripcionExterno		varchar(255)		= @DescripcionExterno
	DECLARE @L_TC_ValorSIAGPJ				varchar(40)			= @ValorSIAGPJ
	DECLARE @L_DescripcionSIAGPJ			varchar(255)		= @DescripcionSIAGPJ,
			@L_TN_CodTipoOficina			smallint			= @CodTipoOficina,
			@L_TC_CodMateria				varchar(5)			= @CodMateria,
			@L_TC_CodContexto				varchar(4)			= @CodContexto

	BEGIN
		INSERT INTO Configuracion.Equivalencia
		(
			TU_Codigo,					TN_CodSistema,			TN_CodCatalogo,			TC_ValorExterno,
			TC_DescripcionExterno,		TC_ValorSIAGPJ,			TC_DescripcionSIAGPJ,	TN_CodTipoOficina,
			TC_CodMateria,				TC_CodContexto
		)
		VALUES
		(
			@L_TU_Codigo,				@L_TN_CodSistema,		@L_TN_CodCatalogo,		@L_TC_ValorExterno,
			@L_TC_DescripcionExterno,	@L_TC_ValorSIAGPJ,		@L_DescripcionSIAGPJ,	@L_TN_CodTipoOficina,
			@L_TC_CodMateria,			@L_TC_CodContexto
		)
	END
END
GO
