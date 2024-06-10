SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================================================================
-- Versión:				<1.0>
-- Creado por:			Gustavo Bravo
-- Fecha de creación:	02/02/2016
-- Descripción:			Consulta los Eventos que tienen fechas anteriores a la fecha actual
-- ==============================================================================================================================
-- Modificación			<Jonathan Aguilar Navarro> <30/05/2018> < Se cambia el parametro oficina por contexto.> 
-- Modificación			<Ronny Ramírez R.> <25/11/2020> <Se modifica CAST a TRY_CAST para evitar error cuando no hay resultados> 
-- Modificación			<Ronny Ramírez R.> <04/05/2021> <Se agrega validación para tomar en cuenta si estado finaliza el evento> 
-- ==============================================================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarEventosPasados] 
@CodContexto varchar(4),
@Lista Bit,
@Cancelada Bit

As
Begin

	  Select Top(10)	 
			 agenda.Evento.TU_CodEvento	as Codigo,		agenda.Evento.TC_Titulo		 as Titulo

	  From 
			 agenda.Evento 
		     Inner Join agenda.FechaEvento  
		     On agenda.Evento.TU_CodEvento = agenda.FechaEvento.TU_CodEvento
		     Inner Join catalogo.EstadoEvento 
		     On agenda.Evento.TN_CodEstadoEvento = catalogo.EstadoEvento.TN_CodEstadoEvento

      Where 
			Convert(Datetime, TRY_CAST(agenda.FechaEvento.TF_FechaFin As Smalldatetime),20) <
			Convert(Datetime, CAST(GETDATE() As Smalldatetime),20) 
			AND  agenda.FechaEvento.TB_Cancelada = @Cancelada
			AND  agenda.FechaEvento.TB_Lista	 = @Lista
			AND  agenda.Evento.TC_CodContexto	 = @CodContexto			
			AND	 catalogo.EstadoEvento.TB_FinalizaEvento = 0
End
GO
