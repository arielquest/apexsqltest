SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO








-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro, Isaac Dobles Mata>
-- Fecha de creación:		<15/12/2020>
-- Descripción :			<Permite consultar la equivalencia de un Catálogo de Gestión a uno de SIAGPJ>
-- =============================================================================================================================================================================
 CREATE PROCEDURE [Itineracion].[PA_ConsultarEquivalenciaCatalogo]
	@Esquema					varchar(255),
	@Tabla						varchar(255),
	@ColumnaSIAGPJ				varchar(255),
	@ColumnaGestion				varchar(255),
	@ValorColumnaGestion		varchar(255),
	@Codigo						varchar(255) OUTPUT
AS 

BEGIN
	--Variables 
	DECLARE	
	@L_SQL			nvarchar(MAX),
	@L_Mensaje		nvarchar(MAX)
    
	--SE HACE CONSULTA DIRECTA A LA TABLA DE CATALOGO DE SIAGPJ
	set @L_SQL = N'SELECT @Codigo = ' 
	+ @ColumnaSIAGPJ 
	+ ' FROM ' 
	+ @Esquema 
	+ '.' 
	+ @Tabla 
	+ ' WHERE ' 
	+ @ColumnaGestion 
	+ ' = ' 
	+ '''' + @ValorColumnaGestion + ''''

	execute sp_executesql @L_SQL, N'@Codigo varchar(255) out', @Codigo = @Codigo out;

	--SE CONSULTA SI EXISTE EQUIVALENCIA O VALOR PREDETERMINADO EN TABLA DE MIGRACION CON EL VALOR QUE TENGA
	IF @Codigo IS NULL
	BEGIN
		set @L_SQL = null
		set @L_SQL = N'SELECT @Codigo = TC_ValorPorDefecto FROM Migracion.ValoresDefecto WHERE TC_NOMBRECAMPO = ''' + @ColumnaSIAGPJ + ''' AND TC_VALORESACTUALES = ''' + @ValorColumnaGestion + ''''
		execute sp_executesql @L_SQL, N'@Codigo varchar(255) out', @Codigo = @Codigo out;
	END

	--SE CONSULTA SI EXISTE EQUIVALENCIA O VALOR PREDETERMINADO EN TABLA DE MIGRACION CON CUALQUIER VALOR
	IF @Codigo IS NULL
	BEGIN
		set @L_SQL = null
		set @L_SQL = N'SELECT @Codigo = TC_ValorPorDefecto FROM Migracion.ValoresDefecto WHERE TC_NOMBRECAMPO = ''' + @ColumnaSIAGPJ + ''' AND TC_VALORESACTUALES = ''#Cualquiera'''
		execute sp_executesql @L_SQL, N'@Codigo varchar(255) out', @Codigo = @Codigo out;
	END
	
	IF @Codigo IS NULL
	BEGIN;
		set @L_Mensaje = N'No se encuentra equivalencia en los catálogos de SIAGPJ para el valor recibido: ' + @ColumnaGestion + ' = ' + @ValorColumnaGestion;
		THROW 50005, @L_Mensaje, 1;
	END;
END
GO
