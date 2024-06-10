SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<20/12/2016>
-- Descripción:				<Permite verificar los choques para los participantes y fechas indicadas.> 
-- =========================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<16/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente>
-- =========================================================================================================
CREATE PROCEDURE [Agenda].[PA_VerificarChoquesFechasParticipantes]
	@JsonFechasEvento			Nvarchar(Max),
	@JsonParticipantesEvento	Nvarchar(Max)
 As
 Begin
	
	--Tabla temporal con las fechas del evento
	Declare @FechasEvento Table
	(
		FechaInicio Datetime2 NOT NULL,
		FechaFin	Datetime2 NOT NULL
	)

	--Tabla temporal con los participantes y fechas de participación de cada uno
	Declare @ParticipantesEvento Table
	(
		CodigoPuestoTrabajo		Varchar(14)		NOT NULL,
		FechasParcialesJson		Varchar(Max),
		FechaInicio				Datetime2		NOT NULL,
		FechaFin				Datetime2		NOT NULL
	)

	--Obtiene las fechas del evento
	Insert Into @FechasEvento
	(
		FechaInicio, 
		FechaFin
	)
	Select *  
	From OPENJSON(@JsonFechasEvento)  
	With (
		FechaInicio Datetime2 'strict $.FechaInicio',
		FechaFin	Datetime2 'strict $.FechaFin'
	)  

	--Obtiene los partipantes del evento con su respectivas fechas y horas de participación
	Insert Into @ParticipantesEvento
	(
			CodigoPuestoTrabajo,		FechasParcialesJson,	FechaInicio,	FechaFin
	)
	--Obtiene los participantes que estarán durante todo el tiempo del evento
	Select	JSON.CodigoPuestoTrabajo,	JSON.FechasParciales,	FE.FechaInicio,	FE.FechaFin
	From	@FechasEvento FE 
	Cross Apply
			OPENJSON(@JsonParticipantesEvento)  
			With 
			(
				CodigoPuestoTrabajo Varchar(14)		'strict $.PuestoTrabajo.Codigo',
				FechasParciales		Nvarchar(max)	As json
			) as JSON
	Where	JSON.FechasParciales IS NULL

	Union

	--Obtiene los participantes que estarán durante únicamente un tiempo parcial
	Select	JSON.CodigoPuestoTrabajo,	JSON.FechasParciales,	FP.FechaInicio, FP.FechaFin
	From	OPENJSON(@JsonParticipantesEvento)  
			With 
			(
				CodigoPuestoTrabajo Varchar(14)		'strict $.PuestoTrabajo.Codigo',
				FechasParciales		Nvarchar(max) as json
			) As JSON

	Cross Apply openjson (JSON.FechasParciales)
	With
	(
			FechaInicio Datetime2 'strict $.FechaInicio',
			FechaFin	Datetime2 'strict $.FechaFin'
	) As FP
	Where	JSON.FechasParciales IS NOT NULL

	Select  e.[TU_CodEvento]				As	Codigo,				e.[TC_NumeroExpediente]			As	NumeroExpediente,		
			e.[TC_Titulo]					As	Titulo,				e.[TC_Descripcion]				As	Descripcion,
			e.[TB_RequiereSala]				As	RequiereSala,		e.[TF_FechaCreacion]			As	FechaCreacion,
			e.[TF_Actualizacion]			As	FechaActualizacion, 'SplitPuestoTrabajo'			As	SplitPuestoTrabajo,
			pt.TC_CodPuestoTrabajo			As	Codigo,				pt.TC_Descripcion				As	Descripcion,
			pt.TF_Inicio_Vigencia			As	FechaActivacion,	pt.TF_Fin_Vigencia				As	FechaDesactivacion,
			'SplitFechasEvento'				As	SplitFechasEvento,	fe.[TU_CodFechaEvento]			As	Codigo,
			fe.[TF_FechaInicio]				As	FechaInicio,		fe.[TF_FechaFin]				As	FechaFin,
			fe.[TC_Observaciones]			As	Observaciones,		fe.[TB_Cancelada]				As	Cancelada,
			fe.[TN_MontoRemate]				As	MontoRemate,		'SplitParticipanteEvento'		As	SplitParticipanteEvento,
			pe.TU_CodParticipacion			As	Codigo,				pe.TC_Observaciones				As	Observaciones,	
			'SplitFechaParcial'				As	SplitFechaParcial,	fpp.TF_FechaInicioParticipacion As FechaInicio,
			fpp.TF_FechaFinParticipacion	As	FechaFin
	From	[Agenda].[Evento]				As	e
	Join	[Agenda].[ParticipanteEvento]	As	pe 
	On		pe.[TU_CodEvento]				=	e.[TU_CodEvento]
	Join	Catalogo.PuestoTrabajo			As	pt 
	On		pt.TC_CodPuestoTrabajo			=	pe.TC_CodPuestoTrabajo
	Join	@ParticipantesEvento			As	pne 
	On		pe.TC_CodPuestoTrabajo			=	pne.CodigoPuestoTrabajo
	Join	[Agenda].[FechaEvento]			As	fe 
	On		fe.TU_CodEvento					=	e.[TU_CodEvento] 
	AND		fe.TB_Cancelada					=	0
	Left Join [Agenda].[FechaParticipanteParcial]	As	fpp 
	on		fpp.TU_CodFechaEvento				= fe.TU_CodFechaEvento 
	and		fpp.TU_CodParticipacion			=	pe.TU_CodParticipacion
	Where
	(	(
			fpp.TF_FechaFinParticipacion	IS NULL 
	And		fpp.TF_FechaInicioParticipacion IS NULL 
	And		(((fe.TF_FechaInicio			>=	pne.FechaInicio 
	And		fe.TF_FechaInicio				<	pne.FechaFin) 
	Or		(fe.TF_FechaFin					>	pne.FechaInicio 
	And		fe.TF_FechaFin					<=	pne.FechaFin))
	OR		((pne.FechaInicio				>=	fe.TF_FechaInicio 
	And		pne.FechaInicio					<	fe.TF_FechaFin) 
	Or		(pne.FechaFin					>	fe.TF_FechaInicio 
	And		pne.FechaFin					<= fe.TF_FechaFin)))
		)
	OR
		(
			fpp.TF_FechaFinParticipacion		IS	NOT NULL 
	And		fpp.TF_FechaInicioParticipacion		IS	NOT NULL 
	And		(((fpp.TF_FechaInicioParticipacion	>=	pne.FechaInicio 
	And		fpp.TF_FechaInicioParticipacion		<	pne.FechaFin) 
	OR		(fpp.TF_FechaFinParticipacion		>	pne.FechaInicio 
	And		fpp.TF_FechaFinParticipacion		<=	pne.FechaFin))
	OR		((pne.FechaInicio					>=	fpp.TF_FechaInicioParticipacion
	And		pne.FechaInicio						<	fpp.TF_FechaFinParticipacion)
	Or		(pne.FechaFin						>	fpp.TF_FechaInicioParticipacion
	And		pne.FechaFin						<=	fpp.TF_FechaFinParticipacion)))
		)
	) 
	
	AND 
	((		fe.TF_FechaFin						>	Getdate()
	AND		fpp.TF_FechaFinParticipacion		IS	NULL)
	OR		(fpp.TF_FechaFinParticipacion		IS	NOT NULL
	AND		fpp.TF_FechaFinParticipacion		>	Getdate())
	)
	Order By 
			fe.TF_FechaInicio,
			fpp.TF_FechaInicioParticipacion

 End


GO
