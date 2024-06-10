SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<15/03/2017>
-- Descripción:				<Permite modificar ciertos campos de una comunicación, solo los indicados en parámetros.> 
-- ====================================================================================================================================================
-- Modificación:            <18/03/2017> <Diego Navarrete A.> <Se agregarón nuevos campos a la modificación>		
-- Modificación:            <11/02/2017> <Jeffry Hernández.> <Se agrega condicional al insertar el campo sector>
-- Modificación				<28/05/2018> <Jonathan Aguilar Navarro> <Se cambia el parametro CodOficinaOCJ por CodContextoOCJ>
-- Modificación:			<28/10/2021> <Isaac Dobles Mata>  <Se agregan parámetros @ExcluidaAppMovil y @ComunicacionAppMovil>
-- Modificación				<01/12/2021> <Isaac Dobles Mata> <Se agrega parámetros TN_IdNotiEntidadJuridica e TN_IdActaEntidadJuridica,>
-- ====================================================================================================================================================

CREATE PROCEDURE [Comunicacion].[PA_ModificarComunicacion]
(
	@CodigoComunicacion		uniqueidentifier,
	@HorarioMedio			smallint,
	@TienePrioridad			bit,
	@RequiereCopias			bit,
	@Revisado				bit,
	@Sector					int,
	@Observaciones			varchar(255),
	@FechaResolucion		datetime = Null,
	@CodigoMedio			smallint,
	@Valor					varchar(350)  = Null,
	@Prioridad				smallint = Null,
	@Rotulado				varchar (255) = Null, 
	@CodProvincia			int = NULL,
	@CodCanton				int = NULL,
	@CodDistrito			int = NULL,
	@CodBarrio				int = NULL,	
	@Latitud				float = Null,
	@Longitud				float = Null,
	@CodContextoOCJ			Varchar(4) = Null,
	@ComunicacionAppMovil	bit = 0,
	@ExcluidaAppMovil		bit = 0,
	@IdNotiEntidadJuridica	bigint = Null,
	@IdActaEntidadJuridica	bigint = Null
)
AS
BEGIN

	SELECT @Revisado = CASE WHEN C.[TB_Revisado] = 1 THEN C.[TB_Revisado] ELSE @Revisado END,
	@ExcluidaAppMovil = CASE WHEN C.[TB_ExcluidaAppMovil] = 1 THEN C.[TB_ExcluidaAppMovil] ELSE @ExcluidaAppMovil END,
	@ComunicacionAppMovil = CASE WHEN C.[TB_ComunicacionAppMovil] = 1 THEN C.[TB_ComunicacionAppMovil] ELSE @ComunicacionAppMovil END
	FROM [Comunicacion].[Comunicacion] C
	WHERE
		C.[TU_CodComunicacion]	= @CodigoComunicacion
	
	IF @CodContextoOCJ Is Null
		UPDATE [Comunicacion].[Comunicacion]
		SET [TN_CodHorarioMedio]		= @HorarioMedio,
			[TC_Observaciones]			= @Observaciones,
			[TB_Revisado]				= @Revisado,
			[TN_CodSector]				= @Sector,
			[TF_Actualizacion]			= GETDATE(),	
			[TC_CodMedio]				= @CodigoMedio,
			[TB_ExcluidaAppMovil]		= @ExcluidaAppMovil,
			[TB_ComunicacionAppMovil]	= @ComunicacionAppMovil,
			[TN_IdNotiEntidadJuridica]	= @IdNotiEntidadJuridica,
			[TN_IdActaEntidadJuridica]	= @IdActaEntidadJuridica
		WHERE
			[TU_CodComunicacion]	= @CodigoComunicacion
	ELSE
		UPDATE [Comunicacion].[Comunicacion]
		SET [TN_CodHorarioMedio]		= @HorarioMedio,
			[TB_TienePrioridad]			= @TienePrioridad,
			[TB_RequiereCopias]			= @RequiereCopias,
			[TC_Observaciones]			= @Observaciones,
			[TB_Revisado]				= @Revisado,
			[TF_Actualizacion]			= GETDATE(),
			[TF_FechaResolucion]		= @FechaResolucion,
			[TC_CodMedio]				= @CodigoMedio,
			[TC_Valor]					= @Valor,
			[TN_PrioridadMedio]			= @Prioridad,
			[TC_Rotulado]				= @Rotulado,
			[TN_CodProvincia]			= @CodProvincia,                  
			[TN_CodCanton]				= @CodCanton,
			[TN_CodDistrito]			= @CodDistrito,                     
			[TN_CodBarrio]				= @CodBarrio,
			[TC_CodContextoOCJ]			= @CodContextoOCJ,
			[TN_IdNotiEntidadJuridica]	= @IdNotiEntidadJuridica,
			[TN_IdActaEntidadJuridica]	= @IdActaEntidadJuridica,
			[TG_UbicacionPunto]     = Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null),                
			[TN_CodSector]          = Iif(@Sector Is Not Null,@Sector, Comunicacion.FN_ConsultarSectorComunicacion(  Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null),@CodContextoOCJ)),
			[TB_ExcluidaAppMovil]	= @ExcluidaAppMovil,
		[TB_ComunicacionAppMovil]	= @ComunicacionAppMovil
		WHERE
			[TU_CodComunicacion]	= @CodigoComunicacion
END
GO
