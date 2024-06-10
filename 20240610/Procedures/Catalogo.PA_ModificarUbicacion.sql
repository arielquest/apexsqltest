SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Autor:		<Pablo Alvarez>
-- Fecha Creación: <10/09/2015>
-- Descripcion:	<Modificar datos de un Ubicacion>
--
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodUbicacion a TN_CodUbicacion de acuerdo al tipo de dato.>
-- Modificación:			<13/12/2016> <Diego Navarrete> <Se corrige la capacidad del varchar y tipo de @CodUbicacion>
-- Modificación:			<23/11/2020> <Fabian Sequeira> <Se agrega el codigo de oficina>
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarUbicacion] 
	@CodUbicacion		Int, 
	@Descripcion		varchar(255),
	@FechaVencimiento	datetime2,
	@Oficina			varchar(4)
AS
BEGIN

	DECLARE	@L_CodUbicacion					Int					= @CodUbicacion
    DECLARE	@L_Descripcion					Varchar(150)		= @Descripcion
	DECLARE	@L_FechaVencimiento				datetime2			= @FechaVencimiento
	DECLARE	@L_Oficina						varchar(4)			= @Oficina

	UPDATE	Catalogo.Ubicacion
	SET		TC_Descripcion	=		@L_Descripcion,
			TF_Fin_Vigencia	=		@L_FechaVencimiento, 
			TC_CodOficina	=		@L_Oficina
	WHERE	TN_CodUbicacion	=		@L_CodUbicacion
END
GO
