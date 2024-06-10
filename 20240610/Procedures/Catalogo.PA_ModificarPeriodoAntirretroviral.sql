SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<28/08/2015>
-- Descripción :			<Permite Modificar un PeriodoAntirretroviral en la tabla Catalogo.PeriodoAntirretroviral> 
-- =================================================================================================================================================
-- Modificado por:			<08/12/2015> <GerardoLopez> 	<Se cambia tipo dato codigo a smallint>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarPeriodoAntirretroviral]

	@CodPeriodoAntirretro  smallint,
	@Descripcion varchar(150),	
	@FinVigencia datetime2	
	

AS  
BEGIN  

	Update	Catalogo.PeriodoAntirretroviral
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia				
	Where	TN_CodPeriodoAntirretro			=	@CodPeriodoAntirretro
End






GO
