SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<05/12/2018>
-- Descripción :			<Permite modificar una clase> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarClase]
	@CodClase			int, 
	@Descripcion		varchar(255),
	@FechaVencimiento	datetime2
AS
BEGIN
	UPDATE	Catalogo.Clase
	SET     TC_Descripcion		=	@Descripcion,
			TF_Fin_Vigencia		=	@FechaVencimiento
	WHERE	TN_CodClase			=	@CodClase
END

GO
