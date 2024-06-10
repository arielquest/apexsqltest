SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<07/08/2015>
-- Descripción :			<Permite Modificar un estado en la tabla Catalogo.Estado> 
-- Modificado :				<Alejandro Villalta, 14/12/2015, Se modifica el tipo de dato del codigo de tipo estado.> 
-- Modificado :				<Olger Gamboa Castillo, 17/12/2015, Se modifica el tipo de dato del codigo de estado a smallint.> 
-- Modificación				<Jonathan Aguilar Navarro> <22/02/2019> <Se agregan los parametros @ExpedienteLegajo, @Circulante y @Pasivo>
-- Modificación:			<Karol Jiménez S.><04/05/2021> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEstado]
	@CodEstado			int,
	@Descripcion		varchar(150),	
	@FinVigencia		datetime2,
	@ExpedienteLegajo	varchar(1),
	@Circulante			varchar(1),	
	@Pasivo				varchar(1)	
AS  
BEGIN  

	Update	Catalogo.Estado
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia,
			TC_ExpedienteLegajo				=	@ExpedienteLegajo,
			TC_Circulante					=	@Circulante,
			TC_Pasivo						=	@Pasivo
	Where	TN_CodEstado					=	@CodEstado
End




GO
