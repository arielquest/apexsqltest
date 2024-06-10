SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <31/08/2015>
-- Descripcion:	<Modificar una discapacidad>
-- Modificado:	<Alejandro Villalta, 09-12-2015, Autogenerar el codigo de discapacidad>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarDiscapacidad] 
	@Codigo smallint, 
	@Descripcion varchar(100),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.Discapacidad
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE TN_CodDiscapacidad		=	@Codigo
END




GO
