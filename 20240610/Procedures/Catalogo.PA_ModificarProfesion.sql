SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <18/08/2015>
-- Descripcion:	<Modificar una profesión>
-- =============================================
-- Modificado por:			<14/12/2015> <GerardoLopez> 	<Se cambia tipo dato @Codigo a smallint>
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodProfesión por estandar.>

CREATE PROCEDURE [Catalogo].[PA_ModificarProfesion] 
	@Codigo  smallint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.Profesion
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE TN_CodProfesion			=	@Codigo
END



GO
