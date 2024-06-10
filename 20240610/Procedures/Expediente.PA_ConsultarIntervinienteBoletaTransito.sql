SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<03/10/2019>
-- Descripción :			<Permite consultar el registro único, en caso de existir, de la tabla Expediente.IntervinienteBoletaTransito asociado al interviniente indicado> 
-- =============================================================================================================================================================================
-- Modificación:			<22/01/2021> <Ronny Ramírez R.> <Se modifica parámetro @NumeroBoleta para que sea un varchar(25), en lugar de INT para que no haya problemas
--										 al recibir itineraciones de Gestión>
-- =============================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteBoletaTransito] 
     @Codigo								uniqueidentifier	= null,
     @CodInterviniente						uniqueidentifier	= null,
	 @Placa									varchar(20)			= null,
	 @SerieBoleta							smallint			= null,	 
	 @NumeroBoleta							varchar(25)			= null
	 
As  
Begin
	
	Select	Distinct	  
			
		B.TU_CodBoletaTransito					As	Codigo,		
		B.TC_Placa								As	Placa,
		B.TN_SerieBoleta						As	SerieBoleta,
		B.TN_NumeroBoleta						As	NumeroBoleta,
		B.TC_Descripcion						As	Descripcion,
		B.TF_FechaBoleta						As FechaBoleta,
		B.TC_Marca								As Marca,
		B.TC_CodInspector						As CodInspector,
		B.TC_NombreInspector					As NombreInspector,
		B.TB_VehiculoDetenido					As EsVehiculoDetenido,
		B.TC_VehiculoDepositado					As VehiculoDepositado,
		B.TC_AutoridadRegistra					As Autoridad,
		'SplitInterviniente'					As	SplitInterviniente,
		B.TU_CodInterviniente					As	CodigoInterviniente		

	From		Expediente.IntervinienteBoletaTransito		As	B	WITH (NOLOCK)			

	Where       B.TU_CodBoletaTransito						=	Coalesce(@Codigo, B.TU_CodBoletaTransito) 				
	AND			B.TU_CodInterviniente						=	Coalesce(@CodInterviniente, B.TU_CodInterviniente)
	AND			B.TC_Placa									=	Coalesce(@Placa, B.TC_Placa)
	AND			B.TN_SerieBoleta							=	Coalesce(@SerieBoleta, B.TN_SerieBoleta)
	AND			B.TN_NumeroBoleta							=	Coalesce(@NumeroBoleta, B.TN_NumeroBoleta)	
	
End
GO
