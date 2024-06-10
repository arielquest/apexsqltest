SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Roger Lara>
-- Fecha de creación:	<11/08/2015>
-- Descripción:			<Permitir agregar registro en la tabla de tipocuantia>
-- Modificado por:		<Sigifredo Leitón Luna.>
-- Fecha:				<13/01/2016>
-- Descripción:			<Se realiza cambio para autogenerar el consecutivo de tipo de cuantía - item 5630.>
-- Modificado por:		<Ailyn López> <13/12/2017> <Se modifica el tamaño de la descripción>
-- ======================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoCuantia]
	@Descripcion	varchar(70),
	@InicioVigencia datetime2,
	@FinVigencia	datetime2
AS
BEGIN
	Insert into Catalogo.TipoCuantia 
	(
		TC_Descripcion, TF_Inicio_Vigencia, TF_Fin_Vigencia 
	)
	Values 
	(
		@Descripcion, @InicioVigencia, @FinVigencia
	) 
END


GO
