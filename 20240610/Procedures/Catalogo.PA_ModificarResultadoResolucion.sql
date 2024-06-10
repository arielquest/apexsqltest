SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <18/08/2015>
-- Descripcion:	<Modificar datos de un resultado de resolucion>
-- Modificacion:  16/12/2015  Modificar tipo dato TC_CodResultadoResolucion a smallint
-- Modificado:	<Gerardo Lopez  , 06/05/2016, Agregar campo TC_CodTipoOficina>
-- Modificado:	<Johan Acosta, 08/06/2016, Se quita el campo tipo oficina >
-- Modificado:	<Pablo Alvarez, 05/12/2016, Se corrige TN_CodResultadoesolucion por estandar >
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarResultadoResolucion] 
	@CodResultadoResolucion smallint, 
	@Descripcion varchar(150),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.ResultadoResolucion
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE	TN_CodResultadoResolucion	=	@CodResultadoResolucion
END

GO
