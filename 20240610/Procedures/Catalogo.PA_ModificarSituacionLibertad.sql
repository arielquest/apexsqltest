SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez>
-- Fecha Creación: <24/08/2015>
-- Descripcion:	<Modificar datos de una categoria de delito>
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <04/01/2016>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- Modificado:	            <05/12/2016> <Pablo Alvarez><Se corrige TN_CodSituacionLibertad por estandar >
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarSituacionLibertad] 
	@CodSituacionLibertad smallint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2=null
AS
BEGIN
	UPDATE	Catalogo.SituacionLibertad
	SET		TC_Descripcion	=	@Descripcion,
			TF_Fin_Vigencia	=	@FechaVencimiento
	WHERE	TN_CodSituacionLibertad =	@CodSituacionLibertad
END

GO
