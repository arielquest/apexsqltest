SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<12/02/2019>
-- Descripción :			<Permite modificar un Asunto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarAsunto]
	@CodAsunto			int, 
	@Descripcion		varchar(255),
	@FechaActivacion	datetime2,
	@FechaVencimiento	datetime2
AS
BEGIN
	UPDATE	Catalogo.Asunto
	SET     TC_Descripcion		=	@Descripcion,
			TF_Fin_Vigencia		=	@FechaVencimiento,
			TF_Inicio_Vigencia  =	@FechaActivacion
	WHERE	TN_CodAsunto		=	@CodAsunto
END

GO
