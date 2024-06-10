SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--===========================================================================================================================================================================================      
-- Versión:					<1.0>      
-- Creado por:				<Jefry Hern ndez>      
-- Fecha de creación:		<22/05/2017>      
-- Descripción:				<Obtiene las comunicaciones asociadas a un expediente.>       
--============================================================================================================================================================================================    
-- Modificado:				<Diego Navarrete>      
-- Descripción:				<Se ordena por estado y fecha de registro>}      
-- Modificado por:			<Ailyn López>      
-- Fecha de Modificación:	<01/08/2017>      
-- Descripción:				<Se agrega par metro @CodInterviniente, para que filtre por código de interveniente>       
-- Modificado por:			<Jeffry Hernandez>      
-- Fecha de Modificación:	<30/04/2018>      
-- Descripción:				<Se separa consulta>       
-- Modificación:			<24/05/2018> <Jonathan Aguilar Navarro> <Se modifica el join de Catalago.Oficina ahora es contra Catalogo.Contexto>      
-- Modificación:			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>      
-- Modificación:			<09/10/2018><Juan Ram¡rez><Se enlaza con la tabla intervención>       
-- Modificación:			<03/06/2020><Cristian Cerdas><Se modifica ya que se cambio la columna TU_CodLegajo por TC_NumeroExpediente>      
-- Modificación:			<10/09/2020><Xinia Soto><Se modifica para consultar por NumeroExpediente>      
-- Modificación:			<23/09/2020><Xinia Soto><Se agrega opción para consultar por NumeroExpediente e interviniente>     
-- Modificación:			<18/12/2020><Xinia Soto><Se agrega filtro de estado de la comunicación>    
-- Modificación:			<15/01/2021><Xinia Soto><Se agrega filtro de tipo de la comunicación>   
-- Modificación:			<19/01/2021><Johan Acosta><Se agrega el retorno de la fecha de env¡o y la fecha de resolución y el medio de comunicación>   
-- Modificación:			<25/03/2021><Aida Elena Siles R> <Se modifica el join de la tabla Expediente.Interviniente para que sea LeftJoin ya que las comunicaciones hacia los representantes no se estaban mostrando.>  
-- Modificación:			<13/04/2021><Aida Elena Siles R> <Se agrega a la consulta el consecutivo de la comunicación y el horario del medio de comunicación>  
-- Modificación:			<01/06/2021><Ronny Ram¡rez R.> <Se aplica corrección a filtrado por código de legajo entre las tablas comunicación y legajo, pues solo se tomaba en cuenta el expediente>  
-- Modificación:			<18/06/2021><Isaac Dobles Mata.> <Corrección de consulta porque se estaba mostrando datos duplicados.> 
-- Modificación:			<07/07/2021><Karol Jin‚nez S nchez> <Se aplica corrección al obtener codigo de archivo de acta y de resolución (principal)>
-- Modificación:			<17/08/2021><Isaac Santiago M‚ndez Castillo> <Se corrige IM.TB_PerteneceExpediente en select cuando se consultan comunicaciones en los legajos> 
-- Modificación:			<15/09/2021><Aida Elena Siles R><Se agrega a la consulta de legajo el código de legajo. Se optimiza la consulta utilizando Outer Apply.>
-- Modificación:			<14/10/2021><Karol Jim‚nez S nchez> <Se consulta la descripción del documento principal/resolución>  
-- Modificación:			<28/01/2022><Karol Jim‚nez S nchez> <Se corrigen alias tabla ArchivoComunicacion EsPrincipal, quedaron mal asignados, solución bug 235831> 
-- Modificación:			<05/07/2022><Mario Camacho Flores> <Se modifica el orden y el filtro de las tablas donde se obtiene la info de la persona y/o interviniente, no mostraba los tipo representante> 
-- ==============================================================================================================================================================================================
      
CREATE PROCEDURE [Comunicacion].[PA_ConsultarComunicacionesExpediente]      
    @CodLegajo			UNIQUEIDENTIFIER,      
    @CodInterviniente	UNIQUEIDENTIFIER ,    
    @NumeroExpediente	VARCHAR(14)			= NULL,
	@CodigoEstado		CHAR(1)				= NULL,
	@TipoComunicacion	CHAR(1)				= NULL
AS      
BEGIN  
--Variables
	DECLARE @L_CodigoEstado			CHAR(1)				= @CodigoEstado,
			@L_TipoComunicacion		CHAR(1)				= @TipoComunicacion,
			@L_CodLegajo			UNIQUEIDENTIFIER	= @CodLegajo,
			@L_CodInterviniente		UNIQUEIDENTIFIER	= @CodInterviniente,
			@L_NumeroExpediente		VARCHAR(14)			= @NumeroExpediente

	IF (@L_CodInterviniente IS NOT NULL AND @L_CodLegajo IS NOT NULL)      
		BEGIN      
		SELECT			A.TU_CodComunicacion					CodigoComunicacion, 
						A.TF_FechaEnvio							FechaEnvio, 
						A.TF_FechaResolucion					FechaResolucion, 
						A.TF_FechaRegistro						FechaRegistro,
						A.TC_ConsecutivoComunicacion			ConsecutivoComunicacion,
						A.TU_CodLegajo							CodLegajo,
						'SplitContextoComunicacion'				SplitContextoComunicacion,
						B.TC_CodContexto						Codigo,     
						B.TC_Descripcion						Descripcion,         
						'SplitInterviniente'					SplitInterviniente,
						D.Alias,     
						D.Caracteristicas,      
						D.CodigoInterviniente,  
						D.FechaComisionDelito,            
						'SplitPF'								SplitPF,
						D.CodigoPersona,
						D.Nombre,
						D.PrimerApellido,
						D.SegundoApellido,
						D.Identificacion,
						'SplitPJ'								SplitPJ ,
						D.CodigoPersona,
						D.Identificacion,
						D.TC_Nombre								Nombre,
						D.NombreComercial,
						'SplitTipoMedioComunicacion'			SplitTipoMedioComunicacion, 
						E.TN_CodMedio							Codigo, 
						E.TC_Descripcion						Descripcion,      
						'SplitDatos'							SplitDatos,
						A.TC_Estado								Estado,      
						A.TC_Resultado							Resultado,       
						A.TC_TipoComunicacion					TipoComunicacion,
						E.TC_TipoMedio							TipoMedio,
						F.TU_CodArchivo							Acta,
						G.TU_CodArchivo							Resolucion,
						I.TC_Descripcion						DescripcionDocResolucion,
						D.TipoParticipacion,
						H.CodigoHorarioMedio,
						H.HorarioMedioComunicacionDescrip
		FROM			Comunicacion.Comunicacion				A WITH(NOLOCK)
		INNER JOIN		Catalogo.Contexto						B WITH(NOLOCK)       
		ON				B.TC_CodContexto						=	A.TC_CodContextoOCJ
		INNER JOIN		Expediente.Legajo						LE WITH(NOLOCK)
		ON				LE.TC_NumeroExpediente					= A.TC_NumeroExpediente
		AND				LE.TU_CodLegajo							= A.TU_CodLegajo
		INNER JOIN		Comunicacion.ComunicacionIntervencion	C WITH(NOLOCK)
		ON				C.TU_CodComunicacion					= A.TU_CodComunicacion
		AND				C.TB_Principal							= 1
		OUTER APPLY	(
						SELECT		Z.TC_Alias					Alias,     
									Z.TC_Caracteristicas		Caracteristicas,      
									Z.TU_CodInterviniente		CodigoInterviniente,  
									Z.TF_ComisionDelito			FechaComisionDelito,
									Y.TU_CodPersona				CodigoPersona,
									U.Nombre,
									U.PrimerApellido,
									U.SegundoApellido,
									X.TC_Identificacion			Identificacion,
									S.TC_Nombre,      
									S.NombreComercial,
									Y.TC_TipoParticipacion		TipoParticipacion
						FROM		Expediente.Intervencion		Y WITH(NOLOCK)
						LEFT JOIN	Expediente.Interviniente	Z WITH(NOLOCK)
						ON			Y.TU_CodInterviniente		= Z.TU_CodInterviniente
						INNER JOIN	Persona.Persona				X WITH(NOLOCK)       
						ON			X.TU_CodPersona				= Y.TU_CodPersona
						OUTER APPLY	(
										SELECT	V.TC_Nombre				Nombre,     
												V.TC_PrimerApellido		PrimerApellido,      
												V.TC_SegundoApellido	SegundoApellido
										FROM	Persona.PersonaFisica	V WITH(NOLOCK)
										WHERE	V.TU_CodPersona			= Y.TU_CodPersona
									) U
						OUTER APPLY	(
										SELECT	T.TC_Nombre,
												T.TC_NombreComercial	NombreComercial
										FROM	Persona.PersonaJuridica	T WITH(NOLOCK)
										WHERE	T.TU_CodPersona			= Y.TU_CodPersona
									) S
						WHERE		Y.TU_CodInterviniente					= C.TU_CodInterviniente
					) D
		INNER JOIN  Catalogo.TipoMedioComunicacion				E WITH(NOLOCK)      
		ON			E.TN_CodMedio								= A.TC_CodMedio
		LEFT JOIN	Comunicacion.ArchivoComunicacion			F WITH(NOLOCK)            
		ON			F.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			F.TB_EsActa									=	1 
		AND			F.TB_EsPrincipal							=	0
		LEFT JOIN	Comunicacion.ArchivoComunicacion			G WITH(NOLOCK)            
		ON			G.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			G.TB_EsActa									=	0 
		AND			G.TB_EsPrincipal							=	1
		LEFT JOIN	Archivo.Archivo								I	WITH(NOLOCK)--ARCHIVO RESOLUCION
		ON			I.TU_CodArchivo								=	G.TU_CodArchivo
		OUTER APPLY	(
						SELECT		Q.TN_CodHorario								CodigoHorarioMedio,
									Q.TC_Descripcion							HorarioMedioComunicacionDescrip
						FROM		Expediente.IntervencionMedioComunicacion	R WITH(NOLOCK)
						LEFT JOIN	Catalogo.HorarioMedioComunicacion			Q WITH(NOLOCK)
						ON			Q.TN_CodHorario								= R.TN_CodHorario
						WHERE		R.TU_CodInterviniente						= C.TU_CodInterviniente
						AND			R.TB_PerteneceExpediente					= 0
						AND			R.TN_CodMedio								= A.TC_CodMedio
						AND			R.TC_Valor									= A.TC_Valor
						AND			R.TC_Rotulado								= A.TC_Rotulado
					) H
		WHERE		C.TU_CodInterviniente						= @L_CodInterviniente
		AND			LE.TU_CodLegajo								= @L_CodLegajo
		AND			A.TC_Estado									= ISNULL(@L_CodigoEstado, A.TC_Estado) 
		AND			A.TC_TipoComunicacion						= ISNULL(@L_TipoComunicacion, A.TC_TipoComunicacion)
		ORDER BY    A.TB_Cancelar, A.TF_FechaRegistro DESC       
		END 
	ELSE
	IF (@L_CodInterviniente IS NOT NULL AND @L_NumeroExpediente IS NOT NULL)      
		BEGIN      
		SELECT		A.TU_CodComunicacion					CodigoComunicacion, 
					A.TF_FechaEnvio							FechaEnvio, 
					A.TF_FechaResolucion					FechaResolucion, 
					A.TF_FechaRegistro						FechaRegistro,
					A.TC_ConsecutivoComunicacion			ConsecutivoComunicacion,
					'SplitContextoComunicacion'				SplitContextoComunicacion,
					B.TC_CodContexto						Codigo,     
					B.TC_Descripcion						Descripcion,         
					'SplitInterviniente'					SplitInterviniente,
					D.Alias,     
					D.Caracteristicas,      
					D.CodigoInterviniente,  
					D.FechaComisionDelito,            
					'SplitPF'								SplitPF,
					D.CodigoPersona,
					D.Nombre,
					D.PrimerApellido,
					D.SegundoApellido,
					D.Identificacion,
					'SplitPJ'								SplitPJ ,
					D.CodigoPersona,
					D.Identificacion,
					D.TC_Nombre								Nombre,
					D.NombreComercial,
					'SplitTipoMedioComunicacion'			SplitTipoMedioComunicacion, 
					E.TN_CodMedio							Codigo, 
					E.TC_Descripcion						Descripcion,      
					'SplitDatos'							SplitDatos,
					A.TC_Estado								Estado,      
					A.TC_Resultado							Resultado,       
					A.TC_TipoComunicacion					TipoComunicacion,
					E.TC_TipoMedio							TipoMedio,
					F.TU_CodArchivo							Acta,
					G.TU_CodArchivo							Resolucion,
					I.TC_Descripcion						DescripcionDocResolucion,
					D.TipoParticipacion,
					H.CodigoHorarioMedio,
					H.HorarioMedioComunicacionDescrip
		FROM		Comunicacion.Comunicacion				A WITH(NOLOCK)
		INNER JOIN  Catalogo.Contexto						B WITH(NOLOCK)       
		ON			B.TC_CodContexto						=	A.TC_CodContextoOCJ 
		INNER JOIN	Comunicacion.ComunicacionIntervencion	C WITH(NOLOCK)
		ON			C.TU_CodComunicacion					= A.TU_CodComunicacion
		AND			C.TB_Principal							= 1
		OUTER APPLY	(
						SELECT		Z.TC_Alias					Alias,     
									Z.TC_Caracteristicas		Caracteristicas,      
									Z.TU_CodInterviniente		CodigoInterviniente,  
									Z.TF_ComisionDelito			FechaComisionDelito,
									Y.TU_CodPersona				CodigoPersona,
									U.Nombre,
									U.PrimerApellido,
									U.SegundoApellido,
									X.TC_Identificacion			Identificacion,
									S.TC_Nombre,      
									S.NombreComercial,
									Y.TC_TipoParticipacion		TipoParticipacion
						FROM		Expediente.Intervencion		Y WITH(NOLOCK)
						LEFT JOIN	Expediente.Interviniente	Z WITH(NOLOCK)
						ON			Y.TU_CodInterviniente		= Z.TU_CodInterviniente
						INNER JOIN	Persona.Persona				X WITH(NOLOCK)       
						ON			X.TU_CodPersona				= Y.TU_CodPersona
						OUTER APPLY	(
										SELECT	V.TC_Nombre				Nombre,     
												V.TC_PrimerApellido		PrimerApellido,      
												V.TC_SegundoApellido	SegundoApellido
										FROM	Persona.PersonaFisica	V WITH(NOLOCK)
										WHERE	V.TU_CodPersona			= Y.TU_CodPersona
									) U
						OUTER APPLY	(
										SELECT	T.TC_Nombre,
												T.TC_NombreComercial	NombreComercial
										FROM	Persona.PersonaJuridica	T WITH(NOLOCK)
										WHERE	T.TU_CodPersona			= Y.TU_CodPersona
									) S
						WHERE		Y.TU_CodInterviniente					= C.TU_CodInterviniente
					) D
		INNER JOIN  Catalogo.TipoMedioComunicacion				E WITH(NOLOCK)      
		ON			E.TN_CodMedio								= A.TC_CodMedio
		LEFT JOIN	Comunicacion.ArchivoComunicacion			F WITH(NOLOCK)            
		ON			F.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			F.TB_EsActa									=	1 
		AND			F.TB_EsPrincipal							=	0
		LEFT JOIN	Comunicacion.ArchivoComunicacion			G WITH(NOLOCK)            
		ON			G.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			G.TB_EsActa									=	0 
		AND			G.TB_EsPrincipal							=	1
		LEFT JOIN	Archivo.Archivo								I	WITH(NOLOCK)--ARCHIVO RESOLUCION
		ON			I.TU_CodArchivo								=	G.TU_CodArchivo
		OUTER APPLY	(
						SELECT		Q.TN_CodHorario								CodigoHorarioMedio,
									Q.TC_Descripcion							HorarioMedioComunicacionDescrip
						FROM		Expediente.IntervencionMedioComunicacion	R WITH(NOLOCK)
						LEFT JOIN	Catalogo.HorarioMedioComunicacion			Q WITH(NOLOCK)
						ON			Q.TN_CodHorario								= R.TN_CodHorario
						WHERE		R.TU_CodInterviniente						= C.TU_CodInterviniente
						AND			R.TB_PerteneceExpediente					= 1
						AND			R.TN_CodMedio								= A.TC_CodMedio
						AND			R.TC_Valor									= A.TC_Valor
						AND			R.TC_Rotulado								= A.TC_Rotulado
					) H
		WHERE		C.TU_CodInterviniente						= @L_CodInterviniente
		AND			A.TC_NumeroExpediente						= @L_NumeroExpediente
		AND         A.TU_CodLegajo								IS NULL
		AND			A.TC_Estado									= ISNULL(@L_CodigoEstado, A.TC_Estado) 
		AND			A.TC_TipoComunicacion						= ISNULL(@L_TipoComunicacion, A.TC_TipoComunicacion)
		ORDER BY    A.TB_Cancelar, A.TF_FechaRegistro DESC   
		END   
	ELSE      
	IF (@L_CodLegajo IS NOT NULL)      
		BEGIN      
		SELECT			A.TU_CodComunicacion					CodigoComunicacion, 
						A.TF_FechaEnvio							FechaEnvio, 
						A.TF_FechaResolucion					FechaResolucion, 
						A.TF_FechaRegistro						FechaRegistro,
						A.TC_ConsecutivoComunicacion			ConsecutivoComunicacion,
						A.TU_CodLegajo							CodLegajo,
						'SplitContextoComunicacion'				SplitContextoComunicacion,
						B.TC_CodContexto						Codigo,     
						B.TC_Descripcion						Descripcion,         
						'SplitInterviniente'					SplitInterviniente,
						D.Alias,     
						D.Caracteristicas,      
						D.CodigoInterviniente,  
						D.FechaComisionDelito,            
						'SplitPF'								SplitPF,
						D.CodigoPersona,
						D.Nombre,
						D.PrimerApellido,
						D.SegundoApellido,
						D.Identificacion,
						'SplitPJ'								SplitPJ ,
						D.CodigoPersona,
						D.Identificacion,
						D.TC_Nombre								Nombre,
						D.NombreComercial,
						'SplitTipoMedioComunicacion'			SplitTipoMedioComunicacion, 
						E.TN_CodMedio							Codigo, 
						E.TC_Descripcion						Descripcion,      
						'SplitDatos'							SplitDatos,
						A.TC_Estado								Estado,      
						A.TC_Resultado							Resultado,       
						A.TC_TipoComunicacion					TipoComunicacion,
						E.TC_TipoMedio							TipoMedio,
						F.TU_CodArchivo							Acta,
						G.TU_CodArchivo							Resolucion,
						I.TC_Descripcion						DescripcionDocResolucion,
						D.TipoParticipacion,
						H.CodigoHorarioMedio,
						H.HorarioMedioComunicacionDescrip
		FROM			Comunicacion.Comunicacion				A WITH(NOLOCK)
		INNER JOIN		Catalogo.Contexto						B WITH(NOLOCK)       
		ON				B.TC_CodContexto						=	A.TC_CodContextoOCJ
		INNER JOIN		Expediente.Legajo						LE WITH(NOLOCK)
		ON				LE.TC_NumeroExpediente					= A.TC_NumeroExpediente
		AND				LE.TU_CodLegajo							= A.TU_CodLegajo
		INNER JOIN		Comunicacion.ComunicacionIntervencion	C WITH(NOLOCK)
		ON				C.TU_CodComunicacion					= A.TU_CodComunicacion
		AND				C.TB_Principal							= 1
		OUTER APPLY	(
						SELECT		Z.TC_Alias					Alias,     
									Z.TC_Caracteristicas		Caracteristicas,      
									Z.TU_CodInterviniente		CodigoInterviniente,  
									Z.TF_ComisionDelito			FechaComisionDelito,
									Y.TU_CodPersona				CodigoPersona,
									U.Nombre,
									U.PrimerApellido,
									U.SegundoApellido,
									X.TC_Identificacion			Identificacion,
									S.TC_Nombre,      
									S.NombreComercial,
									Y.TC_TipoParticipacion		TipoParticipacion
						FROM		Expediente.Intervencion		Y WITH(NOLOCK)
						LEFT JOIN	Expediente.Interviniente	Z WITH(NOLOCK)
						ON			Y.TU_CodInterviniente		= Z.TU_CodInterviniente
						INNER JOIN	Persona.Persona				X WITH(NOLOCK)       
						ON			X.TU_CodPersona				= Y.TU_CodPersona
						OUTER APPLY	(
										SELECT	V.TC_Nombre				Nombre,     
												V.TC_PrimerApellido		PrimerApellido,      
												V.TC_SegundoApellido	SegundoApellido
										FROM	Persona.PersonaFisica	V WITH(NOLOCK)
										WHERE	V.TU_CodPersona			= Y.TU_CodPersona
									) U
						OUTER APPLY	(
										SELECT	T.TC_Nombre,
												T.TC_NombreComercial	NombreComercial
										FROM	Persona.PersonaJuridica	T WITH(NOLOCK)
										WHERE	T.TU_CodPersona			= Y.TU_CodPersona
									) S
						WHERE		Y.TU_CodInterviniente					= C.TU_CodInterviniente
					) D
		INNER JOIN  Catalogo.TipoMedioComunicacion				E WITH(NOLOCK)      
		ON			E.TN_CodMedio								= A.TC_CodMedio
		LEFT JOIN	Comunicacion.ArchivoComunicacion			F WITH(NOLOCK)            
		ON			F.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			F.TB_EsActa									=	1 
		AND			F.TB_EsPrincipal							=	0
		LEFT JOIN	Comunicacion.ArchivoComunicacion			G WITH(NOLOCK)            
		ON			G.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			G.TB_EsActa									=	0 
		AND			G.TB_EsPrincipal							=	1
		LEFT JOIN	Archivo.Archivo								I	WITH(NOLOCK)--ARCHIVO RESOLUCION
		ON			I.TU_CodArchivo								=	G.TU_CodArchivo
		OUTER APPLY	(
						SELECT		Q.TN_CodHorario								CodigoHorarioMedio,
									Q.TC_Descripcion							HorarioMedioComunicacionDescrip
						FROM		Expediente.IntervencionMedioComunicacion	R WITH(NOLOCK)
						LEFT JOIN	Catalogo.HorarioMedioComunicacion			Q WITH(NOLOCK)
						ON			Q.TN_CodHorario								= R.TN_CodHorario
						WHERE		R.TU_CodInterviniente						= C.TU_CodInterviniente
						AND			R.TB_PerteneceExpediente					= 1
						AND			R.TN_CodMedio								= A.TC_CodMedio
						AND			R.TC_Valor									= A.TC_Valor
						AND			R.TC_Rotulado								= A.TC_Rotulado
					) H
		WHERE		LE.TU_CodLegajo								= @L_CodLegajo
		AND			A.TC_Estado									= ISNULL(@L_CodigoEstado, A.TC_Estado) 
		AND			A.TC_TipoComunicacion						= ISNULL(@L_TipoComunicacion, A.TC_TipoComunicacion)
		ORDER BY    A.TB_Cancelar, A.TF_FechaRegistro DESC     
		END         
	ELSE      
	IF (@L_NumeroExpediente IS NOT NULL)      
		BEGIN      
		SELECT		A.TU_CodComunicacion					CodigoComunicacion, 
					A.TF_FechaEnvio							FechaEnvio, 
					A.TF_FechaResolucion					FechaResolucion, 
					A.TF_FechaRegistro						FechaRegistro,
					A.TC_ConsecutivoComunicacion			ConsecutivoComunicacion,
					'SplitContextoComunicacion'				SplitContextoComunicacion,
					B.TC_CodContexto						Codigo,     
					B.TC_Descripcion						Descripcion,         
					'SplitInterviniente'					SplitInterviniente,
					D.Alias,     
					D.Caracteristicas,      
					D.CodigoInterviniente,  
					D.FechaComisionDelito,            
					'SplitPF'								SplitPF,
					D.CodigoPersona,
					D.Nombre,
					D.PrimerApellido,
					D.SegundoApellido,
					D.Identificacion,
					'SplitPJ'								SplitPJ ,
					D.CodigoPersona,
					D.Identificacion,
					D.TC_Nombre								Nombre,
					D.NombreComercial,
					'SplitTipoMedioComunicacion'			SplitTipoMedioComunicacion, 
					E.TN_CodMedio							Codigo, 
					E.TC_Descripcion						Descripcion,      
					'SplitDatos'							SplitDatos,
					A.TC_Estado								Estado,      
					A.TC_Resultado							Resultado,       
					A.TC_TipoComunicacion					TipoComunicacion,
					E.TC_TipoMedio							TipoMedio,
					F.TU_CodArchivo							Acta,
					G.TU_CodArchivo							Resolucion,
					I.TC_Descripcion						DescripcionDocResolucion,
					D.TipoParticipacion,
					H.CodigoHorarioMedio,
					H.HorarioMedioComunicacionDescrip
		FROM		Comunicacion.Comunicacion				A WITH(NOLOCK)
		INNER JOIN  Catalogo.Contexto						B WITH(NOLOCK)       
		ON			B.TC_CodContexto						=	A.TC_CodContextoOCJ 
		INNER JOIN	Comunicacion.ComunicacionIntervencion	C WITH(NOLOCK)
		ON			C.TU_CodComunicacion					= A.TU_CodComunicacion
		AND			C.TB_Principal							= 1
		OUTER APPLY	(
						SELECT		Z.TC_Alias					Alias,     
									Z.TC_Caracteristicas		Caracteristicas,      
									Z.TU_CodInterviniente		CodigoInterviniente,  
									Z.TF_ComisionDelito			FechaComisionDelito,
									Y.TU_CodPersona				CodigoPersona,
									U.Nombre,
									U.PrimerApellido,
									U.SegundoApellido,
									X.TC_Identificacion			Identificacion,
									S.TC_Nombre,      
									S.NombreComercial,
									Y.TC_TipoParticipacion		TipoParticipacion
						FROM		Expediente.Intervencion		Y WITH(NOLOCK)
						LEFT JOIN	Expediente.Interviniente	Z WITH(NOLOCK)
						ON			Y.TU_CodInterviniente		= Z.TU_CodInterviniente
						INNER JOIN	Persona.Persona				X WITH(NOLOCK)       
						ON			X.TU_CodPersona				= Y.TU_CodPersona
						OUTER APPLY	(
										SELECT	V.TC_Nombre				Nombre,     
												V.TC_PrimerApellido		PrimerApellido,      
												V.TC_SegundoApellido	SegundoApellido
										FROM	Persona.PersonaFisica	V WITH(NOLOCK)
										WHERE	V.TU_CodPersona			= Y.TU_CodPersona
									) U
						OUTER APPLY	(
										SELECT	T.TC_Nombre,
												T.TC_NombreComercial	NombreComercial
										FROM	Persona.PersonaJuridica	T WITH(NOLOCK)
										WHERE	T.TU_CodPersona			= Y.TU_CodPersona
									) S
						WHERE		Y.TU_CodInterviniente					= C.TU_CodInterviniente
					) D
		INNER JOIN  Catalogo.TipoMedioComunicacion				E WITH(NOLOCK)      
		ON			E.TN_CodMedio								= A.TC_CodMedio
		LEFT JOIN	Comunicacion.ArchivoComunicacion			F WITH(NOLOCK)            
		ON			F.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			F.TB_EsActa									=	1 
		AND			F.TB_EsPrincipal							=	0
		LEFT JOIN	Comunicacion.ArchivoComunicacion			G WITH(NOLOCK)            
		ON			G.TU_CodComunicacion						=	A.TU_CodComunicacion 
		AND			G.TB_EsActa									=	0 
		AND			G.TB_EsPrincipal							=	1
		LEFT JOIN	Archivo.Archivo								I	WITH(NOLOCK)--ARCHIVO RESOLUCION
		ON			I.TU_CodArchivo								=	G.TU_CodArchivo
		OUTER APPLY	(
						SELECT		Q.TN_CodHorario								CodigoHorarioMedio,
									Q.TC_Descripcion							HorarioMedioComunicacionDescrip
						FROM		Expediente.IntervencionMedioComunicacion	R WITH(NOLOCK)
						LEFT JOIN	Catalogo.HorarioMedioComunicacion			Q WITH(NOLOCK)
						ON			Q.TN_CodHorario								= R.TN_CodHorario
						WHERE		R.TU_CodInterviniente						= C.TU_CodInterviniente
						AND			R.TB_PerteneceExpediente					= 1
						AND			R.TN_CodMedio								= A.TC_CodMedio
						AND			R.TC_Valor									= A.TC_Valor
						AND			R.TC_Rotulado								= A.TC_Rotulado
					) H
		WHERE		A.TC_NumeroExpediente						= @L_NumeroExpediente
		AND         A.TU_CodLegajo								IS NULL
		AND			A.TC_Estado									= ISNULL(@L_CodigoEstado, A.TC_Estado) 
		AND			A.TC_TipoComunicacion						= ISNULL(@L_TipoComunicacion, A.TC_TipoComunicacion)
		ORDER BY    A.TB_Cancelar, A.TF_FechaRegistro DESC
	END
END 
GO
