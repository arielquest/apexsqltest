SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<13/08/2015>
-- Descripción :			<Permite Consultar los funcionarios de la tabla Catalogo.Funcionario> 
-- ===========================================================================================================================================================
-- Modificación:    <Roger Lara> <22/10/2015> <Se incluyo parametro fecha de activacion>
-- Modificación:	<Andrés Díaz> <08/07/2016> <Se modifican las consultas para que devuelvan los valores ordenados por nombre.>
-- Modificación:	<Ronny Ramírez R.> <22/07/2020> <Se agrega campo de sexo por requerimiento de HU 05 FUN Buscar Funcionario para un puesto de trabajo>
-- Modificación:	<Aida E Siles R> <15/09/2020> <Se agrega el campo de CodFirma para obtener id de la firma funcionario>
-- Modificación:	<Ronny Ramírez R.> <11/03/2021> <Se agrega nuevo campo TC_CodTitulo al SP de consulta>
-- ===========================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFuncionario]
 @UsuarioRed			Varchar(30)	= Null,
 @Nombre				Varchar(50)	= Null, 
 @FechaDesactivacion	Datetime2(7) = Null,
 @FechaActivacion		Datetime2(7) = Null

 As
 Begin
 	
	--Variables
	DECLARE	@L_TC_UsuarioRed			VARCHAR(30)		= @UsuarioRed,
			@L_TC_Nombre				VARCHAR(50)		= @Nombre,
			@L_TF_Inicio_Vigencia		DATETIME2(7)	= @FechaActivacion,
			@L_TF_Fin_Vigencia			DATETIME2(7)	= @FechaDesactivacion

	--Variable para almacenar el nombre 
	Declare @NombreLike Varchar(50)	
	Set		@NombreLike				=	iif(@L_TC_Nombre Is Not Null,'%' +  @L_TC_Nombre + '%','%')

	--Lógica

	--Si todo es nulo se devuelven todos los registros
	If	@L_TC_UsuarioRed Is Null And @L_TC_Nombre Is Null And @L_TF_Fin_Vigencia Is Null and @L_TF_Inicio_Vigencia is null
	Begin	
			Select		A.TC_UsuarioRed			As	UsuarioRed,			A.TC_Nombre				As	Nombre,
						A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,
						A.TC_CodPlaza			As	CodigoPlaza,		A.TU_CodFirma	        As  CodigoFirma,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia		As	FechaDesactivacion,
						'Split'					As	'Split',
						A.TC_CodSexo			As	Codigo,
						S.TC_Descripcion		As	Descripcion,
						'Split'					As	'Split',
						A.TC_CodTitulo			As	Titulo
			From		Catalogo.Funcionario	A 
			LEFT JOIN	Catalogo.Sexo			S
			ON			A.TC_CodSexo			= S.TC_CodSexo
			Order By	A.TC_Nombre, A.TC_PrimerApellido, A.TC_SegundoApellido;
	End
	
	--Solo por codigo
	Else IF	@L_TC_UsuarioRed Is Not Null
	Begin
			Select		A.TC_UsuarioRed			As	UsuarioRed,			A.TC_Nombre				As	Nombre,
						A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,
						A.TC_CodPlaza			As	CodigoPlaza,		A.TU_CodFirma	        As  CodigoFirma,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia		As	FechaDesactivacion,
						'Split'					As	'Split',
						A.TC_CodSexo			As	Codigo,
						S.TC_Descripcion		As	Descripcion,
						'Split'					As	'Split',
						A.TC_CodTitulo			As	Titulo
			From		Catalogo.Funcionario	A 
			LEFT JOIN	Catalogo.Sexo			S
			ON			A.TC_CodSexo			= S.TC_CodSexo
			Where		A.TC_UsuarioRed	=	@L_TC_UsuarioRed
			Order By	A.TC_Nombre, A.TC_PrimerApellido, A.TC_SegundoApellido;

	End	
	
	--Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @L_TF_Fin_Vigencia
	Else If @L_TC_Nombre is not null	Begin
			Select		A.TC_UsuarioRed			As	UsuarioRed,			A.TC_Nombre				As	Nombre,
						A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,
						A.TC_CodPlaza			As	CodigoPlaza,		A.TU_CodFirma           As  CodigoFirma,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia		As	FechaDesactivacion,
						'Split'					As	'Split',
						A.TC_CodSexo			As	Codigo,
						S.TC_Descripcion		As	Descripcion,
						'Split'					As	'Split',
						A.TC_CodTitulo			As	Titulo
			From		Catalogo.Funcionario	A 
			LEFT JOIN	Catalogo.Sexo			S
			ON			A.TC_CodSexo			= S.TC_CodSexo
			where		A.TC_Nombre like @NombreLike	
			And			A.TF_Inicio_Vigencia		< GETDATE ()
			And			(A.TF_Fin_Vigencia Is Null Or A.TF_Fin_Vigencia  >= GETDATE ())	
			Order By	A.TC_Nombre, A.TC_PrimerApellido, A.TC_SegundoApellido;
	End
	Else--por Activos
	If  @L_TF_Inicio_Vigencia Is Not Null and @L_TF_Fin_Vigencia Is Null
	Begin
		Select		A.TC_UsuarioRed			As	UsuarioRed,			A.TC_Nombre				As	Nombre,
					A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,
					A.TC_CodPlaza			As	CodigoPlaza,		A.TU_CodFirma           As  CodigoFirma,		
					A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia		As	FechaDesactivacion,
					'Split'					As	'Split',
					A.TC_CodSexo			As	Codigo,
					S.TC_Descripcion		As	Descripcion,
					'Split'					As	'Split',
					A.TC_CodTitulo			As	Titulo
		From		Catalogo.Funcionario	A 
		LEFT JOIN	Catalogo.Sexo			S
		ON			A.TC_CodSexo			= S.TC_CodSexo
		Where		A.TF_Inicio_Vigencia  < GETDATE ()
		and			(A.TF_Fin_Vigencia Is Null OR A.TF_Fin_Vigencia  >= GETDATE ())
		Order By	A.TC_Nombre, A.TC_PrimerApellido, A.TC_SegundoApellido;
	End
	Else	
		Begin--Por inactivos
			 if  @L_TF_Inicio_Vigencia Is Null and @L_TF_Fin_Vigencia Is not Null
			 Begin 
	
					Select		A.TC_UsuarioRed			As	UsuarioRed,			A.TC_Nombre				As	Nombre,
								A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,
								A.TC_CodPlaza			As	CodigoPlaza,		A.TU_CodFirma           As  CodigoFirma,
								A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia		As	FechaDesactivacion,
								'Split'					As	'Split',
								A.TC_CodSexo			As	Codigo,
								S.TC_Descripcion		As	Descripcion,
								'Split'					As	'Split',
								A.TC_CodTitulo			As	Titulo
					From		Catalogo.Funcionario	A 
					LEFT JOIN	Catalogo.Sexo			S
					ON			A.TC_CodSexo			= S.TC_CodSexo
					Where		(A.TF_Inicio_Vigencia  > GETDATE ()
					Or				A.TF_Fin_Vigencia  < GETDATE ())
					Order By	A.TC_Nombre, A.TC_PrimerApellido, A.TC_SegundoApellido;
			end 
			Else
			Begin	--Si las dos fechas no son nulas traigase los datos por rango de fechas de los inactivos
				Select		A.TC_UsuarioRed			As	UsuarioRed,			A.TC_Nombre				As	Nombre,
							A.TC_PrimerApellido		As	PrimerApellido,		A.TC_SegundoApellido	As	SegundoApellido,
							A.TC_CodPlaza			As	CodigoPlaza,		A.TU_CodFirma           As  CodigoFirma,
							A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia		As	FechaDesactivacion,
							'Split'					As	'Split',
							A.TC_CodSexo			As	Codigo,
							S.TC_Descripcion		As	Descripcion,
							'Split'					As	'Split',
							A.TC_CodTitulo			As	Titulo
				From		Catalogo.Funcionario	A 
				LEFT JOIN	Catalogo.Sexo			S
				ON			A.TC_CodSexo			= S.TC_CodSexo
				Where		A.TF_Fin_Vigencia  <= @L_TF_Fin_Vigencia and A.TF_Inicio_Vigencia >=@L_TF_Inicio_Vigencia
				Order By	A.TC_Nombre, A.TC_PrimerApellido, A.TC_SegundoApellido;
			end
	End
 End
GO
