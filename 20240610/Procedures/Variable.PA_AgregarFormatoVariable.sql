SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro
-- Fecha de creación:		<11/03/2021>
-- Descripción :			<Permite agregar un formato de variable> 
-- =================================================================================================================================================

CREATE PROCEDURE [Variable].[PA_AgregarFormatoVariable]
   @nombre			varchar(30),
   @formato			varchar(100)
 AS 
 BEGIN 

	DECLARE
	@L_nombre	VARCHAR(30)		= @nombre,
	@L_formato	VARCHAR(100)	= @formato

	INSERT INTO Variable.Formato
	(
		var_nombre,	var_formato
	)
	VALUES
	(
		@L_nombre,@L_formato
	)          
END

GO
