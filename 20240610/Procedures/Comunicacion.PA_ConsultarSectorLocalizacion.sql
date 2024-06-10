SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/01/2017>
-- Descripción :			<Permite consultar registros de Comunicacion.SectorLocalizacion.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarSectorLocalizacion]
	@CodSector		smallint
As
Begin
	Select		TN_OrdenPunto							As OrdenPunto,
				TG_UbicacionPunto.Lat					As Latitud,
				TG_UbicacionPunto.Long					As Longitud
	From		[Comunicacion].[SectorLocalizacion]		As A With(NoLock)
	Where		A.TN_CodSector							= @CodSector
	Order By	A.TN_OrdenPunto;		
End

GO
