SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
  -- ===========================================================================================  
  -- Versión:     <1.0>  
  -- Creado por:    <Jefry Hernández>  
  -- Fecha de creación:  <20/12/2016>  
  -- Descripción:    <Permite obtener las jornadas laborales de los funcionarios enviados como parámetro>  
  -- ===========================================================================================  
  
  CREATE PROCEDURE [Agenda].[PA_ConsultarJornadasLaborales]   
  
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
	   CodigoPuestoTrabajo varchar(14)	'strict $.PuestoTrabajo.Codigo',
	   CodigoOficina varchar(4)			'strict $.PuestoTrabajo.Codigo',
	   NombreOficina varchar(255)		'strict $.PuestoTrabajo.Codigo',
	   DescPuestoTrabajo varchar(75)	'strict $.PuestoTrabajo.Descripcion',
	   CodigoTipoFuncionario smallint	'strict $.PuestoTrabajo.TipoFuncionario.Codigo',
	   DescTipoFuncionario varchar(255) 'strict $.PuestoTrabajo.TipoFuncionario.Descripcion'
	 ) as JSON          
	        
		  
		  
	Select	'SplitPuestoTrabajo'	As SplitPuestoTrabajo,		pt.TC_CodPuestoTrabajo		As Codigo,
			pt.TC_Descripcion		As Descripcion,				pt.TF_Inicio_Vigencia		As FechaActivacion,
			pt.TF_Fin_Vigencia		As FechaDesactivacion,      'SplitJornadaLaboral'		As SplitJornadaLaboral,
			JL.TC_Descripcion       As Descripcion,				JL.TF_Fin_Vigencia			As FechaDesactivacion,
			JL.TF_HoraFin           As HoraFin,					JL.TF_HoraInicio			As HoraInicio,     
			JL.TF_Inicio_Vigencia   As FechaActivacion,			JL.TN_CodJornadaLaboral		As  Codigo          
	From		@ParticipantesEvento PE    
	Inner Join  [Catalogo].[PuestoTrabajo] PT
	On			PE.CodigoPuestoTrabajo = PT.TC_CodPuestoTrabajo
	Inner Join  [Catalogo].[JornadaLaboral] JL
	On			JL.TN_CodJornadaLaboral = PT.TN_CodJornadaLaboral
	
End  
  
  
  
  
  
  
  
GO
