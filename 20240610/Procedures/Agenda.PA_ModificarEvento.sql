SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<2.0>
-- Creado pOr:				<Tatiana Flores>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite modificar un registro a [Agenda].[Evento].>
-- ===========================================================================================
-- Modificiación			<Jonathan Aguilar Navarro> <30/05/2018> <Se cambia el parametro  CodigoOficina por CodigoContexto>
-- =========================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<19/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente>
-- =========================================================================================================

CREATE PROCEDURE [Agenda].[PA_ModificarEvento]
	 @CodigoEvento Uniqueidentifier,
	 @CodigoContexto Varchar(4),
	 @NumeroExpediente Char(14) = null,
	 @Titulo Varchar(80),
	 @DescripciOn Varchar(300),
	 @CodigoTipoEvento SmallInt,
	 @CodigoEstadoEvento SmallInt,
	 @CodigoMotivoEvento SmallInt,
	 @CodigoPrioridadEvento SmallInt,	 
	 @RequiereSala Bit	
As
Declare

@Finalizado bit = 0

Begin

	Update	[AgEnda].[Evento]          
	Set	
	TC_CodContexto		=	@CodigoContexto, 
	TC_NumeroExpediente	=	@NumeroExpediente, 
	TC_Titulo			=	@Titulo, 
	TC_DescripciOn		=	@DescripciOn, 
	TN_CodTipoEvento	=	@CodigoTipoEvento, 
	TN_CodEstadoEvento	=	@CodigoEstadoEvento, 
	TN_CodMotivoEstado	=	@CodigoMotivoEvento, 
	TN_CodPriOridadEvento=	@CodigoPrioridadEvento,
	TB_RequiereSala		=	@RequiereSala,
	TF_Actualizacion    =   GetDate()				
	Where	
	[TU_CodEvento]		=	@CodigoEvento

	--Actualiza las fechas de eventos para que las cancele en caso de que el evento sea finalizado
	set @Finalizado =( select TB_FinalizaEvento
					   from Catalogo.EstadoEvento
					   where TN_CodEstadoEvento	=	@CodigoEstadoEvento)
    
	If (@Finalizado = 1)
	Begin 
		Update Agenda.FechaEvento 
		Set TB_Cancelada   = 1 
		Where TU_CodEvento = @CodigoEvento
		And TF_FechaInicio > Getdate()
	End
	
	--Libera las salas de juicio asociadas
	if (@RequiereSala = 0)
	Begin 
		Update Agenda.FechaEvento
		Set TN_CodSala     = null
		Where TU_CodEvento = @CodigoEvento
		And TF_FechaInicio > GetDate()
	End

End
GO
