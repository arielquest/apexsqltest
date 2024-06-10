SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================================================================================================
-- Versión:						<1.0>
-- Creado por:					<Andrew Allen Dawson>
-- Fecha de creación:			<08/07/2020>
-- Descripción :				<Inserta un nuevo escrito> 
-- =====================================================================================================================================================
-- Modificación:			<Andrew Allen Dawson> <24/07/2020> <Se cambia para retornar el ID del nuevo escrito>
-- Modificación:			<Jonathan Aguilar Navarro> <20/08/2020> <Se agrega parametro del código de escrito para que no genere uno nuevo.> 
-- Modificación:			<Jonathan Aguilar Navarro> <20/10/2020> <Se corrige, ya que se estaba pasando mal el parametro de CodigoEscrito> 
-- Modificación:			<Isaac Dobles Mata> <22/02/2021> <Se incorpora IDACO para las itineraciones hacia SIAGPJ>
-- Modificacion:			<Mario Camacho Flores> <17/06/2022> <Se agrega la fecha de ingreso de oficina y la fecha de registro que vienen del escrito>
-- Modificación:			<Josué Quirós Batista> <01/03/2023> <Modificación para mantener la fecha de ingreso a la oficina tras recibir un expediente itinerado.
--							<Nota 22/03/2023> <Durante el merge las versiones 2.4.5.0 y la 2.5.0.0 se identifica que el ajuste de Mario C. del 17/06/2022 tienen el mismo objetivo que las
--							 realizadas el 01/03/2023. Se mantendrán los ajustes realizados por Mario.>
-- =====================================================================================================================================================


CREATE PROCEDURE [Expediente].[PA_AgregarEscritoExpediente]
	@CodigoEscrito			uniqueidentifier,
	@CodPuestoTrabajo		varchar(14),
	@NumeroExpediente		char(14),
	@CodTipoEscrito			smallint,
	@CodContexto			varchar(4),
	@CodEntrega				varchar(12),
	@Descripcion			varchar(255),
	@FechaIngresoOficina    datetime2(2),
	@IDARCHIVO				uniqueidentifier,
	@FechaEnvio				datetime2(2),
	@EstadoEscrito			varchar(1),
	@FechaRegistro          datetime2(2),
	@Consecutivo			int,
	@VariasGestiones		bit,
	@IDACO					int = null
AS
BEGIN
			
	DECLARE @L_CodPuestoTrabajo		varchar(14)			=	@CodPuestoTrabajo,		
			@L_NumeroExpediente		char(14)			=	@NumeroExpediente,		
			@L_CodTipoEscrito		smallint			=	@CodTipoEscrito,			
			@L_CodContexto			varchar(4)			=	@CodContexto,			
			@L_CodEntrega			varchar(12)			=	@CodEntrega,				
			@L_Descripcion			varchar(255)		=	@Descripcion,	
			@L_FechaIngresoOficina  datetime2(2)        =   @FechaIngresoOficina, 
			@L_IDARCHIVO			uniqueidentifier	=	@IDARCHIVO,				
			@L_FechaEnvio			datetime2(2)		=	@FechaEnvio,				
			@L_EstadoEscrito		varchar(1)			=	@EstadoEscrito,				
			@L_FechaRegistro		datetime2(2)		=	@FechaRegistro,				
			@L_Consecutivo			int					=	@Consecutivo,			
			@L_VariasGestiones		bit					=	@VariasGestiones,
			@L_CodEscrito			uniqueidentifier	=	@CodigoEscrito,
			@L_IDACO				int					=	@IDACO
	
	IF (@L_FechaIngresoOficina is null)
	BEGIN
		SET @L_FechaIngresoOficina = GETDATE();	
	END;

	IF (@L_FechaRegistro is null)
	BEGIN
		SET @L_FechaRegistro = GETDATE();
	END;

	INSERT INTO [Expediente].[EscritoExpediente]
	           ([TU_CodEscrito]
	           ,[TC_CodPuestoTrabajo]
	           ,[TC_NumeroExpediente]
	           ,[TN_CodTipoEscrito]
	           ,[TC_CodContexto]
	           ,[TC_CodEntrega]
	           ,[TC_Descripcion]
	           ,[TF_FechaIngresoOficina]
	           ,[TC_IDARCHIVO]
	           ,[TF_FechaEnvio]
	           ,[TC_EstadoEscrito]
	           ,[TF_FechaRegistro]
	           ,[TN_Consecutivo]
	           ,[TB_VariasGestiones],
			   [IDACO])
	     VALUES
	           (@L_CodEscrito		
	           ,@L_CodPuestoTrabajo		
	           ,@L_NumeroExpediente		
	           ,@L_CodTipoEscrito		
	           ,@L_CodContexto			
	           ,@L_CodEntrega			
	           ,@L_Descripcion			
	           ,@L_FechaIngresoOficina	
	           ,@L_IDARCHIVO			
	           ,@L_FechaEnvio			
	           ,@L_EstadoEscrito		
	           ,@L_FechaRegistro		
	           ,@L_Consecutivo			
	           ,@L_VariasGestiones
			   ,@L_IDACO)	
			   
	SELECT @L_CodEscrito
END


GO
