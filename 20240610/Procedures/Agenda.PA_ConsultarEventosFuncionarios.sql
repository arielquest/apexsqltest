SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Wilbert Gamboa>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Este SP me permite recOrrer una lIsta de TC_CodPuestoTrabajo de funciOnarios y extraer, para cada uno de ellos,
--                          los cruces o choques de actividades de Forma unificada. Recibe como parámetro la lIsta de TC_CodPuestoTrabajo> 
-- ===========================================================================================
CREATE Procedure [Agenda].[PA_ConsultarEventosFuncionarios]
	@FechaInicial		Datetime2,
	@FechaFinal			Datetime2,
	@lIstaFunciOnarios	Varchar(8000),
	@Color				Varchar(30)
As
Begin

	Declare @COntadOrFecha							Datetime2
	Set @COntadOrFecha = @FechaInicial
	Declare @lIstaFunciOnariosParaJOrnadaEspecial	Varchar(1000)
	Set @lIstaFunciOnariosParaJOrnadaEspecial = @lIstaFunciOnarios
	Declare @TablaTempOralOcupados					As Table 
	(
		FechaHOraInicio Datetime2,
		FechaHOraFin	Datetime2,
		Nombre			Varchar(100)
	)
	Declare @HOrarioOcupadoTrAslapes				As Table 
	(
		FechaHOraInicio Datetime2,
		FechaHOraFin	Datetime2,
		Nombre			Varchar(100),
		Color			Varchar(20));
	
	With TiposPuesto
	As
	(
		Select	S  As TC_CodPuestoTrabajo
		From	[dbo].[SplitString] (@lIstaFunciOnarios, '|')
	)	
	,
	FechasParcialesEventos
	As
	(

		Select Distinct	FPP.TF_FechaInicioParticipaciOn		As FechaHOraInicio,	FPP.TF_FechaFinParticipaciOn				As FechaHOraFin,
						FPP.TU_CodParticipaciOn				As cod_ParticipaciOn,F.Nombre + ' ' + F.PrimerApellido			As Nombre
		
		From            [AgEnda].[ParticipanteEvento]			As		PE  
		Inner Join		TiposPuesto								As		TP							  
		On				PE.TC_CodPuestoTrabajo					=		TP.TC_CodPuestoTrabajo
		Inner Join		[AgEnda].[ParticipanteFechaEvento]		As		PFE     
		On				PFE.TU_CodParticipaciOn					=		PE.TU_CodParticipaciOn
		Inner Join		[AgEnda].[FechaParticipanteParcial]		As		FPP    
		On				FPP.TU_CodParticipaciOn					=		PFE.TU_CodParticipaciOn
		And				FPP.TU_CodFechaEvento					=		PFE.TU_CodFechaEvento		

		Outer Apply         [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](TP.TC_CodPuestoTrabajo) As F
		
		Where               FPP.TF_FechaInicioParticipaciOn Between @FechaInicial And @FechaFinal
		Or					FPP.TF_FechaFinParticipaciOn	Between @FechaInicial And @FechaFinal		
	)
	,
	FechasEventos
	As
	(
		Select Distinct	FE.[TF_FechaInicio]						As	FechaHOraInicio,	FE.[TF_FechaFin]	As FechaHOraFin,
						F.Nombre + ' ' + F.PrimerApellido		As	Nombre
		From	        [AgEnda].[ParticipanteEvento]			As	PE  
		Inner Join		TiposPuesto								As	TP							  
		On				PE.TC_CodPuestoTrabajo					=	TP.TC_CodPuestoTrabajo
		Inner Join		[AgEnda].[FechaEvento]					As	FE				  
		On				FE.TU_CodEvento							=	PE.TU_CodEvento
		Inner Join		FechAsParcialesEventos					As	FPE				  
		On				PE.TU_CodParticipaciOn					NOT IN	(FPE.cod_ParticipaciOn)

		Outer Apply         [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](TP.TC_CodPuestoTrabajo) As F


		Where			FE.TF_FechaInicio Between @FechaInicial And @FechaFinal
		Or				FE.TF_FechaFin	  Between @FechaInicial And @FechaFinal
					
		Union All
		Select			FPE.FechaHOraInicio,	FPE.FechaHOraFin,	FPE.Nombre
		From            FechasParcialesEventos FPE
		 		
	)

	Insert Into @TablaTempOralOcupados
	(
			FechaHOraInicio,	FechaHOraFin,	Nombre
	)
	Select	FechaHOraInicio,	FechaHOraFin,	Nombre
	From	FechasEventos

	Insert Into @HOrarioOcupadoTrAslapes 
	(
				FechaHOraInicio,		FechaHOraFin,						Color
	)
	Select		s1.FechaHOraInicio,		MIN(t1.FechaHOraFin) As FechaFin,	@Color
	From		@TablaTempOralOcupados s1 
	Inner Join	@TablaTempOralOcupados t1 
	On			s1.FechaHOraInicio	<= t1.FechaHOraFin
	And 
	Not Exists	(
				Select *
				From	@TablaTempOralOcupados	t2 
				Where	t1.FechaHOraFin		>=	t2.FechaHOraInicio
				And		t1.FechaHOraFin		<	t2.FechaHOraFin
				 ) 
	Where 
	Not Exists	(
				Select *
				From	@TablaTempOralOcupados	s2 
				Where	s1.FechaHOraInicio	>	s2.FechaHOraInicio 
				And		s1.FechaHOraInicio	<=	s2.FechaHOraFin
				) 
	Group BY s1.FechaHOraInicio 
	Order By s1.FechaHOraInicio

	Select	* 
	From	@HOrarioOcupadoTrAslapes
End
GO
