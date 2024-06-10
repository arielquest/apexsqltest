SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<17/08/2015>
-- Descripción :			<Permite Agregar procedimientos a una clases asunto> 
-- Modificado:				<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a int>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarClaseAsuntoProcedimiento]
   @CodClaseAsunto int,
   @CodProcedimiento smallint,
   @Inicio_Vigencia datetime2(7)
AS 
    BEGIN          
			INSERT INTO Catalogo.ClaseAsuntoProcedimiento
			(
			TN_CodClaseAsunto, TC_CodProcedimiento, TF_Inicio_Vigencia 
			)
			VALUES
			(
			@CodClaseAsunto,	@CodProcedimiento,	@Inicio_Vigencia
			)
    END
 


GO
