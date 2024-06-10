SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<12/03/2021>
-- Descripción :			<Permite modificar una variable existe> 
-- =================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_ModificarVariable] 
	@var_variable int,
	@var_nombre varchar(30),
	@var_tipo int, 
	@var_multiple bit, 
	@var_formato varchar(30), 
	@var_dato1 varchar(max), 
	@var_dato2 varchar(150), 
	@var_observacion varchar(100) 
AS 

DECLARE
	@L_var_variable int				= @var_variable,
	@L_var_nombre varchar(30)		= @var_nombre,
	@L_var_tipo int					= @var_tipo, 
	@L_var_multiple bit				= @var_multiple, 
	@L_var_formato varchar(30)		= @var_formato, 
	@L_var_dato1 varchar(max)		= @var_dato1, 
	@L_var_dato2 varchar(150)		= @var_dato2, 
	@L_var_observacion varchar(100) = @var_observacion;


UPDATE
			[Variable].[Variable]
SET 
			[var_nombre]		=	@L_var_nombre, 
			[var_tipo]			=	@L_var_tipo, 
			[var_multiple]		=	@L_var_multiple, 
			[var_formato]		=	@L_var_formato, 
			[var_dato1]			=	@L_var_dato1, 
			[var_dato2]			=	@L_var_dato2, 
			[var_observacion]	=	@L_var_observacion
WHERE 
		var_variable = @L_var_variable;

GO
