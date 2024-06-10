SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<01/12/2016>
-- Descripción :			<Permite agregar una nueva TipoComunicacionJudicial a a la tabla Catalogo.TipoComunicacionJudicial> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoComunicacionJudicial]
	@Descripcion varchar(50),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
AS  
BEGIN  

	Insert Into		Catalogo.TipoComunicacionJudicial
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End






GO
