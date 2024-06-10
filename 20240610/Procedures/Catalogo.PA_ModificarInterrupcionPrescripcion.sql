SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <26/08/2015>
-- Descripcion:	<Modificar datos de un acto de interrupcion de prescripción.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarInterrupcionPrescripcion] 
	@CodInterrupcion smallint, 
	@Descripcion varchar(100),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.InterrupcionPrescripcion
	SET		TC_Descripcion		=	@Descripcion,
			TF_Fin_Vigencia		=	@FechaVencimiento
	WHERE	TN_CodInterrupcion	=	@CodInterrupcion
END
GO
