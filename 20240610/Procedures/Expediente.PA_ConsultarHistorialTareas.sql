SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Méndez Ch>
-- Fecha de creación:	<10/11/2020>
-- Descripción:			<Permite consultar el historial de tareas finalizadas o reasignadas para un expediente o legajo>
-- ==================================================================================================================================================================================
-- Modificación :		<26/03/2021> <Richard Zúñiga Segura> <Se modifica consulta de tareas del expediente ya que estaba retornando adicionalmente las tareas del legajo>
-- Modificación :		<04/06/2021> <Jose Gabriel Cordero Soto> <Se modifica consulta en sus relaciones (JOIN) y se ajusta la ultima relación por tema de que el valor de l puesto anterior puede ser nulo, por lo tanto, se debe utilizar LEFT JOIN>
-- Modificación :		<04/07/2022> <Jose Gabriel Cordero Soto> <Se incluye el DISTINCT por un tema de comportamiento de Contexto en las tareas, esto por la version 2.1 y a solicitud de implantaciones >
-- Modificación :		<15/07/2022> <Ricardo Alfonso Jiménez Arroyo> <Se incluye @CodContexto para filtrar el Contexto en cada consulta>
-- ==================================================================================================================================================================================

CREATE PROCEDURE	[Expediente].[PA_ConsultarHistorialTareas]
	@NumeroPagina			int,
	@CantidadRegistros		int,	
	@NumeroExpediente		VARCHAR(14)			=	NULL,
	@CodLegajo				UNIQUEIDENTIFIER	=	NULL,
	@CodTipoOficina			SMALLINT,
	@CodMateria				VARCHAR(5),
	@Finalizadas			BIT,
	@CodContexto			VARCHAR(4)
	
AS
BEGIN
	--Variables
	DECLARE	@L_NumeroPagina			int					=	@NumeroPagina,
			@L_CantidadRegistros	int					=	@CantidadRegistros,
			@L_NumeroExpediente		VARCHAR(14)			=	@NumeroExpediente,
			@L_CodLegajo			UNIQUEIDENTIFIER	=	@CodLegajo,
			@L_CodTipoOficina		SMALLINT			=	@CodTipoOficina,
			@L_CodMateria			VARCHAR(5)			=	@CodMateria,
			@L_Finalizadas			BIT					=	@Finalizadas,
			@L_CodContexto			VARCHAR(4)			=	@CodContexto

			
			
	--Lógica
	IF( @L_NumeroPagina is null) SET @L_NumeroPagina=1;

	IF	@L_NumeroExpediente	IS NOT NULL	-- Expediente
	BEGIN

		SELECT DISTINCT	A.TU_CodTareaPendiente				Codigo,
				A.TF_Recibido						FechaRecibido,
				A.TF_Vence							FechaVence,
				A.TC_Mensaje						Mensaje,
				A.TF_Finalizacion					FechaFinalizacion,
				A.TF_Reasignacion					FechaReasignacion,	
				COUNT(*) OVER()						AS	TotalRegistros,
				'SplitExpediente'					As	SplitExpediente,			
				A.TC_NumeroExpediente				Numero,
				'SplitLegajo'						As	SplitLegajo,
				A.TU_CodLegajo						Codigo,
				'SplitPuestoTrabajoOrigen'			As	SplitPuestoTrabajoOrigen,
				A.TC_CodPuestoTrabajoOrigen			Codigo,
				B.TC_Descripcion					Descripcion,
				'SplitFuncionarioOrigen'			As	SplitFuncionarioOrigen,
				C.TC_UsuarioRed						UsuarioRed,
				C.TC_Nombre							Nombre,
				C.TC_PrimerApellido					PrimerApellido,
				C.TC_SegundoApellido				SegundoApellido,			
				'SplitTarea'						As SplitTarea,
				A.TN_CodTarea						Codigo,
				D.TC_Descripcion					Descripcion,
				K.TN_CantidadHoras					CantidadHoras,
				'SplitClaseExpediente'				As SplitClaseExpediente,
				F.TN_CodClase						Codigo,
				F.TC_Descripcion					Descripcion,
				'SplitTareaPendienteAnterior'		As SplitTareaPendienteAnterior,
				G.TU_CodTareaPendiente				Codigo,
				'SplitTareaAnterior'				As SplitTareaAnterior,
				H.TN_CodTarea						Codigo,
				H.TC_Descripcion					Descripcion,
				'SplitDelitoExpediente'				As	SplitDelitoExpediente,
				I.TN_CodDelito						Codigo,
				I.TC_Descripcion					Descripcion,
				'SplitUsuarioReasigna'				As SplitUsuarioReasigna,
				M.TC_UsuarioRed						UsuarioRed,
				M.TC_Nombre							Nombre,
				M.TC_PrimerApellido					PrimerApellido,
				M.TC_SegundoApellido				SegundoApellido,
				'SplitUsuarioFinaliza'				As SplitUsuarioFinaliza,
				L.TC_UsuarioRed						UsuarioRed,
				L.TC_Nombre							Nombre,
				L.TC_PrimerApellido					PrimerApellido,
				L.TC_SegundoApellido				SegundoApellido,
				'SplitPuestoTrabajoFinaliza'		As	SplitPuestoTrabajoFinaliza,
				A.TC_CodPuestoTrabajoFinaliza		Codigo,
				O.TC_Descripcion					Descripcion,
				'SplitPuestoTrabajoReasigna'		As	SplitPuestoTrabajoReasigna,
				A.TC_CodPuestoTrabajoReasigna		Codigo,
				P.TC_Descripcion					Descripcion,
				'SplitTareaPendienteSiguiente'		As SplitTareaPendienteSiguiente,
				Q.TU_CodTareaPendiente				Codigo,
				Q.TC_Mensaje						Mensaje,
				'SplitTareaSiguiente'				As SplitTareaSiguiente,
				R.TN_CodTarea						Codigo,
				R.TC_Descripcion					Descripcion,								
				'SplitPuestoTrabajoSiguiente'		As	SplitPuestoTrabajoSiguiente,
				Q.TC_CodPuestoTrabajoDestino		Codigo,
				S.TC_Descripcion					Descripcion

				
		FROM		Expediente.TareaPendiente			A	WITH (NOLOCK)
		INNER JOIN	Catalogo.PuestoTrabajo				B 	WITH (NOLOCK)
		ON			B.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoOrigen
		INNER JOIN	Catalogo.Funcionario				C	WITH (NOLOCK)
		ON			C.TC_UsuarioRed						=	A.TC_UsuarioRedOrigen
		INNER JOIN	Catalogo.Tarea						D 	WITH (NOLOCK)
		ON			D.TN_CodTarea						= 	A.TN_CodTarea
		LEFT JOIN	Expediente.ExpedienteDetalle 		E 	WITH (NOLOCK)
		On			E.TC_NumeroExpediente				=	A.TC_NumeroExpediente
															and E.TC_CodContexto = @L_CodContexto
		LEFT JOIN	Catalogo.Clase						F 	WITH (NOLOCK)
		ON			F.TN_CodClase						=	E.TN_CodClase
		LEFT JOIN	Expediente.TareaPendiente			G	WITH (NOLOCK)
		ON			G.TU_CodTareaPendiente				=	A.TU_CodTareaPendienteAnterior
		LEFT JOIN	Catalogo.Tarea						H 	WITH (NOLOCK)
		ON			H.TN_CodTarea						= 	G.TN_CodTarea
		LEFT JOIN	Expediente.Expediente				I 	WITH (NOLOCK)
		ON			I.TC_NumeroExpediente				=	E.TC_NumeroExpediente
		LEFT JOIN	Catalogo.Delito						J 	WITH (NOLOCK)
		ON			J.TN_CodDelito						=	I.TN_CodDelito
		LEFT JOIN	Catalogo.Funcionario				L	WITH (NOLOCK)
		ON			L.TC_UsuarioRed						=	A.TC_UsuarioRedFinaliza	
		LEFT JOIN	Catalogo.Funcionario				M	WITH (NOLOCK)
		ON			M.TC_UsuarioRed						=	A.TC_UsuarioRedReasigna
		LEFT JOIN	Catalogo.PuestoTrabajo				O 	WITH (NOLOCK)
		ON			O.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoFinaliza		
		LEFT JOIN	Catalogo.PuestoTrabajo				P 	WITH (NOLOCK)
		ON			P.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoReasigna
		LEFT JOIN	Expediente.TareaPendiente			Q	WITH (NOLOCK)
		ON			Q.TU_CodTareaPendienteAnterior		=	A.TU_CodTareaPendiente
		LEFT JOIN	Catalogo.Tarea						R 	WITH (NOLOCK)
		ON			R.TN_CodTarea						= 	Q.TN_CodTarea
		LEFT JOIN	Catalogo.PuestoTrabajo				S 	WITH (NOLOCK)
		ON			S.TC_CodPuestoTrabajo				= 	Q.TC_CodPuestoTrabajoDestino
		LEFT JOIN	Catalogo.TareaTipoOficinaMateria	K 	WITH (NOLOCK)
		ON			K.TN_CodTarea						= 	A.TN_CodTarea
		AND			K.TN_CodTipoOficina					=	@L_CodTipoOficina
		AND			K.TC_CodMateria						=	@L_CodMateria
		   
		WHERE	A.TC_NumeroExpediente					=	@L_NumeroExpediente	
		AND		(
					(@L_Finalizadas	=	0	AND		A.TF_Reasignacion	IS	NOT NULL AND A.TC_UsuarioRedReasigna IS	NOT NULL)--Reasignadas
					OR
					(@L_Finalizadas	=	1	AND		A.TF_Finalizacion	IS	NOT NULL AND A.TC_UsuarioRedFinaliza IS	NOT NULL)--Finalizadas				
				) 
		AND		A.TU_CodLegajo IS NULL

		ORDER BY	A.TF_Finalizacion		Desc
		OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
					FETCH NEXT	@L_CantidadRegistros ROWS ONLY

	END ELSE
	BEGIN -- Legajo
		
		SELECT DISTINCT	A.TU_CodTareaPendiente				Codigo,
				A.TF_Recibido						FechaRecibido,
				A.TF_Vence							FechaVence,
				A.TC_Mensaje						Mensaje,
				A.TF_Finalizacion					FechaFinalizacion,
				A.TF_Reasignacion					FechaReasignacion,	
				COUNT(*) OVER()						AS	TotalRegistros,
				'SplitExpediente'					As	SplitExpediente,			
				A.TC_NumeroExpediente				Numero,
				'SplitLegajo'						As	SplitLegajo,
				A.TU_CodLegajo						Codigo,
				'SplitPuestoTrabajoOrigen'			As	SplitPuestoTrabajoOrigen,
				A.TC_CodPuestoTrabajoOrigen			Codigo,
				B.TC_Descripcion					Descripcion,
				'SplitFuncionarioOrigen'			As	SplitFuncionarioOrigen,
				C.TC_UsuarioRed						UsuarioRed,
				C.TC_Nombre							Nombre,
				C.TC_PrimerApellido					PrimerApellido,
				C.TC_SegundoApellido				SegundoApellido,			
				'SplitTarea'						As SplitTarea,
				A.TN_CodTarea						Codigo,
				D.TC_Descripcion					Descripcion,
				K.TN_CantidadHoras					CantidadHoras,
				'SplitClaseExpediente'				As SplitClaseExpediente,
				F.TN_CodClase						Codigo,
				F.TC_Descripcion					Descripcion,
				'SplitTareaPendienteAnterior'		As SplitTareaPendienteAnterior,
				G.TU_CodTareaPendiente				Codigo,
				'SplitTareaAnterior'				As SplitTareaAnterior,
				H.TN_CodTarea						Codigo,
				H.TC_Descripcion					Descripcion,
				'SplitDelitoExpediente'				As	SplitDelitoExpediente,
				I.TN_CodDelito						Codigo,
				I.TC_Descripcion					Descripcion,
				'SplitUsuarioReasigna'				As SplitUsuarioReasigna,
				M.TC_UsuarioRed						UsuarioRed,
				M.TC_Nombre							Nombre,
				M.TC_PrimerApellido					PrimerApellido,
				M.TC_SegundoApellido				SegundoApellido,
				'SplitUsuarioFinaliza'				As SplitUsuarioFinaliza,
				L.TC_UsuarioRed						UsuarioRed,
				L.TC_Nombre							Nombre,
				L.TC_PrimerApellido					PrimerApellido,
				L.TC_SegundoApellido				SegundoApellido,
				'SplitPuestoTrabajoFinaliza'		As	SplitPuestoTrabajoFinaliza,
				A.TC_CodPuestoTrabajoFinaliza		Codigo,
				O.TC_Descripcion					Descripcion,
				'SplitPuestoTrabajoReasigna'		As	SplitPuestoTrabajoReasigna,
				A.TC_CodPuestoTrabajoReasigna		Codigo,
				P.TC_Descripcion					Descripcion,
				'SplitTareaPendienteSiguiente'		As SplitTareaPendienteSiguiente,
				Q.TU_CodTareaPendiente				Codigo,
				Q.TC_Mensaje						Mensaje,
				'SplitTareaSiguiente'				As SplitTareaSiguiente,
				R.TN_CodTarea						Codigo,
				R.TC_Descripcion					Descripcion,								
				'SplitPuestoTrabajoSiguiente'		As	SplitPuestoTrabajoSiguiente,
				Q.TC_CodPuestoTrabajoDestino		Codigo,
				S.TC_Descripcion					Descripcion

				
		FROM		Expediente.TareaPendiente			A	WITH (NOLOCK)
		INNER JOIN	Catalogo.PuestoTrabajo				B 	WITH (NOLOCK)
		ON			B.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoOrigen
		INNER JOIN	Catalogo.Funcionario				C	WITH (NOLOCK)
		ON			C.TC_UsuarioRed						=	A.TC_UsuarioRedOrigen
		INNER JOIN	Catalogo.Tarea						D 	WITH (NOLOCK)
		ON			D.TN_CodTarea						= 	A.TN_CodTarea
		LEFT JOIN	Expediente.ExpedienteDetalle 		E 	WITH (NOLOCK)
		On			E.TC_NumeroExpediente				=	A.TC_NumeroExpediente
														and E.TC_CodContexto = @L_CodContexto
		LEFT JOIN	Catalogo.Clase						F 	WITH (NOLOCK)
		ON			F.TN_CodClase						=	E.TN_CodClase
		LEFT JOIN	Expediente.TareaPendiente			G	WITH (NOLOCK)
		ON			G.TU_CodTareaPendiente				=	A.TU_CodTareaPendienteAnterior
		LEFT JOIN	Catalogo.Tarea						H 	WITH (NOLOCK)
		ON			H.TN_CodTarea						= 	G.TN_CodTarea
		LEFT JOIN	Expediente.Expediente				I 	WITH (NOLOCK)
		ON			I.TC_NumeroExpediente				=	E.TC_NumeroExpediente
		LEFT JOIN	Catalogo.Delito						J 	WITH (NOLOCK)
		ON			J.TN_CodDelito						=	I.TN_CodDelito
		LEFT JOIN	Catalogo.Funcionario				L	WITH (NOLOCK)
		ON			L.TC_UsuarioRed						=	A.TC_UsuarioRedFinaliza	
		LEFT JOIN	Catalogo.Funcionario				M	WITH (NOLOCK)
		ON			M.TC_UsuarioRed						=	A.TC_UsuarioRedReasigna
		LEFT JOIN	Catalogo.PuestoTrabajo				O 	WITH (NOLOCK)
		ON			O.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoFinaliza		
		LEFT JOIN	Catalogo.PuestoTrabajo				P 	WITH (NOLOCK)
		ON			P.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoReasigna
		LEFT JOIN	Expediente.TareaPendiente			Q	WITH (NOLOCK)
		ON			Q.TU_CodTareaPendienteAnterior		=	A.TU_CodTareaPendiente
		LEFT JOIN	Catalogo.Tarea						R 	WITH (NOLOCK)
		ON			R.TN_CodTarea						= 	Q.TN_CodTarea
		LEFT JOIN	Catalogo.PuestoTrabajo				S 	WITH (NOLOCK)
		ON			S.TC_CodPuestoTrabajo				= 	Q.TC_CodPuestoTrabajoDestino
		LEFT JOIN	Catalogo.TareaTipoOficinaMateria	K 	WITH (NOLOCK)
		ON			K.TN_CodTarea						= 	A.TN_CodTarea
		AND			K.TN_CodTipoOficina					=	@L_CodTipoOficina
		AND			K.TC_CodMateria						=	@L_CodMateria
		   
		WHERE	A.TU_CodLegajo							=	@L_CodLegajo	
		AND		(
					(@L_Finalizadas	=	0	AND		A.TF_Reasignacion	IS	NOT NULL AND A.TC_UsuarioRedReasigna IS	NOT NULL)--Reasignadas
					OR
					(@L_Finalizadas	=	1	AND		A.TF_Finalizacion	IS	NOT NULL AND A.TC_UsuarioRedFinaliza IS	NOT NULL)--Finalizadas				
				) 
		ORDER BY	A.TF_Finalizacion		Desc
		OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
					FETCH NEXT	@L_CantidadRegistros ROWS ONLY
	END
END
GO
