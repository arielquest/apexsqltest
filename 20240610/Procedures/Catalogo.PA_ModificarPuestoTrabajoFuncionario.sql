SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta>
-- Fecha Creación: <21/07/2016>
-- Descripcion:	<Modificar un puesto de trabajo funcionario>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarPuestoTrabajoFuncionario] 
	 @CodPuestoFuncionario	uniqueidentifier,
	 @FechaVencimiento		datetime2
AS
BEGIN
	UPDATE	Catalogo.PuestoTrabajoFuncionario
	SET		TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE	TU_CodPuestoFuncionario		=	@CodPuestoFuncionario
END



GO
