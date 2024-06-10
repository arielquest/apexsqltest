SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<04/09/2015>
-- Descripción :			<Permite Consultar Legajos> 
-- ===========================================================================================================================================================================================================================================
-- Modificación:			<Alejandro Villalta>		 <25/04/2016>	<Se agrega el filtro por codigo de oficina.>
-- Modificación:			<Donald Vargas Zúñiga>		 <02/12/2016>	<Se corrige el nombre del campo TC_CodMoneda, TC_CodPrioridad, TC_CodTipoCuantia, 
--																		 TC_CodTipoViabilidad y TC_CodTipoAsunto a TN_CodMoneda, TN_CodPrioridad, TN_CodTipoCuantia, 
--																		 TN_CodTipoViabilidad y TN_CodTipoAsunto de acuerdo al tipo de dato>
-- Modificación:			<Johan Acosta>				 <05/12/2016>	<Descripcion: Se cambio nombre de TC a TN>
-- Modificación:			<Jonathan Aguilar Navarro>	 <26/04/2018>	<Se cambia el campo y parametros @CodOficina por @CodContexto y TC_CodOficina por TC_CodContexto>
-- Modificación:			<Tatiana Flores>			 <22/08/2018>	<Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:			<Jonathan Aguilar Navarro>   <08/01/2019>	<Se agrega a la consulta el ExpedienteAcumula> 
-- Modificacion:			<Jonathan Aguilar Navarro>   <12/03/2019>	<Se modifica con respecto a los cambios de Creacion de expediente>
-- Modificacion:			<Jonathan Aguilar Navarro>   <28/05/2019>	<Se agrega a la consulta la oficina del Contexto>
-- Modificacion:			<Isaac Dobles Mata>			 <05/08/2019>	<Se agrega consultar el movimiento de circulante del estado del expediente>
-- Modificacion:			<Jonathan Aguilar Navarro>   <23/08/2019>	<Se agregar a la consulta el tipo de oficina y la materia del contexto>
-- Modificacion:			<Isaac Dobles Mata>			 <31/10/2019>	<Se modifica consulta del estado para que use el MAX de la fecha del movimiento circulante en
--																		 lugar de TOP 1 ordenado por fecha>
-- Modificacion:			<Isaac Dobles Mata>			 <04/11/2019>	<Se agrega la categoría del delito en la consulta>
-- Modificación				<Johan Manuel Acosta Ibañez> <14/04/2020>	<Se agrega si el contexto donde se encuentra permite EnvioEscritos a Gestión en Linea y App Móvil 
--																		 PBI 72302 Funcionalidad HU 11 Envío de Escritos GL- Funcionalidad búsqueda del expediente.> 
-- Modificación				<Kirvin Bennett Mathurin>    <27/04/2020>	<Se agrega si el contexto donde se encuentra permite EnvioDemandasDenuncias a
--																		 Gestión en Linea y App Móvil PBI 102758 HU 08 FUN Registrar Datos Generales de la demanda> 
-- Modificacion:			<Wagner Vargas Sanabria>     <15/06/2020>	<Se modifica la consulta para obtener en el codigo del contexto detalle de la tabla
--																		ExpedienteDetalle TC_codContexto PBI 98813 BUG 0019- Expediente: Historias Usuario
--																		expediente HU 7: 01.Historias Usuario-Expediente - Hoja: 03 AbrirExpediente 
--																		- versión 1.7.17.19325 - Corresponde a: Pantalla datos generales>
-- Modificación				<Kirvin Bennett Mathurin>    <09/07/2020>	<Se agrega que retorne si el contexto donde se encuentra permite ConsultaPublicaCiudadadono
--																	   y ConsultaPrivadaCiudadadono a Gestión en Linea y App Móvil>
-- Modificación				<Isaac Dobles Mata>			 <02/10/2020>	<Se modifica consulta de expediente acumulado>
-- Modificación				<Andrew Allen Dawson>		 <22/10/2020>	<Se cambia K.TC_CodContexto por B.TC_CodContexto para que realice la busqueda correctamente>
-- Modificación:			<Aida Elena Siles Rojas>	 <24/11/2020>	<Se agregan variables locales al SP.>
-- Modificación             <Roger Lara>				 <14/12/2020>	<Se ajusta la consulta por Fase, para que consulte en el historico de fases el expediente>
-- Modificación             <Karol Jiménez S.>			 <19/02/2021>	<Se agrega consulta de CarpetaGestion (CARPETA)>
-- Modificación				<Ronny Ramírez R.>			 <11/03/2021>	<Se agrega nuevo campo de TC_DescripcionHechos a la consulta>
-- Modificación				<Ronny Ramírez R.>			 <12/03/2021>	<Se agregan nuevos campos de TN_MontoMensual, TN_MontoAguinaldo y TN_MontoSalarioEscolar a la consulta>
-- Modificación				<Fabian Sequeira Gamboa.>	 <09/06/2021>	<Luego de la migracion no se debe contar con lo contextos 0000, osea eliminar el cascaron
--																		para que se vea el expediente Habilitado>
-- Modificación				<Ronny Ramírez R.>			 <23/06/2021>	<Se elimina el filtro de contextos 0000 agregado por Fabián, pues afecta
--																		las itineraciones, Wagner buscará otra solución para la migración>
-- Modificación				<Josué Quirós Batista>		 <17/06/2021>	<Se modifica para incluir el código de la oficina asociada al contexto de procedencia>
-- Modificación				<Isaac S. Méndez Castillo>	 <06/07/2021>	<Se agregan nuevo campo "TN_MontoEmbargo" a la consulta>
-- Modificación				<Johan M. Acosta Ibañez>	 <16/16/2021>	<Se añade la ubicación y tarea a la consulta para el detalle del expediente  en tramitación masiva>
-- Modificación				<Aarón	Ríos Retana>		 <05/05/2022>	<HU117183 - Se añade TC_TestimonioPiezas a la consulta para el detalle del expediente >
-- Modificación				<Elías González P.>		     <15/02/2023>	<Se actualiza el INNER JOIN Catalogo.Contexto para que se haga contra Expediente.Expediente en lugar de ExpedienteDetalle para que coincida con el código de Expediente>
-- Modificación				<Ricardo Gutiérrez Peña>	 <16/02/2023>   <Se modifica para incluir el código del contexto superior>																
-- Modificación				<Karol Jiménez Sánchez>		 <04/10/2023>   <Se modifica para incluir a la consulta el valor TB_EmbargosFisicos. PBI 347798.>																													  
-- ===========================================================================================================================================================================================================================================
  
CREATE   PROCEDURE [Expediente].[PA_ConsultarExpediente]
	@Numero			CHAR(14),
	@CodContexto    VARCHAR(4)	=	NULL
 AS
 BEGIN
 --VARIABLES
 DECLARE	@L_NumeroExpediente CHAR(14)	=	@Numero,
			@L_CodContexto		VARCHAR(4)	=	@CodContexto
 
--LÓGICA
IF (@L_CodContexto IS NULL)
  BEGIN
	SELECT			K.TC_Descripcion				AS	Descripcion,			
					K.TN_MontoCuantia				AS	MontoCuantia,
					B.TB_DocumentosFisicos			AS  DocumentosFisicos,	
					B.TF_Entrada					AS	FechaEntrada,
					B.TB_Habilitado					AS	Habilitado,	
					K.TB_Confidencial				AS	Confidencial,
					K.TF_Hechos						AS	FechaHechos,
					K.TB_CasoRelevante				AS	CasoRelevante,
					K.CARPETA						AS	CarpetaGestion,
					K.TN_MontoMensual				AS	MontoMensual,
					K.TN_MontoAguinaldo				AS	MontoAguinaldo,
					K.TN_MontoSalarioEscolar		AS	MontoSalarioEscolar,
					K.TN_MontoEmbargo				AS  MontoEmbargo,
					B.TC_TestimonioPiezas			AS	ExpedienteTestimonioPiezas,
					K.TB_EmbargosFisicos			AS	EmbargosFisicos,
					'Split'							AS	Split,					
					K.TC_NumeroExpediente			AS	NumeroExpediente,		
					K.TF_Inicio						AS	FechaInicio,								 
					K.TC_CodContexto				AS	CodigoContexto,			
					D.TC_Descripcion				AS 	ContextoDescrip,
					D.TB_EnvioEscrito_GL_AM			AS	EnvioEscritoContexto,
					D.TB_EnvioDemandaDenuncia_GL_AM AS	EnvioDemandaDenunciaContexto,
					D.TB_ConsultaPublicaCiudadano	AS	ConsultaPublicaCiudadanoContexto,
					D.TB_ConsultaPrivadaCiudadano	AS	ConsultaPrivadaCiudadanoContexto,
					K.TN_CodPrioridad				AS	CodigoPrioridad,				 
					E.TC_Descripcion				AS	PrioridadDescrip,			
					K.TN_CodTipoCuantia				AS	CodigoTipoCuantia,		
					F.TC_Descripcion				AS	TipoCuantiaDescrip,		
					K.TN_CodMoneda					AS	CodigoMoneda,			
					G.TC_Descripcion				AS	MonedaDescrip,				
					K.TN_CodTipoViabilidad			AS	CodigoTipoViabilidad,	
					H.TC_Descripcion				AS  TipoViabilidadDescrip,  
					B.TC_CodContexto	            AS	CodigoContextoDetalle,
					I.TC_Descripcion				AS 	ContextoDetalleDescrip,
					B.TC_CodContextoProcedencia	    AS	CodigoContextoProcedencia,
					CP.TC_Descripcion				AS 	ContextoProcedenciaDescrip,
					CF.TC_CodOficina				As  CodigoOficinaContextoProc,
					OJ.TC_Nombre					As NombreOficinaContextoProc,													   										
					CC.TN_CodCircuito               AS  CodigoCircuito,
                    CC.TC_Descripcion               AS  CircuitoDescrip,
					J.TC_NumeroExpedienteAcumula	AS  ExpedienteAcumula,
					L.TC_CodMateria					AS	CodigoMateria,
					L.TC_Descripcion				AS  MateriaDescripcion,
					M.TN_CodClase					AS	CodigoClase,
					M.TC_Descripcion				AS	DescripcionClase,
					N.TN_CodProceso					AS	CodigoProceso,
					N.TC_Descripcion				AS	DescripcionProceso,
					ISNULL(HFO.TN_CodFase, B.TN_CodFase) AS	CodigoFase,
					ISNULL(HFO.TC_Descripcion,HFL.TC_Descripcion) AS DescripcionFase,
					O.TN_CodGrupoTrabajo			AS	CodigoGrupoTrabajo,
					O.TC_Descripcion				AS	DescripcionGrupoTrabajo,
					P.TN_CodProvincia				AS	CodigoProvincia,
					P.TC_Descripcion				AS	DescripcionProvincia,
					Q.TN_CodCanton					AS	CodigoCanton,
					Q.TC_Descripcion				AS	DescripcionCanton,
					R.TN_CodDistrito				AS	CodigoDistrito,
					R.TC_Descripcion				AS	DescripcionDistrito,
					S.TN_CodBarrio					AS	CodigoBarrio,
					S.TC_Descripcion				AS	DescripcionBarrio,
					K.TC_Señas						AS	Sennas,
					K.TC_DescripcionHechos			AS	DescripcionHechos,
					T.TN_CodDelito					AS	CodigoDelito,
					T.TC_Descripcion				AS	DescripcionDelito,
					CD.TN_CodCategoriaDelito		AS	CodigoCategoriaDelito,
					CD.TC_Descripcion				AS	DescripcionCategoriaDelito,
					HFP.TN_CodEstado					AS	CodigoEstado,
					HFP.TC_Descripcion				AS	DescripcionEstado,
					HFP.TC_Circulante					AS	Circulante,
					V.TC_CodContexto				AS	CodigoContextoCreacion,
					V.TC_Descripcion				AS  DescripcionContextoCreacion,
					W.TC_CodOficina					AS	CodigoOficinaDetalle,
					W.TC_Nombre						AS	DescripcionOficinaDetalle,
					X.TC_CodOficina				    AS  CodigoOficinaContexto,
					X.TC_Nombre						AS  DescripcionOficinaContexto,
					Y.TN_CodTipoOficina				AS	TipoOficina,
					Y.TC_Descripcion				AS	DescripcionTipoOficina,
					Z.TC_CodMateria					AS	CodigoMateria,
					Z.TC_Descripcion				AS	DescripcionMateria,
					MP.TC_CodMateria				AS	CodigoMateriaProcedencia,
					MP.TC_Descripcion				AS	DescripcionMateriaProcedencia,
					HUB.TN_CodUbicacion				AS	CodigoUbicacion,
					HUB.TC_Descripcion				AS	DescripcionUbicacion,
					TAR.TN_CodTarea					AS	CodigoTarea,
					TAR.TC_Descripcion				AS	DescripcionTarea,
					D.TC_CodContextoSuperior        AS  CodigoContextoSuperior															   
	FROM			Expediente.Expediente						AS  K WITH(NOLOCK)
	INNER JOIN		Expediente.ExpedienteDetalle				AS	B WITH(NOLOCK)	
	ON			    K.TC_NumeroExpediente						=	B.TC_NumeroExpediente	
	LEFT JOIN		Historico.ExpedienteAcumulacion				AS  J WITH(NOLOCK)
	ON				J.TC_NumeroExpediente						=   K.TC_NumeroExpediente  
	AND				J.TF_FinAcumulacion							IS NULL		 
	INNER JOIN		Catalogo.Contexto							AS  D WITH(NOLOCK)
	ON				D.TC_CodContexto							=	K.TC_CodContexto
	LEFT OUTER JOIN	Catalogo.Prioridad							AS  E WITH(NOLOCK)
	ON				E.TN_CodPrioridad							=	K.TN_CodPrioridad
	LEFT OUTER JOIN	Catalogo.TipoCuantia						AS  F WITH(NOLOCK)
	ON				F.TN_CodTipoCuantia							=	K.TN_CodTipoCuantia
	LEFT OUTER JOIN	Catalogo.Moneda								AS  G WITH(NOLOCK)
	ON				G.TN_CodMoneda								=	K.TN_CodMoneda
	LEFT OUTER JOIN	Catalogo.TipoViabilidad						AS  H WITH(NOLOCK)
	ON				H.TN_CodTipoViabilidad						=	K.TN_CodTipoViabilidad
	LEFT JOIN		Catalogo.Contexto							AS  I WITH(NOLOCK)
	ON				I.TC_CodContexto							=	B.TC_CodContexto
	LEFT JOIN		Catalogo.Contexto							AS  CP WITH(NOLOCK)
	ON				B.TC_CodContextoProcedencia					=   CP.TC_CodContexto
	LEFT JOIN		Catalogo.Contexto							As  CF With(NoLock)
	On				B.TC_CodContextoProcedencia					=   CF.TC_CodContexto
	LEFT JOIN		Catalogo.Oficina							As  OJ With(NoLock)
	On				CF.TC_CodOficina							=   OJ.TC_CodOficina
	INNER JOIN		Catalogo.Materia							AS  L WITH(NOLOCK)
	ON				L.TC_CodMateria								=   I.TC_CodMateria
	INNER JOIN		Catalogo.Clase								AS	M WITH(NOLOCK)
	ON				M.TN_CodClase								=	B.TN_CodClase
	INNER JOIN		Catalogo.Proceso							AS	N WITH(NOLOCK)
	ON				N.TN_CodProceso								=	B.TN_CodProceso
    OUTER APPLY                                                 (SELECT TOP(1)  HF.TN_CodFase,NN.TC_Descripcion 
	                                                             FROM           Historico.ExpedienteFase HF WITH(NOLOCK) 
	                                                             INNER JOIN		Catalogo.Fase				AS	NN WITH(NOLOCK)
	                                                             ON				NN.TN_CodFase				=	HF.TN_CodFase
	                                                             WHERE          HF.TC_NumeroExpediente      = B.TC_NumeroExpediente AND
						                                                        HF.TC_CodContexto           = B.TC_CodContexto 
                                                                 ORDER BY       HF.TF_Fase DESC) HFO
	OUTER APPLY                                                 (SELECT         HF.TN_CodFase,NN.TC_Descripcion 
	                                                             FROM           Expediente.ExpedienteDetalle HF WITH(NOLOCK) 
	                                                             INNER JOIN		Catalogo.Fase				AS	NN WITH(NOLOCK)
	                                                             ON				NN.TN_CodFase				=	HF.TN_CodFase
																 where          HF.TC_NumeroExpediente      = B.TC_NumeroExpediente 
																 and            HF.TC_CodContexto           = B.TC_CodContexto) HFL
	LEFT JOIN		Catalogo.GrupoTrabajo						AS	O WITH(NOLOCK)
	ON				O.TN_CodGrupoTrabajo						=	B.TN_CodGrupoTrabajo
	LEFT JOIN		Catalogo.Provincia							AS	P WITH(NOLOCK)
	ON				P.TN_CodProvincia							=	K.TN_CodProvincia
	LEFT JOIN		Catalogo.Canton								AS	Q WITH(NOLOCK)
	ON				Q.TN_CodCanton								=	K.TN_CodCanton 
	AND				Q.TN_CodProvincia							=   P.TN_CodProvincia
	LEFT JOIN		Catalogo.Distrito							AS  R WITH(NOLOCK)
	ON				R.TN_CodDistrito							=	K.TN_CodDistrito 
	AND				R.TN_CodCanton								=	Q.TN_CodCanton 
	AND				R.TN_CodProvincia							=   Q.TN_CodProvincia
	LEFT JOIN		Catalogo.Barrio								AS	S WITH(NOLOCK)
	ON				S.TN_CodBarrio								=	K.TN_CodBarrio 
	AND				S.TN_CodCanton								=   R.TN_CodCanton 
	AND				S.TN_CodDistrito							=	R.TN_CodDistrito 
	AND				S.TN_CodProvincia							=	R.TN_CodProvincia
	LEFT JOIN		Catalogo.Delito								AS	T WITH(NOLOCK)
	ON				T.TN_CodDelito								=	K.TN_CodDelito
	LEFT JOIN		Catalogo.CategoriaDelito					AS	CD WITH(NOLOCK)
	ON				CD.TN_CodCategoriaDelito					=	T.TN_CodCategoriaDelito
	INNER JOIN		Catalogo.Contexto							AS	V WITH(NOLOCK)
	ON				V.TC_CodContexto							=	K.TC_CodContextoCreacion
	INNER JOIN		Catalogo.Oficina							AS	W WITH(NOLOCK)
	ON				W.TC_CodOficina								=	I.TC_CodOficina
	INNER JOIN		Catalogo.Oficina							AS  X WITH(NOLOCK)
	ON				X.TC_CodOficina								=   D.TC_CodOficina
	INNER JOIN		Catalogo.TipoOficina						AS	Y WITH(NOLOCK)
	ON				Y.TN_CodTipoOficina							=	X.TN_CodTipoOficina
	LEFT JOIN		Catalogo.Oficina							AS	OP WITH(NOLOCK)
	ON				OP.TC_CodOficina							=	CP.TC_CodOficina
	LEFT JOIN       Catalogo.Circuito							AS  CC WITH(NOLOCK)
	ON              CC.TN_CodCircuito							=   OP.TN_CodCircuito
	INNER JOIN		Catalogo.Materia							AS	Z WITH(NOLOCK)
	ON				Z.TC_CodMateria								=	I.TC_CodMateria
	LEFT JOIN		Catalogo.Materia							AS	MP WITH(NOLOCK)
	ON				MP.TC_CodMateria							=	CP.TC_CodMateria
    OUTER APPLY                                                 (SELECT TOP(1)  HP.TN_CodEstado,NV.TC_Descripcion,NV.TC_Circulante
	                                                             FROM           Historico.ExpedienteMovimientoCirculante HP WITH(NOLOCK) 
	                                                             INNER JOIN		Catalogo.Estado				AS	NV WITH(NOLOCK)
	                                                             ON				NV.TN_CodEstado				=	HP.TN_CodEstado
	                                                             WHERE          HP.TC_NumeroExpediente      = B.TC_NumeroExpediente AND
						                                                        HP.TC_CodContexto           = B.TC_CodContexto 
                                                                 ORDER BY       HP.TF_Fecha DESC) HFP
	OUTER APPLY                                                 (SELECT TOP(1)	UB.TN_CodUbicacion,	UB.TC_Descripcion
																 FROM			Historico.ExpedienteUbicacion  EU WITH (NOLOCK)
																 INNER JOIN		Catalogo.Ubicacion			   UB With(Nolock)
																 ON				UB.TN_CodUbicacion			 = EU.TN_CodUbicacion
																 WHERE	        EU.TC_NumeroExpediente	     = B.TC_NumeroExpediente  AND
																				EU.TC_CodContexto			 = B.TC_CodContexto
																 ORDER BY		EU.TF_FechaUbicacion DESC) HUB
	OUTER APPLY													(SELECT TOP(1)	TA.TN_CodTarea,TA.TC_Descripcion
																 FROM			Expediente.TareaPendiente			TP WITH(NOLOCK)
																 INNER JOIN		Catalogo.Tarea						TA WITH(NOLOCK)
																 ON				TA.TN_CodTarea				 = TP.TN_CodTarea
																 INNER JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH(NOLOCK)
																 ON				TTO.TN_CodTarea				 = TP.TN_CodTarea
																 AND			TTO.TN_CodTipoOficina		 = X.TN_CodTipoOficina
																 AND			TTO.TC_CodMateria			 = I.TC_CodMateria	
																 WHERE			TP.TC_NumeroExpediente		 = B.TC_NumeroExpediente
																 AND			TP.TC_CodContexto			 = B.TC_CodContexto
																 AND			TP.TU_CodLegajo				 IS NULL
																 AND			TP.TC_UsuarioRedFinaliza	 IS NULL
																 AND			TP.TF_Finalizacion			 IS NULL
																 AND			TP.TC_UsuarioRedReasigna	 IS NULL
																 AND			TP.TF_Reasignacion			 IS NULL
    															ORDER BY		TP.TF_Recibido DESC) TAR
	WHERE			K.TC_NumeroExpediente						=	@L_NumeroExpediente
										
END
ELSE
BEGIN
	SELECT			K.TC_Descripcion				AS	Descripcion,			
					K.TN_MontoCuantia				AS	MontoCuantia,
					B.TB_DocumentosFisicos			AS  DocumentosFisicos,	
					B.TF_Entrada					AS	FechaEntrada,
					B.TB_Habilitado					AS	Habilitado,	
					K.TB_Confidencial				AS	Confidencial,
					K.TF_Hechos						AS	FechaHechos,
					K.TB_CasoRelevante				AS	CasoRelevante,
					K.CARPETA						AS	CarpetaGestion,
					K.TN_MontoMensual				AS	MontoMensual,
					K.TN_MontoAguinaldo				AS	MontoAguinaldo,
					K.TN_MontoSalarioEscolar		AS	MontoSalarioEscolar,
					B.TC_TestimonioPiezas			AS	ExpedienteTestimonioPiezas,
					K.TB_EmbargosFisicos			AS	EmbargosFisicos,
					'Split'							AS	Split,					
					K.TC_NumeroExpediente			AS	NumeroExpediente,		
					K.TF_Inicio						AS	FechaInicio,								 
					K.TC_CodContexto				AS	CodigoContexto,			
					D.TC_Descripcion				AS 	ContextoDescrip,
					D.TB_EnvioEscrito_GL_AM			AS	EnvioEscritoContexto,
					D.TB_EnvioDemandaDenuncia_GL_AM	AS	EnvioDemandaDenunciaContexto,
					D.TB_ConsultaPublicaCiudadano	AS	ConsultaPublicaCiudadanoContexto,
					D.TB_ConsultaPrivadaCiudadano	AS	ConsultaPrivadaCiudadanoContexto,
					K.TN_CodPrioridad				AS	CodigoPrioridad,				 
					E.TC_Descripcion				AS	PrioridadDescrip,			
					K.TN_CodTipoCuantia				AS	CodigoTipoCuantia,		
					F.TC_Descripcion				AS	TipoCuantiaDescrip,		
					K.TN_CodMoneda					AS	CodigoMoneda,			
					G.TC_Descripcion				AS	MonedaDescrip,				
					K.TN_CodTipoViabilidad			AS	CodigoTipoViabilidad,	
					H.TC_Descripcion				AS  TipoViabilidadDescrip,  
					B.TC_CodContexto		        AS	CodigoContextoDetalle,
					I.TC_Descripcion				AS 	ContextoDetalleDescrip,
					B.TC_CodContextoProcedencia	    AS	CodigoContextoProcedencia,
					CP.TC_Descripcion				AS 	ContextoProcedenciaDescrip,
					CF.TC_CodOficina				As  CodigoOficinaContextoProc,
					OJ.TC_Nombre					 As NombreOficinaContextoProc,
					CC.TN_CodCircuito               AS  CodigoCircuito,
                    CC.TC_Descripcion               AS  CircuitoDescrip,
					J.TC_NumeroExpedienteAcumula	AS  ExpedienteAcumula,
					L.TC_CodMateria					AS	CodigoMateria,
					L.TC_Descripcion				AS  MateriaDescripcion,
					M.TN_CodClase					AS	CodigoClase,
					M.TC_Descripcion				AS	DescripcionClase,
					N.TN_CodProceso					AS	CodigoProceso,
					N.TC_Descripcion				AS	DescripcionProceso,
					ISNULL(HFO.TN_CodFase, B.TN_CodFase) AS	CodigoFase,
					ISNULL(HFO.TC_Descripcion,HFL.TC_Descripcion) AS DescripcionFase,
					O.TN_CodGrupoTrabajo			AS	CodigoGrupoTrabajo,
					O.TC_Descripcion				AS	DescripcionGrupoTrabajo,
					P.TN_CodProvincia				AS	CodigoProvincia,
					P.TC_Descripcion				AS	DescripcionProvincia,
					Q.TN_CodCanton					AS	CodigoCanton,
					Q.TC_Descripcion				AS	DescripcionCanton,
					R.TN_CodDistrito				AS	CodigoDistrito,
					R.TC_Descripcion				AS	DescripcionDistrito,
					S.TN_CodBarrio					AS	CodigoBarrio,
					S.TC_Descripcion				AS	DescripcionBarrio,
					K.TC_Señas						AS	Sennas,
					K.TC_DescripcionHechos			AS	DescripcionHechos,
					T.TN_CodDelito					AS	CodigoDelito,
					T.TC_Descripcion				AS	DescripcionDelito,
					CD.TN_CodCategoriaDelito		AS	CodigoCategoriaDelito,
					CD.TC_Descripcion				AS	DescripcionCategoriaDelito,
					HFP.TN_CodEstado					AS	CodigoEstado,
					HFP.TC_Descripcion				AS	DescripcionEstado,
					HFP.TC_Circulante					AS  Circulante,
					V.TC_CodContexto				AS	CodigoContextoCreacion,
					V.TC_Descripcion				AS  DescripcionContextoCreacion,
					W.TC_CodOficina					AS	CodigoOficinaDetalle,
					W.TC_Nombre						AS	DescripcionOficinaDetalle,
					X.TC_CodOficina				    AS  CodigoOficinaContexto,
					X.TC_Nombre						AS  DescripcionOficinaContexto,
					Y.TN_CodTipoOficina				AS	TipoOficina,
					Y.TC_Descripcion				AS	DescripcionTipoOficina,
					Z.TC_CodMateria					AS	CodigoMateria,
					Z.TC_Descripcion				AS	DescripcionMateria,
					MP.TC_CodMateria				AS	CodigoMateriaProcedencia,
					MP.TC_Descripcion				AS	DescripcionMateriaProcedencia,
					HUB.TN_CodUbicacion				AS	CodigoUbicacion,
					HUB.TC_Descripcion				AS	DescripcionUbicacion,
					TAR.TN_CodTarea					AS	CodigoTarea,
					TAR.TC_Descripcion				AS	DescripcionTarea,
					D.TC_CodContextoSuperior        AS  CodigoContextoSuperior																				
	FROM			Expediente.Expediente						AS  K WITH(NOLOCK)
	INNER JOIN		Expediente.ExpedienteDetalle				AS	B WITH(NOLOCK)	
	ON			    K.TC_NumeroExpediente						=	B.TC_NumeroExpediente	
	LEFT JOIN		Historico.ExpedienteAcumulacion				AS  J WITH(NOLOCK)
	ON				J.TC_NumeroExpediente						=  K.TC_NumeroExpediente  
	AND				J.TF_FinAcumulacion							IS NULL	
	INNER JOIN		Catalogo.Contexto							AS  D WITH(NOLOCK)
	ON				D.TC_CodContexto							=	K.TC_CodContexto
	LEFT OUTER JOIN	Catalogo.Prioridad							AS  E WITH(NOLOCK)
	ON				E.TN_CodPrioridad							=	K.TN_CodPrioridad
	LEFT OUTER JOIN	Catalogo.TipoCuantia						AS  F WITH(NOLOCK)
	ON				F.TN_CodTipoCuantia							=	K.TN_CodTipoCuantia
	LEFT OUTER JOIN	Catalogo.Moneda								AS  G WITH(NOLOCK)
	ON				G.TN_CodMoneda								=	K.TN_CodMoneda
	LEFT OUTER JOIN	Catalogo.TipoViabilidad						AS  H WITH(NOLOCK)
	ON				H.TN_CodTipoViabilidad						=	K.TN_CodTipoViabilidad
	LEFT JOIN		Catalogo.Contexto							AS  I WITH(NOLOCK)
	ON				I.TC_CodContexto							=	B.TC_CodContexto
	LEFT JOIN		Catalogo.Contexto							AS  CP WITH(NOLOCK)
	ON				B.TC_CodContextoProcedencia					=   CP.TC_CodContexto
	LEFT JOIN		Catalogo.Contexto							As  CF With(NoLock)
	On				B.TC_CodContextoProcedencia					=   CF.TC_CodContexto
	LEFT JOIN		Catalogo.Oficina							As  OJ With(NoLock)
	On				CF.TC_CodOficina							=   OJ.TC_CodOficina
	INNER JOIN		Catalogo.Materia							AS  L WITH(NOLOCK)
	ON				L.TC_CodMateria								=   I.TC_CodMateria
	INNER JOIN		Catalogo.Clase								AS	M WITH(NOLOCK)
	ON				M.TN_CodClase								=	B.TN_CodClase
	INNER JOIN		Catalogo.Proceso							AS	N WITH(NOLOCK)
	ON				N.TN_CodProceso								=	B.TN_CodProceso
    OUTER APPLY                                                 (SELECT TOP(1)  HF.TN_CodFase,NN.TC_Descripcion 
	                                                             FROM           Historico.ExpedienteFase HF WITH(NOLOCK) 
	                                                             INNER JOIN		Catalogo.Fase				AS	NN WITH(NOLOCK)
	                                                             ON				NN.TN_CodFase				=	HF.TN_CodFase
	                                                             WHERE          HF.TC_NumeroExpediente      = B.TC_NumeroExpediente AND
						                                                        HF.TC_CodContexto           = B.TC_CodContexto 
                                                                 ORDER BY       HF.TF_Fase DESC) HFO
	OUTER APPLY                                                 (SELECT         HF.TN_CodFase,NN.TC_Descripcion 
	                                                             FROM           Expediente.ExpedienteDetalle HF WITH(NOLOCK) 
	                                                             INNER JOIN		Catalogo.Fase				AS	NN WITH(NOLOCK)
	                                                             ON				NN.TN_CodFase				=	HF.TN_CodFase
																 where          HF.TC_NumeroExpediente      = B.TC_NumeroExpediente 
																 and            HF.TC_CodContexto           = B.TC_CodContexto) HFL
	LEFT JOIN		Catalogo.GrupoTrabajo						AS	O WITH(NOLOCK)
	ON				O.TN_CodGrupoTrabajo						=	B.TN_CodGrupoTrabajo
	LEFT JOIN		Catalogo.Provincia							AS	P WITH(NOLOCK)
	ON				P.TN_CodProvincia							=	K.TN_CodProvincia
	LEFT JOIN		Catalogo.Canton								AS	Q WITH(NOLOCK)
	ON				Q.TN_CodCanton								=	K.TN_CodCanton 
	AND				Q.TN_CodProvincia							=	P.TN_CodProvincia
	LEFT JOIN		Catalogo.Distrito							AS  R WITH(NOLOCK)
	ON				R.TN_CodDistrito							=	K.TN_CodDistrito 
	AND				R.TN_CodCanton								=	Q.TN_CodCanton 
	AND				R.TN_CodProvincia							=	Q.TN_CodProvincia
	LEFT JOIN		Catalogo.Barrio								AS	S WITH(NOLOCK)
	ON				S.TN_CodBarrio								=	K.TN_CodBarrio 
	AND				S.TN_CodCanton								=	R.TN_CodCanton 
	AND				S.TN_CodDistrito							=	R.TN_CodDistrito 
	AND				S.TN_CodProvincia							=	R.TN_CodProvincia
	LEFT JOIN		Catalogo.Delito								AS	T WITH(NOLOCK)
	ON				T.TN_CodDelito								=	K.TN_CodDelito
	LEFT JOIN		Catalogo.CategoriaDelito					AS	CD WITH(NOLOCK)
	ON				CD.TN_CodCategoriaDelito					=	T.TN_CodCategoriaDelito
	INNER JOIN		Catalogo.Contexto							AS	V WITH(NOLOCK)
	ON				V.TC_CodContexto							=	K.TC_CodContextoCreacion
	INNER JOIN		Catalogo.Oficina							AS	W WITH(NOLOCK)
	ON				W.TC_CodOficina								=	I.TC_CodOficina
	INNER JOIN		Catalogo.Oficina							AS  X WITH(NOLOCK)
	ON				X.TC_CodOficina								=   D.TC_CodOficina
	INNER JOIN		Catalogo.TipoOficina						AS	Y WITH(NOLOCK)
	ON				Y.TN_CodTipoOficina							=	X.TN_CodTipoOficina
	LEFT JOIN		Catalogo.Oficina							AS	OP WITH(NOLOCK)
	ON				OP.TC_CodOficina							=	CP.TC_CodOficina
	LEFT JOIN      Catalogo.Circuito							AS  CC WITH(NOLOCK)
	ON              CC.TN_CodCircuito							=   OP.TN_CodCircuito
	INNER JOIN		Catalogo.Materia							AS	Z WITH(NOLOCK)
	ON				Z.TC_CodMateria								=	I.TC_CodMateria
	LEFT JOIN		Catalogo.Materia							AS	MP WITH(NOLOCK)
	ON				MP.TC_CodMateria							=	CP.TC_CodMateria
    OUTER APPLY                                                 (SELECT TOP(1)  HP.TN_CodEstado,NV.TC_Descripcion,NV.TC_Circulante
	                                                             FROM           Historico.ExpedienteMovimientoCirculante HP WITH(NOLOCK) 
	                                                             INNER JOIN		Catalogo.Estado				AS	NV WITH(NOLOCK)
	                                                             ON				NV.TN_CodEstado				=	HP.TN_CodEstado
	                                                             WHERE          HP.TC_NumeroExpediente      = B.TC_NumeroExpediente AND
						                                                        HP.TC_CodContexto           = B.TC_CodContexto 
                                                                 ORDER BY       HP.TF_Fecha DESC) HFP
	OUTER APPLY                                                 (SELECT TOP(1)	UB.TN_CodUbicacion,	UB.TC_Descripcion
																 FROM			Historico.ExpedienteUbicacion  EU WITH (NOLOCK)
																 INNER JOIN		Catalogo.Ubicacion			   UB With(Nolock)
																 ON				UB.TN_CodUbicacion			 = EU.TN_CodUbicacion
																 WHERE	        EU.TC_NumeroExpediente	     = B.TC_NumeroExpediente  AND
																				EU.TC_CodContexto			 = B.TC_CodContexto
																 ORDER BY		EU.TF_FechaUbicacion DESC) HUB
	OUTER APPLY													(SELECT TOP(1)	TA.TN_CodTarea,TA.TC_Descripcion
																 FROM			Expediente.TareaPendiente			TP WITH(NOLOCK)
																 INNER JOIN		Catalogo.Tarea						TA WITH(NOLOCK)
																 ON				TA.TN_CodTarea				 = TP.TN_CodTarea
																 INNER JOIN		Catalogo.TareaTipoOficinaMateria	TTO	WITH(NOLOCK)
																 ON				TTO.TN_CodTarea				 = TP.TN_CodTarea
																 AND			TTO.TN_CodTipoOficina		 = X.TN_CodTipoOficina
																 AND			TTO.TC_CodMateria			 = I.TC_CodMateria	
																 WHERE			TP.TC_NumeroExpediente		 = @L_NumeroExpediente
																 AND			TP.TU_CodLegajo				 IS NULL
																 AND			TP.TC_UsuarioRedFinaliza	 IS NULL
																 AND			TP.TF_Finalizacion			 IS NULL
																 AND			TP.TC_UsuarioRedReasigna	 IS NULL
																 AND			TP.TF_Reasignacion			 IS NULL
    															ORDER BY		TP.TF_Recibido DESC) TAR
	WHERE			K.TC_NumeroExpediente						=	@L_NumeroExpediente
	AND				B.TC_CodContexto							=   @L_CodContexto
										

	END
END

GO
