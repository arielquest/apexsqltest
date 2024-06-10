SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================
-- Autor:			<Roger Lara>
-- Fecha Creación:  <1/10/2015>
-- Descripcion:		<Crear un nuevo tipo de diligencia>
-- Modificacion		<Gerardo Lopez> <09/11/2015> <Agregar estado diligencia>
-- Modificacion		<Alejandro Villalta> <14/12/2015> <Autogenerar el campo codigo>
-- ===============================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoDiligencia] 
	@Descripcion varchar(100),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2=null
AS
BEGIN
	INSERT INTO Catalogo.TipoDiligencia
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia 
	)
	VALUES
	(
		@Descripcion,	@FechaActivacion	,@FechaVencimiento 
	)
END
GO
