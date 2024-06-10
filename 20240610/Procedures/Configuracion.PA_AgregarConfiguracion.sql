SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jeffry Hernández>
-- Fecha de creación:	<05/02/2018>
-- Descripción:			<Permite agregar un registro a la tabla Configuracion.Configuracion>
-- ======================================================================================================
CREATE PROCEDURE [Configuracion].[PA_AgregarConfiguracion]
	@CodConfiguracion	    varchar(27),
	@Nombre					varchar(25),
	@Descripcion			varchar(250),
	@TipoConfiguracion		char(1),
	@FechaCreacion			datetime2,
	@EsValorGeneral			bit,
	@EsMultiple				bit,
	@NombreEstructura		varchar(256),
	@CampoMostrar			varchar(100),
	@CampoIdentificador		varchar(100)
AS
BEGIN
	Insert into Configuracion.Configuracion
	(
		TC_CodConfiguracion,		TC_Nombre,			TC_Descripcion,		TC_TipoConfiguracion,
		TF_FechaCreacion,			TB_EsValorGeneral,	TB_EsMultiple,		TC_CampoIdentificador,
		TC_CampoMostrar,			TC_NombreEstructura
	)
	Values 
	(
		@CodConfiguracion,			@Nombre,			@Descripcion,		@TipoConfiguracion,
		@FechaCreacion,				@EsValorGeneral,	@EsMultiple,		@CampoIdentificador,
		@CampoMostrar,				@NombreEstructura
	) 
END


GO
