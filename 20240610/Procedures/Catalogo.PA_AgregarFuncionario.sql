SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================
-- Author:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<13/08/2015>
-- Descripcion:		<Permite agregar un nuevo funcionario.>
-- ================================================================================================================================
-- Modificación:	<Ronny Ramírez R.> <22/07/2020>	<Se agrega campo de sexo por requerimiento de HU 05 FUN Buscar 
--					Funcionario para un puesto de trabajo>
-- Modificación:	<Ronny Ramírez R.> <11/03/2021> <Se agrega nuevo campo CodigoTitulo al SP>
-- Modificación:	<Ronny Ramírez R.> <27/07/2022> <Se modifica lógica para que se ponga el valor por defecto 
--					en el campo TC_CodPlaza, si viene NULL>
-- ================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarFuncionario] 
	@UsuarioRed				varchar(30), 
	@Nombre					varchar(50),
	@PrimerApellido			varchar(50),
	@SegundoApellido		varchar(50),
	@CodigoPlaza			varchar(20), 
	@FechaActivacion		datetime2(7),
	@FechaVencimiento		datetime2(7) = NULL,
	@CodigoSexo				CHAR(1)	= NULL,
	@CodigoTitulo			CHAR(1)	= NULL

AS
BEGIN
	--Variables
	DECLARE	@L_TC_UsuarioRed			VARCHAR(30)		= @UsuarioRed,
			@L_TC_Nombre				VARCHAR(50)		= @Nombre,
			@L_TC_PrimerApellido		VARCHAR(50)		= @PrimerApellido,
			@L_TC_SegundoApellido		VARCHAR(50)		= @SegundoApellido,
			@L_TC_CodPlaza				VARCHAR(20)		= @CodigoPlaza,
			@L_TF_Inicio_Vigencia		DATETIME2(7)	= @FechaActivacion,
			@L_TF_Fin_Vigencia			DATETIME2(7)	= @FechaVencimiento,
			@L_TC_CodSexo				CHAR(1)			= @CodigoSexo,
			@L_TC_CodTitulo				CHAR(1)			= @CodigoTitulo

	--Cuerpo
	IF(@L_TC_CodPlaza IS NOT NULL)
		INSERT INTO	Catalogo.Funcionario
		(	
			TC_UsuarioRed,		TC_Nombre,				TC_PrimerApellido,	TC_SegundoApellido, 
			TC_CodPlaza,		TF_Inicio_Vigencia,		TF_Fin_Vigencia,	TC_CodSexo,
			TC_CodTitulo
		)
		VALUES
		(	
			@L_TC_UsuarioRed,		@L_TC_Nombre,				@L_TC_PrimerApellido,		@L_TC_SegundoApellido,
			@L_TC_CodPlaza,			@L_TF_Inicio_Vigencia,		@L_TF_Fin_Vigencia,			@L_TC_CodSexo,
			@L_TC_CodTitulo
		)
	ELSE
		INSERT INTO	Catalogo.Funcionario
		(	
			TC_UsuarioRed,		TC_Nombre,				TC_PrimerApellido,	TC_SegundoApellido,
			TF_Inicio_Vigencia,		TF_Fin_Vigencia,	TC_CodSexo,			TC_CodTitulo
		)
		VALUES
		(	
			@L_TC_UsuarioRed,		@L_TC_Nombre,				@L_TC_PrimerApellido,		@L_TC_SegundoApellido,			
			@L_TF_Inicio_Vigencia,		@L_TF_Fin_Vigencia,			@L_TC_CodSexo,			@L_TC_CodTitulo
		)
END
GO
