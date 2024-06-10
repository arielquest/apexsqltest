SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<30-10-2020>
-- Description:					<Traducción de la Variables relacionadas con mostrar un funcionarios asociados a un despacho>
--								<El parametro @Salida debe recibir los siguientes valores:>
--											 <1: Muestra Nombre y Apellidos>
--											 <2: Codigo de plaza>
--											 <3: Nombre, Puesto>
--											 <4: Titulo + Nombre + Apellidos, Puesto >
-- Modificacion:				<14/06/2021> <Jose Miguel Avendaño Rosales> Se ajusta para que permita listar personas de varios tipos de puestos de trabajo al mismo tiempo.
-- Modificacion:				<16/02/2024> <Ronny Ramírez R.> Se agrega join con Catalogo.ContextoPuestoTrabajo para filtrar por contexto oficinas no presupuestarias en lugar de oficina
-- ========================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_ListarFuncionarios]
	@Contexto				As VarChar(4),
	@TiposPuestoTrabajo		As VarChar(MAX),
	@Salida					As Integer
AS
BEGIN
	Declare		@L_Contexto             As VarChar(4)   = @Contexto,
				@L_TiposPuestoTrabajo	VARCHAR(MAX)	= @TiposPuestoTrabajo,
				@L_Salida				As Integer		= @Salida;
	Declare		@L_Tipos				TABLE (Tipo int);

	If LEN(@L_TiposPuestoTrabajo) = 0
		INSERT Into @L_Tipos
		Select	TN_CodTipoPuestoTrabajo
		From	Catalogo.TipoPuestoTrabajo With(NoLock)
	Else
		INSERT Into @L_Tipos
		Select	convert(int,RTRIM(LTRIM(Value)))
		From	STRING_SPLIT(@L_TiposPuestoTrabajo, ',')

	Select		Case 
					When @L_Salida = 1 Then Concat(C.TC_Nombre, ' ', C.TC_PrimerApellido, ' ', C.TC_SegundoApellido)
					When @L_Salida = 2 Then C.TC_CodPlaza
					When @L_Salida = 3 Then Concat(C.TC_Nombre, ' ', C.TC_PrimerApellido, ' ', C.TC_SegundoApellido, ', ', D.TC_Descripcion)
					When @L_Salida = 4 Then Concat(Case C.TC_CodTitulo
													When 'L' Then 'Licenciado '
													When 'A' Then 'Licenciada '
													When 'M' Then 'Master '
													When 'D' Then 'Doctor '
													When 'B' then 'Doctora '
												   End, C.TC_Nombre, ' ', C.TC_PrimerApellido, ' ', C.TC_SegundoApellido, ', ', D.TC_Descripcion)
				End As Nombre
	From		Catalogo.PuestoTrabajo				A With(NoLock)
	INNER JOIN	Catalogo.PuestoTrabajoFuncionario	B With(NoLock)
	On			A.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
	AND			B.TF_Inicio_Vigencia				<= GETDATE()
	AND			(B.TF_Fin_Vigencia					> GETDATE()
	OR			B.TF_Fin_Vigencia					IS NULL)
	INNER JOIN	Catalogo.ContextoPuestoTrabajo		P WITH(NOLOCK)
	ON			P.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
	Inner Join	Catalogo.Funcionario				C With (NoLock)
	On			B.TC_UsuarioRed						= C.TC_UsuarioRed
	Inner Join	Catalogo.TipoPuestoTrabajo			D With (NoLock)
	On			D.TN_CodTipoPuestoTrabajo			= A.TN_CodTipoPuestoTrabajo
	Where		P.TC_CodContexto					= @L_Contexto
	And			A.TN_CodTipoPuestoTrabajo			In (
														SELECT	Tipo
														FROM	@L_Tipos
														)
END
GO
