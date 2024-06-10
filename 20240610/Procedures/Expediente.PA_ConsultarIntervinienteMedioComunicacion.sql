SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<03/12/2015>
-- Descripción :			<Permite Consultar los domicilios de un interviniente.> 
-- Modificación:			<Andrés Díaz> <07-03-2016> <Se reordena la consulta, se agrega el campo tipo medio, se elimina la tabla interviniente.> 
-- Modificación:			<Andrés Díaz><14/03/2016><Se modifica el nombre del campo Tipo a Prioridad.>
-- Modificación:			<Donald Vargas Zúñiga><02/12/2016><Se corrige el nombre del campo TC_CodMedio a TN_CodMedio de acuerdo al tipo de dato en la tabla IntervinienteMedioComunicacion>
-- Modificación:			<Roger Lara><08/22/2017><Se agragan campos TG_UbicacionPunto y TN_CodHorario a  IntervinienteMedioComunicacion>
-- Modificación:			<Andrés Díaz><24/08/2017><Se modifica para que se pueda consultar por legajo.>
-- Modificación:			<Andrés Díaz><11/09/2017><Se modifica para que devuelva el código del interviniente asociado.>
-- Modificación:			<Andrés Díaz> <22/05/2018> <Se optimiza la consulta.>
-- Modificación:			<Juan Ramírez V> <24/09/2018> <Se modifica la estructura debido al cambio de interviniente a intervenciones>
-- Modificación:			<Isaac Dobles Mata> <17/06/2019> <Se modifica TN_Prioridad por TN_PrioridadExpediente>
-- Modificación:			<Isaac Dobles Mata> <17/09/2019> <Se agrega parámetro PerteneceExpediente>
-- Modificación:			<Karol Jiménez S.> <09/03/2021> <Se agregan paréntesis en condición PerteneceExpediente, para evitar resultados incorrectos en la consulta>
-- Modificación:			<Luis Alonso Leiva Tames> <06/06/2023> <PBI:298963 Se modifica el left de la consulta de Barrio ya que se duplicaban datos>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteMedioComunicacion]
	@CodInterviniente		uniqueidentifier = Null,
	@NumeroExpediente		varchar(14) = Null
AS
BEGIN

	DECLARE @TempCodigo AS TABLE
	(
		Codigo UNIQUEIDENTIFIER NOT NULL
	);

	If (@CodInterviniente Is Not Null And @NumeroExpediente Is Null)
	Begin
		Insert Into	@TempCodigo
		Select		A.TU_CodMedioComunicacion
		From		Expediente.IntervencionMedioComunicacion	As A With(NoLock)
		Where		A.TU_CodInterviniente						= @CodInterviniente
		AND			(A.TB_PerteneceExpediente					= 1
			OR		A.TB_PerteneceExpediente					IS NULL);
	End
	Else If (@CodInterviniente Is Null And @NumeroExpediente Is Not Null)
	Begin
		Insert Into	@TempCodigo
		Select		A.TU_CodMedioComunicacion
		From		Expediente.IntervencionMedioComunicacion	As A With(NoLock)
		Inner Join	Expediente.Intervencion						As B With(NoLock)
		On			B.TU_CodInterviniente						= A.TU_CodInterviniente
		Where		B.TC_NumeroExpediente						= @NumeroExpediente
		AND			(A.TB_PerteneceExpediente					= 1
			OR		A.TB_PerteneceExpediente					IS NULL);
	End
	Else If (@CodInterviniente Is Not Null And @NumeroExpediente Is Not Null)
	Begin
		Insert Into	@TempCodigo
		Select		A.TU_CodMedioComunicacion
		From		Expediente.IntervencionMedioComunicacion	As A With(NoLock)
		Inner Join	Expediente.Intervencion						As B With(NoLock)
		On			B.TU_CodInterviniente						= A.TU_CodInterviniente
		Where		A.TU_CodInterviniente						= @CodInterviniente
		And			B.TC_NumeroExpediente						= @NumeroExpediente
		AND			(A.TB_PerteneceExpediente					= 1
			OR			A.TB_PerteneceExpediente				IS NULL);
	End

	Select		A.TU_CodMedioComunicacion					As CodigoMedio,	
				A.TC_Valor									As Valor,						
				A.TC_Rotulado								As Rotulado,
				A.TU_CodInterviniente						As CodigoInterviniente,
				A.TB_PerteneceExpediente					As PerteneceExpediente,
				'Split1'									As Split1,
				H.TN_CodBarrio								As Codigo,				
				H.TC_Descripcion							As Descripcion,
				'Split2'									As Split2,
				B.TN_CodDistrito							As Codigo,			
				B.TC_Descripcion							As Descripcion,
				'Split3'									As Split3,
				C.TN_CodCanton								As Codigo,				
				C.TC_Descripcion							As Descripcion,
				'Split4'									As Split4,
				D.TN_CodProvincia							As Codigo,		
				D.TC_Descripcion							As Descripcion,
				'Split5'									As Split5,
				E.TN_CodMedio								As Codigo,	
				E.TC_Descripcion							As Descripcion,
				'Split6'									As Split6,
				A.TN_PrioridadExpediente					As PrioridadExpediente,
				E.TC_TipoMedio								As TipoMedio,
				F.TN_CodHorario								As CodigoHorario,	
				F.TC_Descripcion							As DescripcionHorario,
				A.TG_UbicacionPunto.Lat						As Latitud,
				A.TG_UbicacionPunto.Long					As Longitud		
	From		Expediente.IntervencionMedioComunicacion	As A With(NoLock)	
	Left Join	Catalogo.Distrito							As B With(NoLock)
	On			A.TN_CodDistrito							= B.TN_CodDistrito 
	And			A.TN_CodCanton								= B.TN_CodCanton
	And			A.TN_CodProvincia							= B.TN_CodProvincia
	Left Join	Catalogo.Canton								As C With(NoLock)	
	On			A.TN_CodCanton								= C.TN_CodCanton
	And			A.TN_CodProvincia							= C.TN_CodProvincia
	Left Join	Catalogo.Provincia							As D With(NoLock) 
	On			A.TN_CodProvincia							= D.TN_CodProvincia
	Left Join	Catalogo.Barrio								As H With(NoLock) 
	On			A.TN_CodBarrio								= H.TN_CodBarrio
	AND			A.TN_CodCanton								= H.TN_CodCanton
	AND			A.TN_CodDistrito							= H.TN_CodDistrito
	AND			A.TN_CodProvincia							= H.TN_CodProvincia	
	Inner Join	Catalogo.TipoMedioComunicacion				As E With(NoLock) 
	On			A.TN_CodMedio								= E.TN_CodMedio
	Left Join	Catalogo.HorarioMedioComunicacion			As F With(NoLock) 
	On			A.TN_CodHorario								= F.TN_CodHorario
	Inner Join	@TempCodigo									As G
	On			G.Codigo									= A.TU_CodMedioComunicacion
END

GO
