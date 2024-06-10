SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<10/03/2016>
-- Descripción :			<Permite modificar un medio de comunicacion de un interviniente.>
-- Modificación:			<Andrés Díaz><14/03/2016><Se modifica el nombre del campo Tipo a Prioridad. Se modifica la llave primaria de la tabla.>
-- Modificación:			<Johan Acosta Ibañez><30/09/2016><Se agrega la tabla Jornada Laboral.>
-- Modificación:			<Donald Vargas Zúñiga><02/12/2016><Se corrige el nombre del campo TC_CodMedio a TN_CodMedio de acuerdo al tipo de dato y se elimina referencia al campo TN_CodJornadaLaboral porque no existe en la tabla>
-- Modificación:			<Andrés Díaz><19/01/2017><Se elimina el parametro CodJornadaLaboral.>
-- Modificación:			<Roger Lara><08/02/2017><Se agrega campos TG_UbicacionPunto y TN_CodHorario.>
-- Modificación:            <Pablo Alvarez><11/05/2017><Se hace un if para validar si la ubicacion geo viene nula.>
-- Modificación:			<Juan Ramírez V> <24/09/2018> <Se modifica la estructura debido al cambio de interviniente a intervenciones>
-- Modificación:			<Isaac Dobles> <27/06/2019> <Se modifica la estructura para que actualice sólo los datos que vengan en los parámetros>
-- Modificación:			<Isaac Dobles Mata> <17/09/2019> <Se agrega parámetro PerteneceExpediente>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarIntervinienteMedioComunicacion] 
	@CodMedioComunicacion	uniqueidentifier,
	@CodInterviniente		uniqueidentifier, 
	@Prioridad				smallint, 
	@CodMedio				smallint,
	@Valor					varchar(350),
	@CodProvincia			smallint,
	@CodCanton				smallint,
	@CodDistrito			smallint,
	@CodBarrio				smallint,
	@Rotulado				varchar(255),
	@CodHorario				Smallint= NULL,
	@Latitud				float= NULL,
	@Longitud				float= NULL,
	@PerteneceExpediente	bit

AS
BEGIN
   if @Latitud is not null
	Update	Expediente.IntervencionMedioComunicacion
	Set		
			TU_CodInterviniente		= COALESCE(@CodInterviniente,TU_CodInterviniente),
			TN_PrioridadExpediente	= COALESCE(@Prioridad,TN_PrioridadExpediente),
			TN_CodMedio				= COALESCE(@CodMedio,TN_CodMedio),
			TC_Valor				= COALESCE(@Valor, TC_Valor),
			TN_CodProvincia			= COALESCE(@CodProvincia, TN_CodProvincia),
			TN_CodCanton			= COALESCE(@CodCanton, TN_CodCanton), 
			TN_CodDistrito			= COALESCE(@CodDistrito, TN_CodDistrito),
			TN_CodBarrio			= COALESCE(@CodBarrio,TN_CodBarrio),
			TC_Rotulado				= COALESCE(@Rotulado, TC_Rotulado),
			TF_Actualizacion		= GETDATE(),
			TN_CodHorario			= COALESCE(@CodHorario, TN_CodHorario),
			TG_UbicacionPunto		= geography::Point(@Latitud,@Longitud,4326),
			TB_PerteneceExpediente	= COALESCE(@PerteneceExpediente, TB_PerteneceExpediente)

	Where	TU_CodMedioComunicacion	= @CodMedioComunicacion;
  else
    Update	Expediente.IntervencionMedioComunicacion
	Set		
			TU_CodInterviniente		= COALESCE(@CodInterviniente,TU_CodInterviniente),
			TN_PrioridadExpediente	= COALESCE(@Prioridad,TN_PrioridadExpediente),
			TN_CodMedio				= COALESCE(@CodMedio,TN_CodMedio),
			TC_Valor				= COALESCE(@Valor, TC_Valor),
			TN_CodProvincia			= COALESCE(@CodProvincia, TN_CodProvincia),
			TN_CodCanton			= COALESCE(@CodCanton, TN_CodCanton), 
			TN_CodDistrito			= COALESCE(@CodDistrito, TN_CodDistrito),
			TN_CodBarrio			= COALESCE(@CodBarrio,TN_CodBarrio),
			TC_Rotulado				= COALESCE(@Rotulado, TC_Rotulado),
			TF_Actualizacion		= GETDATE(),
			TN_CodHorario			= @CodHorario,
			TB_PerteneceExpediente	= COALESCE(@PerteneceExpediente, TB_PerteneceExpediente)
	Where	TU_CodMedioComunicacion	= @CodMedioComunicacion;
END



GO
