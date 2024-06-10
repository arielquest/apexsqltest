SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
---- ==================================================================================================================================================================================
---- Versión:				<1.0>
---- Creado por:			<Ronny Ram¡rez Rojas>
---- Fecha de creación:		<23/10/2020>
---- Descripción:			<Permite consultar un registro en la tabla: TareaPendiente.>
---- ==================================================================================================================================================================================
---- Modificación:		<28/10/2020> <Ronny Ram¡rez R.> <Se modifica para agregar campos para el detalle> 
---- Modificación:		<09/11/2020> <Jonathan Aguilar Navarro> <Se agregar a la consulta la información del usuario que Reasigna y Finaliza,>
----						<Adem s se agrega a la consulta el filtro de fecha de reasignación, para que no muestre las tareas que han sido reasginadas. >
---- Modificación:		<10/11/2020> <Ronny Ram¡rez R.> <Se modifica para cambiar origen de los datos del Funcionario Origen basado en el usuarioRedOrigen> 
---- Modificación:		<07/12/2020> <Roger Lara > <Se modifica para agregar filtrado por Ubicacion de expediente o legajo> 
---- Modificación:		<09/12/2020> <Ronny Ram¡rez R.> <Se modifica la relación de tarea anterior por un Left join para que no haya problema con la tarea inicial> 
---- Modificación:		<29/01/2021> <Ronny Ram¡rez R.> <Se aplica operador Distinct para evita duplicados en consulta final.> 
---- Modificación:		<08/03/2021> <Ronny Ram¡rez R.> <Se aplica corrección para traer descripción del delito en lugar de la tarea, en el mapeo del delito.> 
---- Modificación:		<22/04/2021> <Ronny Ram¡rez R.> <Se aplica filtro para que no muestre las tareas que han sido finalizadas> 
---- Modificación:		<28/05/2021> <Jose Cordero Soto.> <Se agrega entre los filtros el valor de CONTEXTO para filtrar la consulta> 
---- Modificación:		<08/06/2021> <Daniel Ruiz Hern ndez> <Se agrega filtro de CONTEXTO para el detalle de expedientes> 
---- Modificación:		<23/06/2021> <Daniel Ruiz Hern ndez> <Se agrega filtro de usuario de red finaliza y usuario de red reasigna> 
---- Modificación:		<07/07/2021> <Josu‚ Quirós Batista> <Se obtiene el asunto de los legajos consultados.> 
---- Modificación:		<08/07/2021> <Fabi n Sequeira Gamboa> <Se corrige lo aplicado por Daniel, ya que no considera que el expediente puede que no tenga detalle ya que la oficina sólo tiene un legajo.> 
---- Modificación:		<26/08/2021> <Luis Alonso Leiva Tames> <Se modifica para enviar los datos del contexto creación.> 
---- Modificación:		<05/01/2022> <Ronny Ram¡rez R.> <Se modifica para enviar los datos del contexto actual en lugar del de creación.> 
---- modificación:		<24/05/2022> <Jose Gabriel Cordero Soto> <Se agrega consulta de proceso del legajo o expediente de la tarea a visualizar, ademas se renombran alias en consulta y ordenamiento de otras subconsultas>
---- modificación:		<20/07/2022> <Ricardo Alfonso Jiménez Arroyo> <Se agrega el filtro de la búsqueda por codContexto en el Proceso del Expediente>
---- Modificación:		<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
---- Modificación:		<27/03/2023> <Elías González Porras> <Se modifica la columna por la que debe ordenar la seleccion para obtener la clase de expediente.>
---- ==================================================================================================================================================================================
CREATE   PROCEDURE	[Expediente].[PA_ConsultarBuzonTareasPendientes]

@CodPuestoTrabajoDestino			VARCHAR(14),
@CodClase							INT				= NULL,
@IndicadorMenorEdad					BIT				= 0,-- NO SE UTILIZA 
@IndicadorAdultoMayor				BIT				= 0,-- NO SE UTILIZA
@Plazo								BIT				= NULL,
@FechaDesde							DATETIME2		= NULL,
@FechaHasta							DATETIME2		= NULL,
@NumeroExpediente					VARCHAR(14)		= NULL,
@CodOficina							VARCHAR(4),
@CodTipoOficina						SMALLINT,
@CodMateria							VARCHAR(5),
@CodUbicacion						INT				= NULL,
@CodContexto						VARCHAR(4)		

AS
BEGIN
	--Variables
	DECLARE		@L_TC_CodPuestoTrabajoDestino																	VARCHAR(14)		= @CodPuestoTrabajoDestino,
				@L_TN_CodClase																					INT				= @CodClase,
				@L_TB_IndicadorMenorEdad																		BIT				= @IndicadorMenorEdad,
				@L_TB_IndicadorAdultoMayor																		BIT				= @IndicadorAdultoMayor,
				@L_TB_Plazo																						BIT				= @Plazo,
				@L_TF_FechaDesde																				DATETIME2		= @FechaDesde,
				@L_TF_FechaHasta																				DATETIME2		= @FechaHasta,
				@L_TC_NumeroExpediente																			VARCHAR(14)		= @NumeroExpediente,
				@L_TC_CodOficina																				VARCHAR(4)		= @CodOficina,
				@L_TN_CodTipoOficina																			SMALLINT		= @CodTipoOficina,
				@L_TC_CodMateria																				VARCHAR(5)		= @CodMateria,
				@L_TF_FechaHoraActual																			DATETIME2		= SYSDATETIME(),
				@L_TN_CodUbicacion																				INT				= @CodUbicacion,
				@L_TC_CodContexto																				VARCHAR(4)		= @CodContexto
	
	--Lógica
	SELECT		DISTINCT 
				A.TU_CodTareaPendiente																			Codigo,
				A.TF_Recibido																					FechaRecibido,
				A.TF_Vence																						FechaVence,
				A.TC_Mensaje																					Mensaje,
				A.TF_Finalizacion																				FechaFinalizacion,
				A.TF_Reasignacion																				FechaReasignacion,
				(Agenda.FN_CantidadDiasHabiles (A.TF_Recibido, @L_TF_FechaHoraActual, @L_TC_CodOficina) * 24)	TiempoTranscurrido,
				'SplitExpediente'																				As	SplitExpediente,
				A.TC_NumeroExpediente																			Numero,
				'SplitLegajo'																					As	SplitLegajo,
				A.TU_CodLegajo																					Codigo,
				L.DescripAsuntoLegajo																			Descripcion,	
				'SplitPuestoTrabajoOrigen'																		As	SplitPuestoTrabajoOrigen,
				A.TC_CodPuestoTrabajoOrigen																		Codigo,
				B.TC_Descripcion																				Descripcion,
				'SplitFuncionarioOrigen'																		SplitFuncionarioOrigen,
				C.TC_UsuarioRed																					UsuarioRed,
				C.TC_Nombre																						Nombre,
				C.TC_PrimerApellido																				PrimerApellido,
				C.TC_SegundoApellido																			SegundoApellido,
				C.TC_CodPlaza																					CodigoPlaza,
				C.TF_Inicio_Vigencia																			FechaActivacion,
				C.TF_Fin_Vigencia																				FechaDesactivacion,
				'SplitUsuarioOrigen'																			SplitUsuarioOrigen,
				A.TC_UsuarioRedOrigen																			UsuarioRed,
				'SplitTarea'																					SplitTarea,
				A.TN_CodTarea																					Codigo,
				D.TC_Descripcion																				Descripcion,
				E.TN_CantidadHoras																				CantidadHoras,
				'SplitClaseExpediente'																			SplitClaseExpediente,
				F.Codigo																						Codigo,
				F.Descripcion																					Descripcion,
				'SplitTareaPendienteAnterior'																	SplitTareaPendienteAnterior,
				A.TU_CodTareaPendiente																			Codigo,
				'SplitTareaAnterior'																			SplitTareaAnterior,
				G.Codigo																						Codigo,
				G.Descripcion																					Descripcion,
				'SplitDelitoExpediente'																			SplitDelitoExpediente,
				H.Codigo																						Codigo,
				H.Descripcion																					Descripcion,
				'SplitUsuarioReasigna'																			SplitUsuarioReasigna,
				A.TC_UsuarioRedReasigna																			UsuarioRed,
				'SplitUsuarioFinaliza'																			SplitUsuarioFinaliza,
				A.TC_UsuarioRedFinaliza																			UsuarioRed,
				'SplitContexto'																					SplitContexto,
				V.TC_CodContexto																				Codigo, 
				V.TC_Descripcion																				Descripcion,
				'SplitProcesoExpediente'																		SplitProcesoExpediente,
				M.TN_CodProceso																					Codigo,
				M.TC_Descripcion																				Descripcion,	
				'SplitProcesoLegajo'																			SplitProcesoLegajo,
				N.TN_CodProceso																					Codigo,
				N.TC_Descripcion																				Descripcion,
				'SplitClaseAsuntoLegajo'																		SplitClaseAsuntoLegajo,
				O.TN_CodClaseAsunto																				Codigo,
				O.TC_Descripcion																				Descripcion
				
	FROM		Expediente.TareaPendiente																		A WITH(NOLOCK)	
	INNER JOIN	Catalogo.PuestoTrabajo																			B WITH(NOLOCK)
	ON			B.TC_CodPuestoTrabajo																			= A.TC_CodPuestoTrabajoOrigen	
	INNER JOIN  Expediente.Expediente																			Ex WITH(NOLOCK)
	ON			A.TC_NumeroExpediente																			= Ex.TC_NumeroExpediente 	
	INNER JOIN  Catalogo.Contexto																				V WITH(NOLOCK)
	ON			V.TC_CodContexto																				= Ex.TC_CodContexto	
	INNER JOIN	Catalogo.Funcionario																			C WITH(NOLOCK)
	ON			C.TC_UsuarioRed																					= A.TC_UsuarioRedOrigen	
	INNER JOIN	Catalogo.Tarea																					D WITH(NOLOCK)
	ON			D.TN_CodTarea																					= A.TN_CodTarea	
	LEFT JOIN	Catalogo.TareaTipoOficinaMateria																E WITH(NOLOCK)
	ON			E.TN_CodTarea																					= A.TN_CodTarea
	AND			E.TN_CodTipoOficina																				= @L_TN_CodTipoOficina
	AND			E.TC_CodMateria																					= @L_TC_CodMateria
	
	-- OBTIENE LA CLASE DEL EXPEDIENTE
	OUTER APPLY	(
					SELECT TOP 1	Z.TN_CodClase					Codigo,
									Y.TC_Descripcion				Descripcion,
									Z.TC_CodContexto
					FROM			Expediente.ExpedienteDetalle	Z WITH(NOLOCK)
					INNER JOIN		Catalogo.Clase					Y WITH(NOLOCK)
					ON				Y.TN_CodClase					= Z.TN_CodClase
					WHERE			Z.TC_NumeroExpediente			= A.TC_NumeroExpediente
					AND				Z.TN_CodClase					= ISNULL(@CodClase, Z.TN_CodClase)
					AND				(
										Z.TC_CodContexto			= @L_TC_CodContexto
									OR
										Z.TC_CodContexto			= '0000'
									)
					ORDER BY		Z.TC_CodContexto					DESC
				) F	
	--OBTIENE INFORMACION DE LA DESCRIPCION DE LA TAREA
	OUTER APPLY	(
					SELECT		X.TN_CodTarea				Codigo,
								W.TC_Descripcion			Descripcion
					FROM		Expediente.TareaPendiente	X WITH(NOLOCK)
					INNER JOIN	Catalogo.Tarea				W WITH(NOLOCK)
					ON			W.TN_CodTarea				= X.TN_CodTarea
					WHERE		X.TU_CodTareaPendiente		= A.TU_CodTareaPendienteAnterior
				) G
	--OBTENER DESCRIPCION Y CODIGO DEL DELITO ASOCIADO 
	CROSS APPLY	(
					SELECT		V.TN_CodDelito			Codigo,
								U.TC_Descripcion		Descripcion
					FROM		Expediente.Expediente	V WITH(NOLOCK)
					LEFT JOIN	Catalogo.Delito			U WITH(NOLOCK)
					ON			U.TN_CodDelito			= V.TN_CodDelito
					WHERE		V.TC_NumeroExpediente	= A.TC_NumeroExpediente
				) H
	--OBTIENE LA éLTIMA UBICACIàN EN EL éLTIMO CONTEXTO EN EL QUE ESTµ EL EXPEDIENTE, PARA FILTRARLO LUEGO
	OUTER APPLY	(
					SELECT TOP 1	T.TN_CodUbicacion
					FROM			Historico.ExpedienteUbicacion	T WITH(NOLOCK)
					WHERE			T.TC_NumeroExpediente			= A.TC_NumeroExpediente
					AND				T.TC_CodContexto				= F.TC_CodContexto
					ORDER BY		TF_FechaUbicacion				DESC
				) I
	--OBTIENE LA éLTIMA UBICACIàN EN EL éLTIMO CONTEXTO EN EL QUE ESDTµ EL LEGAJO, PARA FILTRARLO LUEGO.
	OUTER APPLY	(
					SELECT TOP 1	S.TC_CodContexto
					FROM			Expediente.LegajoDetalle	S WITH(NOLOCK)
					WHERE			S.TU_CodLegajo				= A.TU_CodLegajo
					AND				S.TC_CodContexto			= @L_TC_CodContexto
					ORDER BY		S.TF_Entrada					DESC				
				) J
	--OBTIENE LA UBICACION DEL LEGAJO 
	OUTER APPLY	(
					SELECT TOP 1	R.TN_CodUbicacion
					FROM			Historico.LegajoUbicacion	R WITH(NOLOCK)
					WHERE			R.TC_NumeroExpediente		= A.TC_NumeroExpediente
					AND				R.TU_CodLegajo				= A.TU_CodLegajo
					AND				R.TC_CodContexto			= J.TC_CodContexto
					ORDER BY		TF_FechaUbicacion			DESC
				) K
	-- Asunto de los legajos
	Outer Apply (
					Select			DO.TC_Descripcion			DescripAsuntoLegajo
					From			Expediente.LegajoDetalle	CO WITH(NOLOCK)
					Inner Join		Catalogo.Asunto				DO WITH(NOLOCK)
					On				DO.TN_CodAsunto				= CO.TN_CodAsunto 
					AND				CO.TC_CodContexto			= @L_TC_CodContexto
					Where			CO.TU_CodLegajo				= A.TU_CodLegajo
				) L
	--Proceso del Expediente
	OUTER APPLY (
					SELECT		Z.TN_CodProceso,				Z.TC_Descripcion	
					FROM		Catalogo.Proceso				Z WITH(NOLOCK)
					INNER JOIN	Expediente.ExpedienteDetalle	Y WITH(NOLOCK)
					ON			Z.TN_CodProceso					= Y.TN_CodProceso
					AND			Y.TC_CodContexto				= @L_TC_CodContexto
					WHERE		Y.TC_NumeroExpediente			= A.TC_NumeroExpediente
				) M
	--Proceso del Legajo
	OUTER APPLY (
					SELECT		Z.TN_CodProceso,				Z.TC_Descripcion	
					FROM		Catalogo.Proceso				Z WITH(NOLOCK)
					INNER JOIN	Expediente.LegajoDetalle		Y WITH(NOLOCK)
					ON			Z.TN_CodProceso					= Y.TN_CodProceso
					AND			Y.TC_CodContexto				= @L_TC_CodContexto
					INNER JOIN	Expediente.Legajo				X WITH(NOLOCK)
					ON			X.TU_CodLegajo					= Y.TU_CodLegajo
					WHERE		Y.TU_CodLegajo					= Y.TU_CodLegajo
					AND			X.TC_NumeroExpediente			= A.TC_NumeroExpediente		
					AND			X.TU_CodLegajo					= A.TU_CodLegajo
				) N	
	--Clase Asunto del Legajo
	OUTER APPLY (
					SELECT		Z.TN_CodClaseAsunto,			Z.TC_Descripcion
					FROM		Catalogo.ClaseAsunto			Z WITH(NOLOCK)
					INNER JOIN	Expediente.LegajoDetalle		Y WITH(NOLOCK)
					ON			Z.TN_CodClaseAsunto				= Y.TN_CodClaseAsunto
					AND			Y.TC_CodContexto				= @L_TC_CodContexto
					INNER JOIN	Expediente.Legajo				X WITH(NOLOCK)
					ON			X.TU_CodLegajo					= Y.TU_CodLegajo
					WHERE		Y.TU_CodLegajo					= Y.TU_CodLegajo
					AND			X.TC_NumeroExpediente			= A.TC_NumeroExpediente		
					AND			X.TU_CodLegajo					= A.TU_CodLegajo	
				) O

	WHERE		A.TC_CodPuestoTrabajoDestino																	= @L_TC_CodPuestoTrabajoDestino
	AND			A.TC_CodContexto																				= @L_TC_CodContexto
	AND			A.TF_Reasignacion																				IS NULL
	AND			A.TC_UsuarioRedReasigna																			IS NULL
	AND			A.TF_Finalizacion																				IS NULL
	AND			A.TC_UsuarioRedFinaliza																			IS NULL
	AND			(
					@L_TB_Plazo																					IS NULL-- Cualquier plazo
	OR			(
					@L_TB_Plazo																					= 0-- Plazo Sin Vencer
	AND 
					A.TF_Vence																					> @L_TF_FechaHoraActual
				)
	OR			(
					@L_TB_Plazo 																				= 1-- Plazo Vencido
	AND 
					A.TF_Vence																					<= @L_TF_FechaHoraActual
				)
	)
	AND			(	
					@L_TF_FechaDesde																			IS NULL					
	OR
					DATEDIFF(DAY, A.TF_Recibido, @L_TF_FechaDesde)												<= 0
				)
	AND			(	
					@L_TF_FechaHasta																			IS NULL					
	OR 									
					DATEDIFF(DAY, A.TF_Recibido, @L_TF_FechaHasta)												>= 0
				)
	AND				A.TC_NumeroExpediente																		= ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)
	AND			(
					ISNULL(I.TN_CodUbicacion, 0) = ISNULL(@L_TN_CodUbicacion, ISNULL(I.TN_CodUbicacion, 0))
	OR
					ISNULL(K.TN_CodUbicacion, 0) = ISNULL(@L_TN_CodUbicacion, ISNULL(K.TN_CodUbicacion, 0))
				)
	AND			(F.TC_CodContexto = @L_TC_CodContexto or J.TC_CodContexto = @L_TC_CodContexto)
END
GO
