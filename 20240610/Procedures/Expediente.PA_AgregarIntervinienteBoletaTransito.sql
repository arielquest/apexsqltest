SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<03/10/2019>
-- Descripción :			<Permite agregar un registro de boleta de tránsito a la tabla Expediente.IntervinienteBoletaTransito asociado al interviniente indicado> 
-- =================================================================================================================================================================
-- Modificación				<Ronny Ramírez Rojas> <22/10/2019> <Se corrige el SP para aumentar el tamaño del campo @Descripcion, pues estaba en 225 caracteres>
-- Modificación:			<22/01/2021> <Ronny Ramírez R.> <Se modifica parámetro @NumeroBoleta para que sea un varchar(25), en lugar de INT para que no haya 										
--										 problemas al recibir itineraciones de Gestión>
-- =================================================================================================================================================================
-- Modificación				<Fabian Sequeira> <22/02/2019> <Se corrige el SP para incluir datos adiconales>
-- Modificación:			<22/01/2021> <FabianSequeira >
--==================================================================================================================================================================
-- Modificación				<Gabriel Arnaez H.> <07/05/2024> <Se corrige el SP para incluir datos a la columna TF_Actualizacion>
--==================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteBoletaTransito] 
     @Codigo								uniqueidentifier,
     @CodInterviniente						uniqueidentifier,
	 @Placa									varchar(20),
	 @SerieBoleta 							smallint,
	 @NumeroBoleta 							varchar(25),
	 @Descripcion							varchar(255)	NULL, 
	 @FechaBoleta							datetime2(7)		= null,
	 @IdMarca								varchar(4)			= null,
	 @Marca									varchar(50)			= null,
	 @CodInspector							varchar(4)			= null,	 
	 @NombreInspector						varchar(82)			= null,
	 @EsVehiculoDetenido					bit					= null,
	 @VehiculoDepositado					varchar(50)			= null,
	 @Autoridad								varchar(35)			= null
As  
Begin
  
  	Insert Into Expediente.IntervinienteBoletaTransito 
			(	
				TU_CodBoletaTransito,	TU_CodInterviniente,	TC_Placa,
				TN_SerieBoleta,			TN_NumeroBoleta,		TC_Descripcion,
				TF_FechaBoleta, 		TN_CodMarcaVehiculo,	TC_Marca,				
				TC_CodInspector,		TC_NombreInspector,		TB_VehiculoDetenido,	
				TC_VehiculoDepositado, 	TC_AutoridadRegistra,	TF_Actualizacion,
				TB_Cargado
			) 	
	Values	(	
				@Codigo,				@CodInterviniente,		@Placa,
				@SerieBoleta,			@NumeroBoleta,			@Descripcion,
				@FechaBoleta,			@IdMarca,				@Marca,					
				@CodInspector,			@NombreInspector,		@EsVehiculoDetenido,		
				@VehiculoDepositado,	@Autoridad,				GETDATE(),
				0
			)
End
GO
