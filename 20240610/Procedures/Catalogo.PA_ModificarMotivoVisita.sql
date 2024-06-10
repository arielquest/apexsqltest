SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <27/08/2015>
-- Descripcion:	<Modificar un motivo de visita>
-- Modificacion:<Alejandro Villalta><04/01/2016><Modificar el tipo de dato del campo codigo de motivo de visita>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoVisita] 
	@Codigo smallint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.MotivoVisita
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE TN_CodMotivoVisita			=	@Codigo
END




GO
