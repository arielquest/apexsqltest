SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<14/11/2018>
-- Descripción :			<Permite Modificar un Banco> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarBanco] 
	@CodBanco			char(4), 
	@Descripcion		varchar(255),
	@FechaVencimiento	datetime2
AS
BEGIN
	UPDATE	Catalogo.Banco
	SET     TC_Descripcion		  =	@Descripcion,
			TF_Fin_Vigencia		  =	@FechaVencimiento
	WHERE	TC_CodigoBanco		 =	@CodBanco
END

GO
