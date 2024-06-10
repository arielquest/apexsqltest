SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<05/01/2021>
-- Descripción:				<Permite obtener las fechas de participación de los puestos de trabajo> 
------------------------------------------------------------------------------------------------------------
-- Modificado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<23/04/2021>
-- Descripción:				<Se agrega parámetros de @Dias, Permite considerar los días configurables a partir de la fecha que se consulta> 
-- =========================================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarFechasFuturasParticipantesPorPuestosTrabajos]
	@Fecha						Datetime2,
	@PuestosTrabajo				Nvarchar(Max),
	@Dias						smallint = 0
 As
 Begin
	
	
	Declare	@L_Fecha			Datetime2		=	Convert(date, @Fecha);
	Declare	@L_PuestosTrabajo	Nvarchar(Max)	=	@PuestosTrabajo;
	Declare @L_Dias				smallint		=	@Dias
	Declare	@L_Fecha_Maxima		Datetime2		=	DateAdd(day, @L_Dias, @L_Fecha);
	Set		@L_Fecha_Maxima						=	Convert(date, @L_Fecha_Maxima);
	Select 		0											As		ParticipacionParcial,
				'SplitParticipanteEvento'					As		SplitParticipanteEvento,	
				A.TU_CodParticipacion						As		Codigo,
				A.TC_Observaciones							As		Observaciones,		
				'SplitFechaEvento'							As		SplitFechaEvento,
				B.TU_CodFechaEvento							As		Codigo, 
				B.TF_FechaInicio							As		FechaInicio, 
				B.TF_FechaFin								As		FechaFin, 
				B.TC_Observaciones							As		Observaciones, 
				B.TB_Cancelada								As		Cancelada, 
				B.TN_MontoRemate							As		MontoRemate, 
				B.TB_Lista									As		Lista, 
				'SplitOtros'								As		SplitOtros,
				A.TU_CodEvento								As		CodigoEvento,
				A.TC_CodPuestoTrabajo						As		CodigoPuestoTrabajo
	From		[Agenda].[ParticipanteEvento]				As		A	With(Nolock)	
	Inner Join	[Agenda].[FechaEvento]						As		B	With(Nolock)	
	On			B.TU_CodEvento								=		A.TU_CodEvento
	Inner Join	[dbo].[Util_Split] (@PuestosTrabajo, ',')	As		D
	On			D.Dato										=		A.TC_CodPuestoTrabajo
	Where		Convert(date, B.TF_FechaInicio)				Between	@L_Fecha AND @L_Fecha_Maxima  
	Order By	B.TF_FechaInicio Desc

 End
GO
