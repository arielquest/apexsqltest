SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<06/08/2015>
-- Descripción :			<Permite Agregar un nuevo estado en la tabla Catalogo.Estado> 
-- Modificado :				<Alejandro Villalta, 14/12/2015, Se modifica el tipo de dato del codigo de tipo estado.> 
-- Modificado :				<Olger Gamboa Castillo, 17/12/2015, Se modifica el tipo de dato del codigo de estado.> 
-- Modificación				<Jonathan Aguilar Navarro> <22/02/2019> <Se agregan los parametros @ExpedienteLegajo, @Circulante y @Pasivo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEstado]
	@Descripcion		varchar(150),
	@InicioVigencia		datetime2,
	@FinVigencia		datetime2,
	@ExpedienteLegajo	varchar(1),
	@Circulante			varchar(1),	
	@Pasivo				varchar(1)	
AS  
BEGIN  

	Insert Into		Catalogo.Estado
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia,	TC_ExpedienteLegajo,	TC_Circulante,	TC_Pasivo
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia,		@ExpedienteLegajo,		@Circulante,	@Pasivo
	)
End


GO
