SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:			<Miguel Avendaño>
-- Create date:		<21-07-2020>
-- Description:		<Traducción de las Variable del PJEditor relacionadas con los medios de comunicacion de los intervinientes para LibreOffice>
-- Parametros:		@NumeroExpediente: Numero para el que se quiere buscar los medios de comunicacion
--					@Contexto: Codigo del contexto al que pertenece el expediente
--					@Medio: Tipo de medio a listar
--							1- Todos los medios. Lista todos los medios asociados a la parte, indicando el tipo y el valor.
--							2- Email. Lista el email asociado a la parte, indicando el valor.
--							3- Telefono celular. Lista el telefono celular asociado a la parte, indicando el valor.
--							4- Telefono. Lista el telefono asociado a la parte, indicando el valor.
--							5- Fax. Lista el fax asociado a la parte, indicando el valor.
--							6- Direccion completa. Lista el la direccion en formato Provincia + Canton + Distrito + Barrio + Direccion.
--					@Intervenciones: Codigos de intervencion para los que se desea buscar los medios. Dejar en blanco para todos los tipos de intervencion.
--					@Partes: Nombres completos de las partes para los que se desea buscar los medios.
-- NOTA IMPORTANTE: Se debe actualizar el SP en caso de que los codigos para los tipos de telefono cambien.
-- ====================================================================================================================================================================================
-- Modificación:	<Aida Elena Siles R> <21/01/2022> <Se agrega lógica para legajos.>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_MediosComunicacionIntervinientes]
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				VARCHAR(40) = NULL,
	@Contexto				AS VARCHAR(4),
	@Medio					AS INTEGER,
	@Intervenciones			AS VARCHAR(MAX),
	@Partes					AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)     = @NumeroExpediente,
				@L_CodLegajo			VARCHAR(40)		= @CodLegajo,
				@L_Contexto             AS VARCHAR(4)   = @Contexto,
				@L_Medio				AS INTEGER		= @Medio;
	DECLARE		@L_Intervenciones		TABLE (	Intervenciones		VARCHAR(MAX));
	DECLARE		@L_Partes				TABLE (	Nombre				VARCHAR(MAX));
	DECLARE		@L_Medios				TABLE (	Medio				VARCHAR(MAX),
												CodMedio			INTEGER,
												TipoMedio			CHAR(1),
												TipoIntervencion	INTEGER,
												Nombre				VARCHAR(100),
												ApellidoUno			VARCHAR(50),
												ApellidoDos			VARCHAR(50),
												Provincia			INTEGER,
												Canton				INTEGER,
												Distrito			INTEGER,
												Barrio				INTEGER);

	IF LEN(@Partes) > 0
		INSERT INTO @L_Partes
		SELECT	RTRIM(LTRIM(Value))
		FROM	STRING_SPLIT(@Partes, ',')

	IF LEN(@Intervenciones) > 0
		INSERT INTO @L_Intervenciones
		SELECT	RTRIM(LTRIM(Value))
		FROM	STRING_SPLIT(@Intervenciones, ',')

	--Si hay que listar telefonos hace la consulta de telefonos, sino la de medios
	IF @L_Medio In (1,2,5,6)
	BEGIN
		IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
		BEGIN
			INSERT INTO @L_Medios
			SELECT		G.TC_Descripcion + ': ' + C.TC_Valor		AS Medio,
						C.TN_CodMedio								AS CodMedio,
						G.TC_TipoMedio								AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						E.TC_PrimerApellido							AS ApellidoUno,
						E.TC_SegundoApellido						AS ApellidoDos,
						C.TN_CodProvincia							AS Provincia,
						C.TN_CodCanton								AS Canton,
						C.TN_CodDistrito							AS Distrito,
						C.TN_CodBarrio								AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Expediente.IntervencionMedioComunicacion	C WITH(NOLOCK) 
			ON			B.TU_CodInterviniente						= C.TU_CodInterviniente
			INNER JOIN	Catalogo.TipoMedioComunicacion				G WITH(NOLOCK)
			ON			C.TN_CodMedio								= G.TN_CodMedio
			INNER JOIN	Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion   
			INNER JOIN	Persona.PersonaFisica						E WITH(NOLOCK) 
			ON			E.TU_CodPersona								= B.TU_CodPersona
			LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
			ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente  
			WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
			AND			F.TC_CodContexto							= @L_Contexto
			AND			B.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente 
																			FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																			WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
			UNION ALL				
			SELECT		G.TC_Descripcion + ': ' + C.TC_Valor		AS Medio,
						C.TN_CodMedio								AS CodMedio,
						G.TC_TipoMedio								AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						''											AS ApellidoUno,
						''											AS ApellidoDos,
						C.TN_CodProvincia							AS Provincia,
						C.TN_CodCanton								AS Canton,
						C.TN_CodDistrito							AS Distrito,
						C.TN_CodBarrio								AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Expediente.IntervencionMedioComunicacion	C WITH(NOLOCK) 
			ON			B.TU_CodInterviniente						= C.TU_CodInterviniente
			INNER JOIN	Catalogo.TipoMedioComunicacion				G WITH(NOLOCK)
			ON			C.TN_CodMedio								= G.TN_CodMedio
			INNER JOIN  Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion
			INNER JOIN	Persona.PersonaJuridica						E WITH(NOLOCK) 
			ON			B.TU_CodPersona								= E.TU_CodPersona
			LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
			ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente 
			WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
			AND			F.TC_CodContexto							= @L_Contexto
			AND			B.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente 
																			FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																			WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
		END
		ELSE
		BEGIN
			INSERT INTO @L_Medios
			SELECT		G.TC_Descripcion + ': ' + C.TC_Valor		AS Medio,
						C.TN_CodMedio								AS CodMedio,
						G.TC_TipoMedio								AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						E.TC_PrimerApellido							AS ApellidoUno,
						E.TC_SegundoApellido						AS ApellidoDos,
						C.TN_CodProvincia							AS Provincia,
						C.TN_CodCanton								AS Canton,
						C.TN_CodDistrito							AS Distrito,
						C.TN_CodBarrio								AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
			ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Expediente.IntervencionMedioComunicacion	C WITH(NOLOCK) 
			ON			B.TU_CodInterviniente						= C.TU_CodInterviniente
			INNER JOIN	Expediente.IntervencionMedioComunicacionLegajo IM WITH(NOLOCK)
			ON			IM.TU_CodMedioComunicacion					= C.TU_CodMedioComunicacion
			INNER JOIN	Catalogo.TipoMedioComunicacion				G WITH(NOLOCK)
			ON			C.TN_CodMedio								= G.TN_CodMedio
			INNER JOIN	Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion   
			INNER JOIN	Persona.PersonaFisica						E WITH(NOLOCK) 
			ON			E.TU_CodPersona								= B.TU_CodPersona
			LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
			ON			F.TU_CodLegajo								= LI.TU_CodLegajo
			WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
			AND			F.TC_CodContexto							= @L_Contexto
			UNION ALL				
			SELECT		G.TC_Descripcion + ': ' + C.TC_Valor		AS Medio,
						C.TN_CodMedio								AS CodMedio,
						G.TC_TipoMedio								AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						''											AS ApellidoUno,
						''											AS ApellidoDos,
						C.TN_CodProvincia							AS Provincia,
						C.TN_CodCanton								AS Canton,
						C.TN_CodDistrito							AS Distrito,
						C.TN_CodBarrio								AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
			ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Expediente.IntervencionMedioComunicacion	C WITH(NOLOCK) 
			ON			B.TU_CodInterviniente						= C.TU_CodInterviniente
			INNER JOIN	Expediente.IntervencionMedioComunicacionLegajo IM WITH(NOLOCK)
			ON			IM.TU_CodMedioComunicacion					= C.TU_CodMedioComunicacion
			INNER JOIN	Catalogo.TipoMedioComunicacion				G WITH(NOLOCK)
			ON			C.TN_CodMedio								= G.TN_CodMedio
			INNER JOIN  Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion
			INNER JOIN	Persona.PersonaJuridica						E WITH(NOLOCK) 
			ON			B.TU_CodPersona								= E.TU_CodPersona
			LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
			ON			F.TU_CodLegajo								= LI.TU_CodLegajo
			WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
			AND			F.TC_CodContexto							= @L_Contexto
		END
	END		
	ELSE
	BEGIN
		IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
		BEGIN
			INSERT INTO @L_Medios
			SELECT		G.TC_Descripcion + ': ' + C.TC_Numero		AS Medio,
						C.TN_CodTipoTelefono						AS CodMedio,
						''											AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						E.TC_PrimerApellido							AS ApellidoUno,
						E.TC_SegundoApellido						AS ApellidoDos,
						''											AS Provincia,
						''											AS Canton,
						''											AS Distrito,
						''											AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion   
			INNER JOIN	Persona.PersonaFisica						E WITH(NOLOCK) 
			ON			E.TU_CodPersona								= B.TU_CodPersona
			INNER JOIN	Persona.Telefono							C WITH(NOLOCK)
			ON			C.TU_CodPersona								= E.TU_CodPersona
			INNER JOIN	Catalogo.TipoTelefono						G WITH(NOLOCK)
			ON			G.TN_CodTipoTelefono						= C.TN_CodTipoTelefono
			LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
			ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente  
			WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
			AND			F.TC_CodContexto							= @L_Contexto
			AND			B.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente 
																			FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																			WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
			UNION ALL				
			SELECT		G.TC_Descripcion + ': ' + C.TC_Numero		AS Medio,
						C.TN_CodTipoTelefono						AS CodMedio,
						''											AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						''											AS ApellidoUno,
						''											AS ApellidoDos,
						''											AS Provincia,
						''											AS Canton,
						''											AS Distrito,
						''											AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion   
			INNER JOIN	Persona.PersonaJuridica						E WITH(NOLOCK) 
			ON			E.TU_CodPersona								= B.TU_CodPersona
			INNER JOIN	Persona.Telefono							C WITH(NOLOCK)
			ON			C.TU_CodPersona								= E.TU_CodPersona
			INNER JOIN	Catalogo.TipoTelefono						G WITH(NOLOCK)
			ON			G.TN_CodTipoTelefono						= C.TN_CodTipoTelefono
			LEFT JOIN	Expediente.ExpedienteDetalle				F WITH(NOLOCK) 
			ON			B.TC_NumeroExpediente						= F.TC_NumeroExpediente 
			WHERE		F.TC_NumeroExpediente						= @L_NumeroExpediente
			AND			F.TC_CodContexto							= @L_Contexto
			AND			B.TU_CodInterviniente						NOT IN (SELECT	TU_CodInterviniente 
																			FROM	Expediente.LegajoIntervencion WITH(NOLOCK)
																			WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
			END
		ELSE
		BEGIN
			INSERT INTO @L_Medios
			SELECT		G.TC_Descripcion + ': ' + C.TC_Numero		AS Medio,
						C.TN_CodTipoTelefono						AS CodMedio,
						''											AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						E.TC_PrimerApellido							AS ApellidoUno,
						E.TC_SegundoApellido						AS ApellidoDos,
						''											AS Provincia,
						''											AS Canton,
						''											AS Distrito,
						''											AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
			ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion   
			INNER JOIN	Persona.PersonaFisica						E WITH(NOLOCK) 
			ON			E.TU_CodPersona								= B.TU_CodPersona
			INNER JOIN	Persona.Telefono							C WITH(NOLOCK)
			ON			C.TU_CodPersona								= E.TU_CodPersona
			INNER JOIN	Catalogo.TipoTelefono						G WITH(NOLOCK)
			ON			G.TN_CodTipoTelefono						= C.TN_CodTipoTelefono
			LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
			ON			F.TU_CodLegajo								= LI.TU_CodLegajo
			WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
			AND			F.TC_CodContexto							= @L_Contexto
			UNION ALL				
			SELECT		G.TC_Descripcion + ': ' + C.TC_Numero		AS Medio,
						C.TN_CodTipoTelefono						AS CodMedio,
						''											AS TipoMedio,
						A.TN_CodTipoIntervencion					AS TipoIntervencion,
						E.TC_Nombre									AS Nombre,
						''											AS ApellidoUno,
						''											AS ApellidoDos,
						''											AS Provincia,
						''											AS Canton,
						''											AS Distrito,
						''											AS Barrio
			FROM		Expediente.Interviniente					A WITH(NOLOCK)
			INNER JOIN	Expediente.Intervencion						B WITH(NOLOCK)
			ON			A.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Catalogo.TipoIntervencion					D WITH(NOLOCK) 
			ON			A.TN_CodTipoIntervencion					= D.TN_CodTipoIntervencion   
			INNER JOIN  Expediente.LegajoIntervencion				LI WITH(NOLOCK)
			ON			LI.TU_CodInterviniente						= B.TU_CodInterviniente
			INNER JOIN	Persona.PersonaJuridica						E WITH(NOLOCK) 
			ON			E.TU_CodPersona								= B.TU_CodPersona
			INNER JOIN	Persona.Telefono							C WITH(NOLOCK)
			ON			C.TU_CodPersona								= E.TU_CodPersona
			INNER JOIN	Catalogo.TipoTelefono						G WITH(NOLOCK)
			ON			G.TN_CodTipoTelefono						= C.TN_CodTipoTelefono
			LEFT JOIN	Expediente.LegajoDetalle					F WITH(NOLOCK) 
			ON			F.TU_CodLegajo								= LI.TU_CodLegajo	
			WHERE		F.TU_CodLegajo								= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
			AND			F.TC_CodContexto							= @L_Contexto
		END
		
	END
		

	IF (SELECT COUNT(Intervenciones) FROM @L_Intervenciones) >= 1
		DELETE
		FROM	@L_Medios
		WHERE	TipoIntervencion NOT IN (	
											SELECT	Intervenciones
											FROM	@L_Intervenciones
										)
	IF (SELECT COUNT(Nombre) FROM @L_Partes) >= 1
		DELETE
		FROM	@L_Medios
		WHERE	CONCAT(Nombre, ' ', ApellidoUno, ' ', ApellidoDos) NOT IN	(
																			SELECT	Nombre
																			FROM	@L_Partes
																			)
		AND		CONCAT(ApellidoUno, ' ', ApellidoDos, ' ', Nombre) NOT IN	(
																			SELECT	Nombre
																			FROM	@L_Partes
																			)

	--Lista todos los medios
	IF @L_Medio = 1
		IF (SELECT COUNT(Medio) FROM @L_Medios) > 0
			SELECT STUFF((SELECT		', ' + Medio
			FROM		(
						SELECT	Medio
						FROM	@L_Medios
						)
			AS			TABLA
			WHERE		Medio IS NOT NULL
			FOR XML PATH ('')), 1, 1, '')
		ELSE
			SELECT 'No Indica'

	--Lista solo los medios de tipo Email
	IF @L_Medio = 2
		IF (SELECT COUNT(Medio) FROM @L_Medios WHERE TipoMedio = 'E') > 0
			SELECT STUFF((SELECT		', ' + Medio
			FROM		(
						SELECT	Medio
						FROM	@L_Medios
						WHERE	TipoMedio = 'E'
						)
			AS			TABLA
			WHERE		Medio IS NOT NULL
			FOR XML PATH ('')), 1, 1, '')
		ELSE
			SELECT 'No Indica'

	--Lista solo los medios de tipo telefono celular
	IF @L_Medio = 3
		IF (SELECT COUNT(Medio) FROM @L_Medios WHERE CodMedio = 1) > 0
			SELECT STUFF((SELECT		', ' + Medio
			FROM		(
						SELECT	Medio
						FROM	@L_Medios
						WHERE	CodMedio = 1
						)
			AS			TABLA
			WHERE		Medio IS NOT NULL
			FOR XML PATH ('')), 1, 1, '')
		ELSE
			SELECT 'No Indica'

	--Lista solo los medios de tipo telefono
	IF @L_Medio = 4
		IF (SELECT COUNT(Medio) FROM @L_Medios WHERE CodMedio = 2) > 0
			SELECT STUFF((SELECT		', ' + Medio
			FROM		(
						SELECT	Medio
						FROM	@L_Medios
						WHERE	CodMedio = 2
						)
			AS			TABLA
			WHERE		Medio IS NOT NULL
			FOR XML PATH ('')), 1, 1, '')
		ELSE
			SELECT 'No Indica'

	--Lista solo los medios de tipo fax
	IF @L_Medio = 5
		IF (SELECT COUNT(Medio) FROM @L_Medios WHERE TipoMedio = 'F') > 0
			SELECT STUFF((SELECT		', ' + Medio
			FROM		(
						SELECT	Medio
						FROM	@L_Medios
						WHERE	TipoMedio = 'F'
						)
			AS			TABLA
			WHERE		Medio IS NOT NULL
			FOR XML PATH ('')), 1, 1, '')
		ELSE
			SELECT 'No Indica'

	--Lista solo los medios de tipo domicilio
	IF @L_Medio = 6
		IF (SELECT COUNT(Medio) FROM @L_Medios WHERE TipoMedio = 'D') > 0
			SELECT STUFF((SELECT		', ' + CONVERT(VARCHAR,Provincia) + ' - ' + CONVERT(VARCHAR,Canton) + ' - ' + CONVERT(VARCHAR,Distrito) + ' - ' + CONVERT(VARCHAR,Barrio) + ' - ' + Medio
			FROM		(
						SELECT	B.TC_Descripcion AS Provincia,
								C.TC_Descripcion AS Canton,
								D.TC_Descripcion AS Distrito,
								E.TC_Descripcion AS Barrio,
								Medio
						FROM	@L_Medios				A
						INNER JOIN Catalogo.Provincia	B
						ON		A.Provincia				= B.TN_CodProvincia
						INNER JOIN Catalogo.Canton		C
						ON		A.Canton				= C.TN_CodCanton
						AND		A.Provincia				= C.TN_CodProvincia
						INNER JOIN Catalogo.Distrito	D
						ON		A.Distrito				= D.TN_CodDistrito
						AND		A.Canton				= D.TN_CodCanton
						AND		A.Provincia				= D.TN_CodProvincia
						INNER JOIN Catalogo.Barrio		E
						ON		A.Barrio				= E.TN_CodBarrio
						AND		A.Distrito				= E.TN_CodDistrito
						AND		A.Canton				= E.TN_CodCanton
						AND		A.Provincia				= E.TN_CodProvincia
						WHERE	TipoMedio = 'D'
						)
			AS			TABLA
			WHERE		Medio IS NOT NULL
			FOR XML PATH ('')), 1, 1, '')
		ELSE
			SELECT 'No Indica'
END
GO
