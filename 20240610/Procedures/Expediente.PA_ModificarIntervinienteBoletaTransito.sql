SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<08/10/2019>
-- Descripción :			<Permite modificar un registro de boleta de tránsito en Expediente.IntervinienteBoletaTransito asociado al interviniente indicado> 
-- =================================================================================================================================================================
-- Modificación				<Ronny Ramírez Rojas> <22/10/2019> <Se corrige el SP para aumentar el tamaño del campo @Descripcion, pues estaba en 225 caracteres>
-- Modificación				<Fabian Sequeira > <22/02/2019> <Se agregan datos adicionales a la boleta de transito>
-- Modificación				<Gabriel Arnaez H.> <07/05/2024> <Se corrige el SP para incluir datos a la columna TF_Actualizacion y TB_Cargado>
-- =================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarIntervinienteBoletaTransito] 
     @Codigo								uniqueidentifier,
	 @Placa									varchar(20),	 
	 @Descripcion							varchar(255) = NULL,
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
  
   	UPDATE Expediente.IntervinienteBoletaTransito 	
	SET
		TC_Placa										= @Placa,	
		TC_Descripcion									= @Descripcion,	
		TF_FechaBoleta									=@FechaBoleta,
		TN_CodMarcaVehiculo								= @IdMarca,
		TC_Marca										=@Marca,
		TC_CodInspector									=@CodInspector,
		TC_NombreInspector								=@NombreInspector,
		TB_VehiculoDetenido								=@EsVehiculoDetenido,
		TC_VehiculoDepositado							=@VehiculoDepositado,
		TC_AutoridadRegistra							=@Autoridad,
		TF_Actualizacion								=GETDATE(),
		TB_Cargado										=0
	WHERE
		TU_CodBoletaTransito							= @Codigo  
End
GO
