SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ailyn López> 
-- Fecha de creación:		<03/05/2018>
-- Descripción:				<Se consultan las estructuras existentes en la base de datos>
-- Modificación:			<Ronny Ramírez R.><19/10/2022> <Se cambia el nombre del SP de   
--								PA_ConsultarEstructuraBD a PA_ConsultarListaCatalogosBD y se elimina el parámetro
--								@Esquema por seguridad, para que solo se puedan listar las tablas de catálogos>
-- ===============================================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarListaCatalogosBD]	
AS
BEGIN
	--Variables 
	DECLARE	@L_Esquema			NVARCHAR(128)		= 'Catalogo';

	SELECT		KCU.TABLE_NAME
    FROM		INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC WITH(NOLOCK)
    INNER JOIN	INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU WITH(NOLOCK)
    ON			TC.CONSTRAINT_NAME   = KCU.CONSTRAINT_NAME
    AND			TC.CONSTRAINT_SCHEMA = KCU.CONSTRAINT_SCHEMA
    WHERE		TC.CONSTRAINT_TYPE   = 'PRIMARY KEY' AND
				TC.TABLE_SCHEMA	     = @L_Esquema
    GROUP BY	KCU.TABLE_NAME
	HAVING		Count(*) = 1 
	ORDER BY	KCU.TABLE_NAME 
END
GO
