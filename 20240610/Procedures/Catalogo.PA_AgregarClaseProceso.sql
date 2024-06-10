SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Agregar procedimientos a una clases asunto> 
-- Modificado:				<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificado:				<Isaac Dobles><04/02/2019><Se modifica para que ahora direccione a la tabla Catalogo.ClaseProceso>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarClaseProceso]
   @CodClase int,
   @CodProceso smallint,
   @Inicio_Vigencia datetime2(7)
AS 
    BEGIN          
			INSERT INTO Catalogo.ClaseProceso
			(
			TN_CodClase, TN_CodProceso, TF_Inicio_Vigencia 
			)
			VALUES
			(
			@CodClase,	@CodProceso,	@Inicio_Vigencia
			)
    END

GO
