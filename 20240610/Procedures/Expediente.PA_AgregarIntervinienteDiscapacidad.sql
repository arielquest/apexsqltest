SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Alejandro Villalta>
-- Fecha Creación:	<03/12/2015>
-- Descripcion:		<Agregar discapacidades a un interviniente.>
--
-- Modificación:	<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodDiscapacidad a TN_CodDiscapacidad de acuerdo al tipo de dato.>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteDiscapacidad]   
	@CodInterviniente	uniqueidentifier,
	@CodDiscapacidad	smallint
AS
BEGIN
	   INSERT INTO Expediente.IntervinienteDiscapacidad
	   (
		TU_CodInterviniente, TN_CodDiscapacidad, TF_Actualizacion
	   )
	   Values
	   (
		@CodInterviniente,	@CodDiscapacidad,	 Getdate()
	   )	 
END
GO
