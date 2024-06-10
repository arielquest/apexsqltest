SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================================================================================================================
-- Versión:					<1.4>
-- Creado por:				<Esteban Cordero Benavides.>
-- Fecha de creación:		<28 de mayo de 2020.>
-- Descripción:				<Elimina del repositorio todos los datos existente, no reinicia contadores.>
-- Fecha de modificación:	<04 de junio de 2020.>
-- Descripción:				<Se agrega la discriminación del esquema Variable para no borrar lo de los formatos jurídicos.>
-- Fecha de modificación:	<30 de julio de 2020.>
-- Descripción:				<Se agrega la discriminación del esquema Configuracion para no borrar los datos ya configurados.>
-- Fecha de modificación:	<15 de marzo de 2021.>
-- Descripción:				<Se modifica la discriminación del esquema de Configuración, para sólo conservar los datos de los
--							 valores de congiguración y restaurarles al finalizar el proceso de migración.>
-- Fecha de modificación:	<19 de mayo de 2021.>
-- Descripción:				<Se agrega la discriminación del esquema catálogos para no borrar los datos ya configurados.>
-- Modificado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:		<03/11/2021>
-- Descripción:				<Modificacion para prueba de politica perisiva>
-- ==========================================================================================================================================================================================

CREATE Procedure [Utilitario].[EliminaDatos]
	@Reinicia_Secuencias	BIT,
	@EliminaVariables		BIT,
	@RespaldarConfiguracion	BIT,
	@ConservarCatalogos		BIT
AS
BEGIN
	SET NOCOUNT ON;
	--Declaración de variables.
	Declare	@Tablas_Borrado AS Table	(
											Nivel			TinyInt		Not Null,
											Nombre_Esquema	VarChar(40)	Not Null,
											Nombre_Tabla	VarChar(60) Not Null,
											Id_Tabla		Int			Not Null
										);
	Declare	@Secuencias_Borrado AS Table	(
												Id					Int				Not Null,
												Nombre_Secuencia	VarChar(512)	Not Null
											);
	Declare	@Tabla_Actual			VarChar(60),
			@Tabla_Actual_Esquema	VarChar(60),
			@Tabla_Actual_Id		Int,
			@MsgError				VarChar(Max),
			@SentenciaSQL			NVarChar(Max),
			@L_Reinicia_Secuencias	Bit				= @Reinicia_Secuencias,
			@Secuencia_Actual		VarChar(521),
			@Secuencia_Actual_Id	Int;
	--Obtención de las tablas de manera dinámica.
	With Hijos As	(
							Select Distinct		C.Papá_Id_Esquema,
												C.Papá_Nombre_Esquema,
												C.Papá_Id,
												C.Papá_Nombre,
												B.Hijo_Id_Esquema,
												B.Hijo_Nombre_Esquema,
												B.Hijo_Id,
												B.Hijo_Nombre				
							From				sys.foreign_keys		A With(NoLock)
							Outer Apply			(
													Select		X.schema_id	Hijo_Id_Esquema,
																X.name		Hijo_Nombre_Esquema,
																Z.object_id	Hijo_Id,
																Z.name		Hijo_Nombre
													From		sys.tables	Z With(NoLock)
													Inner Join	sys.schemas	X With(NoLock)
													On			X.schema_id	= Z.schema_id
													Where		Z.object_id	= A.referenced_object_id
												)	B
							Outer Apply			(
													Select		X.schema_id	Papá_Id_Esquema,
																X.name		Papá_Nombre_Esquema,
																Z.object_id	Papá_Id,
																Z.name		Papá_Nombre
													From		sys.tables	Z With(NoLock)												
													Inner Join	sys.schemas	X With(NoLock)
													On			X.schema_id	= Z.schema_id
													Where		Z.object_id	= A.parent_object_id
												)	C
							Where				B.Hijo_Id				<> C.Papá_Id --Discrimina los registros que la tabla y la relación es la misma.
						),
						Papá As	(
									Select		A.schema_id				Papá_Id_Esquema,
												C.name					Papá_Nombre_Esquema,
												A.object_id				Papá_Id,
												A.name					Papá_Nombre,
												B.Hijo_Id_Esquema,
												B.Hijo_Nombre_Esquema,
												B.Hijo_Id,
												B.Hijo_Nombre											
									From		sys.tables				A With(NoLock)
									Left Join	Hijos					B
									On			B.Papá_Id				= A.object_Id
									And			B.Papá_Id_Esquema		= A.schema_id
									And			B.Papá_Nombre			= A.name
									Inner Join	sys.schemas				C With(NoLock)
									On			C.schema_id				= A.schema_id
									Where		A.schema_id				<> 1 --Elimina lo que no tenga esquema, porque Apex y el propio SQL tiene tablas allí como la sysdiagrams.
								),
								Totales As	(
												Select	A.Papá_Id_Esquema,
														A.Papá_Nombre_Esquema,
														A.Papá_Id,
														A.Papá_Nombre,
														A.Hijo_Id_Esquema,
														A.Hijo_Nombre_Esquema,
														A.Hijo_Id,
														A.Hijo_Nombre,
														1		Nivel
												From	Papá	A
												Where	Hijo_Id	Is Null
												Union All
												Select		A.Papá_Id_Esquema,
															A.Papá_Nombre_Esquema,
															A.Papá_Id,
															A.Papá_Nombre,
															A.Hijo_Id_Esquema,
															A.Hijo_Nombre_Esquema,
															A.Hijo_Id,
															A.Hijo_Nombre,
															B.Nivel + 1			Nivel
												From		Papá				A
												Inner Join	Totales				B
												On			A.Hijo_Id			= B.Papá_Id
											)
	Insert Into	@Tablas_Borrado
	(
				Nivel,
				Nombre_Esquema,
				Nombre_Tabla,
				Id_Tabla
	)
	Select		Max(A.Nivel)			Nivel,
				A.Papá_Nombre_Esquema,
				A.Papá_Nombre,
				A.Papá_Id		
	From		Totales					A
	Group By	A.Papá_Id_Esquema,
				A.Papá_Nombre_Esquema,
				A.Papá_Id,
				A.Papá_Nombre
	Order By	Nivel				Desc,
				Papá_Id				Desc
	--Proceso de borrado.
	If (@EliminaVariables = 0)
	Begin
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema = 'Variable'
	End
	DELETE FROM	Migracion.RespaldoConfiguracionValor;

	If (@RespaldarConfiguracion <> 0)
	Begin
		INSERT INTO	Migracion.RespaldoConfiguracionValor
		(
				TU_Codigo,							TC_CodConfiguracion,	TC_CodContexto,	TF_FechaCreacion,
				TF_FechaActivacion,					TF_FechaCaducidad,		TC_Valor
		)
		SELECT	TU_Codigo,							TC_CodConfiguracion,	TC_CodContexto,	TF_FechaCreacion,
				TF_FechaActivacion,					TF_FechaCaducidad,		TC_Valor
		FROM	Configuracion.ConfiguracionValor	A WITH(NOLOCK);		
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Migracion'
		AND		Nombre_Tabla	= 'RespaldoConfiguracionValor';
	End
	IF	(@ConservarCatalogos = 1)
	BEGIN
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Catalogo';

		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Comunicacion'
		AND		Nombre_Tabla	IN	(
										'Perimetro',	'PerimetroMateria', 'Sector'
									);
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Configuracion'
		AND		Nombre_Tabla	IN	(
										'Configuracion',	'ConfiguracionValor', 'Equivalencia'
									);
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Migracion'
		AND		Nombre_Tabla	IN	(
										'ValoresDefecto'
									);
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Variable'
		AND		Nombre_Tabla	IN	(
										'Formato', 'Tipo', 'Variable'
									);
		Delete
		From	@Tablas_Borrado
		Where	Nombre_Esquema	= 'Agenda'
		AND		Nombre_Tabla	IN	(
										'Formato', 'DiaFestivo', 'DiaFestivoCircuito'
									);
	END
	--Recorrido de tablas para borrado de información.
	While Exists	(
						Select	*
						From	@Tablas_Borrado
					)
	Begin
		--Carga de tabla actual.
		Select	Top 1	@Tabla_Actual			= A.Nombre_Tabla,
						@Tabla_Actual_Esquema	= A.Nombre_Esquema,
						@Tabla_Actual_Id		= A.Id_Tabla,	
						@SentenciaSQL			= ''
		From			@Tablas_Borrado			A
		Order By		Nivel					Desc;
		--Genera sentencia de borrado.
		Set @SentenciaSQL = 'Delete' + Char(9) +
							'From' + Char(9) + @Tabla_Actual_Esquema + '.' + @Tabla_Actual + Char(9);
		--Test
		--Print @SentenciaSQL
		Begin Try
			Begin Tran
			--Elimina los datos de las tablas.
			Execute SP_EXECUTESQL @SentenciaSQL;
			Commit Tran
		End Try
		Begin Catch
			Set @MsgError = @SentenciaSQL + ' ' + ERROR_MESSAGE()
			RollBack Tran
			RaisError(@MsgError, 16, 1)
		End Catch
		--Elimina la tabla para pasar al siguiente registro.
		Delete
		From	@Tablas_Borrado
		Where	Id_Tabla			= @Tabla_Actual_Id;
	End
	Print 'Datos eliminados correctamente.';
	If @L_Reinicia_Secuencias = 1
	Begin
		Insert Into @Secuencias_Borrado
		(
				Id,
				Nombre_Secuencia
		)
		Select		A.object_id,	B.name + '.' + A.name
		From		sys.sequences	A
		Inner Join	sys.schemas		B
		On			B.schema_id		= A.schema_id
		Order By	A.object_id
		--Proceso de reinicio.
		--Recorrido de secuencias para borrado de información.
		While Exists	(
							Select	*
							From	@Secuencias_Borrado
						)
		Begin
			--Carga de secuencia actual.
			Select	Top 1	@Secuencia_Actual		= A.Nombre_Secuencia,
							@Secuencia_Actual_Id	= A.Id,	
							@SentenciaSQL			= ''
			From			@Secuencias_Borrado		A;
			--Genera sentencia de borrado.
			Set @SentenciaSQL = 'Alter Sequence ' + Char(9) + @Secuencia_Actual + Char(9) + 'Restart With 1;'
			--Test
			--Print @SentenciaSQL;
			Begin Try
				Begin Tran
				--Elimina los datos de las tablas.
				Execute SP_EXECUTESQL @SentenciaSQL;
				Commit Tran
			End Try
			Begin Catch
				Set @MsgError = @SentenciaSQL + ' ' + ERROR_MESSAGE()
				RollBack Tran
				RaisError(@MsgError, 16, 1)
			End Catch
			--Elimina la tabla para pasar al siguiente registro.
			Delete
			From	@Secuencias_Borrado
			Where	Id			= @Secuencia_Actual_Id;
		End
		Print 'Secuencias reiniciadas correctamente.';
	End
	Set NoCount Off;
End
GO
