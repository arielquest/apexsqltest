SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<13/08/2015>
-- Descripción :			<Permite Consultar ubicacines de un despacho 
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarUbicacionesOficina]

@CodOficina varchar(4)
			
 As
 Begin
	select		TN_CodUbicacion    as  Codigo,
				TC_Descripcion     as  Descripcion,
				TF_Inicio_Vigencia as  FechaActivacion,
				TF_Fin_Vigencia    as  FechaVencimiento
	From		Catalogo.Ubicacion
	Where		TN_CodUbicacion in (select TN_CodUbicacion 
									FROM Catalogo.OficinaUbicacion 
									Where TC_CodOficina= @CodOficina )
	Order By	TC_Descripcion;
End
GO
