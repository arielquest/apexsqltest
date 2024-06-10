SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <07/08/2015>
-- Descripcion:	<Modificar un tipo de moneda.>
-- Modificacion:  08/12/2015  Modificar tipo dato CodMoneda a smallint
-- Modificación: <02-12-2016> <Pablo Alvarez>  <Se modifica TN_CodMedioComunicación por estandar.>
--
-- Modificación:	<2017/05/24><Andrés Díaz><Se cambia el tamaño de la descripción a 50>
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarMoneda] 
	@CodMoneda			smallint, 
	@Descripcion		varchar(50),
	@FinVigencia		datetime2=null	
AS
BEGIN
	UPDATE	Catalogo.Moneda
	Set		TC_Descripcion		= @Descripcion,
			TF_Fin_Vigencia		= @FinVigencia
	where	TN_CodMoneda		= @CodMoneda
END
GO
