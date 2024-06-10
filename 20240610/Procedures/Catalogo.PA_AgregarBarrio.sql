SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


/*  OBJETO      : PA_AgregarBarrio. 
**  DESCRIPCION : Permitir agregar registro en la tabla de Barrio.                   
**  VERSION     : 1.0           
**  CREACION    : 10/11/2015
**  AUTOR       : Johan Acosta. 
--
-- Modificación : <Andrés Díaz><19/12/2016><Se agrega el campo TG_UbicacionPunto.>
*/
  
 CREATE PROCEDURE [Catalogo].[PA_AgregarBarrio]
	@CodigoProvincia	smallint,
	@CodigoCanton		smallint,
	@CodigoDistrito		smallint,
	@Descripcion		varchar(255),
	@Latitud			float			= Null,
	@Longitud			float			= Null,
	@FechaActivacion	datetime2,
	@FechaVencimiento	datetime2
As
Begin
	Insert into [Catalogo].[Barrio]
		(TN_CodProvincia,
		TN_CodCanton,
		TN_CodDistrito,
		TC_Descripcion,
		TG_UbicacionPunto,
		TF_Inicio_Vigencia,
		TF_Fin_Vigencia)
	Values 
		(@CodigoProvincia
		,@CodigoCanton
		,@CodigoDistrito
		,@Descripcion
		,Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null)
		,@FechaActivacion
		,@FechaVencimiento)
 
End
GO
