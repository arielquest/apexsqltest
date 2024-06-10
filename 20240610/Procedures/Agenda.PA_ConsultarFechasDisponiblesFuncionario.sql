SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Wilbert Gamboa>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Este SP me permite recOrrer una lIsta de IDs de funciOnarios y extraer, para cada uno de ellos,
--							 los cruces o choques de actividades de Forma unificada. Una vez extraídos los cruces se procede 
--                           a obtener los espacios dIspOnibles de cada uno de los funciOnarios. Recibe como parámetro la 
--                           lIsta de IDs (TC_UsuariOred), @FechaInicial y @FechaFinal para dIspOnibilidad del evento y la 
--                           duración del evento.> 
-- Modificacion:             <Se agrega Parentesis en el 'or'>
-- Modificado:              <14/09/2016><Diego Navarrete>
-- Descripción:				<se elimino el case se agrego la funcion FN_ObtenerDiaSemana>
-- ===========================================================================================

CREATE Procedure [Agenda].[PA_ConsultarFechasDisponiblesFuncionario]

	@listaFuncionarios	Varchar(1000),
	@FechaInicial		Datetime2,
	@FechaFinal			Datetime2,
	@CantidadHoras		Decimal(18,2),
	@Particionado		int  
-- Cuando Particionado posee el valor:
-- 1 -- Se está buscando disponibilidad para un evento Particionado
-- 0 -- Se está buscando disponibilidad para un evento NO Particionado
-- 3 -- Se está buscando disponibilidad para un evento de tipo Remate
-- 5 -- Se está buscando disponibilidad para participantes externos

As
Begin

	Set Datefirst 7; 
		-- ******************  VARIABLES  **************************
	Declare @COntadOrFecha	Datetime2
	Set @COntadOrFecha = @FechaInicial
	Declare @COntadOrFecha2 Datetime2
	Set @COntadOrFecha2 = @FechaInicial
	Declare @COntadOrFechaJOrnadaLabOral Datetime2
	Set @COntadOrFechaJOrnadaLabOral = @FechaInicial
	Declare @lIstaFunciOnariosParaJOrnadaEspecial Varchar(1000)
	Set @lIstaFunciOnariosParaJOrnadaEspecial = @lIstaFunciOnarios
	Declare @lIstaFunciOnariosParaJOrnadaLabOral Varchar(1000)
	Set @lIstaFunciOnariosParaJOrnadaLabOral = @lIstaFunciOnarios
	Declare @cOntadOrFunciOnariosParaJOrnadaLabOral Varchar(1000)
	Set @cOntadOrFunciOnariosParaJOrnadaLabOral = @lIstaFunciOnarios
	Declare @CANTIDAD_PARTICIPANTES Int 
	-- ****************  FIN VARIABLES  *************************

	-- ******************  TABLAs TEMPOrALES  **************************
	Declare @TablaTemporalOcupados As Table
	( 
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2
	)
	Declare @TablaTemporalLaborales As Table
	( 
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2,
	TC_CodPuestoTrabajo	Varchar(100)
	)
	Declare @HorarioOcupadoTraslapes As Table 
	(
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2
	)
	Declare @TablaTemporalTiemposLibres As Table
	(
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2
	)
	Declare @TablaTemporalLaboralesCompartidos As Table
	(
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2
	)
	Declare @TablaTemporalLibreDelDia As Table
	(
	FechaHoraInicio		Datetime2, 
	FechaHoraFin		Datetime2
	)
	Declare @TablaTemporalOcupadosDelDia As Table
	(
	FechaHoraInicio		Datetime2,
	FechaHoraFin		Datetime2
	);
	
	-- ****************  FIN TABLAS TEMPORALES  ************************

	-- **********************************************************************
	-- ************** PAsO 1: SACAMOS LOS ESPACIOS OCUPADOS *****************
	-- **********************************************************************

--Esto lo que me permite recOrrer una lIsta de TC_CodPuestoTrabajo de funciOnarios y extraer, para cada uno de ellos,
--lAs fechAs en lAs que tienen eventos Asignados. Recibe como parámetro la lIsta de TC_CodPuestoTrabajo
	With 
	TiposPuesto
	As
	(
		Select S  As TC_CodPuestoTrabajo
		From [dbo].[SplitString] (@lIstaFunciOnarios, '|')
	)

	,
	FechAsParcialesEventos
	As
	(

		Select Distinct	FPP.TF_FechaInicioParticipaciOn			As FechaHOraInicio,
						FPP.TF_FechaFinParticipaciOn			As FechaHOraFin,
						FPP.TU_CodParticipaciOn					As cod_ParticipaciOn

		From			[AgEnda].[ParticipanteEvento] PE					  
		Inner Join		TiposPuesto TP
		On				PE.TC_CodPuestoTrabajo = TP.TC_CodPuestoTrabajo	  
		Inner Join      [AgEnda].[ParticipanteFechaEvento] PFE
		On				PFE.TU_CodParticipaciOn  = PE.TU_CodParticipaciOn  
		Inner Join      [AgEnda].[FechaParticipanteParcial] FPP
		On				FPP.TU_CodParticipaciOn = PFE.TU_CodParticipaciOn  
		And             FPP.TU_CodFechaEvento = PFE.TU_CodFechaEvento

	    Where	        FPP.TF_FechaInicioParticipaciOn >=	@FechaInicial	  
		And             FPP.TF_FechaInicioParticipaciOn <	@FechaFinal
		Or				FPP.TF_FechaFinParticipaciOn	>	@FechaInicial       
		And				FPP.TF_FechaFinParticipaciOn	<=	@FechaFinal
		And				PE.TN_CodEstadoParticipacion	=	1		
		)

	,
	FechAsEventos
	As(

        Select Distinct  FE.[TF_FechaInicio]	             As FechaHOraInicio, 
						 FE.[TF_FechaFin]		             As FechaHOraFin

		From			[AgEnda].[ParticipanteEvento] PE                  
		Inner Join		TiposPuesto TP
		On				PE.TC_CodPuestoTrabajo	=	TP.TC_CodPuestoTrabajo     
		Inner Join		[AgEnda].[FechaEvento]	As	FE
		On				FE.TU_CodEvento			=	PE.TU_CodEvento

		Where 
						FE.TF_FechaInicio		>=  @FechaInicial   
		And				FE.TF_FechaInicio		<	@FechaFinal
		Or				FE.TF_FechaFin			>	@FechaInicial    
		And				FE.TF_FechaFin			<=  @FechaFinal
		And				FE.TB_Cancelada			=	0
		And				PE.TU_CodParticipaciOn NOT IN(	
												Select Distinct TU_CodParticipaciOn As cod_Participacion
												From			FechAsParcialesEventos)	
								
		Union All

		Select			FPE.FechaHOraInicio,
						FPE.FechaHOraFin
		From			FechAsParcialesEventos FPE	
	)

	
	Insert Into @TablaTempOralOcupados
	(  
		FechaHOraInicio, FechaHOraFin
	)
	Select *
	From FechAsEventos

	--Este ciclo permite obtener lAs fechAs de lAs jOrnadAs especiales que estén dentro
	--del rango de fechAs que recibe como parámetro y que estén AsociadAs a la lIsta de TC_CodPuestoTrabajo
	While @COntadOrFecha <= @FechaFinal
	Begin

		With 
		tablaTempOral_TC_CodPuestoTrabajo 
		As
		(
			Select s 
			From [dbo].[SplitString] (@lIstaFunciOnariosParaJOrnadaEspecial, '|')
		)
	
		--Insertamos los resultados en la tabla tempOral
		Insert Into @TablaTempOralOcupados
		( 
					FechaHOraInicio,		FechaHOraFin)
		Select 
					Cast(Cast(Convert(Date,@COntadOrFecha) As Varchar) + ' ' +
					Cast(JTE.TF_HOraInicio As Varchar)As Datetime2)				As INICIO,
					Cast(Cast(Convert(Date,@COntadOrFecha) As Varchar) + ' ' +
					Cast(JTE.TF_HOraFin As Varchar)As Datetime2)					As FIN
		
		From		[AgEnda].[JOrnadaTrabajoEspecial] JTE
		Inner Join	tablaTempOral_TC_CodPuestoTrabajo IDS 
		On			IDS.s = JTE.TC_CodPuestoTrabajo
		Where		
					Agenda.FN_ObtenerDiaSemana(@ContadorFecha)= JTE.TC_DiAsemana 
		And			(@COntadOrFecha Between JTE.TF_Inicio_Vigencia And JTE.TF_Fin_Vigencia		
		Or 	        
		(			@COntadOrFecha >= JTE.TF_Inicio_Vigencia 
					And         
					JTE.TF_Fin_Vigencia Is Null
		))

		Set @COntadOrFecha = Dateadd(Day, 1, @COntadOrFecha)

	End

	--Obtiene el merge de hOrarios ocupados
	Insert Into @HOrarioOcupadoTrAslapes 
	(
				FechaHOraInicio,	FechaHOraFin
	)
	Select		s1.FechaHOraInicio, MIN(t1.FechaHOraFin) As FechaFin
	From		@TablaTempOralOcupados	s1 
	Inner Join	@TablaTempOralOcupados	t1 
	On			s1.FechaHOraInicio <=	t1.FechaHOraFin

	And Not Exists( Select	* 
					From	@TablaTempOralOcupados	t2 
					Where	t1.FechaHOraFin		>=	t2.FechaHOraInicio 
					And		t1.FechaHOraFin		<	t2.FechaHOraFin) 

	Where Not Exists(Select * 
					 From	@TablaTempOralOcupados		s2 
					 Where	s1.FechaHOraInicio		>	s2.FechaHOraInicio 
					 And	s1.FechaHOraInicio		<=	s2.FechaHOraFin) 

	GROUP BY	s1.FechaHOraInicio 
	Order By	s1.FechaHOraInicio

	-- **********************************************************************
	-- ************* PAsO 2: SACAMOS LOS ESPACIOS LABOrABLES ****************
	-- **********************************************************************

	--Este procedimiento almacenado nos permite obtener lAs fechAs de lAs jOrnadAs labOrales que estén dentro
	--del rango de fechAs que recibe y que estén AsociadAs a la lIsta de TC_CodPuestoTrabajo
	--Recibe como parámetro el inicio y fin del periodo y la lIsta de TC_CodPuestoTrabajo

	While Convert(Date,@COntadOrFechaJOrnadaLabOral) <= Convert(Date,@FechaFinal)
	Begin

		With 
		PuestosNecesarios 
		As
		(
			Select s As COD_PUESTO
			From [dbo].[SplitString] (@lIstaFunciOnariosParaJOrnadaLabOral, '|')
		)
		
		Insert Into @TablaTemporalLaborales 
		(
				FechaHoraInicio,	FechaHoraFin,	TC_CodPuestoTrabajo
		)

		Select
				
		Cast(Cast(Convert(Date,@ContadorFechaJornadaLaboral) As Varchar) + ' ' + 	
		Cast((
		Case 
			When	Convert(Date,@FechaInicial)  =	Convert(Date,@ContadorFechaJornadaLaboral) 
			And		Cast(@FechaInicial As Time)  >	Cast(JL.TF_HoraInicio As Time)
			Then	Cast(@FechaInicial As Time) 
			Else	Cast(JL.TF_HoraInicio As Time)
		End
		)	
		As Varchar) As Datetime2)	As FechaHoraInicio, 

		Cast(Cast(Convert(Date,@ContadOrFechaJornadaLaboral) As Varchar) + ' ' +  
		Cast((
		Case 
			When	Convert(Date,@FechaFinal)	=	Convert(Date,@ContadorFechaJornadaLaboral) 
			And		Cast(@FechaFinal As Time)	<	Cast(JL.TF_HoraFin As Time)
			Then	Cast(@FechaFinal As Time) 
			Else	Cast(JL.TF_HoraFin As Time)
		End
		)				
		As Varchar)As Datetime2)	As FechaHoraFin,

		PT.TC_CodPuestoTrabajo      As TC_CodPuestoTrabajo

		From		[Catalogo].[PuestoTrabajo] PT
		Inner Join	[Catalogo].[JornadaLaboral] JL
		On			JL.TN_CodJornadaLaboral = PT.TN_CodJornadaLaboral
		Inner Join	PuestosNecesarios PN
		On			PT.TC_CodPuestoTrabajo IN (PN.COD_PUESTO)
		
		Where		@COntadOrFechaJOrnadaLabOral Between JL.TF_Inicio_Vigencia And JL.TF_Fin_Vigencia
		Or         (@COntadOrFechaJOrnadaLabOral >= JL.TF_Inicio_Vigencia      And JL.TF_Fin_Vigencia Is Null)
		

		Set @COntadOrFechaJOrnadaLabOral = Dateadd(Day, 1, @COntadOrFechaJOrnadaLabOral)

	End
	

	-- Esta variable nos permite obtener el número de elementos que trae el string de funciOnarios
	Set @CANTIDAD_PARTICIPANTES = (Select count(s) From [dbo].[SplitString] (@cOntadOrFunciOnariosParaJOrnadaLabOral, '|'))

	--COn este proceso determinamos únicamente el espacio dOnde todos los funciOnarios de la lIsta podrían
	--labOrar juntos, de acuerdo a sus jOrnadAs labOrales
	
	Insert Into @TablaTempOralLabOralesCompartidos
	(
			FechaHoraInicio,						FechaHoraFin		
	)
	Select	T2.FechaHOraInicio As FechaHoraInicio,	MIN(T1.FechaHOraFin) As FechaHoraFin

	From		@TablaTempOralLabOrales T1
	Inner Join	@TablaTempOralLabOrales T2
	On			T2.FechaHOraInicio Between T1.FechaHOraInicio And T1.FechaHOraFin 
	GROUP BY	T2.FechaHOraInicio
	HAVING COUNT(T2.FechaHOraInicio) % @CANTIDAD_PARTICIPANTES = 0 And
	COUNT(	Distinct T1.TC_CodPuestoTrabajo ) = @CANTIDAD_PARTICIPANTES;

		
	---- **********************************************************************
	---- *************** PAsO 3: SACAMOS LOS ESPACIOS LIBRES ******************
	---- **********************************************************************

    Set @COntadOrFecha = @FechaInicial

	-- Se recOrre de inicio a fin el periodo de búsqueda esTablecido, para ir obteniEndo la dIspOnibilidad de cada día.
	While Convert(Date,@COntadOrFecha) <= Convert(Date,@FechaFinal)
	Begin

		--Se almacena el inicio y fin del tiempo labOrable para el día
		Insert Into @TablaTemporalLibreDelDia
		(
					FechaHoraInicio,	FechaHoraFin
		)
	
		Select		B.FechaHOraInicio,	B.FechaHOraFin
		From		@TablaTempOralLabOralesCompartidos B
		Where		Cast(B.FechaHOraInicio As Date) = Cast(@COntadOrFecha As Date)		
	
		--Se almacena el inicio y fin de los tiempos ocupados para el día
		Insert Into @TablaTemporalOcupadosDelDia
		(
				FechaHoraInicio,	FechaHoraFin
		)	
		Select	N.FechaHOraInicio,	N.FechaHOraFin
		From		@HOrarioOcupadoTrAslapes N
		Inner Join	@TablaTemporalLibreDelDia B
		On			N.FechaHOraInicio	Between B.FechaHOraInicio And B.FechaHOraFin Or
					N.FechaHOraFin		Between B.FechaHOraInicio And B.FechaHOraFin Or
					B.FechaHOraInicio	Between N.FechaHOraInicio And N.FechaHOraFin Or
					B.FechaHOraFin		Between N.FechaHOraInicio And N.FechaHOraFin
		Where Cast(N.FechaHOraInicio As Date) = Cast(@COntadOrFecha  As Date)			

	
		-- El espacio libre está dentro de algún espacio ocupado? Si es así entonces en ese día no hay disponibilidad	
		-- Por lo contrario, si el resultado de la siguiente cOnsulta es 0, entOnces hay posibilidad de encOntrar dIspOnibilidad
		  
		If(		(Select		COUNT(B.FechaHOraFin)
				 From		@TablaTemporalLibreDelDia B
				 Inner Join	@TablaTemporalOcupadosDelDia N
				 On			B.FechaHOraInicio	Between N.FechaHOraInicio And N.FechaHOraFin 
				 And		B.FechaHOraFin		Between N.FechaHOraInicio And N.FechaHOraFin
				) = 0
		   )
		Begin 			
					 --No existe ningún espacio ocupado ese día?. 			
			If(		(Select	COUNT(T.FechaHOraInicio) 
					 From	@TablaTemporalOcupadosDelDia T
					 Where	Cast(T.FechaHOraFin As Date) = Cast(@COntadOrFecha As Date)
					) = 0  
				Or
					--No existe ningún espacio ocupado que Interrumpa al espacio libre? De ser así todo el día está disponible. 
					(Select		COUNT(L.FechaHOraFin) From @TablaTemporalLibreDelDia L
					 Inner Join @TablaTemporalOcupadosDelDia O
					 On			(L.FechaHOraInicio	Between O.FechaHOraInicio And O.FechaHOraFin
					 Or			 L.FechaHOraFin		Between O.FechaHOraInicio And O.FechaHOraFin) 
					 Or		    (O.FechaHOraInicio	Between L.FechaHOraInicio And L.FechaHOraFin 
					 Or	         O.FechaHOraFin		Between L.FechaHOraInicio And L.FechaHOraFin)
					 ) = 0
	
				)

			Begin 	            
				--Se guarda todo el día como espacio disponible
				Insert Into @TablaTempOralTiemposLibres
				Select B.FechaHOraInicio , B.FechaHOraFin
				From @TablaTempOralLabOralesCompartidos B
				Where Cast(B.FechaHOraInicio As Date) = Cast(@COntadOrFecha As Date)

			End
			Else
			Begin		
				--Existe un lapso disponible al inicio de día?
				If(		(Select		COUNT(B.FechaHOraInicio)
						 From		@TablaTemporalOcupadosDelDia N
						 Inner Join @TablaTemporalLibreDelDia B
						 On			B.FechaHOraInicio Between N.FechaHOraInicio And N.FechaHOraFin
						 )= 0
				  )
				Begin		               
					--Se almacena el primer lapso disponible del día			
					Insert Into @TablaTempOralTiemposLibres
					(
							FechaHoraInicio,	FechaHoraFin
					)
					Select  B.FechaHOraInicio,	(Select TOP 1 N.FechaHOraInicio 
												 From		@TablaTemporalOcupadosDelDia N 
												 Order By	N.FechaHOraInicio Asc)
					From @TablaTemporalLibreDelDia B 
				End

			    --Existe un lapso disponible al final de día?
				IF(		(Select		COUNT(B.FechaHOraFin)
						 From		@TablaTemporalOcupadosDelDia N
						 Inner Join @TablaTemporalLibreDelDia B
						 On			B.FechaHOraFin Between N.FechaHOraInicio And N.FechaHOraFin
						 )= 0
				  )
				Begin
					--Se almacena el último espacio disponible del día			
					Insert Into @TablaTempOralTiemposLibres
					(
								 FechaHoraInicio,  FechaHoraFin
					)				
					Select TOP 1 N.FechaHOraFin,  (Select  B.FechaHOraFin 
					                               From		@TablaTemporalLibreDelDia B ) 		
					From		@TablaTemporalOcupadosDelDia N 
					Order By	N.FechaHOraInicio DESC 		
				
				End;
					With
					SegmentosIntermedios
					As
					(
						Select T1.FechaHOraInicio, T1.FechaHOraFin, ROW_NUMBER() OVER(Order By FechaHOraInicio Asc) As NumeroFila
						From @TablaTemporalOcupadosDelDia  T1 
					)
					
					--Se almacenan los espacios disponibles intermedios.
					Insert Into @TablaTempOralTiemposLibres
					(
								FechaHoraInicio,	FechaHoraFin
					)
					Select		t2.FechaHOraFin,	  t1.FechaHOraInicio
					From		SegmentosIntermedios  t1 
					Inner Join	SegmentosIntermedios  t2
					On			t1.NumeroFila =		  t2.NumeroFila + 1

			End --Fin Else
		End --Fin IF
	
		Set @COntadOrFecha = Dateadd(Day, 1, @COntadOrFecha) --Se aumenta el contador
				
		-- Se limpian lAs tablAs del dia actual para continuar con el siguiente día
		Delete From @TablaTemporalLibreDelDia
		Delete From @TablaTemporalOcupadosDelDia

	End -- Fin While
	
	-- Se eliminan los días festivos 
	Delete
	From	@TablaTempOralTiemposLibres 
	Where	Cast(FechaHOraInicio As Date) 
	IN 		(Select		Cast(DF.TF_FechaFestivo As Date) 
			 From		[AgEnda].[DiaFestivo] DF
			 )

	If(@Particionado = 1)
	Begin
		Select		*, 
					Convert(Decimal(18, 2), ABS(Datediff(MINUTE, LI.FechaHOraInicio, LI.FechaHOraFin)))/60 As CantidadHoras
		From		@TablaTempOralTiemposLibres LI
		Where		(((ABS(Datediff(MINUTE, LI.FechaHoraInicio, LI.FechaHoraFin)) >= 30
		And			LI.FechaHOraInicio	< LI.FechaHOraFin)
		And			LI.FechaHOraFin		<= @FechaFinal))
		Order By	LI.FechaHOraInicio Asc
	End

	Else 
	If(@Particionado = 5)
	Begin
		Select	*,
				Convert(Decimal(18, 2), ABS(Datediff(MINUTE, LI.FechaHOraInicio, LI.FechaHOraFin)))/60 as CantidadHoras
		From	@TablaTempOralTiemposLibres LI
		Where	LI.FechaHOraInicio <	LI.FechaHOraFin 
		And		LI.FechaHOraFin		<=	@FechaFinal
		order by LI.FechaHOraInicio asc
			   
		End
	Else
	Begin
		Select	*,
				Convert(Decimal(18, 2), ABS(Datediff(MINUTE, LI.FechaHOraInicio, LI.FechaHOraFin)))/60 as CantidadHoras
		From	@TablaTempOralTiemposLibres LI
		Where	(((ABS(Datediff(MINUTE, LI.FechaHoraInicio, LI.FechaHoraFin)) >= (@CantidadHorAs * 60) 
		Or		@CantidadHOrAs Is Null)
		And		LI.FechaHOraInicio < LI.FechaHOraFin)
		And		LI.FechaHOraFin <= @FechaFinal)
		order by LI.FechaHOraInicio asc	
			   
	End
End 
GO
