SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:		   <Pablo Alvarez E>
-- Fecha Creación: <19/02/2016>
-- Descripcion:    <Modificar un EstadoTramite.>
--
-- Modificación:	<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 50.>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoTramite] 
	@CodEstadoTramite		smallint, 
	@Descripcion			varchar(50),
	@FinVigencia			datetime2=null	
AS
BEGIN
	UPDATE	Catalogo.EstadoTramite
	Set		TC_Descripcion			= @Descripcion,
			TF_Fin_Vigencia			= @FinVigencia
	where	TN_CodEstadoTramite		= @CodEstadoTramite;
END
GO
