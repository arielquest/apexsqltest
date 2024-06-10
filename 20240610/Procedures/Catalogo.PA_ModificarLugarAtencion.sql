SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Johan Acosta Ibañez>
-- Fecha Creación: <08/09/2015>
-- Descripcion:    <Modificar un Lugar de Atención a la victima.>
-- Modificacion:   15/12/2015  Pablo Alvarez <Generar llave por sequence> 
-- Modificacion:   02/12/2016  Pablo Alvarez <Se modifica TN_CodLugarAtención por estandar> 
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarLugarAtencion] 
	@Codigo smallint, 
	@Descripcion varchar(255),
	@CodProvincia smallint,
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.LugarAtencion
	SET		TC_Descripcion			=	@Descripcion,
			TN_CodProvincia			=   @CodProvincia,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE TN_CodLugarAtencion		=	@Codigo
END




GO
