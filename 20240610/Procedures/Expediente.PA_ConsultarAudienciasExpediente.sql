SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<05/02/2020>
-- Descripción :			<Permite Consultar las audiencias asociadas a un expediente>
-- =================================================================================================================================================
-- Modificador por:         <Jose Gabriel Cordero Soto><17-04-2020><Se modifica consulta incluyendo excepcion de registros en legajos>
-- =================================================================================================================================================
-- Modificador por:         <Jose Gabriel Cordero Soto><02-06-2020><Se modifica campo Duracion por DuracionTotal por entidad en visual studio, para podr cargar dato>
-- Modificación:			<Jonathan Aguilar Navarro> <07/10/2020> <Se cambio a left join la relación con Funcionario>
-- Modificación				<Jonathan Aguilar Navarro> <08/10/2020> <Se agrega el parametro de @FechaAcumulación, si tiene valor, muestra las audiencias posteriores a la fecha indicada>
-- Modificación				<Andrew Allen Dawson> <08/10/2020> <Se agregan los campos TC_NombreArchivo y TN_CantidadArchivos>
-- Modificacion				<Jose Gabriel Cordero Soto> <06-05-2021> <Se agrega TN_EstadoPublicacion en el resultado de la consulta>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAudienciasExpediente]
 	@NumeroExpediente			VARCHAR(14),
	@FechaAcumulacion			DATETIME2(3) = null
AS
BEGIN

	DECLARE		@L_NumeroExpediente			VARCHAR(14) = @NumeroExpediente
	DECLARE		@L_FechaAcumulacion			DATETIME2(3) = @FechaAcumulacion

    SELECT		A.TN_CodAudiencia			AS Codigo,				
		 	    A.TC_Descripcion			AS Descripcion,
			    A.TC_NombreArchivo			AS NombreArchivo,
			    A.TC_Duracion				AS DuracionTotal,
			    A.TF_FechaCrea				AS FechaCrea,
				A.TN_EstadoPublicacion		AS	EstadoPublicacion,
				A.TN_CantidadArchivos		AS	CantidadArchivos,
				'splitTipoAudiencia'		AS splitTipoAudiencia,
				TA.TN_CodTipoAudiencia		AS Codigo,
				TA.TC_Descripcion			AS Descripcion,
				'splitContexto'				AS splitContexto,
				C.TC_CodContexto			AS Codigo,
				C.TC_Descripcion			AS Descripcion,
				'splitUsuario'				AS splitUsuario,	
				F.TC_UsuarioRed				AS Usuario,
				F.TC_Nombre					AS Nombre,
				F.TC_PrimerApellido			AS PrimerApellido,
				F.TC_SegundoApellido		AS SegundoApellido,
			    'splitOtros'				AS splitOtros,
				A.TC_Estado					AS Estado,
				A.TN_EstadoPublicacion		AS EstadoPublicacion,
				A.TC_NumeroExpediente		AS NumeroExpediente

    FROM		Expediente.Audiencia		AS A  
	INNER JOIN	Catalogo.TipoAudiencia		AS TA WITH(NOLOCK)
	ON			A.TN_CodTipoAudiencia		= TA.TN_CodTipoAudiencia
	INNER JOIN  Catalogo.Contexto			AS C WITH(NOLOCK)
	ON			A.TC_CodContextoCrea		= C.TC_CodContexto	
	LEFT JOIN	Catalogo.Funcionario		AS F WITH(NOLOCK)
	ON			A.TC_UsuarioRedCrea			= F.TC_UsuarioRed
	INNER JOIN 
	(
				SELECT     A.TN_CodAudiencia 
				FROM	   Expediente.Audiencia       AS A WITH(NOLOCK)
				WHERE	   A.TC_NumeroExpediente      = @L_NumeroExpediente
				EXCEPT
				SELECT	   AL.TN_CodAudiencia
				FROM       Expediente.AudienciaLegajo AS AL WITH(NOLOCK)
				INNER JOIN Expediente.Audiencia		  AS A  WITH(NOLOCK)
				ON	  	   A.TN_CodAudiencia		  = AL.TN_CodAudiencia
				WHERE	   A.TC_NumeroExpediente      = @L_NumeroExpediente
	) AS X
    ON			X.TN_CodAudiencia			= A.TN_CodAudiencia
	WHERE		A.TC_NumeroExpediente		= @L_NumeroExpediente 
	And			A.TF_FechaCrea				>= coalesce(@L_FechaAcumulacion, A.TF_FechaCrea)
    
	ORDER BY	A.TF_FechaCrea				ASC  

END
GO
