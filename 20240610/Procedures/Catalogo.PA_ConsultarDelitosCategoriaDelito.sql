SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<25/08/2015>
-- Descripción :			<Permite Consultar delitos de una categoria de delito
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================

  
CREATE PROCEDURE [Catalogo].[PA_ConsultarDelitosCategoriaDelito]
	@CodCategoriaDelito varchar(4)		
 As
 Begin
	select		TN_CodDelito          as  Codigo,
				TC_Descripcion        as  Descripcion,
				TF_Inicio_Vigencia    as  FechaActivacion,
				TF_Fin_Vigencia       as  FechaVencimiento
	From		Catalogo.Delito
	Where		TN_CodCategoriaDelito = @CodCategoriaDelito 
	and			TF_Fin_Vigencia Is Null
	Order By	TC_Descripcion;
End
GO
