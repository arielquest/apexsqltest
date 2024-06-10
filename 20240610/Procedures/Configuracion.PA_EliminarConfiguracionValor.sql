SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jeffry Hernández>
-- Fecha de creación:	<02/05/2018>
-- Descripción:			<Permite eliminar uno o varios registros a la tabla Configuracion.ConfiguracionValor>
-- Modificación:		<Se agrega parámetro @EsGeneral y condición>
-- Modificación:        <Tatiana Flores><17/08/2018> Se cambia el código de la oficina por código de contexto
-- ======================================================================================================
CREATE PROCEDURE [Configuracion].[PA_EliminarConfiguracionValor]	
	@CodConfiguracion		varchar(27),
	@CodContexto			varchar(4) = NULL,
	@EsValorGeneral			bit

AS
BEGIN	

	IF(@EsValorGeneral = 1)
	BEGIN

		DELETE
		FROM	Configuracion.ConfiguracionValor
		WHERE	TC_CodConfiguracion			= @CodConfiguracion
	
	END
	ELSE
	BEGIN

		DELETE
		FROM	Configuracion.ConfiguracionValor
		WHERE	TC_CodConfiguracion			= @CodConfiguracion		
		AND		TC_CodContexto				= @CodContexto 
		
	END

	
END

GO
