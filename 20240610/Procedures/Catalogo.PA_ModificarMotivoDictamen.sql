SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<02/10/2015>
-- Descripcion:		<Modificar un Motivo de dictamen.>
-- Modificación:   <02/12/2016> <Pablo Alvarez> <Se modifican TN_CodMotivoDictamen por estandar.>
-- ==================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoDictamen] 
	@Codigo smallint, 
	@Descripcion varchar(150),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.MotivoDictamen
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE	TN_CodMotivoDictamen		=	@Codigo
END




GO
