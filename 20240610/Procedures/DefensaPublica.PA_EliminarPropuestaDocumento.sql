SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================-- Versión:				<1.0>-- Creado por:			<Jose Gabriel Cordero Soto>-- Fecha de creación:	<05/08/2022>-- Descripción:			<Permite eliminar un registro en la tabla: PropuestaDocumento.>-- ==================================================================================================================================================================================CREATE PROCEDURE	[DefensaPublica].[PA_EliminarPropuestaDocumento]	@CodPropuesta				UNIQUEIDENTIFIERASBEGIN	--Variables	DECLARE	@L_TU_CodPropuesta			UNIQUEIDENTIFIER		= @CodPropuesta	--Lógica	DELETE	FROM	DefensaPublica.PropuestaDocumento	WITH (ROWLOCK)	WHERE	TU_CodPropuesta				= @L_TU_CodPropuestaEND
GO
