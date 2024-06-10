SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Olger Ariel Gamboa Castillo
-- Create date: <14-08-2015>
-- Description:	<Modificar un tipo de entidad jurídica
-- Modificacion:  15/12/2015  Modificar tipo dato CodTipoEntidad a smallint
-- =============================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoEntidadJuridica]
@CodTipoEntidad smallint,
@Descripcion varchar(255),
@FechaVencimiento datetime2(3)=null
AS
BEGIN
	UPDATE	Catalogo.TipoEntidadJuridica
	SET		TC_Descripcion		=	@Descripcion,
			TF_Fin_Vigencia		=	@FechaVencimiento
	WHERE	TN_CodTipoEntidad	=	@CodTipoEntidad
END

GO
