SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Roger Lara>
-- Fecha Creación: <07/09/2015>
-- Descripcion:	<Modificar datos de un tipo de profesional>
-- =============================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoProfesional] 
	@CodTipoProfesional  smallint, 
	@Descripcion varchar(100),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.TipoProfesional
	SET		TC_Descripcion	=	@Descripcion,
			TF_Fin_Vigencia	=	@FechaVencimiento
	WHERE	TN_CodTipoProfesional	=	@CodTipoProfesional
END
GO
