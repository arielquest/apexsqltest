SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/*  OBJETO      : PA_AgregarTipoLicencia. 
**  DESCRIPCION : Permitir agregar registro en la tabla de TipoLicencia.                   
**  VERSION     : 1.0           
**  CREACION    : 16/09/2015
**  AUTOR       : Johan Acosta. 
--
-- Modificación:	<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 150.>
*/
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoLicencia]
	@Descripcion			varchar(150),
	@FechaActivacion		datetime2,
	@FechaVencimiento		datetime2
As
Begin

	Insert into [Catalogo].[TipoLicencia]  
		(TC_Descripcion 
		,TF_Inicio_Vigencia
		,TF_Fin_Vigencia )
	Values 
		(@Descripcion
		,@FechaActivacion
		,@FechaVencimiento);

End
GO
