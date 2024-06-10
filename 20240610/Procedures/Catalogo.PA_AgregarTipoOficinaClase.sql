SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite Agregar una clase asunto a un tipo de oficina>
-- Modificado:				<Alejandro Villalta><17/12/2015><Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificado:				<Alejandro Villalta Ruiz><18/12/2015><Autogenerar el codigo del tipo de oficina>
-- Modificado:				<Jefry Hernández><12/07/2017>< Se agrega la materia >
-- Modificado:				<Johan Acosta Ibañez><05/11/2018><Se agrega el campo CostasPersonales>
-- Modificación				<Jonathan Aguilar Navarro> <31/01/2018> < Se cambia nombre al sp y se cambio nombre de la tabla TipoOficinaClaseAsunto por ClaseTipoOficina> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoOficinaClase]
   @CodTipoOficina		Smallint,
   @CodClase			Int,
   @FechaActivacion		Datetime2(7), 
   @CodMateria			Varchar(5),
   @CostasPersonales	Bit
AS 
    BEGIN          
			INSERT INTO Catalogo.ClaseTipoOficina
			(
				TN_CodTipoOficina, TN_CodClase, TF_Inicio_Vigencia,	TC_CodMateria, TB_CostasPersonales
			)
			VALUES
			(
				@CodTipoOficina,	@CodClase,	@FechaActivacion,	@CodMateria,	@CostasPersonales
			)
    END
 
GO
