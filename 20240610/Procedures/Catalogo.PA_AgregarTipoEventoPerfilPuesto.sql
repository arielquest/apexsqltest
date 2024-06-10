SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<09/11/2016>
-- Descripción :			<Permite agregar un registro a Catalogo.TipoEventoPerfilPuesto.>
-- ================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEventoPerfilPuesto]
	@CodTipoEvento		smallint,
--	@CodPerfilPuesto	smallint,
	@FechaActivacion	datetime2
As 
Begin
	Insert Into Catalogo.TipoEventoPerfilPuesto
		(TN_CodTipoEvento, 
	--	TN_CodPerfilPuesto, 
		TF_Inicio_Vigencia)
	Values
		(@CodTipoEvento,
	--	@CodPerfilPuesto,
		@FechaActivacion);
End
GO
