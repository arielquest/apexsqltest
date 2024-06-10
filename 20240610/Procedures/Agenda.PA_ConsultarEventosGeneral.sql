SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<25/11/2020>
-- Descripción:			<Permite consultar los eventos de agenda.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarEventosGeneral]  
	@Contexto				Varchar(4),
	@TiposEvento			Varchar(1000),
	@NumeroExpediente		Char(14) = null,
	@FechaInicio			Datetime2 = null,
	@FechaFin				Datetime2 = null,
	@EstadoEvento			Smallint = null
As
Begin

	
	
	--Variables
	Declare @L_TC_Contexto				Varchar(4)		=	@Contexto,
			@L_TD_FechaInicio			Datetime2		=	@FechaInicio,
			@L_TD_FechaFin				Datetime2		=	@FechaFin,
			@L_TC_NumeroExpediente		Char(14)		=	@NumeroExpediente,
			@L_TC_TiposEvento			Varchar(1000)	=	@TiposEvento,
			@L_TN_CodEstadoEvento		smallint		=	@EstadoEvento

	Set NoCount On;


		If (@L_TD_FechaInicio Is Null And @L_TD_FechaFin Is Null)
		Begin

			With ListaTipoEvento 
			As
			(
				Select S  As TN_CodTipoEvento
				From dbo.SplitString (@L_TC_TiposEvento, ',')
			)
			Select				Distinct
								--Expediente
								A.TC_NumeroExpediente		As NumeroExpediente,
								--Contexto					
								B.TC_CodContexto			As CodigoContexto,
								B.TC_Descripcion			As DescripcionContexto,
								--TipoEvento 
								D.TN_CodTipoEvento			As CodigoTipoEvento, 
								D.TC_Descripcion			As DescripcionTipoEvento, 
								D.TC_ColorEvento			As ColorEvento, 
								D.TB_EsRemate				As EsRemate,
								--FechaEvento 
								F.TN_CodEstadoEvento		As Estado,
								F.TC_Descripcion			As DescripcionEstadoEvento, 
								--EstadoEvento
								C.TB_Cancelada				As Cancelada, 
								C.TU_CodFechaEvento			As CodigoFechaEvento,
								C.TC_Observaciones			As Observaciones,		
								C.TF_FechaInicio			As FechaInicio,
								C.TF_FechaFin				As FechaFin, 
								--Evento 	
								A.TU_CodEvento				As CodigoEvento,
								A.TC_Descripcion			As DescripcionEvento,
								A.TC_Titulo					As Titulo,							
								--SalaJuicio
								G.TC_Descripcion            As DescripcionSala		
			From				Agenda.Evento				As	A	With(Nolock)
			Inner join			Catalogo.Contexto			As	B	With(Nolock)
			On					B.TC_CodContexto			=	A.TC_CodContexto
			Inner Join			Agenda.FechaEvento			As	C 
			On					C.TU_CodEvento				=	A.TU_CodEvento 
			Inner Join			Catalogo.TipoEvento			As	D	With(Nolock)
			On					D.TN_CodTipoEvento			=	A.TN_CodTipoEvento
			Inner Join			ListaTipoEvento				As	E
			On					E.TN_CodTipoEvento			=	D.TN_CodTipoEvento
			Inner Join			Catalogo.EstadoEvento		As	F	With(Nolock)
			On					F.TN_CodEstadoEvento		=	A.TN_CodEstadoEvento
			Left Outer Join		Catalogo.SalaJuicio			As	G	With(Nolock) 
			On					G.TN_CodSala				=	C.TN_CodSala  
			Where				A.TC_CodContexto			=	@L_TC_Contexto
			And					((@L_TC_NumeroExpediente	is	Not Null 
			And  				TC_NumeroExpediente			=	@L_TC_NumeroExpediente)
			Or					@L_TC_NumeroExpediente		is  null)
			And					A.TN_CodEstadoEvento		=	Coalesce (@L_TN_CodEstadoEvento, A.TN_CodEstadoEvento)
			Order By			C.TU_CodFechaEvento, C.TF_FechaInicio Asc	 
		End
		Else
		Begin
			With ListaTipoEvento 
			As
			(
				Select S  As TN_CodTipoEvento
				From dbo.SplitString (@L_TC_TiposEvento, ',')
			)
			Select				Distinct
								--Expediente
								A.TC_NumeroExpediente			As		NumeroExpediente,
								--Contexto						
								B.TC_CodContexto				As		CodigoContexto,
								B.TC_Descripcion				As		DescripcionContexto,
								--TipoEvento 
								D.TN_CodTipoEvento				As		CodigoTipoEvento, 
								D.TC_Descripcion				As		DescripcionTipoEvento, 
								D.TC_ColorEvento				As		ColorEvento, 
								D.TB_EsRemate					As		EsRemate,
								--FechaEvento 
								F.TN_CodEstadoEvento			As		Estado,
								F.TC_Descripcion				As		DescripcionEstadoEvento, 
								--EstadoEvento
								C.TB_Cancelada					As		Cancelada, 
								C.TU_CodFechaEvento				As		CodigoFechaEvento,
								C.TC_Observaciones				As		Observaciones,		
								C.TF_FechaInicio				As		FechaInicio,
								C.TF_FechaFin					As		FechaFin, 
								--Evento 	
								A.TU_CodEvento					As		CodigoEvento,
								A.TC_Descripcion				As		DescripcionEvento,
								A.TC_Titulo						As		Titulo,							
								--SalaJuicio
								G.TC_Descripcion				As		DescripcionSala		
			From				Agenda.Evento					As		A	With(Nolock)
			Inner join			Catalogo.Contexto				As		B	With(Nolock)
			On					B.TC_CodContexto				=		A.TC_CodContexto
			Inner Join			Agenda.FechaEvento				As		C 
			On					C.TU_CodEvento					=		A.TU_CodEvento 
			Inner Join			Catalogo.TipoEvento				As		D	With(Nolock)
			On					D.TN_CodTipoEvento				=		A.TN_CodTipoEvento
			Inner Join			ListaTipoEvento					As		E
			On					E.TN_CodTipoEvento				=		D.TN_CodTipoEvento
			Inner Join			Catalogo.EstadoEvento			As		F	With(Nolock)
			On					F.TN_CodEstadoEvento			=		A.TN_CodEstadoEvento
			Left Outer Join		Catalogo.SalaJuicio				As		G	With(Nolock) 
			On					G.TN_CodSala					=		C.TN_CodSala  
			Where				A.TC_CodContexto				=		@L_TC_Contexto
			And					((@L_TC_NumeroExpediente		is		Not Null 
			And  				TC_NumeroExpediente				=		@L_TC_NumeroExpediente)
			Or					@L_TC_NumeroExpediente			is		null)
			And					A.TN_CodEstadoEvento			=		Coalesce (@L_TN_CodEstadoEvento, A.TN_CodEstadoEvento)
			And					Cast(C.TF_FechaInicio As Date)	Between	Cast(@L_TD_FechaInicio	As Date)	And Cast(@L_TD_FechaFin	As Date)
			Order By			C.TU_CodFechaEvento, C.TF_FechaInicio Asc
		End

	Set NoCount Off;
End










GO
