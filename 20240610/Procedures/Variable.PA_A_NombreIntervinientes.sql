SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris Ramírez>
-- Create date:					<27/05/2020>
-- Description:					<Traducción de la Variable del PJEditor A_NombreIntervinientes para LibreOffice>
--								<Parametrizar los tipos de intervencion y la salida del nombre>
-- ====================================================================================================================================================================================
-- NOTA:						<27/05/2020> <El parametro @TiposIntervencion debe recibir los valores separados por comas.>
--														  <Por ejemplo: '1,14,15,11,17,18,19,20'>
--								<27/05/2020> <El parametro @Salida debe recibir los siguientes valores:>
--											 <1: Muestra Nombre y Apellidos>
--											 <2: Muestra Apellidos y Nombre>
--											 <3: Muestra Nombre>
--											 <4: Muestra Apellidos>
--											 <5: Muestra Nombre, Apellidos y Identificacion>
--											 <6: Muestra Identificacion>
--											 <7: Muestra Solo juridicos>
--											 <8: Muestra Solo fisicos>
--====================================================================================================================================================================================
-- <Modificacion> <13/07/2021> <Miguel Avendaño> <Se ajusta para que permita mostrar unicamente las cedulas de los intervinientes fisicos>
-- <Modificación> <12/01/2022> <Aida Elena Siles R> <Se agrega lógica para legajos.>
--====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_NombreIntervinientes]                 
	@NumeroExpediente		AS CHAR(14),
	@CodLegajo				AS VARCHAR(40),
	@Contexto				AS VARCHAR(4),
	@TiposIntervencion		AS VARCHAR(MAX),
	@Salida					AS VARCHAR(2)
AS
BEGIN
	DECLARE		@L_NumeroExpediente		AS CHAR(14)		=	@NumeroExpediente
	DECLARE		@L_CodLegajo			VARCHAR(40)		=	@CodLegajo
	DECLARE		@L_Contexto				AS VARCHAR(4)	=	@Contexto
	DECLARE		@L_TiposIntervencion	VARCHAR(MAX)	=	@TiposIntervencion
	DECLARE		@L_Salida				VARCHAR(2)		=	@Salida
	DECLARE		@L_Tipos				TABLE (Tipo INT);
	
	IF LEN(@L_TiposIntervencion) = 0
		INSERT INTO @L_Tipos
		SELECT	TN_CodTipoIntervencion
		From	Catalogo.TipoIntervencion WITH(NOLOCK)
	ELSE
		INSERT INTO @L_Tipos
		SELECT	CONVERT(INT,RTRIM(LTRIM(Value)))
		From	STRING_SPLIT(@L_TiposIntervencion, ',')

	IF (@L_CodLegajo IS NULL OR @L_CodLegajo = '' OR @L_CodLegajo = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT	Nombre 
		FROM		(
					SELECT		CASE 
									WHEN @L_Salida='1' THEN CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido)
									WHEN @L_Salida='2' THEN CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', F.TC_Nombre)
									WHEN @L_Salida='3' THEN F.TC_Nombre
									WHEN @L_Salida='4' THEN CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido)
									WHEN @L_Salida='5' THEN CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', E.TC_Descripcion, ' ', D.TC_Identificacion)
									WHEN @L_Salida='6' THEN D.TC_Identificacion
									WHEN @L_Salida='8' THEN D.TC_Identificacion
								END AS Nombre
					FROM		Expediente.Interviniente			A WITH(NOLOCK)
					INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
					ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
					INNER JOIN	Catalogo.TipoIntervencion			C WITH(NOLOCK) 
					ON			A.TN_CodTipoIntervencion			= C.TN_CodTipoIntervencion  
					INNER JOIN	Persona.Persona						D WITH(NOLOCK) 			
					ON			B.TU_CodPersona						= D.TU_CodPersona 
					INNER JOIN  Catalogo.TipoIdentificacion			E WITH(NOLOCK)			
					ON			E.TN_CodTipoIdentificacion			= D.TN_CodTipoIdentificacion
					INNER JOIN	Persona.PersonaFisica				F WITH(NOLOCK) 
					ON			F.TU_CodPersona						= B.TU_CodPersona
					LEFT JOIN	Expediente.ExpedienteDetalle		G WITH(NOLOCK) 
					ON			B.TC_NumeroExpediente				= G.TC_NumeroExpediente  
					WHERE		C.TN_CodTipoIntervencion			IN (
																		SELECT	Tipo
																		FROM	@L_Tipos
																		)   
					AND			G.TC_NumeroExpediente				= @L_NumeroExpediente
					AND			G.TC_CodContexto					= @L_Contexto
					AND			B.TU_CodInterviniente				NOT IN (SELECT	LI.TU_CodInterviniente
																			FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																			WHERE	LI.TU_CodInterviniente = B.TU_CodInterviniente)
					UNION ALL
					SELECT		CASE
									WHEN @L_Salida='1' THEN G.TC_Nombre
									WHEN @L_Salida='2' THEN G.TC_Nombre
									WHEN @L_Salida='3' THEN G.TC_Nombre
									WHEN @L_Salida='4' THEN G.TC_Nombre
									WHEN @L_Salida='5' THEN CONCAT (G.TC_Nombre, ' ', E.TC_Descripcion, ' ' , D.TC_Identificacion)
									WHEN @L_Salida='6' THEN D.TC_Identificacion
									WHEN @L_Salida='7' THEN D.TC_Identificacion
								END AS Nombre 
					FROM		Expediente.Interviniente			A WITH(NOLOCK)
					INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
					ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
					INNER JOIN  Catalogo.TipoIntervencion			C WITH(NOLOCK) 
					ON			A.TN_CodTipoIntervencion			= C.TN_CodTipoIntervencion 
					INNER JOIN	Persona.Persona						D WITH(NOLOCK) 
					ON			B.TU_CodPersona						= D.TU_CodPersona 
					INNER JOIN  Catalogo.TipoIdentificacion			E WITH(NOLOCK)			
					ON			E.TN_CodTipoIdentificacion			= D.TN_CodTipoIdentificacion				
					LEFT JOIN	Expediente.ExpedienteDetalle		F WITH(NOLOCK) 
					ON			B.TC_NumeroExpediente				= F.TC_NumeroExpediente 
					INNER JOIN	Persona.PersonaJuridica				G WITH(NOLOCK) 
					ON			D.TU_CodPersona						= G.TU_CodPersona
					WHERE		C.TN_CodTipoIntervencion			IN (
																		SELECT	Tipo
																		FROM	@L_Tipos
																		)   
					AND			F.TC_NumeroExpediente				= @L_NumeroExpediente
					AND			F.TC_CodContexto					= @L_Contexto
					AND			B.TU_CodInterviniente				NOT IN (SELECT	TU_CodInterviniente
																			FROM	Expediente.LegajoIntervencion LI WITH(NOLOCK)
																			WHERE	TU_CodInterviniente = B.TU_CodInterviniente)
					)
		AS		 TABLA
		WHERE	 Nombre IS NOT NULL
		ORDER BY Nombre ASC
	END
	ELSE
	BEGIN
		SELECT	Nombre 
		FROM		(
					SELECT		CASE 
									WHEN @L_Salida='1' THEN CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido)
									WHEN @L_Salida='2' THEN CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', F.TC_Nombre)
									WHEN @L_Salida='3' THEN F.TC_Nombre
									WHEN @L_Salida='4' THEN CONCAT(F.TC_PrimerApellido, ' ', F.TC_SegundoApellido)
									WHEN @L_Salida='5' THEN CONCAT(F.TC_Nombre, ' ', F.TC_PrimerApellido, ' ', F.TC_SegundoApellido, ' ', E.TC_Descripcion, ' ', D.TC_Identificacion)
									WHEN @L_Salida='6' THEN D.TC_Identificacion
									WHEN @L_Salida='8' THEN D.TC_Identificacion
								END AS Nombre
					FROM		Expediente.Interviniente			A WITH(NOLOCK)
					INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
					ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
					INNER JOIN  Expediente.LegajoIntervencion		LI WITH(NOLOCK)
					ON			LI.TU_CodInterviniente				= B.TU_CodInterviniente
					INNER JOIN	Catalogo.TipoIntervencion			C WITH(NOLOCK) 
					ON			A.TN_CodTipoIntervencion			= C.TN_CodTipoIntervencion  
					INNER JOIN	Persona.Persona						D WITH(NOLOCK) 			
					ON			B.TU_CodPersona						= D.TU_CodPersona 
					INNER JOIN  Catalogo.TipoIdentificacion			E WITH(NOLOCK)			
					ON			E.TN_CodTipoIdentificacion			= D.TN_CodTipoIdentificacion
					INNER JOIN	Persona.PersonaFisica				F WITH(NOLOCK) 
					ON			F.TU_CodPersona						= B.TU_CodPersona
					LEFT JOIN	Expediente.LegajoDetalle			G WITH(NOLOCK) 
					ON			G.TU_CodLegajo						= LI.TU_CodLegajo
					WHERE		C.TN_CodTipoIntervencion			IN (
																		SELECT	Tipo
																		FROM	@L_Tipos
																		)   
					AND			G.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
					AND			G.TC_CodContexto					= @L_Contexto
					UNION ALL
					SELECT		CASE
									WHEN @L_Salida='1' THEN G.TC_Nombre
									WHEN @L_Salida='2' THEN G.TC_Nombre
									WHEN @L_Salida='3' THEN G.TC_Nombre
									WHEN @L_Salida='4' THEN G.TC_Nombre
									WHEN @L_Salida='5' THEN CONCAT (G.TC_Nombre, ' ', E.TC_Descripcion, ' ' , D.TC_Identificacion)
									WHEN @L_Salida='6' THEN D.TC_Identificacion
									WHEN @L_Salida='7' THEN D.TC_Identificacion
								END AS Nombre 
					FROM		Expediente.Interviniente			A WITH(NOLOCK)
					INNER JOIN	Expediente.Intervencion				B WITH(NOLOCK)
					ON			A.TU_CodInterviniente				= B.TU_CodInterviniente
					INNER JOIN  Expediente.LegajoIntervencion		LI WITH(NOLOCK)
					ON			LI.TU_CodInterviniente				= B.TU_CodInterviniente
					INNER JOIN  Catalogo.TipoIntervencion			C WITH(NOLOCK) 
					ON			A.TN_CodTipoIntervencion			= C.TN_CodTipoIntervencion 
					INNER JOIN	Persona.Persona						D WITH(NOLOCK) 
					ON			B.TU_CodPersona						= D.TU_CodPersona 
					INNER JOIN  Catalogo.TipoIdentificacion			E WITH(NOLOCK)			
					ON			E.TN_CodTipoIdentificacion			= D.TN_CodTipoIdentificacion				
					LEFT JOIN	Expediente.LegajoDetalle			F WITH(NOLOCK) 
					ON			F.TU_CodLegajo						= LI.TU_CodLegajo
					INNER JOIN	Persona.PersonaJuridica				G WITH(NOLOCK) 
					ON			D.TU_CodPersona						= G.TU_CodPersona
					WHERE		C.TN_CodTipoIntervencion			IN (
																		SELECT	Tipo
																		FROM	@L_Tipos
																		)   
					AND			F.TU_CodLegajo						= CAST(@L_CodLegajo AS UNIQUEIDENTIFIER)
					AND			F.TC_CodContexto					= @L_Contexto
					)
		AS		 TABLA
		WHERE	 Nombre IS NOT NULL
		ORDER BY Nombre ASC
	END

	
END
GO
