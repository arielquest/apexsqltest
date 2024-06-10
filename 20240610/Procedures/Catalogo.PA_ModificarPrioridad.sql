SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<10/08/2015>
-- Descripción :			<Permite Modificar una Prioridad en la tabla Catalogo.Prioridad> 
-- Modificación:			<21/12/2016> <Pablo Alvarez> <Se corrige TN_CodPrioridad por estandar.>
-- 
--Modificación:				<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 150.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarPrioridad]

	@CodPrioridad	smallint,
	@Descripcion	varchar(150),	
	@FinVigencia	datetime2,
	@ColorAlerta	varchar(10)
AS  
BEGIN  

	Update	Catalogo.Prioridad 
	Set		TC_Descripcion					=	@Descripcion,		
			TF_Fin_Vigencia					=	@FinVigencia,
			TC_ColorAlerta					=	@ColorAlerta
	Where	TN_CodPrioridad 				=	@CodPrioridad
End
GO
