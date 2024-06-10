SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--Begin
--	Create Schema Utilitario Authorization siagpj;
--End
--Go
--Grant Control On Schema :: Utilitario To SIAGPJ
--Go
-- ==========================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Cordero Benavides.>
-- Fecha de creación:		<08 de noviembre de 2019.>
-- Descripción:				<Crea los scripts para el CRUD de una tabla transaccional.>
-- Modificado por:			<Esteban Cordero Benavides.>
-- Fecha de creación:		<08 de enero de 2020.>
-- Descripción:				<Se agrega la inicialización de null en los campos que lo permiten.>
-- ==========================================================================================================================================================================================
/*
Exec Utilitario.BackEndEntidad	@Nombre_Tabla			= 'Expediente', 
								@Nombre_Esquema			= 'Expediente', 
								@Nombre_Desarrollador	= 'Esteban Cordero Benavides'
*/
CREATE Procedure [Utilitario].[BackEndEntidad]
	@Nombre_Esquema			VarChar(256),
	@Nombre_Tabla			VarChar(256),
	@Nombre_Desarrollador	VarChar(150)
As
Begin
	--Validar que exista la tabla y el esquema
	If Not Exists	(
						Select	*
						From	sys.objects	With(Nolock)
						Where	type		= 'U' --USER_TABLE
						And		name		= @Nombre_Tabla
					)
	Begin
		RaisError (21078,-1,-1, 'La tabla no existe en la base de datos.');
	End;
	--Validar que exista la tabla y el esquema
	If Not Exists	(
						Select	*
						From	sys.schemas	With(Nolock)
						Where	name		= @Nombre_Esquema
					)
	Begin
		RaisError (15659,-1,-1, 'El esquema no existe en la base de datos.');		
	End;
	If Not Exists	(
						Select		*
						From		sys.objects	A With(NoLock)
						Inner Join	sys.schemas	B With(NoLock)
						On			B.schema_id	= A.schema_id
						And			B.name		= @Nombre_Esquema
						Where		A.type		= 'U' --Indica que es de tipo: USER_TABLE.
						And			A.name		= @Nombre_Tabla
					)
	Begin
		RaisError (22931,-1,-1, 'La tabla y el esquema indicados no se encuentran relacionados.');
	End;
	--Agregar
	Declare @SQL VarChar(Max) = '-- ==================================================================================================================================================================================' + Char(13) +
								'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
								'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @Nombre_Desarrollador + '>' + Char(13) +
								'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GetDate(), 103) + '>' + Char(13) +
								'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite agregar un registro en la tabla: ' + @Nombre_Tabla + '.>' + Char(13) +
								'-- =================================================================================================================================================================================='+ Char(13);
	If Not Exists	(
						Select		*
						From		sys.objects A With(Nolock)
						Inner Join	sys.schemas	B With(NoLock)
						On			B.schema_id	= A.schema_id
						And			B.name		= @Nombre_Esquema
						Where		A.name		= 'PA_Agregar' + @Nombre_Tabla
					)
	Begin
		Set	@SQL += 'CREATE PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Agregar' + @Nombre_Tabla + Char(13);
	End Else
	Begin
		Set	@SQL += 'ALTER PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Agregar' + @Nombre_Tabla + Char(13);
	End
	--
	Declare	@SQL_Campos_Vertical		NVarChar(Max) = '';
	Declare	@SQL_Variables_Vertical		NVarChar(Max) = '';
	Declare	@SQL_Vertical_Asignacion	NVarChar(Max) = '';
	Declare	@SQL_Campos_Horizontales	NVarChar(Max) = '';
	Declare	@SQL_Variables_Horizontales	NVarChar(Max) = '';
	Declare	@SQL_Where					NVarChar(Max) = '';
	Declare	@SQL_Llaves					NVarChar(Max) = '';
	Declare	@SQL_Llaves_Vertical		NVarChar(Max) = '';
	Declare	@SQL_Select_Vertical		NVarChar(Max) = '';
	Declare @Datos Table	(
								ID			TinyInt Primary Key Identity(1, 1),
								Campo		VarChar(Max),
								Tamaño		SmallInt,
								Nulable		Bit,
								Scalar		TinyInt,
								Tipo		VarChar(Max),
								Longitud	SmallInt Not Null Default 0,
								IndPK		Bit Default 0
							);
	Declare @CantidadColumnas		TinyInt			= 0,
			@Columna				TinyInt			= 1,
			@Campo					VarChar(Max)	= '',
			@Variable				VarChar(Max)	= '',
			@Tamaño					VarChar(4),
			@Nulable				Bit				= 0,
			@Scalar					TinyInt			= 0,
			@Tipo					VarChar(Max)		= '',
			@Longitud				SmallInt		= 0,
			@PalabraMasGrande		SmallInt		= 0,
			@PalabraTipoMasGrande	SmallInt		= 0,
			@IndPK					Bit				= 0
	--
	Insert Into	@Datos
	(
				Campo,				Tamaño,			Nulable,		Scalar,
				Tipo,				
				Longitud
	)
	Select		B.name,				B.max_length,	B.is_nullable, B.scale,	
				Case C.system_type_id
					When 167 Then UPPER(C.name) + '(' + Convert(VarChar, B.max_length) + ')' --varchar
					When 175Then UPPER(C.name) + '(' + Convert(VarChar, B.max_length) + ')' --char
					When 231 Then UPPER(C.name) + '(' + Convert(VarChar, B.max_length) + ')' --nvarchar
					When 239 Then UPPER(C.name) + '(' + Convert(VarChar, B.max_length) + ')' --nchar
					When 42 Then UPPER(C.name) + '(' + Convert(VarChar, B.max_length) + ')' --datetime2
					Else UPPER(C.name)
				End,
				Len(C.name)
	From		sys.objects			A With(NoLock)
	Inner Join	sys.columns			B With(NoLock)
	On			B.object_id			= A.object_id
	Inner Join	sys.types			C With(NoLock)
	On			C.system_type_id	= B.system_type_id
	Inner Join	sys.schemas			D With(NoLock)
	On			D.schema_id			= A.schema_id
	And			D.name				= @Nombre_Esquema
	Where		A.name				= @Nombre_Tabla
	Order By	B.column_id;
	--
	Set @CantidadColumnas = @@RowCount;
	--Obtiene los campos de la PK.
	Update		A
	Set			A.IndPK	= 1
	From		@Datos																								A	
	Inner Join	Information_Schema.Key_Column_Usage																	B
	On			B.Column_Name																						= A.Campo
	And			B.Table_Name																						= @Nombre_Tabla
	And			B.Table_Schema																						= @Nombre_Esquema
	And			ObjectProperty(Object_Id(B.Constraint_Schema + '.' + QuoteName(B.Constraint_Name)), 'IsPrimaryKey') = 1;
	--
	Select Top 1	@PalabraMasGrande = Longitud + 1
	From			@Datos
	Order By		Longitud	Desc
	Select Top 1	@PalabraTipoMasGrande = Max(Longitud) + 1 + Max(Len(Tamaño))
	From			@Datos
	Group By		Longitud,	Tamaño
	--
	While @Columna	<= @CantidadColumnas
	Begin
		Select	@Campo		= Campo,
				@Tamaño		= Convert(VarChar, Tamaño),
				@Nulable	= Nulable,
				@Scalar		= Scalar,
				@Tipo		= Tipo,
				@Longitud	= Longitud,
				@IndPK		= IndPK
		From	@Datos
		Where	ID			= @Columna
		--
		Select	@SQL_Campos_Vertical += Char(9) + Utilitario.Tabulador (@PalabraMasGrande, '@' + SubString(@Campo, CharIndex('_', @Campo) + 1, Len(@Campo)-CharIndex('_', @Campo))) + @Tipo +  Iif(@Nulable = 1, Char(9) + '= NULL', '') + Iif(@Columna = @CantidadColumnas, Char(13), ',' + Char(13));
		Select	@Variable = Utilitario.Tabulador (@PalabraMasGrande, Iif(@Columna = 1, '', Char(9) + Char(9) + Char(9)) + '@L_' + @Campo);
		Select	@Variable = Utilitario.Tabulador (@PalabraTipoMasGrande, @Variable + @Tipo);
		Select	@SQL_Variables_Vertical += @Variable + '= @' + SubString(@Campo, CharIndex('_', @Campo) + 1, Len(@Campo)-CharIndex('_', @Campo)) + Iif(@Columna = @CantidadColumnas, Char(13), ',' + Char(13));
		--
		Select	@SQL_Campos_Horizontales += Utilitario.Tabulador (@PalabraMasGrande, @Campo + Iif(@Columna = @CantidadColumnas, '', ','))  + Char(9) + iif (@Columna = @CantidadColumnas, Char(13), Iif((@Columna % 4) = 0, Char(13) + Char(9) + Char(9), ''))
		Select	@SQL_Variables_Horizontales += Utilitario.Tabulador (@PalabraMasGrande, '@L_'+ @Campo + Iif(@Columna = @CantidadColumnas, '', ','))  + Char(9) + iif (@Columna = @CantidadColumnas, Char(13), Iif((@Columna % 4) = 0, Char(13) + Char(9) + Char(9), ''))
		--
		If @IndPK = 0
		Begin
			Select	@SQL_Vertical_Asignacion += Iif(@SQL_Vertical_Asignacion = '', Char(9) + Char(9), Char(9) + Char(9) + Char(9)) + Utilitario.Tabulador (@PalabraMasGrande, @Campo) + '= ' + '@L_'+ @Campo + Iif(@Columna = @CantidadColumnas, Char(13), ',' + Char(13));
			--
			Select	@Variable = Utilitario.Tabulador (@PalabraMasGrande, Iif(@SQL_Select_Vertical = '', Char(9), Char(9) + Char(9) + Char(9)) + 'A.' + @Campo);
			Select	@SQL_Select_Vertical+= @Variable + SubString(@Campo,CharIndex('_',@Campo) + 1, Len(@Campo) - CharIndex('_',@Campo) + 1) + Iif(@Columna = @CantidadColumnas, '', ',' + Char(13));

		End Else
		Begin
			If @SQL_Where = ''
			Begin
				Select	@SQL_Where += Char(9) + 'WHERE'
			End Else
			Begin
				Select	@SQL_Where += Char(13) + Char(9) + 'AND' + Char(9)
			End
			Select	@SQL_Where += Char(9) + Utilitario.Tabulador (@PalabraMasGrande, @Campo) + '= ' + '@L_'+ @Campo;
			--
			Select	@SQL_Llaves += Iif(@SQL_Llaves <> '', ',', '' + Char(13)) + Char(9) + Utilitario.Tabulador (@PalabraMasGrande, '@' + SubString(@Campo,CharIndex('_',@Campo) + 1, Len(@Campo) - CharIndex('_',@Campo) + 1)) + @Tipo;
			--
			Select	@Variable = Utilitario.Tabulador (@PalabraMasGrande, Iif(@Columna = 1, '', Char(9) + Char(9) + Char(9)) + '@L_' + @Campo);
			Select	@Variable = Utilitario.Tabulador (@PalabraTipoMasGrande, @Variable + @Tipo);
			Select	@SQL_Llaves_Vertical += Iif(@SQL_Llaves_Vertical = '', '', ',' + Char(13)) + @Variable + '= @' + SubString(@Campo,CharIndex('_',@Campo) + 1, Len(@Campo) - CharIndex('_',@Campo) + 1);

		End
		Set @Columna += 1;
	End
	--Agregar
	Select	@SQL += @SQL_Campos_Vertical + 
					Char(13) + 'AS' + Char(13) + 
					'BEGIN' + Char(13) + 
					Char(9) + '--Variables' + Char(13) + 
					Char(9) + 'DECLARE' + Char(9) + @SQL_Variables_Vertical + 
					Char(9) + '--Cuerpo' + Char(13) + 
					Char(9) + 'INSERT INTO' + Char(9) + @Nombre_Esquema + '.' + @Nombre_Tabla + Char(9) + 'WITH (ROWLOCK)' + Char(13) + 
					Char(9) + '(' + Char(13) + 
					Char(9) + Char(9) + @SQL_Campos_Horizontales + 
					Char(9) + ')' + Char(13) + 
					Char(9) + 'VALUES' + Char(13) + 
					Char(9) + '(' + Char(13) + 
					Char(9) + Char(9) + @SQL_Variables_Horizontales +
					Char(9) + ')' + Char(13) + 
					'END'
	Select	'Agregar' SP, @SQL Sentencia;
	--Modificar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GetDate(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite actualizar un registro en la tabla: ' + @Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13);
	If Not Exists	(
						Select		*
						From		sys.objects A With(Nolock)
						Inner Join	sys.schemas	B With(NoLock)
						On			B.schema_id	= A.schema_id
						And			B.name		= @Nombre_Esquema
						Where		A.name		= 'PA_Modificar' + @Nombre_Tabla
					)
	Begin
		Set	@SQL += 'CREATE PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Modificar' + @Nombre_Tabla + Char(13);
	End Else
	Begin
		Set	@SQL += 'ALTER PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Modificar' + @Nombre_Tabla + Char(13);
	End
	--
	Select	@SQL += @SQL_Campos_Vertical + 
					'AS' + Char(13) + 
					'BEGIN' + Char(13) + 
					Char(9) + '--Variables' + Char(13) + 
					Char(9) + 'DECLARE' + Char(9) + @SQL_Variables_Vertical + 
					Char(9) + '--Lógica' + Char(13) + 
					Char(9) + 'UPDATE' + Char(9) + @Nombre_Esquema + '.' + @Nombre_Tabla + Char(9) + 'WITH (ROWLOCK)' + Char(13) + 
					Char(9) + 'SET' + @SQL_Vertical_Asignacion +
					@SQL_Where + Char(13) +
					'END'
	Select	'Modificar' SP, @SQL Sentencia;
	--Eliminar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GetDate(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite eliminar un registro en la tabla: ' + @Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13);
	If Not Exists	(
						Select		*
						From		sys.objects A With(Nolock)
						Inner Join	sys.schemas	B With(NoLock)
						On			B.schema_id	= A.schema_id
						And			B.name		= @Nombre_Esquema
						Where		A.name		= 'PA_Eliminar' + @Nombre_Tabla
					)
	Begin
		Set	@SQL += 'CREATE PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Eliminar' + @Nombre_Tabla + Char(13);
	End Else
	Begin
		Set	@SQL += 'ALTER PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Eliminar' + @Nombre_Tabla + Char(13);
	End
	--
	Select	@SQL += @SQL_Llaves + 
					Char(13) + 'AS' + Char(13) + 
					'BEGIN' + Char(13) +
					Char(9) + '--Variables' + Char(13) +
					Char(9) + 'DECLARE' + Char(9) +
					@SQL_Llaves_Vertical + Char(13) +
					Char(13) + Char(9) + '--Lógica' + Char(13) +
					Char(9) + 'DELETE' + Char(13) +
					Char(9) + 'FROM' + Char(9) + @Nombre_Esquema + '.' + @Nombre_Tabla + Char(9) + 'WITH (ROWLOCK)' + Char(13) + 
					@SQL_Where + Char(13) + 
					'END'
	Select	'Eliminar' SP, @SQL Sentencia;
	--Consultar
	Set @SQL =	'-- ==================================================================================================================================================================================' + Char(13) +
				'-- Versión:' + Char(9) + Char(9) + Char(9) + Char(9) + '<1.0>' + Char(13) +
				'-- Creado por:' + Char(9) + Char(9) + Char(9) + '<' + @Nombre_Desarrollador + '>' + Char(13) +
				'-- Fecha de creación:' + Char(9) + '<' + Convert(VarChar(10), GetDate(), 103) + '>' + Char(13) +
				'-- Descripción:' + Char(9) + Char(9) + Char(9) + '<Permite consultar un registro en la tabla: ' + @Nombre_Tabla + '.>' + Char(13) +
				'-- =================================================================================================================================================================================='+ Char(13);
	If Not Exists	(
						Select		*
						From		sys.objects A With(Nolock)
						Inner Join	sys.schemas	B With(NoLock)
						On			B.schema_id	= A.schema_id
						And			B.name		= @Nombre_Esquema
						Where		A.name		= 'PA_Consultar' + @Nombre_Tabla
					)
	Begin
		Set	@SQL += 'CREATE PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Consultar' + @Nombre_Tabla + Char(13);
	End Else
	Begin
		Set	@SQL += 'ALTER PROCEDURE' + Char(9) + @Nombre_Esquema + '.PA_Consultar' + @Nombre_Tabla + Char(13);
	End
	--
	Select	@SQL += @SQL_Llaves + 
					Char(13) + 'AS' + Char(13) + 
					'BEGIN' + Char(13) +
					Char(9) + '--Variables' + Char(13) +
					Char(9) + 'DECLARE' + Char(9) +
					@SQL_Llaves_Vertical +
					Char(13) + Char(9) + '--Lógica' + Char(13) +
					Char(9) + 'SELECT' + 
					@SQL_Select_Vertical + ',' + Char(13) +
					Char(9) + Char(9) + Char(9) + '''Split''' + Char(13) + 
					Char(9) + 'FROM' + Char(9) + @Nombre_Esquema + '.' + @Nombre_Tabla + Char(9) + Char(9) + 'A WITH (NOLOCK)' + Char(13) +
					@SQL_Where + Char(13) +
					'END'
	Select	'Consultar' SP, @SQL Sentencia;

End
GO
