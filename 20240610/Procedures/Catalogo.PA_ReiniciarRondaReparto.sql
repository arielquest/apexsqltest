SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Registra el reparto en bitácora> 
-- =================================================================================================================================================
-- Versión:					<2.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<22/09/2021>
-- Descripción :			<Se agrega línea para que modifique la configuración de reparto y siempre devuelva 1 por si no hay conjunto adicional> 
-- =================================================================================================================================================
-- Versión:					<3.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<22/09/2021>
-- Descripción :			<Se elimina línea para que modifique la configuración de reparto y siempre devuelva 1 por si no hay conjunto adicional> 
-- =================================================================================================================================================
-- Versión:					<4.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<11/07/2023>
-- Descripción :			<PBI:393745 Se realiza cambio para restar el asignado menos el limite> 
-- =================================================================================================================================================
-- Versión:					<5.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<11/07/2023>
-- Descripción :			<PBI:335857 Se realiza cambio en el update de limite ya que la consulta estaba erronea> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ReiniciarRondaReparto]      
	@CodCriterioReparto			uniqueidentifier,
	@PrioridadConjunto			varchar(1)
AS  
BEGIN  
	Declare 
			@L_CodCriterioReparto	uniqueidentifier = @CodCriterioReparto,
			@L_PrioridadConjunto	varchar(1)       = @PrioridadConjunto,
			@L_Contador				INT              = 0


		UPDATE  CA
		SET
			  TN_Asignaciones  = CA.TN_Asignaciones - M.TN_Limite
		FROM  
			Catalogo.CriterioAsignacion CA WITH(NOLOCK)
		INNER JOIN Catalogo.ConjuntosReparto C WITH(NOLOCK)
					ON CA.TU_CodConjuntoReparto = C.TU_CodConjutoReparto
		INNER JOIN Catalogo.MiembrosPorConjuntoReparto M WITH(NOLOCK)
					ON M.TU_CodConjutoReparto = C.TU_CodConjutoReparto 
					AND M.TC_CodPuestoTrabajo = CA.TC_CodPuestoTrabajo
		WHERE 
			CA.TU_CodCriterio			= @L_CodCriterioReparto
			AND C.TC_Prioridad			= @L_PrioridadConjunto 


		Update Catalogo.ControlRondasReparto 
		Set TN_NumeroRonda = TN_NumeroRonda + 1 
		Where TU_CodCriterioReparto = @L_CodCriterioReparto And
			     Exists (Select M.TC_CodPuestoTrabajo
						 From			Catalogo.EquipoCriterio B 
						    Inner Join  Catalogo.EquiposReparto E with(nolock) On E.TU_CodEquipo = B.TU_CodEquipo 
							Inner Join  Catalogo.MiembrosPorConjuntoReparto M with(nolock)  On M.TC_CodPuestoTrabajo = Catalogo.ControlRondasReparto.TC_CodPuestoTrabajo 
							Inner Join  Catalogo.ConjuntosReparto C with(nolock)  On C.TU_CodConjutoReparto = M.TU_CodConjutoReparto And C.TU_CodEquipo = B.TU_CodEquipo
							
						 Where B.TU_CodCriterio                                    = @L_CodCriterioReparto And
							   Catalogo.ControlRondasReparto.TU_CodCriterioReparto = B.TU_CodCriterio And
						   C.TC_Prioridad							           = @L_PrioridadConjunto)




END
GO
