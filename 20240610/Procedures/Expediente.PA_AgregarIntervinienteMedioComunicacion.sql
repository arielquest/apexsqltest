SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Roger Lara>
-- Fecha de creación:	<30/10/2015>
-- Descripción :		<Permite Agregar un Medio de Comunicacion a un interviniente 
-- =================================================================================================================================================
-- Modificacion:		<Alejandro Villalta><11/01/2016><Modificar el tipo de dato del codigo de medio de comunicacion.> 
-- Modificación:		<Andrés Díaz><14/03/2016><Se modifica el nombre del campo Tipo a Prioridad.>
-- Modificación:		<Johan Acosta Ibañez><30/09/2016><Se agrega el campo Jornada Laboral.>
-- Modificación:		<Donald Vargas Zúñiga><02/12/2016><Se corrige el nombre del campo TC_CodMedio a TN_CodMedio de acuerdo al tipo de dato y se elimina referencia al campo TN_CodJornadaLaboral porque no existe en la tabla>
-- Modificación:		<Andrés Díaz><19/01/2017><Se elimina el parametro CodJornadaLaboral.>
-- Modificación:		<Roger Lara><08/02/2017><Se agrego campos TN_CodHorario y TG_UbicacionPunto.>
-- Modificación:		<Juan Ramírez V> <24/09/2018> <Se modifica la estructura debido al cambio de interviniente a intervenciones>
-- Modificación:		<Isaac Dobles Mata> <17/09/2019> <Se agrega parámetro PerteneceExpediente>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteMedioComunicacion] 
	@CodMedioComunicacion	uniqueidentifier,		
	@CodInterviniente		uniqueidentifier, 
	@CodMedio				smallint, 
	@Prioridad				smallint,
	@Valor					varchar(350),
	@CodProvincia			smallint=NULL,
	@CodCanton				smallint=NULL,
	@CodDistrito			smallint=NULL,
	@Rotulado				varchar(255),
	@CodBarrio				smallint,
	@CodHorario				Smallint= NULL,
	@Latitud				float= NULL,
	@Longitud				float= NULL,
	@PerteneceExpediente	bit=true
AS
BEGIN

 if @Latitud is not null
	INSERT INTO Expediente.IntervencionMedioComunicacion
	(
		TU_CodMedioComunicacion,	TU_CodInterviniente,	TN_CodMedio,	TN_PrioridadExpediente,	
		TC_Valor,					TN_CodProvincia,		TN_CodCanton,	TN_CodDistrito,		
		TC_Rotulado,TN_CodBarrio,	TN_CodHorario,			TG_UbicacionPunto,	TB_PerteneceExpediente
	)
	VALUES
	(
		@CodMedioComunicacion,		@CodInterviniente,		@CodMedio,		@Prioridad,
		@Valor,						@CodProvincia,			@CodCanton,		@CodDistrito,
		@Rotulado,					@CodBarrio,				@CodHorario,	geography::Point(@Latitud,@Longitud,4326),
		@PerteneceExpediente
	)
else
	INSERT INTO Expediente.IntervencionMedioComunicacion
		(
			TU_CodMedioComunicacion,	TU_CodInterviniente,	TN_CodMedio,	TN_PrioridadExpediente,	
			TC_Valor,					TN_CodProvincia,		TN_CodCanton,	TN_CodDistrito,		
			TC_Rotulado,TN_CodBarrio,	TN_CodHorario,			TB_PerteneceExpediente			
		)
		VALUES
		(
			@CodMedioComunicacion,		@CodInterviniente,		@CodMedio,		@Prioridad,
			@Valor,						@CodProvincia,			@CodCanton,		@CodDistrito,
			@Rotulado,					@CodBarrio,				@CodHorario,	@PerteneceExpediente	
		)

END

GO
