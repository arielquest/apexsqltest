SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<12/03/2021>
-- Descripción :			<Permite insertar una variable nueva> 
-- =================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_AgregarVariable] 
	@var_nombre varchar(30),
	@var_tipo int, 
	@var_multiple bit, 
	@var_formato varchar(30), 
	@var_dato1 varchar(max), 
	@var_dato2 varchar(150), 
	@var_observacion varchar(100) 
AS 

BEGIN

	DECLARE
		@L_var_nombre varchar(30)		= @var_nombre,
		@L_var_tipo int					= @var_tipo, 
		@L_var_multiple bit				= @var_multiple, 
		@L_var_formato varchar(30)		= @var_formato, 
		@L_var_dato1 varchar(max)		= @var_dato1, 
		@L_var_dato2 varchar(150)		= @var_dato2, 
		@L_var_observacion varchar(100) = @var_observacion;


	INSERT INTO [Variable].[Variable] (
				[var_variable], 
				[var_nombre], 
				[var_tipo], 
				[var_multiple], 
				[var_formato], 
				[var_dato1], 
				[var_dato2], 
				[var_observacion])
	VALUES (
				(SELECT max(var_variable) + 1 FROM  [Variable].[Variable] WITH(NOLOCK)),
				rtrim(ltrim(@L_var_nombre)),
				@L_var_tipo, 
				@L_var_multiple, 
				rtrim(ltrim(@L_var_formato)), 
				@L_var_dato1, 
				rtrim(ltrim(@L_var_dato2)), 
				@L_var_observacion);

END
GO
