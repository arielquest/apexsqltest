SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<08/09/2016>
-- Descripcion:		<Modificar Tipo de evento>
--
-- Modificación:	<Andrés Díaz><28/11/2016><Se agrega el campo TB_EsRemate.>
-- =============================================
	
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoEvento] 
	@CodTipoEvento		smallint, 
	@Descripcion		varchar(50),
	@ColorEvento		nvarchar(50),
	@EsRemate			bit,
	@FechaDesactivacion datetime2	
AS
BEGIN

UPDATE	Catalogo.TipoEvento
Set		TC_Descripcion		= @Descripcion,
		TC_ColorEvento		= @ColorEvento,
		TB_EsRemate			= @EsRemate,
		TF_Fin_Vigencia		= @FechaDesActivacion
where	TN_CodTipoEvento	= @CodTipoEvento

END

GO
