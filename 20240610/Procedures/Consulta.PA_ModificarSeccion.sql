SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Pablo Alvarez>
-- Fecha Creación: <21/04/2016>
-- Descripcion:	   <Modificar una Seccion.>
-- =============================================
CREATE PROCEDURE [Consulta].[PA_ModificarSeccion] 
	@CodSeccion smallint, 
	@Nombre varchar(50),
	@FinVigencia datetime2=null	
AS
BEGIN
	UPDATE	Consulta.Seccion
	Set		TC_Nombre = @Nombre,
			TF_Fin_Vigencia		= @FinVigencia
	where	TN_CodSeccion		= @CodSeccion
END
GO
