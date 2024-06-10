SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Permite consultar registros de Comunicacion.PerimetroLocalizacion.>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarPerimetroLocalizacion]
	@CodPerimetro		smallint
As
Begin
	Select		TN_OrdenPunto							As OrdenPunto,
				TG_UbicacionPunto.Lat					As Latitud,
				TG_UbicacionPunto.Long					As Longitud
	From		[Comunicacion].[PerimetroLocalizacion]	As A With(NoLock)
	Where		A.TN_CodPerimetro						= @CodPerimetro
	Order By	A.TN_OrdenPunto;		
End
GO
