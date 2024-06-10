SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Permite agregar un registro a Comunicacion.PerimetroLocalizacion.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarPerimetroLocalizacion]
	@CodPerimetro		smallint,
	@OrdenPunto			smallint,
	@Latitud			float,
	@Longitud			float
As
Begin
	Insert Into [Comunicacion].[PerimetroLocalizacion]
			   ([TN_CodPerimetro]
			   ,[TN_OrdenPunto]
			   ,[TG_UbicacionPunto])
		 Values
			   (@CodPerimetro
			   ,@OrdenPunto
			   ,geography::Point(@Latitud,@Longitud,4326));
End
GO
