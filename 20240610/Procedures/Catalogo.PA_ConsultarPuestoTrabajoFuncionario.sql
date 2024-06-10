SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I>
-- Fecha de creación:		<19/07/2016>
-- Descripción :			<Permite consultar Puesto de trabajo por funcionario>
-- ==================================================================================================================================================================================================================================
-- Modificación:			<2017/07/04> <Andrés Díaz><Se modifica la consulta para que la oficina no sea requerida, y se simplifica las consultas.>
-- Modificación:			<2017/10/23> <Andrés Díaz><Se agregan los datos de Catalogo.JornadaLaboral a la consulta.>
-- Modificación				<22/05/2017> <Jonathan Aguilar Navarro> < Se quita las relaciones de la tipoOficinaMateria y Materia ya que la materia va a estar dado en el contexto>
-- Modificación				<13/08/2020> <Isaac Dobles Mata> <Se agrega consulta que también valide la vigencia del puesto de trabajo y el funcionario>
-- Modificación				<27/08/2020> <Jonathan Aguilar Navarro> <Se realizan ajustes para agregar la paginación y busqueda> 
-- Modificación				<31/08/2020> <Isaac Dobles Mata> <Se elimina tipo de funcionario y codigo de plaza de consulta> 
-- Modificación				<04/09/2020> <Jonathan Aguilar Navarro> <Se agrega la validación para fecha de desasignación nulas>
-- Modificación				<09/09/2020> <Jonathan Aguilar Navarro> <Se agrega validación para la búsqueda por nombre, apellido y segundo apellido cuando tienen tildes>
-- Modificación				<25/09/2020> <Daniel Ruiz Hernández> <Se agrega a la consulta los datos del tipo funcionario>
-- Modificación				<22/09/2020> <Luis Alonso Leiva Tames> <Se modifica para mostrar todos los puestos trabajos sin importar si tiene funcionario asignado>
-- Modificación				<05/03/2021> <Jonathan Aguilar Navarro><Se agrega parametro @Paginacion para saber si se debe pagina o no , por defecto se devulve todo>
-- Modificación				<12/07/2021> <Jose Miguel Avendañor Rosales><Se modifica para que liste correctamente los puestos de trabajo en los casos en que esten asociados a un contexto que no es una oficina principa>
-- Modificación				<08/08/2021> <Isaac Dobles Mata><Se agrega consulta exclusiva para mostrar los puestos de trabajo a usar en asignación de tareas>
-- Modificación				<23/08/2022> <Rafa Badilla Alvarado><La consulta exclusiva para mostrar los puestos de trabajo a usar en asignación de tareas se modifica para que incluya los puestos de trabajo relacionados a un funcionario con fecha fin vigencia vencida>
-- Modificación				<19/10/2022> <Josué Quirós Batista> <Se modifica para que no retorne registros vacíos (NULL)>
-- Modificación				<03/03/2023> <Aarón Ríos Retana> <Incidente 274922 - Se agrega clausula distinct para que no muestre resultados duplicados> 
-- Modificación				<14/07/2023> <Ronny Ramírez R.> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE en el WHERE>
-- ==================================================================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPuestoTrabajoFuncionario]
	@Codigo					uniqueidentifier	= Null,
	@CodOficina				Varchar(4)			= Null,
	@CodPuestoTrabajo		Varchar(14)			= Null,
	@UsuarioRed				Varchar(30)			= Null,
	@FechaActivacion		Datetime2			= Null,
	@FechaDesactivacion		Datetime2			= Null,
	@VigenciaCompleta		Bit					= 0	,
	@Nombre					varchar(50)			= Null,
	@Apellido1				varchar(50)			= Null,
	@Apellido2				varchar(50)			= Null,
	@NumeroPagina			smallint			,
	@CantidadRegistros		smallint			,
	@Paginacion				bit					= 0,
	@ConsultaPuestosTareas	bit					= 0
 As
Begin

 --Variables locales
	Declare @L_Codigo					uniqueidentifier	= @Codigo,
	@L_CodigoOficina					Varchar(4)			= @CodOficina,
	@L_CodigoPuestoTrabajo				Varchar(14)			= @CodPuestoTrabajo,
	@L_UsuarioRed						Varchar(30)			= @UsuarioRed,
	@L_FechaActivacion					Datetime2			= @FechaActivacion,
	@L_FechaDesactivacion				Datetime2			= @FechaDesactivacion,
	@L_VigenciaCompleta					Bit					= @VigenciaCompleta,
	@L_Nombre							varchar(50)			= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u'),
	@L_Apellido1						varchar(50)			= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u'),
	@L_Apellido2						varchar(50)			= REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u'),
	@L_NumeroPagina						INT					= Iif((@NumeroPagina Is Null Or @NumeroPagina <= 0), 1, @NumeroPagina),
	@L_CantidadRegistros				INT					= Iif((@CantidadRegistros Is Null Or @CantidadRegistros <= 0), 50, @CantidadRegistros),	
	@L_TotalRegistros					int,	
	@L_Paginacion						bit					= @Paginacion,
	@L_ConsultaPuestosTareas			bit					= @ConsultaPuestosTareas

	declare @Result Table 
	(
		Codigo							uniqueidentifier,					
		FechaActivacion					datetime2(3),		
		FechaDesactivacion				datetime2(3),
		SplitDatos						varchar(25),						
		CodigoPT						varchar(14),					
		DescripcionPT					varchar(255),
		FechaActivacionPT				datetime2(3),		
		FechaDesactivacionPT			datetime2(3),
		CodigoO							varchar(4),					
		DescripcionO					varchar(255),
		CodigoTO						smallint,
		NombreTO						varchar(255),
		FechaAsociacion					datetime2(3),	
		SplitFuncionario				varchar(25),		
		UsuarioRed						varchar(25),				
		Nombre							varchar(50),					
		PrimerApellido					varchar(50),			
		SegundoApellido					varchar(50),		
		CodigoPlaza						varchar(20),			
		FechaActivacionF				datetime2(3),		
		FechaDesactivacionF				datetime2(3),		
		Split							varchar(25),
		CodigoJL						smallint,
		DescripcionJL					varchar(255),
		HoraInicioJL					time(3),
		HoraFinJL						time(3),
		CodigoTPT						smallint,
		DescripcionTPT					varchar(100),
		FechaActivacionTPT				datetime2(3),
		FechaDesactivacionTPT			datetime2(3),
		CodigoTF						smallint,
		DescripcionTF					varchar(100),
		FechaActivacionTF				datetime2(3),
		FechaDesactivacionTF			datetime2(3)
	)

	--Se consulta los puestos de trabajo para asignación de tareas, vigentes, tengan o no funcionarios asignados, o que tengan una asignación vencida
	If(@L_ConsultaPuestosTareas = 1)
		BEGIN
			INSERT INTO @Result 
				(
					Codigo,					
					FechaActivacion					,		
					FechaDesactivacion				,
					SplitDatos						,						
					CodigoPT						,					
					DescripcionPT					,
					FechaActivacionPT				,		
					FechaDesactivacionPT			,
					CodigoO							,					
					DescripcionO					,
					CodigoTO						,
					NombreTO						,
					FechaAsociacion					,	
					SplitFuncionario				,		
					UsuarioRed						,				
					Nombre							,					
					PrimerApellido					,			
					SegundoApellido					,		
					CodigoPlaza						,			
					FechaActivacionF				,		
					FechaDesactivacionF				,		
					Split							,
					CodigoJL						,
					DescripcionJL					,
					HoraInicioJL					,
					HoraFinJL						,
					CodigoTPT						,
					DescripcionTPT					,
					FechaActivacionTPT				,
					FechaDesactivacionTPT			,
					CodigoTF						,
					DescripcionTF					,
					FechaActivacionTF				,
					FechaDesactivacionTF
				)
			SELECT		A.TU_CodPuestoFuncionario			AS	Codigo,					
						A.TF_Inicio_Vigencia				AS	FechaActivacion,		
						A.TF_Fin_Vigencia					AS	FechaDesactivacion,
						'SplitDatos'						AS	SplitDatos,	
						B.TC_CodPuestoTrabajo				AS	Codigo,					
						B.TC_Descripcion					AS	Descripcion,
						B.TF_Inicio_Vigencia				AS	FechaActivacion,		
						B.TF_Fin_Vigencia					AS	FechaDesactivacion,	
						D.TC_CodOficina						AS	Codigo,					
						D.TC_Nombre							AS	Descripcion,
						F.TN_CodTipoOficina					AS	Codigo,
						F.TC_Descripcion					AS	Nombre,
						F.TF_Inicio_Vigencia				AS	FechaAsociacion,	
						'SplitFuncionario'					AS	SplitFuncionario,		
						C.TC_UsuarioRed						AS	UsuarioRed,				
						C.TC_Nombre							AS	Nombre,					
						C.TC_PrimerApellido					AS	PrimerApellido,			
						C.TC_SegundoApellido				AS	SegundoApellido,		
						C.TC_CodPlaza						AS	CodigoPlaza,			
						C.TF_Inicio_Vigencia				AS	FechaActivacion,		
						C.TF_Fin_Vigencia					AS	FechaDesactivacion,					
						'Split'								AS	Split,
						H.TN_CodJornadaLaboral				AS	CodigoJL,
						H.TC_Descripcion					AS	DescripcionJL,
						H.TF_HoraInicio						AS	HoraInicioJL,
						H.TF_HoraFin						AS	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			AS	CodigoTPT,
						E.TC_Descripcion					AS	DescripcionTPT,
						E.TF_Inicio_Vigencia				AS	FechaActivacionTPT,
						E.TF_Fin_Vigencia					AS	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				AS	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS	FechaDesactivacionTF
			FROM		Catalogo.PuestoTrabajo				AS	B WITH(NOLOCK) 
			INNER JOIN	Catalogo.ContextoPuestoTrabajo		AS	G WITH(NOLOCK) 
			On			G.TC_CodPuestoTrabajo				=	B.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	AS	A WITH(NOLOCK) 
			On			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.Funcionario				AS	C WITH(NOLOCK)
			On			C.TC_UsuarioRed						=	A.TC_UsuarioRed
			INNER JOIN	Catalogo.Oficina					AS	D WITH(NOLOCK)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			INNER JOIN	Catalogo.TipoPuestoTrabajo			AS	E WITH(NOLOCK)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			INNER JOIN	Catalogo.TipoOficina				AS	F WITH(NOLOCK)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			INNER JOIN	Catalogo.JornadaLaboral				AS	H WITH(NOLOCK)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J WITH(NOLOCK)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario 
			WHERE	 	
			(
				@L_Codigo IS NOT NULL 
				AND
				(
					B.TC_CodPuestoTrabajo IN 
					(
						SELECT TC_CodPuestoTrabajo 
						FROM Catalogo.PuestoTrabajoFuncionario WITH(NOLOCK) 
						WHERE TU_CodPuestoFuncionario = @L_Codigo 
						OR TU_CodPuestoFuncionario IS NULL
					) 
				)
				OR @L_Codigo IS NULL
			)
			AND		G.TC_CodContexto						=	COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			AND		B.TC_CodPuestoTrabajo					=	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			AND		(
						@L_UsuarioRed IS NOT NULL AND
						( 
							A.TC_UsuarioRed IN 
							(
								SELECT TC_UsuarioRed 
								FROM Catalogo.PuestoTrabajoFuncionario WITH(NOLOCK) 
								WHERE TC_UsuarioRed = @L_UsuarioRed 
								OR TC_UsuarioRed IS NULL
							)
						) 
						OR @L_UsuarioRed IS NULL
					)
			AND	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NOT NULL AND (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				IN (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				FROM Catalogo.Funcionario WITH(NOLOCK) WHERE 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL)) OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL )		
			AND	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NOT NULL AND (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				IN (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				FROM Catalogo.Funcionario WITH(NOLOCK) WHERE 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL)) OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL )
			AND	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NOT NULL AND (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				IN (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				FROM Catalogo.Funcionario WITH(NOLOCK) WHERE 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL)) OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL )
			AND			(A.TF_Inicio_Vigencia				<	Getdate() OR A.TF_Inicio_Vigencia IS NULL)
			AND			(A.TF_Fin_Vigencia					IS	NULL OR	A.TF_Fin_Vigencia >= GETDATE())
			AND			(B.TF_Inicio_Vigencia				<	Getdate() OR B.TF_Inicio_Vigencia IS NULL)
			AND			(B.TF_Fin_Vigencia					IS	NULL OR	B.TF_Fin_Vigencia >= GETDATE())
			AND			(C.TF_Inicio_Vigencia				<	Getdate() OR C.TF_Inicio_Vigencia IS NULL)
			UNION
			SELECT		A.TU_CodPuestoFuncionario			AS	Codigo,					
						A.TF_Inicio_Vigencia				AS	FechaActivacion,		
						A.TF_Fin_Vigencia					AS	FechaDesactivacion,
						'SplitDatos'						AS	SplitDatos,	
						B.TC_CodPuestoTrabajo				AS	Codigo,					
						B.TC_Descripcion					AS	Descripcion,
						B.TF_Inicio_Vigencia				AS	FechaActivacion,		
						B.TF_Fin_Vigencia					AS	FechaDesactivacion,	
						D.TC_CodOficina						AS	Codigo,					
						D.TC_Nombre							AS	Descripcion,
						F.TN_CodTipoOficina					AS	Codigo,
						F.TC_Descripcion					AS	Nombre,
						F.TF_Inicio_Vigencia				AS	FechaAsociacion,	
						'SplitFuncionario'					AS	SplitFuncionario,		
						C.TC_UsuarioRed						AS	UsuarioRed,				
						C.TC_Nombre							AS	Nombre,					
						C.TC_PrimerApellido					AS	PrimerApellido,			
						C.TC_SegundoApellido				AS	SegundoApellido,		
						C.TC_CodPlaza						AS	CodigoPlaza,			
						C.TF_Inicio_Vigencia				AS	FechaActivacion,		
						C.TF_Fin_Vigencia					AS	FechaDesactivacion,					
						'Split'								AS	Split,
						H.TN_CodJornadaLaboral				AS	CodigoJL,
						H.TC_Descripcion					AS	DescripcionJL,
						H.TF_HoraInicio						AS	HoraInicioJL,
						H.TF_HoraFin						AS	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			AS	CodigoTPT,
						E.TC_Descripcion					AS	DescripcionTPT,
						E.TF_Inicio_Vigencia				AS	FechaActivacionTPT,
						E.TF_Fin_Vigencia					AS	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				AS	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS	FechaDesactivacionTF
			FROM		Catalogo.PuestoTrabajo				AS	B WITH(NOLOCK) 
			INNER JOIN	Catalogo.ContextoPuestoTrabajo		AS	G WITH(NOLOCK) 
			On			G.TC_CodPuestoTrabajo				=	B.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	AS	A WITH(NOLOCK) 
			On			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
			LEFT JOIN	Catalogo.Funcionario				AS	C WITH(NOLOCK)
			On			C.TC_UsuarioRed						=	A.TC_UsuarioRed
			INNER JOIN	Catalogo.Oficina					AS	D WITH(NOLOCK)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			INNER JOIN	Catalogo.TipoPuestoTrabajo			AS	E WITH(NOLOCK)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			INNER JOIN	Catalogo.TipoOficina				AS	F WITH(NOLOCK)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			INNER JOIN	Catalogo.JornadaLaboral				AS	H WITH(NOLOCK)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J WITH(NOLOCK)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario 
			WHERE	 	
			(
				@L_Codigo IS NOT NULL 
				AND
				(
					B.TC_CodPuestoTrabajo IN 
					(
						SELECT TC_CodPuestoTrabajo 
						FROM Catalogo.PuestoTrabajoFuncionario WITH(NOLOCK) 
						WHERE TU_CodPuestoFuncionario = @L_Codigo 
						OR TU_CodPuestoFuncionario IS NULL
					) 
				)
				OR @L_Codigo IS NULL
			)
			AND		G.TC_CodContexto						=	COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			AND		B.TC_CodPuestoTrabajo					=	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			AND		(
						@L_UsuarioRed IS NOT NULL AND
						( 
							A.TC_UsuarioRed IN 
							(
								SELECT TC_UsuarioRed 
								FROM Catalogo.PuestoTrabajoFuncionario WITH(NOLOCK) 
								WHERE TC_UsuarioRed = @L_UsuarioRed 
								OR TC_UsuarioRed IS NULL
							)
						) 
						OR @L_UsuarioRed IS NULL
					)
			AND	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NOT NULL AND (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				IN (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				FROM Catalogo.Funcionario WITH(NOLOCK) WHERE 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL)) OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL )		
			AND	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NOT NULL AND (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				IN (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				FROM Catalogo.Funcionario WITH(NOLOCK) WHERE 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL)) OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL )
			AND	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NOT NULL AND (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				IN (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				FROM Catalogo.Funcionario WITH(NOLOCK) WHERE 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL)) OR 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') IS NULL )
			AND	A.TF_Inicio_Vigencia =
						(
								SELECT MAX(TF_Inicio_Vigencia)
								FROM Catalogo.PuestoTrabajoFuncionario
								WHERE TC_CodPuestoTrabajo = A.TC_CodPuestoTrabajo
						)
			AND	A.TF_Fin_Vigencia <= GETDATE()
			AND			(B.TF_Inicio_Vigencia				<	Getdate() OR B.TF_Inicio_Vigencia IS NULL)
			AND			(B.TF_Fin_Vigencia					IS	NULL OR	B.TF_Fin_Vigencia >= GETDATE())
			OPTION(RECOMPILE);

			SELECT @L_TotalRegistros = @@rowcount;
		END
	Else If(@L_VigenciaCompleta = 0)
		Begin
		If (@FechaActivacion Is Null And @FechaDesactivacion Is Null)
			Begin
				
			insert into @Result 
				(
					Codigo,					
					FechaActivacion					,		
					FechaDesactivacion				,
					SplitDatos						,						
					CodigoPT						,					
					DescripcionPT					,
					FechaActivacionPT				,		
					FechaDesactivacionPT			,
					CodigoO							,					
					DescripcionO					,
					CodigoTO						,
					NombreTO						,
					FechaAsociacion					,	
					SplitFuncionario				,		
					UsuarioRed						,				
					Nombre							,					
					PrimerApellido					,			
					SegundoApellido					,		
					CodigoPlaza						,			
					FechaActivacionF				,		
					FechaDesactivacionF				,		
					Split							,
					CodigoJL						,
					DescripcionJL					,
					HoraInicioJL					,
					HoraFinJL						,
					CodigoTPT						,
					DescripcionTPT					,
					FechaActivacionTPT				,
					FechaDesactivacionTPT			,
					CodigoTF						,
					DescripcionTF					,
					FechaActivacionTF				,
					FechaDesactivacionTF
				)
			Select		A.TU_CodPuestoFuncionario			As	Codigo,					
						A.TF_Inicio_Vigencia				As	FechaActivacion,		
						A.TF_Fin_Vigencia					As	FechaDesactivacion,
						'SplitDatos'						As	SplitDatos,	
						B.TC_CodPuestoTrabajo				As	Codigo,					
						B.TC_Descripcion					As	Descripcion,
						B.TF_Inicio_Vigencia				As	FechaActivacion,		
						B.TF_Fin_Vigencia					As	FechaDesactivacion,	
						D.TC_CodOficina						As	Codigo,					
						D.TC_Nombre							As	Descripcion,
						F.TN_CodTipoOficina					As	Codigo,
						F.TC_Descripcion					As	Nombre,
						F.TF_Inicio_Vigencia				As	FechaAsociacion,	
						'SplitFuncionario'					As	SplitFuncionario,		
						C.TC_UsuarioRed						As	UsuarioRed,				
						C.TC_Nombre							As	Nombre,					
						C.TC_PrimerApellido					As	PrimerApellido,			
						C.TC_SegundoApellido				As	SegundoApellido,		
						C.TC_CodPlaza						As	CodigoPlaza,			
						C.TF_Inicio_Vigencia				As	FechaActivacion,		
						C.TF_Fin_Vigencia					As	FechaDesactivacion,					
						'Split'								As	Split,
						H.TN_CodJornadaLaboral				As	CodigoJL,
						H.TC_Descripcion					As	DescripcionJL,
						H.TF_HoraInicio						As	HoraInicioJL,
						H.TF_HoraFin						As	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			As	CodigoTPT,
						E.TC_Descripcion					As	DescripcionTPT,
						E.TF_Inicio_Vigencia				As	FechaActivacionTPT,
						E.TF_Fin_Vigencia					As	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				as	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS	FechaDesactivacionTF
			From		Catalogo.PuestoTrabajo				As B With(Nolock) 
			Inner Join	Catalogo.ContextoPuestoTrabajo		As G With(Nolock) 
			On			G.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			Inner join	Catalogo.PuestoTrabajoFuncionario	As A With(Nolock) 
			On			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
			Left Join	Catalogo.Funcionario				As	C With(Nolock)
			On			C.TC_UsuarioRed						= A.TC_UsuarioRed
			Inner Join	Catalogo.Oficina					As	D With(Nolock)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			Inner Join	Catalogo.TipoPuestoTrabajo			As	E With(Nolock)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoOficina				As	F With(Nolock)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral				As	H With(NoLock)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J With(Nolock)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario
			Where	 	(@L_Codigo is not null and (
														B.TC_CodPuestoTrabajo  in (	
																					select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario With(Nolock) 
																					where TU_CodPuestoFuncionario =  @L_Codigo or TU_CodPuestoFuncionario is null
																					) 
													) or @L_Codigo is null
						)
			And			G.TC_CodContexto	= COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			And			B.TC_CodPuestoTrabajo =	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			And	 (@L_UsuarioRed is not null and ( 
				A.TC_UsuarioRed in (select TC_UsuarioRed from Catalogo.PuestoTrabajoFuncionario With(Nolock) where
				TC_UsuarioRed = @L_UsuarioRed or TC_UsuarioRed is null)) or @L_UsuarioRed is null)
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )		
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			OPTION(RECOMPILE);

			select @L_TotalRegistros = @@rowcount; 
		End
		If (@FechaActivacion Is Not Null And @FechaDesactivacion Is Null)
			Begin
			insert into @Result 
				(
					Codigo,					
					FechaActivacion					,		
					FechaDesactivacion				,
					SplitDatos						,						
					CodigoPT						,					
					DescripcionPT					,
					FechaActivacionPT				,		
					FechaDesactivacionPT			,
					CodigoO							,					
					DescripcionO					,
					CodigoTO						,
					NombreTO						,
					FechaAsociacion					,	
					SplitFuncionario				,		
					UsuarioRed						,				
					Nombre							,					
					PrimerApellido					,			
					SegundoApellido					,		
					CodigoPlaza						,			
					FechaActivacionF				,		
					FechaDesactivacionF				,		
					Split							,
					CodigoJL						,
					DescripcionJL					,
					HoraInicioJL					,
					HoraFinJL						,
					CodigoTPT						,
					DescripcionTPT					,
					FechaActivacionTPT				,
					FechaDesactivacionTPT			,
					CodigoTF						,
					DescripcionTF					,
					FechaActivacionTF				,
					FechaDesactivacionTF
				)
			Select		A.TU_CodPuestoFuncionario			As	Codigo,					
						A.TF_Inicio_Vigencia				As	FechaActivacion,		
						A.TF_Fin_Vigencia					As	FechaDesactivacion,
						'SplitDatos'						As	SplitDatos,	
						B.TC_CodPuestoTrabajo				As	Codigo,					
						B.TC_Descripcion					As	Descripcion,
						B.TF_Inicio_Vigencia				As	FechaActivacion,		
						B.TF_Fin_Vigencia					As	FechaDesactivacion,	
						D.TC_CodOficina						As	Codigo,					
						D.TC_Nombre							As	Descripcion,
						F.TN_CodTipoOficina					As	Codigo,
						F.TC_Descripcion					As	Nombre,
						F.TF_Inicio_Vigencia				As	FechaAsociacion,	
						'SplitFuncionario'					As	SplitFuncionario,		
						C.TC_UsuarioRed						As	UsuarioRed,				
						C.TC_Nombre							As	Nombre,					
						C.TC_PrimerApellido					As	PrimerApellido,			
						C.TC_SegundoApellido				As	SegundoApellido,		
						C.TC_CodPlaza						As	CodigoPlaza,			
						C.TF_Inicio_Vigencia				As	FechaActivacion,		
						C.TF_Fin_Vigencia					As	FechaDesactivacion,					
						'Split'								As	Split,
						H.TN_CodJornadaLaboral				As	CodigoJL,
						H.TC_Descripcion					As	DescripcionJL,
						H.TF_HoraInicio						As	HoraInicioJL,
						H.TF_HoraFin						As	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			As	CodigoTPT,
						E.TC_Descripcion					As	DescripcionTPT,
						E.TF_Inicio_Vigencia				As	FechaActivacionTPT,
						E.TF_Fin_Vigencia					As	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				as	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS	FechaDesactivacionTF
			From		Catalogo.PuestoTrabajo				As B With(Nolock) 
			Inner Join	Catalogo.ContextoPuestoTrabajo		As G With(Nolock) 
			On			G.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			Inner join	Catalogo.PuestoTrabajoFuncionario	As A With(Nolock) 
			On			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
			Left Join	Catalogo.Funcionario				As	C With(Nolock)
			On			C.TC_UsuarioRed						= A.TC_UsuarioRed
			Inner Join	Catalogo.Oficina					As	D With(Nolock)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			Inner Join	Catalogo.TipoPuestoTrabajo			As	E With(Nolock)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoOficina				As	F With(Nolock)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral				As	H With(NoLock)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J With(Nolock)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario 
			Where	 	
			(@L_Codigo is not null and (
				B.TC_CodPuestoTrabajo  in 
				(select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario With(Nolock) where 
				TU_CodPuestoFuncionario =  @L_Codigo or TU_CodPuestoFuncionario is null
				) )or @L_Codigo is null)
			And			G.TC_CodContexto	= COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			And			B.TC_CodPuestoTrabajo =	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			And	 (@L_UsuarioRed is not null and ( 
				A.TC_UsuarioRed in (select TC_UsuarioRed from Catalogo.PuestoTrabajoFuncionario With(Nolock) where
				TC_UsuarioRed = @L_UsuarioRed or TC_UsuarioRed is null)) or @L_UsuarioRed is null)
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )		
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And			(A.TF_Inicio_Vigencia				<	Getdate() or A.TF_Inicio_Vigencia is null)
			And			(A.TF_Fin_Vigencia					Is	Null Or	A.TF_Fin_Vigencia >= Getdate())
			order by	A.TF_Fin_Vigencia					desc
			OPTION(RECOMPILE);

			select @L_TotalRegistros = @@rowcount; 
		End
		If (@FechaActivacion Is Null And @FechaDesactivacion Is Not Null)
			Begin
			insert into @Result 
				(
					Codigo,					
					FechaActivacion					,		
					FechaDesactivacion				,
					SplitDatos						,						
					CodigoPT						,					
					DescripcionPT					,
					FechaActivacionPT				,		
					FechaDesactivacionPT			,
					CodigoO							,					
					DescripcionO					,
					CodigoTO						,
					NombreTO						,
					FechaAsociacion					,	
					SplitFuncionario				,		
					UsuarioRed						,				
					Nombre							,					
					PrimerApellido					,			
					SegundoApellido					,		
					CodigoPlaza						,			
					FechaActivacionF				,		
					FechaDesactivacionF				,		
					Split							,
					CodigoJL						,
					DescripcionJL					,
					HoraInicioJL					,
					HoraFinJL						,
					CodigoTPT						,
					DescripcionTPT					,
					FechaActivacionTPT				,
					FechaDesactivacionTPT			,
					CodigoTF						,
					DescripcionTF					,
					FechaActivacionTF				,
					FechaDesactivacionTF
				)
			Select		A.TU_CodPuestoFuncionario			As	Codigo,					
						A.TF_Inicio_Vigencia				As	FechaActivacion,		
						A.TF_Fin_Vigencia					As	FechaDesactivacion,
						'SplitDatos'						As	SplitDatos,	
						B.TC_CodPuestoTrabajo				As	Codigo,					
						B.TC_Descripcion					As	Descripcion,
						B.TF_Inicio_Vigencia				As	FechaActivacion,		
						B.TF_Fin_Vigencia					As	FechaDesactivacion,	
						D.TC_CodOficina						As	Codigo,					
						D.TC_Nombre							As	Descripcion,
						F.TN_CodTipoOficina					As	Codigo,
						F.TC_Descripcion					As	Nombre,
						F.TF_Inicio_Vigencia				As	FechaAsociacion,	
						'SplitFuncionario'					As	SplitFuncionario,		
						C.TC_UsuarioRed						As	UsuarioRed,				
						C.TC_Nombre							As	Nombre,					
						C.TC_PrimerApellido					As	PrimerApellido,			
						C.TC_SegundoApellido				As	SegundoApellido,		
						C.TC_CodPlaza						As	CodigoPlaza,			
						C.TF_Inicio_Vigencia				As	FechaActivacion,		
						C.TF_Fin_Vigencia					As	FechaDesactivacion,					
						'Split'								As	Split,
						H.TN_CodJornadaLaboral				As	CodigoJL,
						H.TC_Descripcion					As	DescripcionJL,
						H.TF_HoraInicio						As	HoraInicioJL,
						H.TF_HoraFin						As	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			As	CodigoTPT,
						E.TC_Descripcion					As	DescripcionTPT,
						E.TF_Inicio_Vigencia				As	FechaActivacionTPT,
						E.TF_Fin_Vigencia					As	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				as	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS	FechaDesactivacionTF
			From		Catalogo.PuestoTrabajo				As B With(Nolock) 
			Inner Join	Catalogo.ContextoPuestoTrabajo		As G With(Nolock) 
			On			G.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			Inner join	Catalogo.PuestoTrabajoFuncionario	As A With(Nolock) 
			On			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
			Left Join	Catalogo.Funcionario				As	C With(Nolock)
			On			C.TC_UsuarioRed						= A.TC_UsuarioRed
			Inner Join	Catalogo.Oficina					As	D With(Nolock)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			Inner Join	Catalogo.TipoPuestoTrabajo			As	E With(Nolock)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoOficina				As	F With(Nolock)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral				As	H With(NoLock)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J With(Nolock)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario 
			Where	 
			(@L_Codigo is not null and (
				B.TC_CodPuestoTrabajo  in 
				(select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario With(Nolock) where 
				TU_CodPuestoFuncionario =  @L_Codigo or TU_CodPuestoFuncionario is null
				) )or @L_Codigo is null)
			And			G.TC_CodContexto	= COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			And			B.TC_CodPuestoTrabajo =	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			And	 (@L_UsuarioRed is not null and ( 
				A.TC_UsuarioRed in (select TC_UsuarioRed from Catalogo.PuestoTrabajoFuncionario With(Nolock) where
				TC_UsuarioRed = @L_UsuarioRed or TC_UsuarioRed is null)) or @L_UsuarioRed is null)
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )		
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And			(A.TF_Inicio_Vigencia				>	Getdate() Or A.TF_Fin_Vigencia < Getdate())
			OPTION(RECOMPILE);

			select @L_TotalRegistros = @@rowcount; 
		End
		Else If (@FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null)
			Begin
			insert into @Result 
				(
					Codigo,					
					FechaActivacion					,		
					FechaDesactivacion				,
					SplitDatos						,						
					CodigoPT						,					
					DescripcionPT					,
					FechaActivacionPT				,		
					FechaDesactivacionPT			,
					CodigoO							,					
					DescripcionO					,
					CodigoTO						,
					NombreTO						,
					FechaAsociacion					,	
					SplitFuncionario				,		
					UsuarioRed						,				
					Nombre							,					
					PrimerApellido					,			
					SegundoApellido					,		
					CodigoPlaza						,			
					FechaActivacionF				,		
					FechaDesactivacionF				,		
					Split							,
					CodigoJL						,
					DescripcionJL					,
					HoraInicioJL					,
					HoraFinJL						,
					CodigoTPT						,
					DescripcionTPT					,
					FechaActivacionTPT				,
					FechaDesactivacionTPT			,
					CodigoTF						,
					DescripcionTF					,
					FechaActivacionTF				,
					FechaDesactivacionTF
				)
			Select		A.TU_CodPuestoFuncionario			As	Codigo,					
						A.TF_Inicio_Vigencia				As	FechaActivacion,		
						A.TF_Fin_Vigencia					As	FechaDesactivacion,
						'SplitDatos'						As	SplitDatos,	
						B.TC_CodPuestoTrabajo				As	Codigo,					
						B.TC_Descripcion					As	Descripcion,
						B.TF_Inicio_Vigencia				As	FechaActivacion,		
						B.TF_Fin_Vigencia					As	FechaDesactivacion,	
						D.TC_CodOficina						As	Codigo,					
						D.TC_Nombre							As	Descripcion,
						F.TN_CodTipoOficina					As	Codigo,
						F.TC_Descripcion					As	Nombre,
						F.TF_Inicio_Vigencia				As	FechaAsociacion,	
						'SplitFuncionario'					As	SplitFuncionario,		
						C.TC_UsuarioRed						As	UsuarioRed,				
						C.TC_Nombre							As	Nombre,					
						C.TC_PrimerApellido					As	PrimerApellido,			
						C.TC_SegundoApellido				As	SegundoApellido,		
						C.TC_CodPlaza						As	CodigoPlaza,			
						C.TF_Inicio_Vigencia				As	FechaActivacion,		
						C.TF_Fin_Vigencia					As	FechaDesactivacion,					
						'Split'								As	Split,
						H.TN_CodJornadaLaboral				As	CodigoJL,
						H.TC_Descripcion					As	DescripcionJL,
						H.TF_HoraInicio						As	HoraInicioJL,
						H.TF_HoraFin						As	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			As	CodigoTPT,
						E.TC_Descripcion					As	DescripcionTPT,
						E.TF_Inicio_Vigencia				As	FechaActivacionTPT,
						E.TF_Fin_Vigencia					As	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				as	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS	FechaDesactivacionTF
			From		Catalogo.PuestoTrabajo				As B With(Nolock) 
			Inner Join	Catalogo.ContextoPuestoTrabajo		As G With(Nolock) 
			On			G.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			Inner join	Catalogo.PuestoTrabajoFuncionario	As A With(Nolock) 
			On			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
			Left Join	Catalogo.Funcionario				As	C With(Nolock)
			On			C.TC_UsuarioRed						= A.TC_UsuarioRed
			Inner Join	Catalogo.Oficina					As	D With(Nolock)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			Inner Join	Catalogo.TipoPuestoTrabajo			As	E With(Nolock)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoOficina				As	F With(Nolock)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral				As	H With(NoLock)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J With(Nolock)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario 
			Where	 	
			(@L_Codigo is not null and (
				B.TC_CodPuestoTrabajo  in 
				(select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario With(Nolock) where 
				TU_CodPuestoFuncionario =  @L_Codigo or TU_CodPuestoFuncionario is null
				) )or @L_Codigo is null)
			And			G.TC_CodContexto	= COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			And			B.TC_CodPuestoTrabajo =	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			And	 (@L_UsuarioRed is not null and ( 
				A.TC_UsuarioRed in (select TC_UsuarioRed from Catalogo.PuestoTrabajoFuncionario With(Nolock) where
				TC_UsuarioRed = @L_UsuarioRed or TC_UsuarioRed is null)) or @L_UsuarioRed is null)
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )		
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And			(A.TF_Inicio_Vigencia				>=	@L_FechaActivacion or A.TF_Inicio_Vigencia is null) 
			And			(A.TF_Fin_Vigencia					is null or A.TF_Fin_Vigencia	 <=@L_FechaDesactivacion)	
			OPTION(RECOMPILE);

			select @L_TotalRegistros = @@rowcount; 
		End
		End
	Else
		Begin
		insert into @Result 
				(
					Codigo,					
					FechaActivacion					,		
					FechaDesactivacion				,
					SplitDatos						,						
					CodigoPT						,					
					DescripcionPT					,
					FechaActivacionPT				,		
					FechaDesactivacionPT			,
					CodigoO							,					
					DescripcionO					,
					CodigoTO						,
					NombreTO						,
					FechaAsociacion					,	
					SplitFuncionario				,		
					UsuarioRed						,				
					Nombre							,					
					PrimerApellido					,			
					SegundoApellido					,		
					CodigoPlaza						,			
					FechaActivacionF				,		
					FechaDesactivacionF				,		
					Split							,
					CodigoJL						,
					DescripcionJL					,
					HoraInicioJL					,
					HoraFinJL						,
					CodigoTPT						,
					DescripcionTPT					,
					FechaActivacionTPT				,
					FechaDesactivacionTPT			,
					CodigoTF						,
					DescripcionTF					,
					FechaActivacionTF				,
					FechaDesactivacionTF
				)
			Select		A.TU_CodPuestoFuncionario			As	Codigo,					
						A.TF_Inicio_Vigencia				As	FechaActivacion,		
						A.TF_Fin_Vigencia					As	FechaDesactivacion,
						'SplitDatos'						As	SplitDatos,	
						B.TC_CodPuestoTrabajo				As	Codigo,					
						B.TC_Descripcion					As	Descripcion,
						B.TF_Inicio_Vigencia				As	FechaActivacion,		
						B.TF_Fin_Vigencia					As	FechaDesactivacion,	
						D.TC_CodOficina						As	Codigo,					
						D.TC_Nombre							As	Descripcion,
						F.TN_CodTipoOficina					As	Codigo,
						F.TC_Descripcion					As	Nombre,
						F.TF_Inicio_Vigencia				As	FechaAsociacion,	
						'SplitFuncionario'					As	SplitFuncionario,		
						C.TC_UsuarioRed						As	UsuarioRed,				
						C.TC_Nombre							As	Nombre,					
						C.TC_PrimerApellido					As	PrimerApellido,			
						C.TC_SegundoApellido				As	SegundoApellido,		
						C.TC_CodPlaza						As	CodigoPlaza,			
						C.TF_Inicio_Vigencia				As	FechaActivacion,		
						C.TF_Fin_Vigencia					As	FechaDesactivacion,					
						'Split'								As	Split,
						H.TN_CodJornadaLaboral				As	CodigoJL,
						H.TC_Descripcion					As	DescripcionJL,
						H.TF_HoraInicio						As	HoraInicioJL,
						H.TF_HoraFin						As	HoraFinJL,
						E.TN_CodTipoPuestoTrabajo			As	CodigoTPT,
						E.TC_Descripcion					As	DescripcionTPT,
						E.TF_Inicio_Vigencia				As	FechaActivacionTPT,
						E.TF_Fin_Vigencia					As	FechaDesactivacionTPT,
						E.TN_CodTipoFuncionario				as	CodigoTF,
						J.TC_Descripcion					AS	DescripcionTF,
						j.TF_Inicio_Vigencia				AS	FechaActivacionTF,
						J.TF_Fin_Vigencia					AS  FechaDesactivacionTF
			From		Catalogo.PuestoTrabajo				As B With(Nolock) 
			Inner Join	Catalogo.ContextoPuestoTrabajo		As G With(Nolock) 
			On			G.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			Inner join	Catalogo.PuestoTrabajoFuncionario	As A With(Nolock) 
			On			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
			Left Join	Catalogo.Funcionario				As	C With(Nolock)
			On			C.TC_UsuarioRed						= A.TC_UsuarioRed
			Inner Join	Catalogo.Oficina					As	D With(Nolock)
			On			D.TC_CodOficina						=	B.TC_CodOficina
			Inner Join	Catalogo.TipoPuestoTrabajo			As	E With(Nolock)
			On			E.TN_CodTipoPuestoTrabajo			=	B.TN_CodTipoPuestoTrabajo
			Inner Join	Catalogo.TipoOficina				As	F With(Nolock)
			On			F.TN_CodTipoOficina					=	D.TN_CodTipoOficina
			Inner Join	Catalogo.JornadaLaboral				As	H With(NoLock)
			On			H.TN_CodJornadaLaboral				=	B.TN_CodJornadaLaboral
			INNER JOIN	Catalogo.TipoFuncionario			AS	J With(Nolock)
			ON			J.TN_CodTipoFuncionario				=	E.TN_CodTipoFuncionario 
			Where	
			(@L_Codigo is not null and (
				B.TC_CodPuestoTrabajo  in 
				(select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario With(Nolock) where 
				TU_CodPuestoFuncionario =  @L_Codigo or TU_CodPuestoFuncionario is null
				) )or @L_Codigo is null)
			And			G.TC_CodContexto	= COALESCE(@L_CodigoOficina, G.TC_CodContexto)
			And			B.TC_CodPuestoTrabajo =	COALESCE(@L_CodigoPuestoTrabajo, B.TC_CodPuestoTrabajo)
			And	 (@L_UsuarioRed is not null and ( 
				A.TC_UsuarioRed in (select TC_UsuarioRed from Catalogo.PuestoTrabajoFuncionario With(Nolock) where
				TC_UsuarioRed = @L_UsuarioRed or TC_UsuarioRed is null)) or @L_UsuarioRed is null)
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Nombre), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )		
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_PrimerApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido1), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And	(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is not null and (
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(C.TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				in (select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') 
				from Catalogo.Funcionario With(Nolock) where 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') = 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(TC_SegundoApellido), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null)) or 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(@L_Apellido2), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') is null )
			And			(A.TF_Inicio_Vigencia				<	Getdate() or A.TF_Inicio_Vigencia is null)
			And			(A.TF_Fin_Vigencia					Is	Null Or	A.TF_Fin_Vigencia >= Getdate())
			And			B.TF_Inicio_Vigencia				<	Getdate()
			And			(B.TF_Fin_Vigencia					Is	Null Or	B.TF_Fin_Vigencia >= Getdate())
			And			(C.TF_Inicio_Vigencia				<	Getdate() or C.TF_Inicio_Vigencia is null) 
			And			(C.TF_Fin_Vigencia					Is	Null Or	C.TF_Fin_Vigencia >= Getdate())
			order by	B.TF_Fin_Vigencia					desc
			OPTION(RECOMPILE);

		select @L_TotalRegistros = @@rowcount; 
	End
	IF (@L_Paginacion = 1)
		BEGIN
		select
				@L_TotalRegistros		as TotalRegistros		,
				Codigo	,					
				FechaActivacion					,		
				FechaDesactivacion				,
				SplitDatos						,						
				CodigoPT						,					
				DescripcionPT					,
				FechaActivacionPT				,		
				FechaDesactivacionPT			,
				CodigoO							,					
				DescripcionO					,
				CodigoTO						,
				NombreTO						,
				FechaAsociacion					,
				SplitFuncionario				,		
				UsuarioRed						,				
				Nombre							,					
				PrimerApellido					,			
				SegundoApellido					,		
				CodigoPlaza						,			
				FechaActivacionF				,		
				FechaDesactivacionF				,						
				Split							,
				CodigoJL						,
				DescripcionJL					,
				HoraInicioJL					,
				HoraFinJL						,
				CodigoTPT						,
				DescripcionTPT					,
				FechaActivacionTPT				,
				FechaDesactivacionTPT			,
				CodigoTF						,
				DescripcionTF					,
				FechaActivacionTF				,
				FechaDesactivacionTF
			from @Result
			ORDER By FechaActivacion ASC
			OFFSET		(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS 
			FETCH NEXT	@L_CantidadRegistros ROWS ONLY
	END
	ELSE
		BEGIN
		select distinct 
				@L_TotalRegistros		as TotalRegistros		,
				Codigo	,					
				FechaActivacion					,		
				FechaDesactivacion				,
				SplitDatos						,						
				CodigoPT						,					
				DescripcionPT					,
				FechaActivacionPT				,		
				FechaDesactivacionPT			,
				CodigoO							,					
				DescripcionO					,
				CodigoTO						,
				NombreTO						,
				FechaAsociacion					,
				SplitFuncionario				,		
				UsuarioRed						,				
				Nombre							,					
				PrimerApellido					,			
				SegundoApellido					,		
				CodigoPlaza						,			
				FechaActivacionF				,		
				FechaDesactivacionF				,						
				Split							,
				CodigoJL						,
				DescripcionJL					,
				HoraInicioJL					,
				HoraFinJL						,
				CodigoTPT						,
				DescripcionTPT					,
				FechaActivacionTPT				,
				FechaDesactivacionTPT			,
				CodigoTF						,
				DescripcionTF					,
				FechaActivacionTF				,
				FechaDesactivacionTF
		from @Result
		ORDER By FechaActivacion ASC
	END
End
GO
