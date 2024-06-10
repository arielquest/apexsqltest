SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/01/2017>
-- Descripción :			<Permite agregar un registro a Comunicacion.SectorLocalizacion.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarSectorLocalizacion]
	@CodSector			smallint,
	@OrdenPunto			smallint,
	@Latitud			float,
	@Longitud			float
As
Begin
	Insert Into [Comunicacion].[SectorLocalizacion]
			   ([TN_CodSector]
			   ,[TN_OrdenPunto]
			   ,[TG_UbicacionPunto])
		 Values
			   (@CodSector
			   ,@OrdenPunto
			   ,geography::Point(@Latitud,@Longitud,4326));
End

GO
