SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <31/08/2015>
-- Descripcion:	<Crear un nuevo tipo de medida cautelar.>
-- =================================================================================================================================================
-- Modificado por:		<05/01/2016> <Alejandro Villalta> <Modificar el tipo de dato del codigo de tipo medida cautelar para autogenerar el valor.>
-- Modificado por:      <02/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de TipoMedidaCautelar a TipoMedida>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_AgregarTipoMedida] 
	@Descripcion varchar(150),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.TipoMedida
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion,	@FechaVencimiento
	)
END
GO
