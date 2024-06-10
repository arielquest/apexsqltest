SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Karol Jiménez Sánchez>
-- Fecha de creación:	<30/12/2020>
-- Descripción:			<Permite consultar todas las tablas del esquema Catalogo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCatalogosSiagpj]
AS
BEGIN

		SELECT		TABLE_SCHEMA + '.' + TABLE_NAME
		FROM		INFORMATION_SCHEMA.TABLES 
		WHERE		TABLE_SCHEMA				= 'Catalogo'
		AND			TABLE_TYPE					= 'BASE TABLE'
		AND			TABLE_NAME					<> 'Catalogo'
		UNION
		SELECT		TABLE_SCHEMA + '.' + TABLE_NAME
		FROM		INFORMATION_SCHEMA.TABLES 
		WHERE		TABLE_SCHEMA				= 'Agenda'
		AND			TABLE_TYPE					= 'BASE TABLE'
		AND			TABLE_NAME					in ('DiaFestivo','Evento')
		UNION
		SELECT		TABLE_SCHEMA + '.' + TABLE_NAME
		FROM		INFORMATION_SCHEMA.TABLES 
		WHERE		TABLE_SCHEMA				= 'Comunicacion'
		AND			TABLE_TYPE					= 'BASE TABLE'
		AND			TABLE_NAME					in ('Perimetro','Sector')
END


GO
