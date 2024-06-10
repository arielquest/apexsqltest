SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================  
-- Versión:     <1.0>  -- Creado por:    <Jefry Hernández>  
-- Fecha de creación:  <20/12/2016>  
-- Descripción:    <Permite obtener las jornadas especiales de los funcionarios enviados como parámetro>  
-- Modificado:		<14/09/2017>
-- Descripción:     <Se elimino el case fue reemplazdo por un Split, para ser leido con un Enumerador>
-- ===========================================================================================  
CREATE PROCEDURE [Agenda].[PA_ConsultarJornadasEspeciales] 
  
	@JsonParticipantesEvento NVARCHAR(MAX)

As   
Begin        
	-- Tabla temporal con los participantes y fechas de participación de cada uno    
	DECLARE @ParticipantesEvento TABLE    
	(       
		CodigoPuestoTrabajo		varchar(14)		NOT NULL,
		CodigoOficina			varchar(4)		NOT NULL,
		NombreOficina			varchar(255)	NOT NULL,
		DescPuestoTrabajo		varchar(75)		NOT NULL,
		CodigoTipoFuncionario	smallint		NOT NULL,
		DescTipoFuncionario		varchar(255)	NOT NULL
	)       
	
	-- Obtiene los partipantes del evento con su respectivas fechas y horas de participación    
	
	INSERT INTO @ParticipantesEvento   
	( 
		CodigoPuestoTrabajo,      CodigoOficina,      NombreOficina,      DescPuestoTrabajo,
		CodigoTipoFuncionario,    DescTipoFuncionario    
	)
	--Obtiene los participantes que estarán durante todo el tiempo del evento    
	
	SELECT JSON.*    
	FROM   OPENJSON(@JsonParticipantesEvento)
	WITH 
	(
	   CodigoPuestoTrabajo varchar(14) 'strict $.PuestoTrabajo.Codigo',
	   CodigoOficina varchar(4) 'strict $.PuestoTrabajo.Codigo',
	   NombreOficina varchar(255) 'strict $.PuestoTrabajo.Codigo',
	   DescPuestoTrabajo varchar(75) 'strict $.PuestoTrabajo.Descripcion',
	   CodigoTipoFuncionario smallint 'strict $.PuestoTrabajo.TipoFuncionario.Codigo',
	   DescTipoFuncionario varchar(255) 'strict $.PuestoTrabajo.TipoFuncionario.Descripcion'
	 ) as JSON          
	 
	 select  'Split'					As Split,					pt.TC_CodPuestoTrabajo			As Codigo,
		      pt.TC_Descripcion			As Descripcion,				pt.TF_Inicio_Vigencia			As FechaActivacion,
			  pt.TF_Fin_Vigencia		As FechaDesactivacion,		'Split'							As Split,		  				
			  JTE.TF_Fin_Vigencia		As FechaDesactivacion,		JTE.TF_HoraFin					As HoraFin,				
			  JTE.TF_HoraInicio			As HoraInicio,				JTE.TF_Inicio_Vigencia			As FechaActivacion,		
			  JTE.TN_CodJornadaTrabajo	As  Codigo,					'Split'							As Split,					
			  JTE.TC_DiaSemana			As DiaSemana
			  
	  From			@ParticipantesEvento PE    
	  Inner Join    [Catalogo].[PuestoTrabajo] PT   
	  On			PE.CodigoPuestoTrabajo = PT.TC_CodPuestoTrabajo
	  Inner Join    [Agenda].[JornadaTrabajoEspecial] JTE    
	  On JTE.TC_CodPuestoTrabajo = PT.TC_CodPuestoTrabajo         
End      
GO
