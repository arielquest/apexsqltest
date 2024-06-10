SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Acosta Ibañez>
-- Fecha de creación:	<28/11/2018>
-- Descripción :		<Permite Asociar ClaseAsuntoDecreto> 
-- =================================================================================================================================================
-- Modificacion:		<03/07/2019> <Isaac Dobles> <Se ajusta a estructura de desarrollo de expedioentes>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarClaseAsuntoDecreto]

	@CodigoDecreto		varchar(15),
	@CodTipoOficina		smallint,
	@CodClase			int,
	@CodMateria			varchar(5),
	@FechaAsociacion	datetime2,
	@MontoInicial		decimal(12,0),
	@MontoFinal			decimal(12,0),
	@Porcentaje			decimal(4,2),
	@UltimoMonto		bit = 0
AS 
BEGIN
	INSERT INTO Catalogo.ClaseAsuntoDecreto
	(
		TC_CodigoDecreto,	TN_CodTipoOficina,	TN_CodClase,	TC_CodMateria,	TF_FechaAsociacion,	TN_MontoInicial,	TN_MontoFinal,	TN_Porcentaje,
		TB_UltimoMonto	
	)
	VALUES
	(
		@CodigoDecreto,	@CodTipoOficina, @CodClase, @CodMateria, @FechaAsociacion, @MontoInicial, @MontoFinal, @Porcentaje, @UltimoMonto
	)
END
 

GO
