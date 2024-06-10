SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<11/11/2020>
-- Descripción:			<Permite consultar los registros de tareas actuales vigentes en un expediente>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><15-11-2020><Se realiza ajustes en los campos que se devuelven donde se agregan varios>
-- ==================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><17-11-2020><Se agrega datos del funcionario del puesto de trabajo destino>
-- ==================================================================================================================================================================================
-- Modificado por:		<Richard Alberto Zúñiga Segura><10-03-2021>Se modifica consulta para que devuelva información incluso cuando el puesto de destino no tiene funcionario asignado>
-- Modificado por:		<Jonathan Aguilar Navarro><08/04/20121>Se modifica consulta para que devuelva información incluso cuando el puesto de destino no tiene funcionario asignado para legajo>
-- Modificado por:		<Fabian Sequeira Gamboa><25/06/20121>Se modifica consulta para que en las tareas del expediente muestre la persona asignada correctamente a la tarea, esta cuando es sustituida.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarTareasActualesExpediente]
	@NumeroExpediente							VARCHAR(14)			= NULL,
	@CodigoLegajo								UNIQUEIDENTIFIER	= NULL,
	@CodOficina									VARCHAR(4),
	@CodTipoOficina								SMALLINT,
	@CodMateria									VARCHAR(5)
AS
BEGIN
	--Variables
	DECLARE	@L_NumeroExpediente					VARCHAR(14)			=   @NumeroExpediente
	DECLARE	@L_CodigoLegajo						UNIQUEIDENTIFIER	=   @CodigoLegajo
	DECLARE @L_TF_FechaHoraActual				DATETIME2			=	SYSDATETIME()
	DECLARE @L_TC_CodOficina					VARCHAR(4)			=	@CodOficina
	DECLARE @L_TN_CodTipoOficina				SMALLINT			=	@CodTipoOficina
	DECLARE @L_TC_CodMateria					VARCHAR(5)			=	@CodMateria

	--Lógica
	IF(@NumeroExpediente IS NOT NULL)
	BEGIN
		SELECT			A.TU_CodTareaPendiente				Codigo,					  
						A.TF_Recibido						FechaRecibido,
						A.TF_Vence							FechaVence,
						A.TC_Mensaje						Mensaje,	
						A.TF_Finalizacion					FechaFinalizacion,	
						A.TF_Reasignacion					FechaReasignacion,
						(Agenda.FN_CantidadDiasHabiles(
								A.TF_Recibido, 
								@L_TF_FechaHoraActual, 
								@L_TC_CodOficina) * 24)		TiempoTranscurrido,
						'splitTarea'						splitTarea,
						T1.TN_CodTarea						Codigo,
						T1.TC_Descripcion					Descripcion,
						TTO.TN_CantidadHoras				CantidadHoras,
						'splitOtros'						splitOtros,
						A.TC_NumeroExpediente				NumeroExpediente,
						A.TU_CodLegajo						CodigoLegajo,
						A.TC_CodPuestoTrabajoOrigen			CodigoPuestoTrabajoOrigen,	
						P.TC_Descripcion					DescripcionTrabajoOrigen,
						PD.TC_CodPuestoTrabajo				CodigoPuestoTrabajoDestino,
						PD.TC_Descripcion					DescripcionPuestoTrabajoDestino,					  
						FU.TC_UsuarioRed					UsuarioFuncionario,
						FU.TC_Nombre						NombreFuncionario,
						FU.TC_PrimerApellido				PrimerApellidoFuncionario,
						FU.TC_SegundoApellido				SegundoApellidoFuncionario,											
						A.TC_UsuarioRedFinaliza				UsuarioRedFinaliza,					  						
						A.TC_UsuarioRedReasigna				UsuarioRedReasigna,
						A.TU_CodTareaPendienteAnterior		CodigoTareaPendienteAnterior,	
						A.TC_UsuarioRedOrigen				UsuarioOrigen,
						FU.TC_UsuarioRed					UsuarioRedOrigen,
						FU.TC_Nombre						NombreOrigen,
						FU.TC_PrimerApellido				PrimerApellidoOrigen,
						FU.TC_SegundoApellido				SegundoApellidoOrigen,
						FU.TC_CodPlaza						CodigoPlazaOrigen,
						FU.TF_Inicio_Vigencia				FechaActivacionOrigen,
						FU.TF_Fin_Vigencia					FechaDesactivacionOrigen,
						FT.TC_UsuarioRed					UsuarioRedDestino, 
						FT.TC_Nombre						NombreDestino, 
						FT.TC_PrimerApellido				PrimerApellidoDestino,
						FT.TC_SegundoApellido				SegundoApellidoDestino, 						
						D.TN_CodDelito						CodigoDelito,
						D.TC_Descripcion					DescripcionDelito,
						B.TU_CodTareaPendiente				CodigoTareaPendienteAnterior,
						T2.TN_CodTarea						CodigoTareaAnterior,
						T2.TC_Descripcion					DescripcionTareaAnterior

		FROM			Expediente.TareaPendiente			A   WITH (NOLOCK)
		INNER JOIN		Catalogo.PuestoTrabajo				P 	WITH (NOLOCK)
		ON				P.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoOrigen
		LEFT JOIN		Catalogo.PuestoTrabajo				PD 	WITH (NOLOCK)
		ON				PD.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoDestino
		INNER JOIN		Catalogo.Funcionario				FU  WITH (NOLOCK)
		ON				FU.TC_UsuarioRed					=   A.TC_UsuarioRedOrigen
		LEFT JOIN		Catalogo.PuestoTrabajoFuncionario	PTF WITH (NOLOCK)
		ON				PTF.TC_CodPuestoTrabajo				=   A.TC_CodPuestoTrabajoDestino
		--And				(PTF.TF_Inicio_Vigencia				<	Getdate() or PTF.TF_Inicio_Vigencia is null)
		--And				(PTF.TF_Fin_Vigencia					Is	Null Or	PTF.TF_Fin_Vigencia >= Getdate())
		LEFT JOIN		Catalogo.Funcionario				FT  WITH (NOLOCK)
		ON				FT.TC_UsuarioRed					=	PTF.TC_UsuarioRed
		INNER JOIN		Catalogo.Tarea						T1  WITH (NOLOCK)
		ON				T1.TN_CodTarea						=   A.TN_CodTarea
		LEFT JOIN		Expediente.ExpedienteDetalle 		ED	WITH (NOLOCK)
		On				ED.TC_NumeroExpediente				=	A.TC_NumeroExpediente
		LEFT JOIN		Catalogo.Clase						C 	WITH (NOLOCK)
		ON				C.TN_CodClase						=	ED.TN_CodClase
		LEFT JOIN		Expediente.TareaPendiente			B	WITH (NOLOCK)
		ON				B.TU_CodTareaPendiente				=	A.TU_CodTareaPendienteAnterior
		LEFT JOIN		Catalogo.Tarea						T2 	WITH (NOLOCK)
		ON				T2.TN_CodTarea						=  B.TN_CodTarea
		LEFT JOIN		Expediente.Expediente				E 	WITH (NOLOCK)
		ON				E.TC_NumeroExpediente				=	ED.TC_NumeroExpediente
		LEFT JOIN		Catalogo.Delito						D 	WITH (NOLOCK)
		ON				D.TN_CodDelito						=	E.TN_CodDelito
		LEFT JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH (NOLOCK)
		ON				TTO.TN_CodTarea						= 	A.TN_CodTarea
		AND				TTO.TN_CodTipoOficina				=	@L_TN_CodTipoOficina
		AND				TTO.TC_CodMateria					=	@L_TC_CodMateria		

		WHERE			A.TC_NumeroExpediente				= @L_NumeroExpediente
		AND				A.TU_CodLegajo						IS NULL
		AND				A.TC_UsuarioRedFinaliza				IS NULL
		AND				A.TF_Finalizacion					IS NULL
		AND				A.TC_UsuarioRedReasigna				IS NULL
		AND				A.TF_Reasignacion					IS NULL

		ORDER BY A.TF_Recibido desc, PTF.TF_Inicio_Vigencia	desc
	END
	ELSE
	BEGIN
		IF (@L_CodigoLegajo IS NOT NULL)
		 BEGIN 
						SELECT	A.TU_CodTareaPendiente				Codigo,					  
								A.TF_Recibido						FechaRecibido,
								A.TF_Vence							FechaVence,
								A.TC_Mensaje						Mensaje,	
								A.TF_Finalizacion					FechaFinalizacion,	
								A.TF_Reasignacion					FechaReasignacion,
								(Agenda.FN_CantidadDiasHabiles(
										A.TF_Recibido, 
										@L_TF_FechaHoraActual, 
										@L_TC_CodOficina) * 24)		TiempoTranscurrido,
								'splitTarea'						splitTarea,
								T1.TN_CodTarea						Codigo,
								T1.TC_Descripcion					Descripcion,
								TTO.TN_CantidadHoras				CantidadHoras,
								'splitOtros'						splitOtros,
								A.TC_NumeroExpediente				NumeroExpediente,
								A.TU_CodLegajo						CodigoLegajo,
								A.TC_CodPuestoTrabajoOrigen			CodigoPuestoTrabajoOrigen,	
								P.TC_Descripcion					DescripcionTrabajoOrigen,
								PD.TC_CodPuestoTrabajo				CodigoPuestoTrabajoDestino,
								PD.TC_Descripcion					DescripcionPuestoTrabajoDestino,					  
								FU.TC_UsuarioRed					UsuarioFuncionario,
								FU.TC_Nombre						NombreFuncionario,
								FU.TC_PrimerApellido				PrimerApellidoFuncionario,
								FU.TC_SegundoApellido				SegundoApellidoFuncionario,											
								A.TC_UsuarioRedFinaliza				UsuarioRedFinaliza,					  						
								A.TC_UsuarioRedReasigna				UsuarioRedReasigna,
								A.TU_CodTareaPendienteAnterior		CodigoTareaPendienteAnterior,	
								A.TC_UsuarioRedOrigen				UsuarioOrigen,
								FU.TC_UsuarioRed					UsuarioRedOrigen,
								FU.TC_Nombre						NombreOrigen,
								FU.TC_PrimerApellido				PrimerApellidoOrigen,
								FU.TC_SegundoApellido				SegundoApellidoOrigen,
								FU.TC_CodPlaza						CodigoPlazaOrigen,
								FU.TF_Inicio_Vigencia				FechaActivacionOrigen,
								FU.TF_Fin_Vigencia					FechaDesactivacionOrigen,
								FT.TC_UsuarioRed					UsuarioRedDestino, 
								FT.TC_Nombre						NombreDestino, 
								FT.TC_PrimerApellido				PrimerApellidoDestino,
								FT.TC_SegundoApellido				SegundoApellidoDestino, 						
								D.TN_CodDelito						CodigoDelito,
								D.TC_Descripcion					DescripcionDelito,
								B.TU_CodTareaPendiente				CodigoTareaPendienteAnterior,
								T2.TN_CodTarea						CodigoTareaAnterior,
								T2.TC_Descripcion					DescripcionTareaAnterior

				FROM			Expediente.TareaPendiente			A   WITH (NOLOCK)
				INNER JOIN		Catalogo.PuestoTrabajo				P 	WITH (NOLOCK)
				ON				P.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoOrigen
				LEFT JOIN		Catalogo.PuestoTrabajo				PD 	WITH (NOLOCK)
				ON				PD.TC_CodPuestoTrabajo				= 	A.TC_CodPuestoTrabajoDestino
				INNER JOIN		Catalogo.Funcionario				FU  WITH (NOLOCK)
				ON				FU.TC_UsuarioRed					=   A.TC_UsuarioRedOrigen
				LEFT JOIN		Catalogo.PuestoTrabajoFuncionario	PTF WITH (NOLOCK)
				ON				PTF.TC_CodPuestoTrabajo				=   A.TC_CodPuestoTrabajoDestino 
				LEFT JOIN		Catalogo.Funcionario				FT  WITH (NOLOCK)
				ON				FT.TC_UsuarioRed					=	PTF.TC_UsuarioRed
				INNER JOIN		Catalogo.Tarea						T1  WITH (NOLOCK)
				ON				T1.TN_CodTarea						=   A.TN_CodTarea
				LEFT JOIN		Expediente.ExpedienteDetalle 		ED	WITH (NOLOCK)
				On				ED.TC_NumeroExpediente				=	A.TC_NumeroExpediente
				LEFT JOIN		Catalogo.Clase						C 	WITH (NOLOCK)
				ON				C.TN_CodClase						=	ED.TN_CodClase
				LEFT JOIN		Expediente.TareaPendiente			B	WITH (NOLOCK)
				ON				B.TU_CodTareaPendiente				=	A.TU_CodTareaPendienteAnterior
				LEFT JOIN		Catalogo.Tarea						T2 	WITH (NOLOCK)
				ON				T2.TN_CodTarea						=  B.TN_CodTarea
				LEFT JOIN		Expediente.Expediente				E 	WITH (NOLOCK)
				ON				E.TC_NumeroExpediente				=	ED.TC_NumeroExpediente
				LEFT JOIN		Catalogo.Delito						D 	WITH (NOLOCK)
				ON				D.TN_CodDelito						=	E.TN_CodDelito
				LEFT JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH (NOLOCK)
				ON				TTO.TN_CodTarea						= 	A.TN_CodTarea
				AND				TTO.TN_CodTipoOficina				=	@L_TN_CodTipoOficina
				AND				TTO.TC_CodMateria					=	@L_TC_CodMateria		

				WHERE		A.TU_CodLegajo							= @L_CodigoLegajo
				AND			A.TC_UsuarioRedFinaliza					IS NULL
				AND			A.TF_Finalizacion						IS NULL
				AND			A.TC_UsuarioRedReasigna					IS NULL
				AND			A.TF_Reasignacion						IS NULL

				ORDER BY	A.TF_Recibido desc, PTF.TF_Inicio_Vigencia	desc
		 END
	END
END
GO
