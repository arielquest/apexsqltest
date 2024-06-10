SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================================================================================================================================================================================
-- Creado por:				<Isaac Santiago Méndez Castillo>
-- Fecha de creación:		<22/06/2021>
-- Descripción:				<Obtiene el domicilio del interviniente en el siguiente orden: "Provincia, Canton, Distrito, B2arrio, Dirección". Al brindarle como
--							 parametros: nombre, número de expediente, contexto, si son habituales (1,0), y una lista de tipos de domicilio (Ejm: '1,2,3')> 
-- ===========================================================================================================================================================================================================================================
-- Modificación:			<Aida Elena Siles R> <12/01/2022> <Se agrega parámetro CodLegajo y lógica para obtener el domicilio del interviniente de un legajo.>
-- ===========================================================================================================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_A_DomicilioInterviniente]
	@NumeroExpediente	CHAR(14),
	@CodLegajo			VARCHAR(40) = NULL,
	@Contexto			VARCHAR(4),
	@NombreParte		VARCHAR(MAX),
	@Habitual			BIT,
	@TiposDomicilio		VARCHAR(MAX)
AS
BEGIN
	DECLARE			@L_NombreParte			VARCHAR(MAX) = @NombreParte,
					@L_CodLegajo			VARCHAR(40)	 = @CodLegajo,
					@L_NumeroExpediente     CHAR(14)     = @NumeroExpediente,
					@L_Contexto             VARCHAR(4)   = @Contexto,
					@L_Habitual				BIT			 = @Habitual,
					@L_TiposDomicilio		VARCHAR(MAX) = @TiposDomicilio;

	DECLARE 		@L_Tipos				TABLE (Tipo INT);

	IF LEN(@L_TiposDomicilio) = 0
		INSERT INTO @L_Tipos
		SELECT	TN_CodTipoDomicilio
		FROM	Catalogo.TipoDomicilio WITH(NOLOCK)
	ELSE
		INSERT INTO @L_Tipos
		SELECT	CONVERT(INT,RTRIM(LTRIM(value)))
		FROM	STRING_SPLIT(@L_TiposDomicilio, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT			CONCAT(
						   CASE WHEN C.TC_Descripcion IS NULL THEN '' ELSE CONCAT(C.TC_Descripcion, ', ') END,											-- DescripcionProvincia
						   CASE WHEN (D.TC_Descripcion IS NULL OR D.TC_Descripcion = C.TC_Descripcion) THEN '' ELSE CONCAT(D.TC_Descripcion, ', ') END, -- DescripcionCanton
						   CASE WHEN (E.TC_Descripcion IS NULL OR E.TC_Descripcion = D.TC_Descripcion) THEN '' ELSE CONCAT(E.TC_Descripcion, ', ') END, -- DescripcionDistrito
						   CASE WHEN (F.TC_Descripcion IS NULL OR F.TC_Descripcion = E.TC_Descripcion) THEN '' ELSE CONCAT(F.TC_Descripcion, ', ') END, -- DescripcionBarrio
						   ISNULL(A.TC_Direccion, '')																									-- Direccion
						   )

		FROM			Persona.Domicilio															AS A WITH(NOLOCK)
		INNER JOIN		Catalogo.TipoDomicilio														AS B WITH(NOLOCK) 
		ON				B.TN_CodTipoDomicilio														= A.TN_CodTipoDomicilio
		LEFT JOIN		Catalogo.Provincia															AS C WITH(NOLOCK) 
		ON				C.TN_CodProvincia															= A.TN_CodProvincia
		LEFT JOIN		Catalogo.Canton																AS D WITH(NOLOCK) 
		ON				D.TN_CodCanton																= A.TN_CodCanton 
		AND				D.TN_CodProvincia															= A.TN_CodProvincia
		LEFT JOIN		Catalogo.Distrito															AS E WITH(NOLOCK) 
		ON				E.TN_CodDistrito															= A.TN_CodDistrito 
		AND				E.TN_CodCanton																= A.TN_CodCanton
		AND				E.TN_CodProvincia															= A.TN_CodProvincia
		LEFT JOIN		Catalogo.Barrio																AS F WITH(NOLOCK) 
		ON				F.TN_CodBarrio																= A.TN_CodBarrio
		AND				E.TN_CodDistrito															= A.TN_CodDistrito 
		AND				E.TN_CodCanton																= A.TN_CodCanton
		AND				E.TN_CodProvincia															= A.TN_CodProvincia
		INNER JOIN		Catalogo.Pais																AS G WITH(NOLOCK) 
		ON				G.TC_CodPais																= A.TC_CodPais
		LEFT JOIN		Persona.PersonaFisica														AS H WITH(NOLOCK)
		ON				A.TU_CodPersona																= H.TU_CodPersona
		LEFT JOIN		Persona.PersonaJuridica														AS I WITH(NOLOCK)
		ON				A.TU_CodPersona																= I.TU_CodPersona
		LEFT JOIN		Expediente.Intervencion														AS J WITH(NOLOCK)
		ON				A.TU_CodPersona																= J.TU_CodPersona
		LEFT JOIN		Expediente.ExpedienteDetalle												AS K WITH(NOLOCK)
		ON				J.TC_NumeroExpediente														= K.TC_NumeroExpediente
		WHERE			(CONCAT(H.TC_Nombre, ' ', H.TC_PrimerApellido, ' ', H.TC_SegundoApellido)   = @L_NombreParte
		OR				CONCAT(H.TC_PrimerApellido, ' ', H.TC_SegundoApellido, ' ', H.TC_Nombre)    = @L_NombreParte
		OR				I.TC_Nombre																	= @L_NombreParte)
		AND				J.TC_NumeroExpediente														= @L_NumeroExpediente
		AND				K.TC_CodContexto															= @L_Contexto
		AND				A.TB_DomicilioHabitual														= @L_Habitual
		AND				A.TN_CodTipoDomicilio														IN (SELECT Tipo
																										FROM @L_Tipos)
		AND				J.TU_CodInterviniente														NOT IN (SELECT	LI.TU_CodInterviniente
																											FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																											WHERE	LI.TU_CodInterviniente = J.TU_CodInterviniente)
	END
	ELSE
	BEGIN
		SELECT			CONCAT(
						   CASE WHEN C.TC_Descripcion IS NULL THEN '' ELSE CONCAT(C.TC_Descripcion, ', ') END,											-- DescripcionProvincia
						   CASE WHEN (D.TC_Descripcion IS NULL OR D.TC_Descripcion = C.TC_Descripcion) THEN '' ELSE CONCAT(D.TC_Descripcion, ', ') END, -- DescripcionCanton
						   CASE WHEN (E.TC_Descripcion IS NULL OR E.TC_Descripcion = D.TC_Descripcion) THEN '' ELSE CONCAT(E.TC_Descripcion, ', ') END, -- DescripcionDistrito
						   CASE WHEN (F.TC_Descripcion IS NULL OR F.TC_Descripcion = E.TC_Descripcion) THEN '' ELSE CONCAT(F.TC_Descripcion, ', ') END, -- DescripcionBarrio
						   ISNULL(A.TC_Direccion, '')																									-- Direccion
						   )

		FROM			Persona.Domicilio															AS A WITH(NOLOCK)
		INNER JOIN		Catalogo.TipoDomicilio														AS B WITH(NOLOCK) 
		ON				B.TN_CodTipoDomicilio														= A.TN_CodTipoDomicilio
		LEFT JOIN		Catalogo.Provincia															AS C WITH(NOLOCK) 
		ON				C.TN_CodProvincia															= A.TN_CodProvincia
		LEFT JOIN		Catalogo.Canton																AS D WITH(NOLOCK) 
		ON				D.TN_CodCanton																= A.TN_CodCanton 
		AND				D.TN_CodProvincia															= A.TN_CodProvincia
		LEFT JOIN		Catalogo.Distrito															AS E WITH(NOLOCK) 
		ON				E.TN_CodDistrito															= A.TN_CodDistrito 
		AND				E.TN_CodCanton																= A.TN_CodCanton
		AND				E.TN_CodProvincia															= A.TN_CodProvincia
		LEFT JOIN		Catalogo.Barrio																AS F WITH(NOLOCK) 
		ON				F.TN_CodBarrio																= A.TN_CodBarrio
		AND				E.TN_CodDistrito															= A.TN_CodDistrito 
		AND				E.TN_CodCanton																= A.TN_CodCanton
		AND				E.TN_CodProvincia															= A.TN_CodProvincia
		INNER JOIN		Catalogo.Pais																AS G WITH(NOLOCK) 
		ON				G.TC_CodPais																= A.TC_CodPais
		LEFT JOIN		Persona.PersonaFisica														AS H WITH(NOLOCK)
		ON				A.TU_CodPersona																= H.TU_CodPersona
		LEFT JOIN		Persona.PersonaJuridica														AS I WITH(NOLOCK)
		ON				A.TU_CodPersona																= I.TU_CodPersona
		INNER JOIN		Expediente.Intervencion														AS J WITH(NOLOCK)
		ON				A.TU_CodPersona																= J.TU_CodPersona
		INNER JOIN		Expediente.LegajoIntervencion												AS LI WITH(NOLOCK)
		ON				LI.TU_CodInterviniente														= J.TU_CodInterviniente
		LEFT JOIN		Expediente.LegajoDetalle													AS K WITH(NOLOCK)
		ON				K.TU_CodLegajo																= LI.TU_CodLegajo
		WHERE			(CONCAT(H.TC_Nombre, ' ', H.TC_PrimerApellido, ' ', H.TC_SegundoApellido)   = @L_NombreParte
		OR				CONCAT(H.TC_PrimerApellido, ' ', H.TC_SegundoApellido, ' ', H.TC_Nombre)    = @L_NombreParte
		OR				I.TC_Nombre																	= @L_NombreParte)
		AND				LI.TU_CodLegajo																= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
		AND				K.TC_CodContexto															= @L_Contexto
		AND				A.TB_DomicilioHabitual														= @L_Habitual
		AND				A.TN_CodTipoDomicilio														IN (SELECT Tipo
																										FROM @L_Tipos)
	END
END

GO
