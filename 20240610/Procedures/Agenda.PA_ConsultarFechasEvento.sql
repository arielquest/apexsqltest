SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado pOr:				<Gustavo Bravo Sánchez>
-- Fecha de creación:		<30/01/2017>
-- Descripción:				<Permite mostrar las fechas de los eventos>
-- ===========================================================================================
--Modificación				<Jonathan Aguilar Navarro> <30/05/2018> <Se cambio el parametro CodOficna por ConContexto>

CREATE PROCEDURE [Agenda].[PA_ConsultarFechasEvento]
	@PCodEvento	 Uniqueidentifier = Null,
	@CodContexto  Varchar(4) = Null,
	@FechaInicio Datetime2 = Null,
	@FechaFin    Datetime2 = Null,
	@Lista       Bit = Null,
	@Cancelada   Bit = Null,
	@FechaActual Datetime2 = Null
	As

Begin

	Select	FE.TU_CodFechaEvento	As	Codigo,		FE.TF_FechaInicio	As	FechaInicio,
			FE.TF_FechaFin			As	FechaFin,	FE.TC_Observaciones	As	Observaciones,
			FE.TB_Cancelada			As	Cancelada,	FE.TN_MontoRemate	As	MontoRemate,
			FE.TB_Lista				As	Lista,		'Split'				As	Split,
			SJ.TN_CodSala			As	Codigo,		SJ.TC_Descripcion	As	Descripcion			
	From		agenda.FechaEvento	As	FE
	Left Join	catalogo.SalaJuicio As	SJ
	On			FE.TN_CodSala		=	SJ.TN_CodSala
	Inner Join	agenda.Evento		As	E 
	On			FE.TU_CodEvento		=	E.TU_CodEvento
	Where  		FE.TU_CodEvento		=	@PCodEvento
	And			E.TC_CodContexto	=	Coalesce(@CodContexto,E.TC_CodContexto)
	And			FE.TF_FechaInicio	Between Coalesce(@FechaInicio,FE.TF_FechaInicio)	And  Coalesce(@FechaFin,FE.TF_FechaFin)  
	And			FE.TF_FechaFin		Between Coalesce(@FechaInicio,FE.TF_FechaInicio)	And  Coalesce(@FechaFin,FE.TF_FechaFin)  
	And			FE.TF_FechaInicio	>=	Coalesce(@FechaActual,FE.TF_FechaInicio)
	And			FE.TB_Cancelada		=	Coalesce(@Cancelada,FE.TB_Cancelada)
	And			FE.TB_Lista			=	Coalesce(@Lista,FE.TB_Lista)
	Order By	FE.TF_FechaInicio


End



	

GO
