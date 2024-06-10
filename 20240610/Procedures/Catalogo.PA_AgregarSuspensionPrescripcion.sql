SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Pablo Alvarez Espinoza>
-- Fecha de creación:	<26/08/2015>
-- Descripción :		<Permite Agregar una prescripción de suspensión> 
-- Modificado por:		<Sigifredo Leitón Luna>
-- Fecha de creación:	<08/01/2016>
-- Descripción :		<Se modifica para la autogeneración del código de suspensión prescripción - item 5606> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarSuspensionPrescripcion]
	@Descripcion varchar(100),
	@FechaActivacion datetime2(3),
	@FechaVencimiento datetime2(3)
 
AS
BEGIN
	INSERT INTO Catalogo.SuspensionPrescripcion
	(
		TC_Descripcion, TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
		@Descripcion, @FechaActivacion, @FechaVencimiento 
	)
END
 

GO
