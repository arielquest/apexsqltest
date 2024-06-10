SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<10/03/2021>
-- Descripción :			<Permite Consultar si el formato recibido esta realacionado a alguna variable> 

CREATE PROCEDURE [Variable].[PA_ConsultarVariableFormato]
	@Formato varchar(30)	= Null
As
Begin
	DECLARE
	@L_Formato varchar(30) = @Formato

	SELECT			var_variable		AS id_variable,
					var_nombre			AS nombre,
					var_tipo			AS tipo,
					var_multiple		AS multiple,
					var_formato			AS nombre_formato,
					var_dato1			AS dato1,
					var_dato2			AS dato2,
					var_observacion		AS observaciones,
					nombreConexion		AS nombreConexion
	FROM			Variable.Variable
	where			var_formato			= @Formato
END
GO
