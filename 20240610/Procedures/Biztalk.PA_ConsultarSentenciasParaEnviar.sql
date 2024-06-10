SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<12/09/2018>
-- Descripción :			<Permite Consultar las sentencias asignadas para enviar  a jurisprudencia>  
-- =================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <07/01/2019> <Se modificar sp para agregar a la consulta los expedientes acumulados como string
--							Ademas se actualizan nombre de esquemas de AsignacionFirmado, AsignacionFirmante>
-- Modificación				<Isaac Dobles Mata> <26/08/2019> <Se modifica SP para eliminar Materia y TipoAsunto>
-- Modificación				<Isaac Dobles Mata> <14/05/2021> <Modificado debido a que con estructura actual de expedientes y legajos no traia registros>
-- =================================================================================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarSentenciasParaEnviar]   

AS
BEGIN
  
  --//Como maximo se consultan mil registros

	SELECT  TOP 1000
	    AE.TU_CodArchivo					as CodigoArchivo,
	    AE.TU_CodArchivo					as CodigoDocumento, -- Este es el identificado en base datos SqlFileStream
		E.TC_NumeroExpediente				as CodigoLegajo, 
		R.TU_CodResolucion					as CodigoResolucion,      
		LS.TC_NumeroResolucion				as NumeroSentencia,
		LS.TC_AnnoSentencia					as AnioSentencia,
		E.TC_NumeroExpediente				as NumeroExpediente,
		ED.TC_CodContexto					as Contexto,
		CL.TC_Descripcion					as Clase,
		O.TC_CodOficina						as Oficina,	 
	    R.TF_FechaResolucion				as FechaVoto,
		R.TN_CodTipoResolucion				as TipoSentencia,
		R.TN_CodResultadoResolucion			as ResultadoSentencia,
		R.TU_RedactorResponsable			as CodigoRedactor, 	
		RTRIM(F.TC_Nombre + ' ' +
	    F.TC_PrimerApellido + ' '+ 
		Coalesce(F.TC_SegundoApellido,''))  as Redactor,
		M.TC_Descripcion				    as Materia,
		E.TB_Confidencial 				    as Confidencial,		 
		R.TB_DatoSensible                   as DatoSensibles,
		R.TC_DescripcionSensible            as DescripcionDatoSensibles,
		R.TB_Relevante                      as Relevante,                    
		(Select STUFF((Select N', ' + A.TC_NumeroExpediente 
						from Historico.ExpedienteAcumulacion A
						Where A.TC_NumeroExpedienteAcumula = AE.TC_NumeroExpediente
						 FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''))								   
		as ExpedientesAcumulados,  
		( Select    STUFF((
					   select N', '+   	RTRIM(F2.TC_Nombre + ' ' + F2.TC_PrimerApellido + ' ' + Coalesce(F2.TC_SegundoApellido,'')) Redactor		
					   from
	     				Expediente.LegajoArchivo		LA2 With(NoLock) 
					   INNER JOIN Archivo.AsignacionFirmado    FF With(NoLock)
						on LA2.TU_CodArchivo                        =FF.TU_CodArchivo AND FF.TC_Estado= 'F'
					   INNER JOIN Archivo.AsignacionFirmante AF  With(NoLock)
					   on FF.TU_CodAsignacionFirmado                  =AF.TU_CodAsignacionFirmado
					   INNER JOIN Catalogo.PuestoTrabajoFuncionario   PTF2 With(NoLock)
					   on AF.TU_FirmadoPor                            = PTF2.TU_CodPuestoFuncionario
					   INNER JOIN Catalogo .Funcionario         F2  With(NoLock) 
						ON PTF2.TC_UsuarioRed                     =F2.TC_UsuarioRed 

						where  LA2.TU_CodARchivo = AE.TU_CodArchivo
						and AF.TB_Salva =0
					  FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')
	  ) as  RedactorVotoSalvado,
	  ( SELECT    STUFF((
					  select N', '+   	RTRIM(F2.TC_Nombre + ' ' + F2.TC_PrimerApellido + ' ' + Coalesce(F2.TC_SegundoApellido,'')) Redactor		
					  from
	     				Expediente.LegajoArchivo		LA2 With(NoLock) 
					   INNER JOIN Archivo.AsignacionFirmado    FF With(NoLock)
						on LA2.TU_CodArchivo                        =FF.TU_CodArchivo AND FF.TC_Estado= 'F'
					   INNER JOIN Archivo.AsignacionFirmante AF  With(NoLock)
					   on FF.TU_CodAsignacionFirmado                  =AF.TU_CodAsignacionFirmado
					   INNER JOIN Catalogo.PuestoTrabajoFuncionario   PTF2 With(NoLock)
					   on AF.TU_FirmadoPor                            = PTF2.TU_CodPuestoFuncionario
					   INNER JOIN Catalogo .Funcionario         F2  With(NoLock) 
						ON PTF2.TC_UsuarioRed                     =F2.TC_UsuarioRed 

						where  LA2.TU_CodARchivo = AE.TU_CodArchivo
						and AF.TB_Nota =1
					  FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')
		)  as  RedactorNotaSeparada,
	    (  select  count(*) 
		   from 	Expediente.LegajoArchivo		LA2 With(NoLock) 
		    INNER JOIN Archivo.AsignacionFirmado       FF With(NoLock)
		    on LA2.TU_CodArchivo                        =FF.TU_CodArchivo AND FF.TC_Estado= 'F'
		    INNER JOIN Archivo.AsignacionFirmante      AF  With(NoLock)
		    on FF.TU_CodAsignacionFirmado                =AF.TU_CodAsignacionFirmado
		    where  LA2.TU_CodARchivo =AE.TU_CodArchivo And AF.TB_Salva =1
		) as VotoSalvado,
		( select  count(*)
		  from Expediente.LegajoArchivo		LA2 With(NoLock) 
		   INNER JOIN Archivo.AsignacionFirmado      FF With(NoLock)
		   on LA2.TU_CodArchivo                        =FF.TU_CodArchivo AND FF.TC_Estado= 'F'
		   INNER JOIN Archivo.AsignacionFirmante     AF  With(NoLock)
		   on FF.TU_CodAsignacionFirmado               =AF.TU_CodAsignacionFirmado
           where  LA2.TU_CodARchivo =AE.TU_CodArchivo And AF.TB_Nota =1
			) as NotaSeparada
			,
        (SELECT    STUFF((
					   select N', '+  	RTRIM(Coalesce(K.TC_Nombre, L.TC_Nombre) + ' ' + coalesce(K.TC_PrimerApellido,'') + ' ' + Coalesce(K.TC_SegundoApellido,'')) 
						From			Expediente.Intervencion		As	A With(NoLock)
						Inner Join		Persona.Persona					As	J With(NoLock)
						On				J.TU_CodPersona					=	A.TU_CodPersona
						Left Join		Persona.PersonaFisica			As	K With(NoLock)
						On				K.TU_CodPersona					=	J.TU_CodPersona
						Left Join		Persona.PersonaJuridica			As	L With(NoLock)
						On				L.TU_CodPersona					=	J.TU_CodPersona
						Where			A.TC_NumeroExpediente			=  AE.TC_NumeroExpediente
							FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')
	   ) as NombrePartes,
	   P.TC_Descripcion					as Proceso,
	   C.TC_CodContexto					as CodigoContexto

	   FROM Expediente.Resolucion						R With(NoLock)
	   INNER JOIN Expediente.ArchivoExpediente			AE With(NoLock) 
	   ON R.TU_CodArchivo								= AE.TU_CodArchivo
	   LEFT JOIN Expediente.LibroSentencia				LS  With(NoLock)  
	   ON R.TU_CodResolucion							= LS.TU_CodResolucion
	   INNER JOIN Expediente.Expediente					E With(NoLock)
	   ON AE.TC_NumeroExpediente						= E.TC_NumeroExpediente
	   INNER JOIN Expediente.ExpedienteDetalle			ED  With(NoLock)
	   ON E.TC_NumeroExpediente							= ED.TC_NumeroExpediente
	   INNER JOIN Catalogo.Clase						CL With(NoLock)
	   ON ED.TN_CodClase								= CL.TN_CodClase
	   INNER JOIN Catalogo.Proceso						P With(NoLock)
	   ON ED.TN_CodProceso								= P.TN_CodProceso
	   INNER JOIN Catalogo.Contexto						C  With(NoLock)
	   ON ED.TC_CodContexto								= C.TC_CodContexto
	   INNER JOIN Catalogo.Materia						M  With(NoLock)
	   ON C.TC_CodMateria								= M.TC_CodMateria
	   INNER JOIN Catalogo.Oficina						O With(NoLock)
	   ON C.TC_CodOficina								= O.TC_CodOficina
	   INNER JOIN Catalogo.PuestoTrabajoFuncionario		PTF With(NoLock)
	   ON R.TU_RedactorResponsable						= PTF.TU_CodPuestoFuncionario
	   INNER JOIN Catalogo .Funcionario					F  With(NoLock)
	   ON												PTF.TC_UsuarioRed = F.TC_UsuarioRed
	   WHERE											R.TC_EstadoEnvioSAS	  ='A'
	   ORDER BY											R.TF_FechaResolucion 
END
GO
