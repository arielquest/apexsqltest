SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<06/09/2016>
-- Descripcion:		<Modificar estado de evento>
--
-- Modificación:	<Andrés Díaz><07/12/2016><Se agrega el campo TB_FinalizaEvento.>
-- =============================================
	
CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoEvento] 
	@CodEstadoEvento	smallint, 
	@Descripcion		varchar(50),
	@FinalizaEvento		bit,
	@FechaDesactivacion datetime2	
AS
BEGIN

UPDATE	Catalogo.EstadoEvento
Set		TC_Descripcion		= @Descripcion,
		TB_FinalizaEvento	= @FinalizaEvento,
		TF_Fin_Vigencia		= @FechaDesActivacion
where	TN_CodEstadoEvento	= @CodEstadoEvento

END

GO
