SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<31/08/2021>
-- Descripción :			<Obtiene los miembros de los conjuntos de un equipo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ObtenerMiembrosPorEquipo]
	@CodEquipo	UNIQUEIDENTIFIER	
AS  
BEGIN  
	DECLARE 
			@L_CodEquipo	UNIQUEIDENTIFIER						=	@CodEquipo

			SELECT			A.TU_CodMiembroReparto					Codigo,
							A.TU_CodConjutoReparto					CodigoConjunto,
							B.TU_CodEquipo							CodigoEquipo,
							A.TC_CodPuestoTrabajo					CodigoPuestoTrabajo,
							A.TN_Limite								Limite,
							A.TN_Prioridad							PrioridadMiembro,
							'Split'									Split,
							B.TC_Prioridad							PrioridadConjunto
			FROM			Catalogo.MiembrosPorConjuntoReparto		A	WITH(NOLOCK) 
			INNER JOIN		Catalogo.ConjuntosReparto				B	WITH(NOLOCK) 
			ON				B.TU_CodConjutoReparto					=	A.TU_CodConjutoReparto
			WHERE			B.TU_CodEquipo							=	@L_CodEquipo						
END



GO
