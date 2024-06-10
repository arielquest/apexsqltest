SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Esteban Jim‚nez Alvarado>  
-- Fecha de creación:  <14/03/2017>  
-- Descripción:    <Obtiene una £nica comunicación seg£n su código.>   
-- =================================================================================================================================================  
-- Modificado:       <Stefany Quesada Cascante>  
-- Fecha Modifica:          <14/03/2017>  
-- Descripción:             <Se elimina join con TipoComunicacionJudicial y el valor se retorna en el Split de SplitEnumerados.>   
-- Modificado:       <Diego GB>  
-- Fecha Modifica:          <14/03/2017>  
-- Descripción:             <Se agrengan Join para la entidad de Registrado>   
-- Modificado:       <Diego GB>  
-- Fecha Modifica:          <21/08/2017>  
-- Descripción:             <Se el obejto tipo Intervecnion>   
-- Modificado:       <Tatiana Flores>  
-- Fecha Modifica:          <27/10/2017>  
-- Descripción:             <Se agrega el Nombre comercial para la persona jur¡dica>   
-- Modificación    <Jonathan Aguilar Navarro> <28/05/2018> <Se cambia el inner join de Oficina por Contexto, ademas cambiar OficinOCJ por ContextoOCJ   
--       Adem s se agrega la OficinaComunicacion y el tipo de Oficina Comunicacion    
-- Modificación    <Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>  
-- Modificación:   <29/10/2018> <Juan Ram¡rez> <Se modifica la consulta y se ajusta al módulo de intervenciones>  
-- Modificación:   <06/11/2018> <Andr‚s D¡az> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia' y 'TF_FinalizaVigencia' a 'TF_Fin_Vigencia'.>  
-- Modificación:            <21/04/2020> <Cristian Cerdas> <Se elimina la columna TU_CodLegajo y se cambia por TC_NumeroExpediente, se elimina la columna L.TC_NumeroExpediente  
--                           Se elimina el inner join que hace referencia a la tabla Expediente.Legajo>  
-- Modificación:   <25/09/2020> <Xinia Soto> <Se retorna s¡ el tipo de identificación.>  
-- Modificación:   <26/03/2021> <Aida Elena Siles R> <Se agrega el tipo de participación a la consulta>  
-- Modificación:   <18/05/2021> <Karol Jim‚nez S nchez> <Se agrega la Oficina OCJ a la consulta> 
-- Modificación:   <07/06/2021> <Roger Lara> <Se cambia join por left para que devuelva dato en caso que no exista intervencion asociado a la comunicacion> 
-- Modificación:   <02/06/2021> <Ronny Ram¡rez R.> <Se agrega el usuario del puesto de trabajo del funcionario que env¡a a la consulta>  
-- Modificación:   <20/07/2021> <Isaac Dobles Mata.> <Se consulta si el sector elegido para la comunicación es utilizado o no para notificar por la app Movil> 
-- Modificación:   <03/09/2021> <Isaac Dobles Mata.> <Se agrega consulta de campo si el interviniente notificado es o no el principal> 
-- Modificación:   <15/09/2021> <Aida Elena Siles R> <Se agrega a la consulta el campo CodLegajo> 
-- Modificación:   <07/10/2021> <Isaac Santiago M‚ndez Castillo> <Se agregan condiciones en el JOIN del distrito para evitar que se provoque un producto carteciano. 
--																	Incidente: 217185>  
-- Modificación:   <29/10/2021> <Isaac Dobles Mata.> <Se agrega consulta AppMovil y ExcluidaAppMovil> 																									   
-- Modificación:   <28/01/2022> <Isaac Dobles Mata.> <Se agrega consulta IdNotiEntidadJuridica y IdActaEntidadJuridica> 
-- Modificación:   <19/01/2023> <Luis Alonso Leiva Tames> <Se modifica las consultas en Provincia, Canton, Distrito, Barrio para eviatar duplicados> 
-- Modificación:   <20/06/2023> <Elias Gonzalez Porras> <Se elimina del LEFT JOIN [Catalogo].[Distrito] el campo de CN.TN_CodCanton = D.TN_CodDistrito y se agrean en barrio 
--                               las consultas de provincia y canton para completar la relación en casacada> 
-- =================================================================================================================================================  
CREATE PROCEDURE [Comunicacion].[PA_ConsultarComunicacion]  
(  
 @CodigoComunicacion UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
--Variables
DECLARE	@L_CodigoComunicacion UNIQUEIDENTIFIER  =	@CodigoComunicacion

  SELECT	C.TU_CodComunicacion			AS CodigoComunicacion,  			C.TC_ConsecutivoComunicacion	AS ConsecutivoComunicacion,  
			C.TC_NumeroExpediente			AS NumeroExpediente,    			C.TC_Valor						AS Valor,       
			C.TC_Rotulado					AS Rotulado,						C.TB_TienePrioridad				AS TienePrioridad,     
			C.TN_PrioridadMedio				AS PrioridadMedio,					C.TF_FechaRegistro				AS FechaRegistro,     
			C.TF_FechaResolucion			AS FechaResolucion,					C.TF_FechaEnvio					AS FechaEnvio,      
			C.TB_Cancelar                   AS Cancelar,						C.TB_RequiereCopias				AS RequiereCopias,   
			C.TC_Observaciones				AS Observaciones,					C.TF_FechaResultado				AS FechaResultado,
			C.TF_Actualizacion				AS FechaActualizacion,  			C.TF_FechaDevolucion			AS FechaDevolucion,   
			C.TB_Revisado					AS Revisado,						C.TF_FechaCancelar				AS FechaCancelar,             
			C.TB_ComunicacionAppMovil		AS AppMovil,						C.TB_ExcluidaAppMovil			AS ExcluidaAppMovil,
			C.TU_CodLegajo					AS CodLegajo,						C.TN_IdNotiEntidadJuridica		AS IdNotiEntidadJuridica,
			C.TN_IdActaEntidadJuridica		AS IdActaEntidadJuridica,
			'SplitPuestoTrabajo'			AS SplitPuestoTrabajo,  			
			PT.TC_CodPuestoTrabajo			AS Codigo,							PT.TC_Descripcion				AS Descripcion,      
			'SplitPuestoFuncionario'		AS SplitPuestoFuncionario,  
			FP.UsuarioRed					AS UsuarioRed,						FP.Nombre						AS Nombre,  
			FP.PrimerApellido				AS PrimerApellido,					FP.SegundoApellido				AS SegundoApellido,  
			FP.CodigoPlaza					AS CodigoPlaza,						FP.FechaActivacion				AS FechaActivacion,  
			FP.FechaDesactivacion			AS FechaDesactivacion,    
			'SplitContextoEmisor'			AS SplitContextoEmisor,  
			CE.TC_CodContexto				AS Codigo,							CE.TC_Descripcion				AS Descripcion,  
			CE.TC_Descripcion				AS DescripcionAbreviada,			CE.TC_Telefono					AS Telefono,  
			CE.TC_Fax						AS Fax,								CE.TC_Email					    AS Email,  
			'SplitContextoComunicacion'		AS SplitContextoComunicacion,  
			CC.TC_CodContexto				AS Codigo,							CC.TC_Descripcion				AS Descripcion,  
			CC.TC_Descripcion				AS Descripcion,						CC.TC_Telefono					AS Telefono,  
			CC.TC_Fax						AS Fax,								CC.TC_Email						AS Email,     
			'SplitInterviniente'			AS SplitInterviniente,  
			IT.TC_Alias						AS Alias,							IT.TC_Caracteristicas			AS Caracteristicas,  
			I.TU_CodInterviniente			AS CodigoInterviniente,				IT.TF_ComisionDelito			AS FechaComisionDelito,  
			'SplitTipoIntervencion'			AS SplitTipoIntervencion, 
			TI.TN_CodTipoIntervencion       AS Codigo,							TI.TC_Descripcion				AS Descripcion,              
			TI.TF_Inicio_Vigencia			AS FechaActivacion,					TI.TF_Fin_Vigencia				AS FechaDesactivacion,  
			'SplitRepresentante'			AS SplitRepresentante,    
			IT.TU_CodInterviniente			AS CodigoRepresentante,    
			'SplitMedioComunicacion'		AS SplitMedioComunicacion, 
			MC.TN_CodMedio					AS Codigo,							MC.TC_Descripcion				AS Descripcion,
			MC.TB_TieneHorarioEspecial		AS TieneHorarioEspecial,			MC.TB_PermiteCopias				AS PermiteCopias,   
			MC.TF_Inicio_Vigencia			AS FechaActivacion,  				MC.TF_Fin_Vigencia				AS FechaDesactivacion,
			'SplitProvincia'				AS SplitProvincia,  
			P.TN_CodProvincia				AS Codigo,							P.TC_Descripcion				AS Descripcion,  
			P.TF_Inicio_Vigencia			AS FechaActivacion,					P.TF_Fin_Vigencia				AS FechaDesactivacion,  
			'SplitCanton'					AS SplitCanton,
			CN.TN_CodCanton					AS Codigo,							CN.TC_Descripcion				AS Descripcion,
			CN.TF_Inicio_Vigencia			AS FechaActivacion,					CN.TF_Fin_Vigencia				AS FechaDesactivacion,
			'SplitDistrito'					AS SplitDistrito,  
			D.TN_CodDistrito				AS Codigo,							D.TC_Descripcion				AS Descripcion,  
			D.TF_Inicio_Vigencia			AS FechaActivacion,					D.TF_Fin_Vigencia				AS FechaDesactivacion,  
			'SplitBarrio'					AS SplitBarrio,
			B.TN_CodBarrio					AS Codigo,							B.TC_Descripcion				AS Descripcion,
			B.TF_Inicio_Vigencia			AS FechaActivacion,					B.TF_Fin_Vigencia				AS FechaDesactivacion,
			'SplitSector'					AS SplitSector,  
			S.TN_CodSector					AS Codigo,							S.TC_Descripcion				AS Descripcion,  
			S.TF_Inicio_Vigencia			AS FechaActivacion,					S.TF_Fin_Vigencia				AS FechaDesactivacion,  
			S.TB_UtilizaAppMovil			AS UtilizaAppMovil,								 
			'SplitGeografia'				AS SplitGeografia,
			C.TG_UbicacionPunto.Lat			AS Latitud,							C.TG_UbicacionPunto.Long		AS Longitud,
			'SplitUsuarioRed'				AS SplitUsuarioRed,  
			F.TC_UsuarioRed					AS UsuarioRed,						F.TC_Nombre						AS Nombre,  
			F.TC_PrimerApellido				AS PrimerApellido,					F.TC_SegundoApellido			AS SegundoApellido,  
			F.TC_CodPlaza					AS CodigoPlaza,						F.TF_Inicio_Vigencia			AS FechaActivacion,  
			F.TF_Fin_Vigencia				AS FechaDesactivacion,    
			'SplitHorarioMedio'				AS SplitHorarioMedio,  
			HM.TN_CodHorario				AS Codigo,							HM.TC_Descripcion				AS Descripcion,  
			HM.TF_HoraInicio				AS HoraInicio,						HM.TF_HoraFin					AS HoraFin,  
			HM.TF_Inicio_Vigencia			AS FechaActivacion,					HM.TF_Fin_Vigencia				AS FechaDesactivacion,  
			'SplitMotivoResultado'			AS SplitMotivoResultado,
			MR.TN_CodMotivoResultado		AS Codigo,							MR.TC_Descripcion				AS Descripcion,
			MR.TF_Inicio_Vigencia			AS FechaActivacion,					MR.TF_Fin_Vigencia				AS FechaDesactivacion,    
			'SplitFuncionarioRegistro'      AS SplitFuncionarioRegistro,
			C.TU_CodPuestoFuncionarioRegistro AS Codigo,      
			'SplitPuestoTrabajoRegistro'	AS SplitPuestoTrabajoRegistro,   
			PTFR.TC_CodPuestoTrabajo		AS Codigo,							PTR.TC_Descripcion				AS Descripcion,
			'SplitPuestoFuncionarioRegistro' AS SplitPuestoFuncionarioRegistro, 
			FPR.UsuarioRed					AS UsuarioRed,						FPR.Nombre						AS Nombre,  
			FPR.PrimerApellido				AS PrimerApellido,					FPR.SegundoApellido				AS SegundoApellido,  
			FPR.CodigoPlaza					AS CodigoPlaza,						FPR.FechaActivacion				AS FechaActivacion,  
			'SplitFuncionarioEnvio'         AS SplitFuncionarioEnvio,  
			C.[TU_CodPuestoFuncionarioEnvio] AS Codigo,     
			'SplitFuncionarioResultado'     AS SplitFuncionarioResultado,  
			C.[TU_CodPuestoFuncionarioResultado] AS Codigo,    
			'SplitFuncionarioCancelar'		AS SplitFuncionarioCancelar,  
			C.[TU_CodPuestoFuncionarioCancelar] AS Codigo,    
			'SplitPuestoTrabajoCancelar'	AS SplitPuestoTrabajoCancelar,   
			PTFC.TC_CodPuestoTrabajo		AS Codigo,							PTC.TC_Descripcion				AS Descripcion,               
			'SplitPuestoFuncionarioCancelar' AS SplitPuestoFuncionarioCancelar, 
			FPC.UsuarioRed					AS UsuarioRed,						FPC.Nombre						AS Nombre,  
			FPC.PrimerApellido				AS PrimerApellido,					FPC.SegundoApellido				AS SegundoApellido,  
			FPC.CodigoPlaza					AS CodigoPlaza,						FPC.FechaActivacion				AS FechaActivacion,  
			'SplitPF'						AS SplitPF,
			PF.TU_CodPersona				AS CodigoPersona,  					PF.TC_Nombre					AS Nombre,
			PF.TC_PrimerApellido			AS PrimerApellido,  				PF.TC_SegundoApellido			AS SegundoApellido,
			Persona.TC_Identificacion		AS Identificacion,					PF.TF_FechaNacimiento AS FechaNacimiento,
			'SplitPJ'						AS SplitPJ,     
			PJ.TU_CodPersona				AS CodigoPersona,  					PJ.TC_Nombre					AS Nombre,
			Persona.TC_Identificacion		AS Identificacion,  				PJ.TC_NombreComercial           AS NombreComercial,
			'SplitIdent'					AS SplitIdent,      
			T.TN_CodTipoIdentificacion		AS Codigo,							T.TC_Descripcion				AS Descripcion,
			T.TB_Nacional					AS Nacional, 
			'SplitEnumerados'				AS SplitEnumerados,
			TI.TC_Intervencion				AS Intervencion,  					C.TC_Estado						AS Estado,
			C.TC_Resultado					AS Resultado,  						MC.TC_TipoMedio					AS TipoMedio,
			C.TC_TipoComunicacion			AS TipoComunicacion,				I.TC_TipoParticipacion			AS TipoParticipacion,
			'SplitOficinaOCJ'				AS SplitOficinaOCJ,
			CC.TC_CodOficina				AS Codigo,
			OCJ.TC_Nombre					AS Descripcion,
			'SplitOtros'					As SplitOtros,
			EC.TN_CodEstadoCivil			As CodigoEstadoCivil,
			EC.TC_Descripcion				AS DescripcionEstadoCivil,
			CI.TB_Principal					AS EsPrincipal,						  
			'SplitPuestoFuncionarioEnvia'	AS SplitPuestoFuncionarioEnvia, 
			PTFEnvia.TC_UsuarioRed			AS UsuarioRed
 FROM		[Comunicacion].[Comunicacion]						C WITH(NOLOCK)  
 JOIN       [Catalogo].[PuestoTrabajoFuncionario]				PTFRegistra WITH(NOLOCK)   
 ON         C.TU_CodPuestoFuncionarioRegistro					= PTFRegistra.[TU_CodPuestoFuncionario]   
 JOIN		[Catalogo].[Contexto]								CE WITH(NOLOCK)  
 ON			CE.TC_CodContexto									= C.TC_CodContexto  
 JOIN		[Catalogo].[Contexto]								CC WITH(NOLOCK)   
 ON			CC.TC_CodContexto									= C.TC_CodContextoOCJ  
 LEFT JOIN	[Catalogo].[Oficina]								OCJ WITH(NOLOCK)   
 ON			OCJ.TC_CodOficina									= CC.TC_CodOficina 
 JOIN		[Catalogo].[TipoMedioComunicacion]					MC WITH(NOLOCK)  
 ON			MC.TN_CodMedio										= C.TC_CodMedio  
 JOIN		[Catalogo].[Funcionario]							F WITH(NOLOCK)   
 ON			F.TC_UsuarioRed										= PTFRegistra.TC_UsuarioRed  
 LEFT JOIN Comunicacion.ComunicacionIntervencion				CI WITH(NOLOCK)  
 ON         CI.TU_CodComunicacion								= C.TU_CodComunicacion AND CI.TB_Principal=1  
 LEFT JOIN [Expediente].Intervencion							I WITH(NOLOCK)  
 ON         I.TU_CodInterviniente								= CI.TU_CodInterviniente  
 LEFT JOIN  [Catalogo].[Provincia]								P WITH(NOLOCK)   
 ON         P.TN_CodProvincia									= C.TN_CodProvincia  
 LEFT JOIN  [Catalogo].[Canton]									CN WITH(NOLOCK)  
 ON         CN.TN_CodCanton										= C.TN_CodCanton  
 AND		CN.TN_CodProvincia									= C.TN_CodProvincia
 LEFT JOIN  [Catalogo].[Distrito]								D WITH(NOLOCK)   
 ON         D.TN_CodDistrito									= C.TN_CodDistrito
 AND		D.TN_CodProvincia									= C.TN_CodProvincia
 AND		D.TN_CodCanton										= C.TN_CodCanton
 LEFT JOIN  [Catalogo].[Barrio]									B WITH(NOLOCK)   
 ON			B.TN_CodBarrio										= C.TN_CodBarrio  
 AND		B.TN_CodDistrito									= C.TN_CodDistrito
 AND		B.TN_CodProvincia									= C.TN_CodProvincia
 AND		B.TN_CodCanton										= C.TN_CodCanton
 LEFT JOIN  [Comunicacion].[Sector]								S WITH(NOLOCK)  
 ON         S.TN_CodSector										= C.TN_CodSector  
 LEFT JOIN  [Catalogo].[HorarioMedioComunicacion]				HM WITH(NOLOCK)   
 ON         HM.TN_CodHorario									= C.TN_CodHorarioMedio  
 LEFT JOIN  [Catalogo].[MotivoResultadoComunicacionJudicial]	MR WITH(NOLOCK)   
 ON         MR.TN_CodMotivoResultado							= C.TN_CodMotivoResultado  
 LEFT JOIN  [Expediente].Interviniente							IT WITH(NOLOCK)  
 ON         IT.TU_CodInterviniente								= I.TU_CodInterviniente  
 LEFT JOIN  Catalogo.TipoIntervencion							TI WITH(NOLOCK)  
 ON         TI.TN_CodTipoIntervencion							= IT.TN_CodTipoIntervencion  
 LEFT JOIN  [Catalogo].PuestoTrabajo							PT WITH(NOLOCK)   
 ON         PT.[TC_CodPuestoTrabajo]							= C.TC_CodPuestoTrabajo  
 LEFT JOIN  [Catalogo].[PuestoTrabajoFuncionario]				PTF WITH(NOLOCK)   
 ON         C.TC_CodPuestoTrabajo								= PTF.[TU_CodPuestoFuncionario]  
 LEFT JOIN  [Catalogo].[PuestoTrabajoFuncionario]				PTFC WITH(NOLOCK)   
 On			C.[TU_CodPuestoFuncionarioCancelar]					= PTFC.TU_CodPuestoFuncionario   
 LEFT JOIN  Persona.Persona										AS Persona WITH (Nolock)   
 On			I.TU_CodPersona										= Persona.TU_CodPersona  
 LEFT JOIN  Persona.PersonaFisica								AS PF WITH (Nolock)   
 On			PF.TU_CodPersona									= Persona.TU_CodPersona  
 LEFT JOIN  Persona.PersonaJuridica								AS PJ WITH (Nolock)   
 On			PJ.TU_CodPersona									= Persona.TU_CodPersona  
 LEFT JOIN  Catalogo.TipoIdentificacion							AS T WITH (Nolock)   
 On			Persona.TN_CodTipoIdentificacion					= T.TN_CodTipoIdentificacion  
 LEFT JOIN  [Catalogo].[PuestoTrabajoFuncionario]				AS PTFR WITH (Nolock)   
 On		    PTFR.[TU_CodPuestoFuncionario]						=  C.TU_CodPuestoFuncionarioRegistro  
 LEFT JOIN  [Catalogo].PuestoTrabajo							PTR WITH(NOLOCK)   
 ON         PTFC.[TC_CodPuestoTrabajo]							= PTR.TC_CodPuestoTrabajo  
 LEFT JOIN  [Catalogo].PuestoTrabajo							PTC WITH(NOLOCK)   
 ON         PTFC.[TC_CodPuestoTrabajo]							= PTC.TC_CodPuestoTrabajo  
 LEFT JOIN Catalogo.EstadoCivil									EC WITH(NOLOCK)
 ON			PF.TN_CodEstadoCivil								=EC.TN_CodEstadoCivil
 LEFT JOIN  [Catalogo].[PuestoTrabajoFuncionario]				PTFEnvia WITH(NOLOCK)   
 ON         PTFEnvia.TU_CodPuestoFuncionario					= C.TU_CodPuestoFuncionarioEnvio     
 OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(C.TC_CodPuestoTrabajo) FP   
 OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(PTFR.TC_CodPuestoTrabajo) FPR   
 OUTER APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(PTFC.TC_CodPuestoTrabajo) FPC  
  
 WHERE		C.TU_CodComunicacion								= @L_CodigoComunicacion  
END  
GO
