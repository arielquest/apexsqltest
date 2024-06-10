SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<01/05/2018>
-- Descripción :			<Permite consultar las columas de una tabla determinada>
-- Modificación:			<29/05/2018><Ailyn López><Se agrega el parámetro @Esquema>
-- Modificación:			<Ronny Ramírez R.><19/10/2022> <Se cambia el nombre del SP de   
--								PA_ConsultarCamposEstructuraBD a PA_ConsultarCamposCatalogoBD y se elimina 
--								el parámetro @Esquema por seguridad, para que solo se puedan listar campos
--								de las tablas de los catálogos>
-- =========================================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarCamposCatalogoBD]   
	@NombreTablaCatalogo				VARCHAR(256)
As
BEGIN
	--Variables 
	DECLARE	@L_NombreTablaCatalogo	VARCHAR(256)	=	@NombreTablaCatalogo,
			@L_Esquema				NVARCHAR(128)	=	'Catalogo';

	SELECT		COLUMN_NAME 
	FROM		INFORMATION_SCHEMA.COLUMNS WITH(NOLOCK)
	WHERE		TABLE_NAME		=  @L_NombreTablaCatalogo 
	AND			TABLE_SCHEMA	=  @L_Esquema
	ORDER BY	COLUMN_NAME
END
GO
