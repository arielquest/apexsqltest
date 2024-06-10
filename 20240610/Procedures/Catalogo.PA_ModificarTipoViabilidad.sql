SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
 -- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Olger Gamboa>
-- Fecha de creación:	<07/08/2015>
-- Descripción :		<Permitir actualizar registro en la tabla tipo viabilidad>
-- =================================================================================================================================================
-- Modificación: <02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodTipoViabilidad a TN_CodTipoViabilidad de acuerdo al tipo de dato.>
-- ================================================================================================================================================= 
 CREATE PROCEDURE [Catalogo].[PA_ModificarTipoViabilidad]
 @CodTipoViabilidad smallint,
 @Descripcion varchar(255),
 @FinVigencia datetime2=null
 As
 Begin
 
   Update Catalogo.TipoViabilidad
	set TC_Descripcion=@Descripcion,
		TF_Fin_Vigencia= @FinVigencia
	Where TN_CodTipoViabilidad=@CodTipoViabilidad
 End 
GO
