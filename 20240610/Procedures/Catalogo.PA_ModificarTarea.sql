SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez>
-- Fecha Creación: <10/09/2015>
-- Descripcion:	<Modificar datos de un Tarea>
-- Modificado : Pablo Alvarez
-- Fecha: 15/12/2015
-- Descripcion: Se cambio la llave a int sequence
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTarea] 
	@CodTarea smallint,
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.Tarea
	SET		TC_Descripcion	=	@Descripcion,
			TF_Fin_Vigencia	=	@FechaVencimiento
	WHERE	TN_CodTarea		=	@CodTarea
END
GO
