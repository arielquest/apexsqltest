SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================================================
-- Autor:					<Johan Acosta Ibañez>
-- Fecha Creación:			<17/08/2015>
-- Descripcion:				<Modificar un tipo de intervención>
-- Modificacion:			<Sigifredo Leitón Luna.> 
-- Fecha de modificación:	<04/01/2016>
-- Descripción:				<Se realiza cambio para autogenerar los consecutivos del codigo de tipo de intervención.>
-- =======================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoIntervencion] 
	@Codigo smallint, 
	@Descripcion varchar(255),
	@Intervencion	char(1),	
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.TipoIntervencion
	SET		TC_Descripcion			=	@Descripcion,
			TC_Intervencion			=	@Intervencion,	
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE	TN_CodTipoIntervencion	=	@Codigo
END


GO
