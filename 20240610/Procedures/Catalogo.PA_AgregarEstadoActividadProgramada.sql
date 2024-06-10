SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<01/10/2015>
-- Descripcion:		<Crear un nuevo estado actividad programada>
--
-- Modificado por: Olger Gamboa Castillo
-- Fecha Modificación:	<09/12/2015>
-- Descripcion:		<Se modifica pára usar sequence>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoActividadProgramada] 
	@Descripcion		Varchar(50),
	@FechaActivacion	Datetime2,
	@FechaVencimiento	Datetime2
AS
BEGIN
	INSERT INTO Catalogo.EstadoActividadProgramada
	(
		TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	) 
	VALUES
	(
		@Descripcion,	@FechaActivacion,	@FechaVencimiento
	)
END
GO
