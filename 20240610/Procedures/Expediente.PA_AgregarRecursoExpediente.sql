SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================================================================== 
-- Versión:				<1.1> 
-- Creado por:			<Jonathan Aguilar Navarro> 
-- Fecha de creación:	<11/11/2019> 
-- Descripción:			<Permite agregar un registro en la tabla: RecursoExpediente.> 
-- ================================================================================================================================================================================== 
-- Modificación:		<07/05/2020> <Jonathan Aguilar Navarro> <Se agrega el campo TC_CodContextoOrigen>
-- Modificación:		<20/01/2021> <Aida Elena Siles R> <Se cambia el tipo de dato del parámetro @ClaseAsunto por int, ya que se cambio en la tabla catalogo>
-- Modificación:		<19/07/2022> <Aaron Rios Retana> <Se agrega el campo codlegajo para asociar el recurso a un legajo>
-- ================================================================================================================================================================================== 

CREATE Procedure [Expediente].[PA_AgregarRecursoExpediente]  
@Recurso					uniqueidentifier,  
@ClaseAsunto				int,  
@ContextoOrigen				varchar(4), 
@ContextoDestino			varchar(4),   
@TipoIntervencion			smallint, 
@NumeroExpediente			char(14),  
@MotivoItineracion			smallint,  
@EstadoItineracion			smallint, 
@Resolucion					uniqueidentifier,  
@FechaCreacion				datetime2(3),  
@FechaEnvio					datetime2(3)		= null,  
@FechaRecepcion				datetime2(3)		= null,  
@HistoricoItineracion		uniqueidentifier	= null,  
@ResultadoRecurso			uniqueidentifier	= null,  
@CodLegajo					uniqueidentifier	= null
 
 As Begin  

 --Variables  
 Declare 
 @L_TU_CodRecurso				uniqueidentifier	= @Recurso,    
 @L_TN_CodClaseAsunto			int					= @ClaseAsunto,
 @L_TC_CodContextoOrigen		varchar(4)			= @ContextoOrigen, 
 @L_TC_CodContextoDestino		varchar(4)			= @ContextoDestino,    
 @L_TN_CodTipoIntervencion		smallint			= @TipoIntervencion,    
 @L_TC_NumeroExpediente			char(14)			= @NumeroExpediente,    
 @L_TN_CodTipoItineracion		smallint			= @MotivoItineracion,    
 @L_TN_CodEstadoItineracion		smallint			= @EstadoItineracion, 
 @L_TU_CodResolucion			uniqueidentifier	= @Resolucion,    
 @L_TF_Fecha_Creacion			datetime2(3)		= @FechaCreacion,    
 @L_TF_Fecha_Envio				datetime2(3)		= @FechaEnvio,    
 @L_TF_Fecha_Recepcion			datetime2(3)		= @FechaRecepcion,
 @L_TU_CodLegajo				uniqueidentifier	= @CodLegajo
 
 --Cuerpo  
 Insert Into Expediente.RecursoExpediente With(RowLock)  
 (   
			TU_CodRecurso,     
			TN_CodClaseAsunto,    
			TC_CodContextoOrigen,
			TC_CodContextoDestino,   
			TN_CodTipoIntervencion,  
			TN_CodEstadoItineracion,      
			TC_NumeroExpediente,   
			TN_CodMotivoItineracion, 
			TU_CodResolucion,    
			TF_Fecha_Creacion,
			TU_CodLegajo
)  
 Values  
 (   
			@L_TU_CodRecurso,    
			@L_TN_CodClaseAsunto, 
			@L_TC_CodContextoOrigen,
			@L_TC_CodContextoDestino,   
			@L_TN_CodTipoIntervencion,   
			@L_TN_CodEstadoItineracion,   
			@L_TC_NumeroExpediente,   
			@L_TN_CodTipoItineracion,   
			@L_TU_CodResolucion,   
			@L_TF_Fecha_Creacion,
			@L_TU_CodLegajo
) 
 End
GO
