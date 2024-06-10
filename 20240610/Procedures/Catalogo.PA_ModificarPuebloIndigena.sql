SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:		<Pablo ALvarez E>
-- Fecha Creación: <22/09/2015>
-- Descripcion:	<Modificar datos de un PuebloIndigena>
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodPuebloIndigena por estandar.>
--
-- Modificación:			<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 255.>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarPuebloIndigena] 
	@CodPuebloIndigena smallint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.PuebloIndigena
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE	TN_CodPuebloIndigena		=	@CodPuebloIndigena
END

GO
