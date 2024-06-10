SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--If Not Exists	(
--					Select	*
--					From	sys.schemas	A	WITH(NOLOCK)
--					Where	A.name		= 'Utilitario'
--				)
--Begin
--	Create Schema Utilitario Authorization siagpj;
--End
--Go
--Grant Control On Schema :: Utilitario To SIAGPJ
--Go
-- ==========================================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Esteban Cordero Benavides.>
-- Fecha de creación:		<25 de octubre de 2019.>
-- Descripción:				<Crea los scripts para el CRUD de una tabla.>
-- Modificación:			<07/07/2020> <Henry Mendez Ch> <Se corrige para que agregue descripción a TF_Fin_Vigencia en la creación>
-- ==========================================================================================================================================================================================
/*
Exec Utilitario.BackEndCatalogo @Nombre_Tabla			= 'Esteban', 
								@Nombre_Esquema			= 'Esteban', 
								@Nombre_Desarrollador	= 'Esteban Cordero Benavides',
								@Tamaño_Descripcion		= 255 --Si no se pasa el parámetro, el valor por defeto es de 150.
*/
CREATE Procedure [Utilitario].[BackEndCatalogo]
	@Nombre_Tabla			VarChar(50),
	@Nombre_Esquema			VarChar(50),
	@Nombre_Desarrollador	VarChar(150),
	@Tamaño_Descripcion		SMALLINT = 150
As
Begin
	--Variables
	Declare	@L_Nombre_Tabla				VarChar(50)		= @Nombre_Tabla,
			@L_Nombre_Esquema			VarChar(50)		= @Nombre_Esquema,
			@L_Nombre_Desarrollador		VarChar(150)	= @Nombre_Desarrollador,
			@L_Tamaño_Descripcion		VarChar(4)		= Convert(VarChar, @Tamaño_Descripcion),
			@SQL						NVarChar(Max)	= ''
	--Cuerpo
	If Not Exists	(
						Select		*
						From		sys.objects	A	WITH(NOLOCK)
						INNER JOIN	sys.schemas	B WITH(NOLOCK)
						On			B.schema_id	= A.schema_id
						And			B.name		= @Nombre_Esquema
						Where		A.type		= 'U' --Indica que es de tipo: USER_TABLE.
						And			A.name		= @L_Nombre_Tabla
					)
	Begin
		--Create
		Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
					'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
					'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @L_Nombre_Desarrollador + '>' + Char(13) +
					'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GETDATE(), 103) + '>' + Char(13) +
					'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite agregar un registro en la tabla: ' + @L_Nombre_Tabla + '.>' + Char(13) +
					'-- =================================================================================================================================================================================='+ Char(13) +
					'--Secuencia' + Char(13) +
					'IF NOT EXISTS' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + Char(9) + '*' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + Char(9) + 'sys.objects' + Char(9) + 'A WITH(NOLOCK)'+ Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'INNER JOIN' + Char(9) + Char(9) + 'sys.schemas' + Char(9) + 'B WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + Char(9) + 'B.schema_id' + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + '= ''SO'' --SEQUENCE_OBJECT' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + '= ''' + @L_Nombre_Esquema + '.Secuencia' + @L_Nombre_Tabla + '''' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'CREATE SEQUENCE' + Char(9) + @L_Nombre_Esquema + '.Secuencia' + @L_Nombre_Tabla + Char(9) + 'AS SMALLINT' + Char(13) +
					Char(9) + Char(9) + 'START WITH' + Char(9) + Char(9) + '1' + Char(13) +
					Char(9) + Char(9) + 'INCREMENT BY' + Char(9) + '1' + Char(13) +
					Char(9) + Char(9) + 'MINVALUE' + Char(9) + Char(9) + '1' + Char(13) +
					Char(9) + Char(9) + 'MAXVALUE' + Char(9) + Char(9) + '32767' + Char(13) +
					Char(9) + Char(9) + 'CACHE;' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Secuencia: "' + @L_Nombre_Esquema + '.Secuencia' + @L_Nombre_Tabla + '", creada correctamente.'';' + Char(13) +
					'END' + Char(13) + 
					';' + Char(13) +
					'--Tabla' + Char(13) +
					'IF NOT EXISTS' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + Char(9) + '*' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + Char(9) + 'sys.objects' + Char(9) + 'A WITH(NOLOCK)'+ Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'INNER JOIN' + Char(9) + Char(9) + 'sys.schemas' + Char(9) + 'B WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + Char(9) + 'B.schema_id' + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + '= ''U'' --USER_TABLE' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + '= '''+ @L_Nombre_Tabla + '''' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + '--Creación' + Char(13) +
					Char(9) + 'CREATE TABLE' + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(13) +
					Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) +  'SMALLINT' + Char(9) + Char(9) + 'Not NULL,' + Char(13) +
					Char(9) + Char(9) + 'TC_Descripcion' + Char(9) + Char(9) + Char(9) +  'VARCHAR(' + @L_Tamaño_Descripcion + ')' + Char(9) + 'Not NULL,' + Char(13) +
					Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + 'Not NULL,' + Char(13) +
					Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) +  'DATETIME2(3)' + Char(9) + 'NULL,' + Char(13) +
					Char(9) + Char(9) + 'CONSTRAINT PK_' + @L_Nombre_Esquema + '_' + @L_Nombre_Tabla + Char(9) + 'PRIMARY KEY CLUSTERED' + Char(13) +
					Char(9) + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + 'ASC' + Char(13) +
					Char(9) + Char(9) + ')' + Char(9) + 'WITH' + Char(13) +
					Char(9) + Char(9) + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + 'PAD_INDEX' + Char(9) + Char(9) + Char(9) + Char(9) + '= OFF,' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + 'STATISTICS_NORECOMPUTE' + Char(9) + '= OFF,' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + 'IGNORE_DUP_KEY' + Char(9) + Char(9) + Char(9) + '= OFF,' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + 'ALLOW_ROW_LOCKS' + Char(9) + Char(9) + Char(9) + '= ON,' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + 'ALLOW_PAGE_LOCKS' + Char(9) + Char(9) + '= ON' + Char(13) +
					Char(9) + Char(9) + Char(9) + ') ON [PRIMARY]' + Char(13) +
					Char(9) + Char(9) + ') ON [PRIMARY];' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Tabla: "' + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '", creada correctamente.''' + Char(13) +
					'END' + Char(13) + 
					';' + Char(13) +
					'--Relación de secuencia.' + Char(13) +
					'IF NOT EXISTS' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + '*' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + 'sys.objects' + Char(9) + 'WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + 'type' + Char(9) + Char(9) + '= ''D'' --DEFAULT_CONSTRAINT' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'name' + Char(9) + Char(9) + '= ''DF_'+ @L_Nombre_Esquema + '_' + @L_Nombre_Tabla + '_TN_Cod' + @L_Nombre_Tabla + '''' + Char(13) + 
					Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'ALTER TABLE' + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(13) +
					Char(9) + 'ADD CONSTRAINT' + Char(9) + 'DF_'+ @L_Nombre_Esquema + '_' + @L_Nombre_Tabla + '_TN_Cod' + @L_Nombre_Tabla  + Char(13) +
					Char(9) + 'DEFAULT' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + 'NEXT VALUE FOR' + Char(9) + @L_Nombre_Esquema + '.Secuencia' + @L_Nombre_Tabla + Char(13) +
					Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'FOR' + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + ';' +Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Secuencia: "' + @L_Nombre_Esquema + '.Secuencia' + @L_Nombre_Tabla + '", relacionada correctamente mendiante el constraint: "' + 'DF_'+ @L_Nombre_Esquema + '_' + @L_Nombre_Tabla + '_TN_Cod' + @L_Nombre_Tabla  + '", en la tabla: "' + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '"''' + Char(13) +
					'END' + Char(13) +
					';' + Char(13) +
					'--Propiedades de tabla.' + Char(13) +
					'IF' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'C.value' + Char(13) +
					Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.objects' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) +  'A WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + 'B.value' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + 'sys.Extended_Properties' + Char(9) + 'B WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + 'B.major_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'B.minor_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= 0 --Cero porque es una tabla.' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''MS_Description''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'C' + Char(13) +
					Char(9) + Char(9) + 'INNER JOIN' + Char(9) + 'sys.schemas' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'D WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + 'D.schema_id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 
					Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''U'' --USER_TABLE' + Char(13) +
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''' + @L_Nombre_Tabla + '''' + Char(13) +
					Char(9) + ')' + Char(9) + 'IS NULL' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'EXEC' + Char(9) + 'sys.sp_addextendedproperty' + Char(9) + '@name' + Char(9) + Char(9) + Char(9) + '= N''MS_Description'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@value' + Char(9) + Char(9) + Char(9) + '= N''Catálogo de tipo: "' + @L_Nombre_Tabla + '"'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0type' + Char(9) + Char(9) + '= N''SCHEMA'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Esquema + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1type' + Char(9) + Char(9) + '= N''TABLE'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Tabla + ''';' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Propiedades de tabla: "' +  @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '", creadas correctamente.''' + Char(13) +
					'END' + Char(13) +
					';' + Char(13) +
					'IF' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'E.value' + Char(13) +
					Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.objects' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'A WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + 'B.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + 'sys.columns' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'B WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + 'B.Object_Id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''TN_Cod' + @L_Nombre_Tabla + '''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'C' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'D.value' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.Extended_Properties' + Char(9) + 'D WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'D.major_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.minor_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= C.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''MS_Description''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'E' + Char(13) +
					Char(9) + Char(9) + 'INNER JOIN' + Char(9) + 'sys.schemas' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'F WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + 'F.schema_id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'F.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 		
					Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''U'' --USER_TABLE' + Char(13) +
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''' + @L_Nombre_Tabla + '''' + Char(13) +
					Char(9) +  + Char(9) + ')' + Char(9) + 'IS NULL' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'EXEC' + Char(9) + 'sys.sp_addextendedproperty' + Char(9) + '@name' + Char(9) + Char(9) + Char(9) + '= N''MS_Description'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@value' + Char(9) + Char(9) + Char(9) + '= N''Código del catálogo.'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0type' + Char(9) + Char(9) + '= N''SCHEMA'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Esquema + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1type' + Char(9) + Char(9) + '= N''TABLE'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Tabla + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2type' + Char(9) + Char(9) + '= N''COLUMN'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2name' + Char(9) + Char(9) + '= N''TN_Cod' + @L_Nombre_Tabla + ''';' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Propiedades de tabla: "' +  @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '", para el campo: "TN_Cod' + @L_Nombre_Tabla + '", creadas correctamente.''' + Char(13) +
					'END' + Char(13) +
					';' + Char(13) +
					'IF' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'E.value' + Char(13) +
					Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.objects' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'A WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + 'B.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + 'sys.columns' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'B WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + 'B.Object_Id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''TC_Descripcion''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'C' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'D.value' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.Extended_Properties' + Char(9) + 'D WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'D.major_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.minor_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= C.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''MS_Description''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'E' + Char(13) +					
					Char(9) + Char(9) + 'INNER JOIN' + Char(9) + 'sys.schemas' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'F WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + 'F.schema_id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'F.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 
					Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''U'' --USER_TABLE' + Char(13) +
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''' + @L_Nombre_Tabla + '''' + Char(13) +
					Char(9) +  + Char(9) + ')' + Char(9) + 'IS NULL' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'EXEC' + Char(9) + 'sys.sp_addextendedproperty' + Char(9) + '@name' + Char(9) + Char(9) + Char(9) + '= N''MS_Description'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@value' + Char(9) + Char(9) + Char(9) + '= N''Descripción del catálogo.'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0type' + Char(9) + Char(9) + '= N''SCHEMA'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Esquema + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1type' + Char(9) + Char(9) + '= N''TABLE'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Tabla + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2type' + Char(9) + Char(9) + '= N''COLUMN'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2name' + Char(9) + Char(9) + '= N''TC_Descripcion'';' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Propiedades de tabla: "' +  @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '", para el campo: "TC_Descripcion", creadas correctamente.''' + Char(13) +
					'END' + Char(13) +
					';' + Char(13) +
					'IF' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'E.value' + Char(13) +
					Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.objects' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'A WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + 'B.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + 'sys.columns' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'B WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + 'B.Object_Id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''TF_Inicio_Vigencia''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'C' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'D.value' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.Extended_Properties' + Char(9) + 'D WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'D.major_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.minor_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= C.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''MS_Description''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'E' + Char(13) +					
					Char(9) + Char(9) + 'INNER JOIN' + Char(9) + 'sys.schemas' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'F WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + 'F.schema_id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'F.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 
					Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''U'' --USER_TABLE' + Char(13) +
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''' + @L_Nombre_Tabla + '''' + Char(13) +
					Char(9) +  + Char(9) + ')' + Char(9) + 'Is  NULL' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'EXEC' + Char(9) + 'sys.sp_addextendedproperty' + Char(9) + '@name' + Char(9) + Char(9) + Char(9) + '= N''MS_Description'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@value' + Char(9) + Char(9) + Char(9) + '= N''Fecha de inicio de vigencia del registro.'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0type' + Char(9) + Char(9) + '= N''SCHEMA'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Esquema + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1type' + Char(9) + Char(9) + '= N''TABLE'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Tabla + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2type' + Char(9) + Char(9) + '= N''COLUMN'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2name' + Char(9) + Char(9) + '= N''TF_Inicio_Vigencia'';' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Propiedades de tabla: "' +  @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '", para el campo: "TF_Inicio_Vigencia", creadas correctamente.''' + Char(13) +
					'END' + Char(13) +
					';' + Char(13) +
					'IF' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'E.value' + Char(13) +
					Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.objects' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'A WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + 'B.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + 'sys.columns' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'B WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + 'B.Object_Id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + 'B.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''TF_Fin_Vigencia''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'C' + Char(13) +
					Char(9) + Char(9) + 'OUTER APPLY' + Char(9) + '(' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'D.value' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + 'sys.Extended_Properties' + Char(9) + 'D WITH(NOLOCK)' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'D.major_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= A.Object_Id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.minor_id' + Char(9) + Char(9) + Char(9) + Char(9) + '= C.column_id' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'D.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''MS_Description''' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(9) + 'E' + Char(13) +					
					Char(9) + Char(9) + 'INNER JOIN' + Char(9) + 'sys.schemas' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'F WITH(NOLOCK)' + Char(13) + 
					Char(9) + Char(9) + 'ON' + Char(9) + Char(9) + Char(9) + 'F.schema_id' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= A.schema_id' + Char(13) + 
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'F.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= '''+ @L_Nombre_Esquema + '''' + Char(13) + 
					Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'A.type' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''U'' --USER_TABLE' + Char(13) +
					Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'A.name' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= ''' + @L_Nombre_Tabla + '''' + Char(13) +
					Char(9) +  + Char(9) + ')' + Char(9) + 'IS NULL' + Char(13) +
					'BEGIN' + Char(13) +
					Char(9) + 'EXEC' + Char(9) + 'sys.sp_addextendedproperty' + Char(9) + '@name' + Char(9) + Char(9) + Char(9) + '= N''MS_Description'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@value' + Char(9) + Char(9) + Char(9) + '= N''Fecha de fin de vigencia del registro.'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0type' + Char(9) + Char(9) + '= N''SCHEMA'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level0name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Esquema + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1type' + Char(9) + Char(9) + '= N''TABLE'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level1name' + Char(9) + Char(9) + '= N''' + @L_Nombre_Tabla + ''',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2type' + Char(9) + Char(9) + '= N''COLUMN'',' + Char(13) +
					Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '@level2name' + Char(9) + Char(9) + '= N''TF_Fin_Vigencia'';' + Char(13) +
					Char(9) + 'PRINT' + Char(9) + '''Propiedades de tabla: "' +  @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + '", para el campo: "TF_Fin_Vigencia", creadas correctamente.''' + Char(13) +
					'END' + Char(13) +
					';' + Char(13) +
					''
		Select	'Crear' SP, @SQL Sentencia;
	End
	--Agregar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @L_Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GETDATE(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite agregar un registro en la tabla: ' + @L_Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13)
	If Not Exists	(
						Select	*
						From	sys.objects	A	WITH(NOLOCK)
						Where	A.type		= 'P' --Indica que es de tipo: SQL_STORED_PROCEDURE.
						And		A.name		= 'PA_Agregar' + @L_Nombre_Tabla
					)
	Begin
		Select @SQL = @SQL + 'CREATE PROCEDURE ' + @L_Nombre_Esquema + '.PA_Agregar' + @L_Nombre_Tabla + Char(13)
	END ELSE
	Begin
		Select @SQL = @SQL + 'ALTER PROCEDURE ' + @L_Nombre_Esquema + '.PA_Agregar' + @L_Nombre_Tabla + Char(13)
	End;
	Select	@SQL = @SQL + Char(9) + '@Descripcion' + Char(9) + Char(9) + 'VARCHAR(' + @L_Tamaño_Descripcion + '),' + Char(13) +
			Char(9) + '@InicioVigencia' + Char(9) + Char(9) + 'DATETIME2(3),' + Char(13) +
			Char(9) + '@FinVigencia' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + '= NULL' + Char(13) +
			'AS' + Char(13) +
			'BEGIN' + Char(13) +
			Char(9) + '--Variables.' + Char(13) +
			'DECLARE @L_TC_Descripcion' + Char(9) + Char(9) + 'VARCHAR(' + @L_Tamaño_Descripcion + ')' + Char(9) + '= @Descripcion,' + Char(13) +
			Char(9) + Char(9) + '@L_TF_Inicio_Vigencia' + Char(9) + 'DATETIME2(3)' + Char(9) + '= @InicioVigencia,' + Char(13) +
			Char(9) + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + '= @FinVigencia' + Char(13) +
			Char(9) + '--Lógica.' + Char(13) +
			Char(9) + 'INSERT INTO' + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + ' WITH(ROWLOCK)' + Char(13) +
			Char(9) + '(' + Char(13) +
			Char(9) + Char(9) + 'TC_Descripcion,' + Char(9) + Char(9) + 'TF_Inicio_Vigencia,' + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(13) +
			Char(9) + ')' + Char(13) +
			Char(9) + 'VALUES' + Char(13) +
			Char(9) + '(' + Char(13) +
			Char(9) + Char(9) + '@L_TC_Descripcion,' + Char(9) + '@L_TF_Inicio_Vigencia,' + Char(9) + '@L_TF_Fin_Vigencia' + Char(13) +
			Char(9) + ')' + Char(13) +
			'END' + Char(13) +
			'GO' + Char(13);
	Select	'Agregar' SP, @SQL Sentencia;
	--Modificar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @L_Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GETDATE(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite modificar un registro en la tabla: ' + @L_Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13)
	If Not Exists	(
						Select	*
						From	sys.objects	A	WITH(NOLOCK)
						Where	A.type		= 'P' --Indica que es de tipo: SQL_STORED_PROCEDURE.
						And		A.name		= 'PA_Modificar' + @L_Nombre_Tabla
					)
	Begin
		Select @SQL = @SQL + 'CREATE PROCEDURE ' + @L_Nombre_Esquema + '.PA_Modificar' + @L_Nombre_Tabla + Char(13)
	END ELSE
	Begin
		Select @SQL = @SQL + 'ALTER PROCEDURE ' + @L_Nombre_Esquema + '.PA_Modificar' + @L_Nombre_Tabla + Char(13)
	End;
	Select	@SQL = @SQL + Char(9) + '@Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + 'SMALLINT,' + Char(13) +
			Char(9) + '@Descripcion' + Char(9) + Char(9) + 'VARCHAR(' + @L_Tamaño_Descripcion + '),' + Char(13) +
			Char(9) + '@FinVigencia' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + '= NULL' + Char(13) +
			'AS' + Char(13) +
			'BEGIN' + Char(13) +
			Char(9) + '--Variables.' + Char(13) +
			Char(9) + 'DECLARE' + Char(9) + '@L_TN_Cod' + @L_Nombre_Tabla + Char(9) + 'SMALLINT' + Char(9) + Char(9) + '= @Cod' + @L_Nombre_Tabla + ',' + Char(13) +
			Char(9) + Char(9) + Char(9) + '@L_TC_Descripcion' + Char(9) + Char(9) + 'VARCHAR(' + @L_Tamaño_Descripcion + ')' + Char(9) + '= @Descripcion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + '= @FinVigencia' + Char(13) +
			Char(9) + '--Lógica.' + Char(13) +
			Char(9) + 'UPDATE' + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(9) + Char(9) + 'WITH(ROWLOCK)' + Char(13) +
			Char(9) + 'SET' + Char(9) + Char(9) + 'TC_Descripcion' + Char(9) + Char(9) + '= @L_TC_Descripcion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + '= @L_TF_Fin_Vigencia' + Char(13) +
			Char(9) + 'WHERE' + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + '= @L_TN_Cod' + @L_Nombre_Tabla + Char(13) +
			'END' + Char(13) +
			'GO' + Char(13);
	Select	'Modificar' SP, @SQL Sentencia;
	--Eliminar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @L_Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GETDATE(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite eliminar un registro en la tabla: ' + @L_Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13)
	If Not Exists	(
						Select	*
						From	sys.objects	A	WITH(NOLOCK)
						Where	A.type		= 'P' --Indica que es de tipo: SQL_STORED_PROCEDURE.
						And		A.name		= 'PA_Eliminar' + @L_Nombre_Tabla
					)
	Begin
		Select @SQL = @SQL + 'CREATE PROCEDURE ' + @L_Nombre_Esquema + '.PA_Eliminar' + @L_Nombre_Tabla + Char(13)
	END ELSE
	Begin
		Select @SQL = @SQL + 'ALTER PROCEDURE ' + @L_Nombre_Esquema + '.PA_Eliminar' + @L_Nombre_Tabla + Char(13)
	End;
	Select	@SQL = @SQL + Char(9) + '@Cod' + @L_Nombre_Tabla + Char(9) + 'SMALLINT' + Char(13) +
			'AS' + Char(13) +
			'BEGIN' + Char(13) +
			Char(9) + '--Variables.' + Char(13) +
			Char(9) + 'DECLARE @L_TN_Cod' + @L_Nombre_Tabla + Char(9) + 'SMALLINT' + Char(9) + '= @Cod' + @L_Nombre_Tabla + Char(13) +
			Char(9) + '--Lógica.' + Char(13) +
			Char(9) + 'DELETE' + Char(13) +
			Char(9) + 'FROM' + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(9) + 'WITH(ROWLOCK)' + @L_Nombre_Tabla + Char(13) +
			Char(9) + 'WHERE' + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + '= @L_TN_Cod' + @L_Nombre_Tabla + Char(13) +
			'END' + Char(13) +
			'GO' + Char(13);
	Select	'Eliminar' SP, @SQL Sentencia;
	--Consultar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @L_Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GETDATE(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite consultar un registro en la tabla: ' + @L_Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13)
	If Not Exists	(
						Select	*
						From	sys.objects	A	WITH(NOLOCK)
						Where	A.type		= 'P' --Indica que es de tipo: SQL_STORED_PROCEDURE.
						And		A.name		= 'PA_Consultar' + @L_Nombre_Tabla
					)
	Begin
		Select @SQL = @SQL + 'CREATE PROCEDURE ' + @L_Nombre_Esquema + '.PA_Consultar' + @L_Nombre_Tabla + Char(13)
	END ELSE
	Begin
		Select @SQL = @SQL + 'ALTER PROCEDURE ' + @L_Nombre_Esquema + '.PA_Consultar' + @L_Nombre_Tabla + Char(13)
	End;
	Select	@SQL = @SQL + Char(9) + '@Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + 'SMALLINT' + Char(9) + Char(9) + '= NULL,' + Char(13) +
			Char(9) + '@Descripcion' + Char(9) + Char(9) + 'VARCHAR(' + @L_Tamaño_Descripcion + ')' + Char(9) +  '= NULL,' + Char(13) +
			Char(9) + '@FechaActivacion' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + Char(9) + '= NULL,' + Char(13) +
			Char(9) + '@FechaDesactivacion' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + Char(9) + '= NULL' + Char(13) +
			'AS' + Char(13) +
			'BEGIN' + Char(13) +
			Char(9) + '--Variables.' + Char(13) +
			Char(9) + 'DECLARE' + Char(9) + '@L_TN_Cod' + @L_Nombre_Tabla + Char(9) + 'SMALLINT' + Char(9) + Char(9) + '= @Cod'+ @L_Nombre_Tabla + ',' + + Char(13) +
			Char(9) + Char(9) + Char(9) + '@L_TF_Inicio_Vigencia' + Char(9) + 'DATETIME2(3)' + Char(9) + '= @FechaActivacion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'DATETIME2(3)' + Char(9) + '= @FechaDesactivacion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + '@L_TC_Descripcion' + Char(9) + Char(9) + 'VARCHAR(MAX)' + Char(9) + '= IIF (@Descripcion IS NOT NULL, ''%'' + dbo.FN_RemoverTildes(@Descripcion) + ''%'', ''%'')' + Char(13) +
			Char(9) + '--Lógica.' + Char(13) +
			Char(9) + '--Todos.' + Char(13) +
			Char(9) + 'IF' + Char(9) + '@L_TF_Inicio_Vigencia' + Char(9) + 'IS NULL' + Char(13) +
			Char(9) + 'AND' + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'IS NULL' + Char(13) +
			Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Codigo,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TC_Descripcion' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Descripcion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaActivacion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaDesactivacion' + Char(13) +
			Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WITH(NOLOCK)' + Char(13) +
			Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + 'dbo.FN_RemoverTildes(TC_Descripcion)' + Char(9) + 'LIKE @L_TC_Descripcion' + Char(13) +
			Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= COALESCE(@L_TN_Cod' + @L_Nombre_Tabla + ', TN_Cod' + @L_Nombre_Tabla + ')' + Char(13) +
			Char(9) + Char(9) + 'ORDER BY' + Char(9) + 'TC_Descripcion' + Char(13) +
			Char(9) + 'END ELSE' + Char(13) +
			Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + '--Activos.' + Char(13) +
			Char(9) + Char(9) + 'IF' + Char(9) + '@L_TF_Inicio_Vigencia' + Char(9) + 'IS NOT NULL' + Char(13) +
			Char(9) + Char(9) + 'AND' + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'IS NULL' + Char(13) +
			Char(9) + Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Codigo,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TC_Descripcion' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Descripcion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaActivacion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaDesactivacion' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + Char(9) + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WITH(NOLOCK)' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + Char(9) + 'dbo.FN_RemoverTildes(TC_Descripcion)' + Char(9) + 'LIKE @L_TC_Descripcion' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '< GETDATE()' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + '(' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + + Char(9) + 'IS NULL' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'OR' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '>= GETDATE()' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= COALESCE(@L_TN_Cod' + @L_Nombre_Tabla + ', TN_Cod' + @L_Nombre_Tabla + ')' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'ORDER BY' + Char(9) + Char(9) + 'TC_Descripcion' + Char(13) +		
			Char(9) + Char(9) + 'END ELSE' + Char(13) +
			Char(9) + Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + Char(9) + '--Inactivos.' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'IF' + Char(9) + '@L_TF_Inicio_Vigencia' + Char(9) + 'IS NULL' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'IS NOT NULL' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Codigo,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TC_Descripcion' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Descripcion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaActivacion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaDesactivacion' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + Char(9)  + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WITH(NOLOCK)' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + Char(9) + 'dbo.FN_RemoverTildes(TC_Descripcion)' + Char(9) + 'LIKE @L_TC_Descripcion' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + '(' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '> GETDATE()' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'OR' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '< GETDATE()' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= COALESCE(@L_TN_Cod' + @L_Nombre_Tabla + ', TN_Cod' + @L_Nombre_Tabla + ')' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'ORDER BY' + Char(9) + Char(9) + 'TC_Descripcion' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'END ELSE' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + '--Inactivos por fecha.' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'IF' + Char(9) + '@L_TF_Inicio_Vigencia' + Char(9) + 'IS NOT NULL' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + '@L_TF_Fin_Vigencia' + Char(9) + Char(9) + 'IS NOT NULL' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + 'BEGIN' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'SELECT' + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Codigo,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TC_Descripcion' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'Descripcion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaActivacion,' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FechaDesactivacion' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'FROM' + Char(9) + Char(9) + Char(9)  + @L_Nombre_Esquema + '.' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WITH(NOLOCK)' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'WHERE' + Char(9) + Char(9) + Char(9) + 'dbo.FN_RemoverTildes(TC_Descripcion)' + Char(9) + 'LIKE @L_TC_Descripcion' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + '(' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Inicio_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '> @L_TF_Inicio_Vigencia' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'OR' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'TF_Fin_Vigencia' + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '< @L_TF_Fin_Vigencia' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + ')' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'AND' + Char(9) + Char(9) + Char(9) + Char(9) + 'TN_Cod' + @L_Nombre_Tabla + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + '= COALESCE(@L_TN_Cod' + @L_Nombre_Tabla + ', TN_Cod' + @L_Nombre_Tabla + ')' + Char(13) +
			Char(9) + Char(9) + Char(9) + Char(9) + Char(9) + 'ORDER BY' + Char(9) + Char(9) + 'TC_Descripcion' + Char(13) +	
			Char(9) + Char(9) + Char(9) + Char(9) + 'END' + Char(13) +
			Char(9) + Char(9) + Char(9) + 'END' + Char(13) +
			Char(9) + Char(9) + 'END' + Char(13) +
			Char(9) + 'END' + Char(13) +
			'END' + Char(13) +
			'GO' + Char(13)
			Select	'Consultar' SP, @SQL Sentencia;
End
GO
