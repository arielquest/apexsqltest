SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Obtiene los miembros de un conjunto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ObtenerMiembrosPorConjunto]
	@CodConjuntoReparto  UNIQUEIDENTIFIER	
AS  
BEGIN  
	DECLARE 
			@L_CodConjuntoReparto	UNIQUEIDENTIFIER = @CodConjuntoReparto

			SELECT	M.TC_CodPuestoTrabajo					AS  CodigoPuestoTrabajo,
					M.TN_Prioridad							AS	PrioridadMiembro,
					M.TU_CodMiembroReparto				    AS	Codigo,
					R.TC_Descripcion						AS  DescripcionTipoPuesto,
					F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + F.TC_SegundoApellido AS NombreUsuario,
					M.TN_CodUbicacion						AS CodigoUbicacion,
					M.TN_Limite								AS Limite,
					R.TN_CodTipoPuestoTrabajo				AS TipoPuestoTrabajo
			 FROM		Catalogo.MiembrosPorConjuntoReparto AS	M	WITH(NOLOCK) 
			 INNER JOIN Catalogo.PuestoTrabajoFuncionario	As	P	with(nolock)   
			 ON			P.TC_CODPUESTOTRABAJO				=	M.TC_CODPUESTOTRABAJO 
			 INNER JOIN Catalogo.PuestoTrabajo				As	T  with(nolock)             
			 On			T.TC_CodPuestoTrabajo				=	P.TC_CodPuestoTrabajo 
			 INNER JOIN Catalogo.TipoPuestoTrabajo			As	R  with(nolock)             
			 On			R.TN_CodTipoPuestoTrabajo			=	T.TN_CodTipoPuestoTrabajo
			 INNER JOIN Catalogo.Funcionario			    As	F  with(nolock)             
			 On			F.TC_UsuarioRed          			=	P.TC_UsuarioRed
			 WHERE		M.TU_CodConjutoReparto				=	@L_CodConjuntoReparto 

END
GO
