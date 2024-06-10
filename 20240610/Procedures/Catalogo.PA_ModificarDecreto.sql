SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<06/11/2018>
-- Descripción :			<Permite Modificar un Decreto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarDecreto] 
	@CodDecreto			varchar(15), 
	@Descripcion		varchar(255),
	@FechaVencimiento	datetime2,
	@FechaPublicacion	datetime2
AS
BEGIN
	UPDATE	Catalogo.Decreto
	SET     TC_Descripcion		  =	@Descripcion,
			TF_Fin_Vigencia		  =	@FechaVencimiento,
			TF_FechaPublicacion   =	@FechaPublicacion
	WHERE	TC_CodigoDecreto	  =	@CodDecreto
END

GO
