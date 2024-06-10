SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<ROGER Lara Hernandez>
-- Fecha Creación: <06/08/2015>
-- Descripcion:	<Crear un nuevo circuito>
--
-- Modificación: <Andrés Díaz> <28/10/2016> <Se agrega el código de provincia.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarCircuito] 
	@Descripcion			varchar(255),
	@CodProvincia			smallint,
	@FechaActivacion		datetime2,
	@FechaDesActivacion		datetime2
AS
BEGIN
	INSERT INTO Catalogo.Circuito
	(
		TC_Descripcion,
		TN_CodProvincia,
		TF_Inicio_Vigencia,
		TF_Fin_Vigencia
	) 
	VALUES
	(
		@Descripcion,
		@CodProvincia,
		@FechaActivacion,
		@FechaDesActivacion
	)
END

GO
