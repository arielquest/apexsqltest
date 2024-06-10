SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<02/10/2015>
-- Descripcion:		<Modificar datos de un estado de actividades programadas>
-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<09/12/2015>
-- Descripción :			<Se cambia el tipo de dato del código> 

-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoActividadProgramada] 
	@CodEstadoActividad		smallint,
	@Descripcion			varchar(50),
	@FechaVencimiento		datetime2
AS
BEGIN
	UPDATE	Catalogo.EstadoActividadProgramada
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE	TN_CodEstadoActividad	=	@CodEstadoActividad
END
GO
