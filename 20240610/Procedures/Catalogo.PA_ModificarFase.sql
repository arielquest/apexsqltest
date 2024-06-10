SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Alejandro Villalta Ruiz>
-- Fecha Creación: <10/08/2015>
-- Descripcion:	<Modificar una nueva fase>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarFase] 
	@Codigo varchar(6), 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
			UPDATE Catalogo.Fase
			SET TC_Descripcion=@Descripcion,
				TF_Fin_Vigencia=@FechaVencimiento
			WHERE 
				TN_CodFase=@Codigo
END
GO
