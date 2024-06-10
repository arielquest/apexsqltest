SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<17/05/2021>
-- Descripción :			<Actualiza la prioridad de los miembros de equipos proceso de control de rondas> 
-- =================================================================================================================================================
--select * from Catalogo.ControlRondasReparto order by TU_CodCriterioReparto
--select TC_Prioridad,* from Catalogo.MiembrosPorConjuntoReparto M, Catalogo.ConjuntosReparto C 
--where M.TU_CodConjutoReparto = C.TU_CodConjutoReparto order by TU_CodEquipo
--exec  Catalogo.PA_CambiarPrioridadReparto 'C26957E7-5B61-46AD-9532-07483CE4DADC'
CREATE PROCEDURE [Catalogo].[PA_CambiarPrioridadReparto]      
	@CodCriterioReparto			uniqueidentifier,
	@CodPuestoTrabajo			varchar(14),
	@Prioridad			        smallint
AS  
BEGIN  
	Declare 
			@L_CodCriterioReparto	uniqueidentifier = @CodCriterioReparto,
			@L_CodPuestoTrabajo	    varchar(14)		 = @CodPuestoTrabajo,
			@L_Prioridad	        smallint         = @Prioridad

	Update Catalogo.ControlRondasReparto set TN_Prioridad = @L_Prioridad
	Where TU_CodCriterioReparto = @L_CodCriterioReparto And
	      TC_CodPuestoTrabajo   = @CodPuestoTrabajo

END
GO
