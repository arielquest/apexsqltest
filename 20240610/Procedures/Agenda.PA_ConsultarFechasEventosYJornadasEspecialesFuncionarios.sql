SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Versión:					<1.0>
-- Creado pOr:				<Jefry Hernández>
-- Fecha de creación:		<27/12/2016>
-- Descripción:				<Permite consultar las fechas de eventos y jornadas especiales de los funcionarios, agendados dentro del
--							 periodo recibido como parámetro>
-- Modificado:              <14/09/2016><Diego Navarrete>
-- Descripción:				<se elimino el case se agrego la funcion FN_ObtenerDiaSemana>
-- =============================================
CREATE PROCEDURE  [Agenda].[PA_ConsultarFechasEventosYJornadasEspecialesFuncionarios] 
		
	@FechaInicial		Datetime2,
	@FechaFinal			Datetime2,
	@listaFuncionarios	Varchar(Max)

As
Begin

	Set Datefirst 7; 

	Declare @NombresFuncionarios Varchar(1000)  = '' 
	Declare @CodigosPuestoTrabajo Varchar(1000) = ''
	Declare @TraslapeInicio DateTime2 
	Declare @TraslapeFin    DateTime2											
	Declare @ContadorFecha Datetime2= @FechaInicial;
	Declare @NombresFuncionarios2 Varchar(1000) = '' 
	Declare @PuestosTrabajo2 Varchar(1000) = '' 
	Declare @TraslapeInicio2 DateTime2
	Declare @TraslapeFin2    DateTime2 


	Declare @TempJornadasIndividuales As Table( 
	FechaHoraInicio		Datetime2, 
	FechaHoraFin		Datetime2, 
	NombreFuncionario	Varchar(50), 
	PuestoTrabajo		Varchar(20))

	Declare @TempEventosIndividuales  As Table( 
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2,
	NombreFuncionario	Varchar(50),
	PuestoTrabajo		Varchar(20))

	Declare @TempJornadasTraslapadas  As Table( 
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2)

	Declare @TempEventosTraslapados   As Table(
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2)
	Declare @TempJornadasYEventos     As Table(
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2,
	NombreFuncionario Varchar(1000),
	EsEvento			Bit,
	CodigosPuestoTrabajo Varchar(1000));


--  ****************************          FECHAS DE PARTICIPACIÓN EN EVENTOS          **************************** 

	With 
	TiposPuesto --Almacena los puestos
	As
		(
			 Select S  As TC_CodPuestoTrabajo
			 From [dbo].[SplitString] (@lIstaFunciOnarios, '|')
		)
		,
	FechAsParcialesEventos
	As(

			Select Distinct 
		  
			FPP.TF_FechaInicioParticipaciOn		As	FechaHoraInicio,	FPP.TF_FechaFinParticipaciOn As FechaHoraFin,
			F.Nombre+' '+
			F.PrimerApellido+' '+
			F.SegundoApellido				As NombreFuncionario,	FPP.TU_CodParticipaciOn		 As	cod_Participacion,	PE.TC_CodPuestoTrabajo		 As PuestoTrabajo

			From [AgEnda].[ParticipanteEvento] PE

			Inner Join TiposPuesto TP
			On PE.TC_CodPuestoTrabajo		=		TP.TC_CodPuestoTrabajo
			  
			Inner Join [AgEnda].[ParticipanteFechaEvento] PFE
			On PFE.TU_CodParticipaciOn		=		PE.TU_CodParticipaciOn
			  
			Inner Join [AgEnda].[FechaParticipanteParcial] FPP
			On FPP.TU_CodParticipaciOn		=		PFE.TU_CodParticipaciOn
			And FPP.TU_CodFechaEvento		=		PFE.TU_CodFechaEvento
			  
			Outer Apply [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](PE.TC_CodPuestoTrabajo) As F

			Where 
			FPP.TF_FechaInicioParticipaciOn		>=	@FechaInicial 
			And FPP.TF_FechaInicioParticipaciOn <	@FechaFinal
			Or FPP.TF_FechaFinParticipaciOn		>	@FechaInicial 
			And FPP.TF_FechaFinParticipaciOn	<=	@FechaFinal
			And PE.TN_CodEstadoParticipacion	=	1
		
		)

	,
	FechasEventos  -- Almacena la fechAs de participaciOnes NO PARCIALES Y PARCIALES
	As(

            Select Distinct --Se obtienen las participaciones NO PARCIALES
		  
			  FE.[TF_FechaInicio]		As FechaHOraInicio,		FE.[TF_FechaFin]		As FechaHOraFin,
			  F.Nombre+' '+
			  F.PrimerApellido+' '+
			  F.SegundoApellido		As NombreFuncionario,	TP.TC_CodPuestoTrabajo	As PuestoTrabajo

			From [AgEnda].[ParticipanteEvento] PE
		      Inner Join TiposPuesto TP
			  On PE.TC_CodPuestoTrabajo	= TP.TC_CodPuestoTrabajo

			  Inner Join [AgEnda].[FechaEvento] FE
			  On FE.TU_CodEvento			= PE.TU_CodEvento

			  Outer Apply [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](PE.TC_CodPuestoTrabajo) As F

			  Where 
			  FE.TF_FechaInicio		>=	@FechaInicial 
			  And FE.TF_FechaInicio	<	@FechaFinal
			  Or FE.TF_FechaFin		>	@FechaInicial 
			  And  FE.TF_FechaFin	<=	@FechaFinal
			  And FE.TB_Cancelada	=	0	
			  And 				
			  PE.TU_CodParticipaciOn NOT IN( Select Distinct 
											 TU_CodParticipaciOn As cod_Participacion
											 From FechAsParcialesEventos
		)			
				
			Union All  

			Select  --Se obtienen las participaciones NO PARCIALES
			FPE.FechaHOraInicio,	FPE.FechaHOraFin,	FPE.NombreFuncionario,	FPE.PuestoTrabajo
			From 
			FechAsParcialesEventos FPE
		)

	--Se guardan los eventos de cada funcionario
	Insert Into @TempEventosIndividuales	
	(
			FechaHoraInicio,	FechaHoraFin,	NombreFuncionario,	PuestoTrabajo
	)
	Select  FechaHOraInicio,	FechaHOraFin,	NombreFuncionario,	PuestoTrabajo
	From	FechasEventos
	
	--Se guardan los traslapes entre eventos
	Insert Into @TempEventosTraslapados
	(
				FechaHoraInicio,	FechaHoraFin
	)
	(   
	Select		s1.FechaHoraInicio,	Min(t1.FechaHoraFin) As FechaFin
	
	From 
				@TempEventosIndividuales		s1 
	Inner Join	@TempEventosIndividuales		t1 
	On			s1.FechaHOraInicio			<=	t1.FechaHOraFin
	And 
	Not Exists( Select * 
				From @TempEventosIndividuales	t2 
				Where t1.FechaHOraFin		>=	t2.FechaHOraInicio 
				And t1.FechaHOraFin			<	t2.FechaHOraFin) 
	Where
	Not Exists(	Select * 
				From @TempEventosIndividuales	s2 
				Where s1.FechaHOraInicio	>	s2.FechaHOraInicio 
				And s1.FechaHOraInicio		<=	s2.FechaHOraFin) 
	Group By 
	s1.FechaHOraInicio 
	)	

        --Se recorre la tabla de traslapes para ir extrayendo los nombres de los 
		--funcionarios que conforman cada traslape
	While ((Select Count(FechaHoraInicio) 
			From @TempEventosTraslapados) > 0)
	Begin			

		--Se obtiene el inicio del primer traslape
		Set @TraslapeInicio  =	(Select Top 1 FechaHoraInicio
								From @TempEventosTraslapados
								Order By FechaHoraInicio)

		--Se obtiene el fin del primer traslape
		Set @TraslapeFin     =  (Select Top 1 FechaHoraFin
								From @TempEventosTraslapados
								Order By FechaHoraInicio)													  	
											
		Select  @NombresFuncionarios = ''
		--Se obtienen los nombres de los funcionarios que conforman el primer traslape
		Select  @NombresFuncionarios = @NombresFuncionarios + NombreFuncionario + '|' 
										From @TempEventosIndividuales
										Where FechaHoraInicio Between @TraslapeInicio And @TraslapeFin
										Or    FechaHoraFin    Between @TraslapeInicio And @TraslapeFin
										Group By NombreFuncionario
								
		Select  @CodigosPuestoTrabajo = ''	
		--Se obtienen los codigos de puestos de trabajo de los funcionarios que conforman el primer traslape
		Select  @CodigosPuestoTrabajo = @CodigosPuestoTrabajo + PuestoTrabajo + '|' 
										From @TempEventosIndividuales
										Where FechaHoraInicio Between @TraslapeInicio And @TraslapeFin
										Or    FechaHoraFin    Between @TraslapeInicio And @TraslapeFin
										Group By PuestoTrabajo

		--Se elimina el último caracter
		Set @NombresFuncionarios = (Select SUBSTRING(@NombresFuncionarios, 0, LEN(@NombresFuncionarios))) 
			
		--Se elimina el último caracter
		Set @CodigosPuestoTrabajo = (Select SUBSTRING(@CodigosPuestoTrabajo, 0, LEN(@CodigosPuestoTrabajo))) 
			

		--Se guarda el inicio y fin del traslape junto con sus respectivos nombres de participantes
		Insert Into @TempJornadasYEventos 
		(		
				FechaHoraInicio, FechaHoraFin,			NombreFuncionario,		EsEvento,
				CodigosPuestoTrabajo
		)
		Values 
		(		@TraslapeInicio, @TraslapeFin,			@NombresFuncionarios,		1,
		    	@CodigosPuestoTrabajo)

		--Se elimina de @TempEventosTraslapados, el traslape con el que se acaba de trabajar
		Delete 
		From @TempEventosTraslapados
		Where FechaHoraInicio = @TraslapeInicio
	End


   
--  ****************************          JORNADAS ESPECIALES          ****************************     

--Se obtienen las JORNADAS ESPECIALES que estén dentro
--del rango de fechas recibidas como parámetro. 

	While @ContadorFecha <= @FechaFinal
	Begin

		With 
		CTE_PUESTOS 
		As
		(
			Select s As Puesto
			From [dbo].[SplitString] (@lIstaFunciOnarios, '|')
		)
		,
		JornadasDelDia
		As
		(
			Select 
						Cast(Cast(Convert(Date,@ContadorFecha) As Varchar) + ' ' +
						Cast(JTE.TF_HOraInicio As Varchar) As Datetime2)				As Inicio,
						Cast(Cast(Convert(Date,@ContadorFecha) As Varchar) + ' ' +
						Cast(JTE.TF_HOraFin As Varchar) As Datetime2)					As Fin,
						F.Nombre+' '+
						F.PrimerApellido+' '+
						F.SegundoApellido											As NombreFuncionario,
						JTE.TC_CodPuestoTrabajo											As CodPuestoTrabajo
		
			From		[AgEnda].[JOrnadaTrabajoEspecial] JTE
			Inner Join	CTE_PUESTOS IDS 
			On			IDS.Puesto			=		JTE.TC_CodPuestoTrabajo

			Outer Apply [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](JTE.TC_CodPuestoTrabajo) As F

			Where 
					Agenda.FN_ObtenerDiaSemana(@ContadorFecha) = JTE.TC_DiAsemana 
						
			And(
			@ContadorFecha Between JTE.TF_Inicio_Vigencia And JTE.TF_Fin_Vigencia			 
			And
			JTE.TF_HoraInicio			 >=		Cast(@FechaInicial As Time)  
			And 
			JTE.TF_HoraInicio			 <		Cast(@FechaFinal As Time)
			Or 
			JTE.TF_HoraFin				 >		Cast(@FechaInicial As Time)
			And 
			JTE.TF_HoraFin               <=		Cast(@FechaFinal As Time)	
			Or
			Cast(@FechaInicial As Time)  >=		JTE.TF_HoraInicio	
			And
			Cast(@FechaInicial As Time)  <		JTE.TF_HoraFin	
			Or
			Cast(@FechaFinal As Time)    >		JTE.TF_HoraInicio	
			And
			Cast(@FechaFinal As Time)    <=		JTE.TF_HoraFin	)				
		
		)

		--Se guardan las jornadas del día 
		Insert Into @TempJornadasIndividuales
		(
				FechaHoraInicio, FechaHoraFin, NombreFuncionario, PuestoTrabajo
		)

		Select	Inicio,			 Fin,		   NombreFuncionario, CodPuestoTrabajo
		From	JornadasDelDia
	
		--Se suma un día
		Set @COntadOrFecha = Dateadd(Day, 1, @COntadOrFecha)

	End	

	--Se guardan los traslapes entre jornadas
	Insert Into @TempJornadasTraslapadas 
	(
			FechaHoraInicio,	FechaHoraFin
	)
	
	Select 
			s1.FechaHoraInicio,	Min(t1.FechaHoraFin) As FechaFin

	From	@TempJornadasIndividuales		s1 
	Inner Join @TempJornadasIndividuales	t1 
	On		s1.FechaHoraInicio		<=		t1.FechaHoraFin
	And 
	Not Exists( Select * 
				From	@TempJornadasIndividuales		t2 
				Where	t1.FechaHoraFin				>=	t2.FechaHoraInicio 
				And		t1.FechaHoraFin				<	t2.FechaHoraFin) 
	Where 
	Not Exists( Select * 
				From	@TempJornadasIndividuales	s2 
				Where	s1.FechaHoraInicio		>	s2.FechaHoraInicio 
				And		s1.FechaHoraInicio		<=	s2.FechaHoraFin) 
				Group By s1.FechaHoraInicio 
				Order By s1.FechaHoraInicio


       --Se recorre la tabla de traslapes para ir extrayendo los nombres de los funcionarios que conforman cada traslape
	
	While ((Select Count(FechaHoraInicio) 
			From @TempJornadasTraslapadas) > 0)
	Begin
			
		--Se obtiene el inicio del primer traslape
		Set @TraslapeInicio2  =  (Select Top 1 FechaHoraInicio
								  From @TempJornadasTraslapadas
								  Order By FechaHoraInicio)
		--Se obtiene el fin del primer traslape
		Set @TraslapeFin2     =  (Select Top 1 FechaHoraFin
								  From @TempJornadasTraslapadas
								  Order By FechaHoraInicio)	
												  	
		Select  @NombresFuncionarios2 = ''									  
	    --Se obtienen los nombres de los funcionarios que conforman el primer traslape
        Select  @NombresFuncionarios2 = @NombresFuncionarios2 + NombreFuncionario + '|' 
										From @TempJornadasIndividuales
										Where FechaHoraInicio Between @TraslapeInicio2 And @TraslapeFin2
										Or    FechaHoraFin    Between @TraslapeInicio2 And @TraslapeFin2
										Group By NombreFuncionario

	    Select @PuestosTrabajo2 =''
		--Se obtienen los códigos de puesto trabajo de los funcionarios que conforman el primer traslape
		Select @PuestosTrabajo2  = @PuestosTrabajo2 + PuestoTrabajo + '|' 
										From @TempJornadasIndividuales
										Where FechaHoraInicio Between @TraslapeInicio2 And @TraslapeFin2
										Or    FechaHoraFin    Between @TraslapeInicio2 And @TraslapeFin2
										Group By PuestoTrabajo

		--Se elimina el último caracter
		Set @NombresFuncionarios2 = (Select SUBSTRING(@NombresFuncionarios2, 0, LEN(@NombresFuncionarios2))) 

		--Se elimina el último caracter
		Set @PuestosTrabajo2 = (Select SUBSTRING(@PuestosTrabajo2, 0, LEN(@PuestosTrabajo2))) 
			
		--Se guarda el inicio y fin del traslape junto con sus respectivos nombres de participantes
		Insert Into @TempJornadasYEventos 
		(
				FechaHoraInicio,	FechaHoraFin,	NombreFuncionario,	EsEvento, 
				CodigosPuestoTrabajo
		)
		Values (@TraslapeInicio2,	@TraslapeFin2,	@NombresFuncionarios2,	0, 
				@PuestosTrabajo2)

		--Se elimina de @TempEventosTraslapados, el traslape con el que se acaba de trabajar
		Delete 
		From @TempJornadasTraslapadas 
		Where FechaHoraInicio = @TraslapeInicio2

    End
				
		-- Resultado Final
		Select *
		From @TempJornadasYEventos T
		Order By FechaHoraInicio Asc

End
GO
