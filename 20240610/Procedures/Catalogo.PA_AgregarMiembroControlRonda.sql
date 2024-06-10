SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<29/07/2021>
-- Descripción :			<Registra un miembro en el control de rondas> 
-- Modificado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<01/09/2021>
-- Descripción :			<Se agrega de manera opcional el parámetro del código de criterio> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarMiembroControlRonda]  
	@CodMiembro				UNIQUEIDENTIFIER,
	@CodConjunto			UNIQUEIDENTIFIER,
	@Prioridad				SMALLINT, 
	@CodCriterio			UNIQUEIDENTIFIER = NULL
AS  
BEGIN  
	DECLARE 
			@L_CodConjunto			UNIQUEIDENTIFIER = @CodConjunto,
			@L_CodMiembro			UNIQUEIDENTIFIER = @CodMiembro,
			@L_Prioridad			SMALLINT		 = @Prioridad,
			@L_CodCriterio			UNIQUEIDENTIFIER = @CodCriterio

			

	INSERT INTO Catalogo.ControlRondasReparto (
			TU_CodRonda,	TU_CodCriterioReparto,	TC_CodPuestoTrabajo,
			TN_Prioridad,	TF_Fecha,				TF_Particion,
			TU_CodEquipo)
	SELECT	NEWID(),		R.TU_CodCriterio,		M.TC_CodPuestoTrabajo,
			@L_Prioridad,   GETDATE(),				GETDATE(),
			E.TU_CodEquipo
	FROM       Catalogo.EquiposReparto				E	WITH(NOLOCK)
	INNER JOIN Catalogo.ConjuntosReparto			C	WITH(NOLOCK)    ON C.TU_CodEquipo               = E.TU_CodEquipo
	INNER JOIN Catalogo.MiembrosPorConjuntoReparto  M   WITH(NOLOCK)	ON M.TU_CodConjutoReparto       = C.TU_CodConjutoReparto
	INNER JOIN Catalogo.EquipoCriterio				Q   WITH(NOLOCK)    ON Q.TU_CodEquipo               = E.TU_CodEquipo
	INNER JOIN Catalogo.CriteriosReparto			R   WITH(NOLOCK)    ON R.TU_CodConfiguracionReparto = E.TU_CodConfiguracionReparto AND R.TU_CodCriterio = Q.TU_CodCriterio
	WHERE	   C.TU_CodConjutoReparto	=	@L_CodConjunto AND
		       M.TU_CodMiembroReparto	=	@L_CodMiembro  AND R.TU_CodCriterio = COALESCE(@L_CodCriterio, R.TU_CodCriterio)


	
END
GO
