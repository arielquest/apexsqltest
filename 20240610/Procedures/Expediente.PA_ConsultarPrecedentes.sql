SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================================================================
-- Autor:				<Mario Camacho Flores>
-- Fecha Creación:		<28/02/2023>
-- Descripcion:			<Consulta precedentes en otras oficinas>
-- ======================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarPrecedentes]
	@Expediente					Varchar(20) = null,
	@Identificacion				Varchar(20) = null,
	@Nombre						Varchar(25) = null,
	@PrimerApellido				Varchar(25) = null,
	@SegundoApellido			Varchar(25) = null,
	@Id_OficinaSEG				Varchar(25) = null,
	@UsuarioSEG					Varchar(25) = null,
	@CodMateria					Varchar(5)  = null,
	@CodTipoOficina				Varchar(10) = null

AS	
BEGIN

	DECLARE
	@L_Expediente				Varchar(20) = @Expediente,
	@L_Identificacion			Varchar(20) = @Identificacion,
	@L_Nombre					Varchar(25) = @Nombre,
	@L_PrimerApellido			Varchar(25) = @PrimerApellido,
	@L_SegundoApellido			Varchar(25) = @SegundoApellido,
	@L_Id_OficinaSEG			Varchar(25) = @Id_OficinaSEG,
	@L_@UsuarioSEG				Varchar(25) = @UsuarioSEG,
	@L_@CodMateria				Varchar(5)  = @CodMateria,
	@L_@CodTipoOficina			Varchar(10) = @CodTipoOficina

	IF @L_Identificacion IS NOT NULL AND (@L_Expediente IS NULL OR @L_Expediente = '') AND (@L_Nombre IS NULL OR @L_Nombre = '')
	BEGIN
		SELECT 
			p.tc_identificacion				AS identificacion,
			pf.TC_Nombre					AS Nombre,
			pf.TC_PrimerApellido			AS PrimerApellido,
			pf.TC_SegundoApellido			AS SegundoApellido ,
			e.TC_NumeroExpediente			AS Expediente,
			HE.TC_Descripcion				AS Estado,
			o.TC_Nombre						AS Oficina,
			i.TF_Inicio_Vigencia			AS FechaResolucion,
			i.TF_Fin_Vigencia				AS FechaCesado,
			i.TU_CodInterviniente			AS CodInterviniente
		FROM persona.persona				AS p WITH(NOLOCK)
		INNER JOIN persona.personafisica	AS pf WITH(NOLOCK)
		ON p.TU_CodPersona					= pf.TU_CodPersona
		INNER JOIN Expediente.Intervencion	AS i WITH(NOLOCK)
		ON p.TU_CodPersona					= i.TU_CodPersona
		INNER JOIN Expediente.Expediente	AS e WITH(NOLOCK)
		ON i.TC_NumeroExpediente			= e.TC_NumeroExpediente
		INNER JOIN Catalogo.Contexto		As c WITH(NOLOCK)
		ON c.TC_CodContexto					= e.TC_CodContexto
		INNER JOIN Catalogo.Oficina			AS o WITH(NOLOCK)
		ON c.TC_CodOficina					= o.TC_CodOficina
		OUTER APPLY							(SELECT TOP(1) NV.TC_Descripcion
											FROM			Historico.ExpedienteMovimientoCirculante HP WITH(NOLOCK) 
											INNER JOIN		Catalogo.Estado				AS	NV WITH(NOLOCK)
											ON				NV.TN_CodEstado				=	HP.TN_CodEstado
											WHERE			HP.TC_NumeroExpediente      =   e.TC_NumeroExpediente 
											ORDER BY		HP.TF_Fecha DESC) as HE
		WHERE c.TC_CodMateria				= @L_@CodMateria
		AND o.TN_CodTipoOficina				= @L_@CodTipoOficina
		AND p.TC_Identificacion				= @L_Identificacion
	END
	ELSE IF @L_Expediente IS NOT NULL AND (@L_Identificacion IS NULL OR @L_Identificacion = '') AND (@L_Nombre IS NULL OR @L_Nombre = '')
	BEGIN
		SELECT 
			p.tc_identificacion				AS identificacion,
			pf.TC_Nombre					AS Nombre,
			pf.TC_PrimerApellido			AS PrimerApellido,
			pf.TC_SegundoApellido			AS SegundoApellido ,
			e.TC_NumeroExpediente			AS Expediente,
			HE.TC_Descripcion				AS Estado,
			o.TC_Nombre						AS Oficina,
			i.TF_Inicio_Vigencia			AS FechaResolucion,
			i.TF_Fin_Vigencia				AS FechaCesado,
			i.TU_CodInterviniente			AS CodInterviniente
		FROM persona.persona				AS p WITH(NOLOCK)
		INNER JOIN persona.personafisica	AS pf WITH(NOLOCK)
		ON p.TU_CodPersona					= pf.TU_CodPersona
		INNER JOIN Expediente.Intervencion	AS i WITH(NOLOCK)
		ON p.TU_CodPersona					= i.TU_CodPersona
		INNER JOIN Expediente.Expediente	AS e WITH(NOLOCK)
		ON i.TC_NumeroExpediente			= e.TC_NumeroExpediente
		INNER JOIN Catalogo.Contexto		As c WITH(NOLOCK)
		ON c.TC_CodContexto					= e.TC_CodContexto
		INNER JOIN Catalogo.Oficina			AS o WITH(NOLOCK)
		ON c.TC_CodOficina					= o.TC_CodOficina
		OUTER APPLY							(SELECT TOP(1) NV.TC_Descripcion
											FROM			Historico.ExpedienteMovimientoCirculante HP WITH(NOLOCK) 
											INNER JOIN		Catalogo.Estado				AS	NV WITH(NOLOCK)
											ON				NV.TN_CodEstado				=	HP.TN_CodEstado
											WHERE			HP.TC_NumeroExpediente      =   e.TC_NumeroExpediente 
											ORDER BY		HP.TF_Fecha DESC) as HE
		WHERE c.TC_CodMateria				= @L_@CodMateria 
		AND o.TN_CodTipoOficina				= @L_@CodTipoOficina
		AND E.TC_NumeroExpediente			= @L_Expediente
	END
	ELSE IF @L_Nombre IS NOT NULL AND (@L_Identificacion IS NULL OR @L_Identificacion = '') AND (@L_Expediente IS NULL OR @L_Expediente = '')
	BEGIN
		SELECT 
			p.tc_identificacion				AS identificacion,
			pf.TC_Nombre					AS Nombre,
			pf.TC_PrimerApellido			AS PrimerApellido,
			pf.TC_SegundoApellido			AS SegundoApellido ,
			e.TC_NumeroExpediente			AS Expediente,
			HE.TC_Descripcion				AS Estado,
			o.TC_Nombre						AS Oficina,
			i.TF_Inicio_Vigencia			AS FechaResolucion,
			i.TF_Fin_Vigencia				AS FechaCesado,
			i.TU_CodInterviniente			AS CodInterviniente
		FROM persona.persona				AS p WITH(NOLOCK)
		INNER JOIN persona.personafisica	AS pf WITH(NOLOCK)
		ON p.TU_CodPersona					= pf.TU_CodPersona
		INNER JOIN Expediente.Intervencion	AS i WITH(NOLOCK)
		ON p.TU_CodPersona					= i.TU_CodPersona
		INNER JOIN Expediente.Expediente	AS e WITH(NOLOCK)
		ON i.TC_NumeroExpediente			= e.TC_NumeroExpediente
		INNER JOIN Catalogo.Contexto		As c WITH(NOLOCK)
		ON c.TC_CodContexto					= e.TC_CodContexto
		INNER JOIN Catalogo.Oficina			AS o WITH(NOLOCK)
		ON c.TC_CodOficina					= o.TC_CodOficina
		OUTER APPLY							(SELECT TOP(1) NV.TC_Descripcion
											FROM			Historico.ExpedienteMovimientoCirculante HP WITH(NOLOCK) 
											INNER JOIN		Catalogo.Estado				AS	NV WITH(NOLOCK)
											ON				NV.TN_CodEstado				=	HP.TN_CodEstado
											WHERE			HP.TC_NumeroExpediente      =   e.TC_NumeroExpediente 				
											ORDER BY		HP.TF_Fecha DESC) as HE
		WHERE c.TC_CodMateria				= @L_@CodMateria
		AND o.TN_CodTipoOficina				= @L_@CodTipoOficina
		AND pf.TC_Nombre					LIKE COALESCE(@L_Nombre,'')+'%'
		AND pf.TC_PrimerApellido			LIKE COALESCE(@L_PrimerApellido,'')+'%'
		AND pf.TC_SegundoApellido			LIKE COALESCE(@L_SegundoApellido,'')+'%'
	END
END
GO
