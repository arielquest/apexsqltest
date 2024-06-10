SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===============================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<20/08/2015>
-- Descripción :			<Permite Modificar un Funcionario en la tabla Catalogo.Funcionario> 
-- ================================================================================================================================
-- Modificado por:	<Ronny Ramírez R.> <22/07/2020>	<Se agrega campo de sexo por requerimiento de HU 05 FUN Buscar 
--					Funcionario para un puesto de trabajo>
-- Modificación:	<Ronny Ramírez R.> <11/03/2021> <Se agrega nuevo campo CodigoTitulo al SP>
-- Modificación:	<Ronny Ramírez R.> <27/07/2022> <Se modifica lógica para que se ponga el valor por defecto 
--					en el campo TC_CodPlaza, si viene NULL>
-- ================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_ModificarFuncionario]
	@UsuarioRed			varchar(30), 
	@Nombre				varchar(50),
	@PrimerApellido		varchar(50),
	@SegundoApellido	varchar(50),
	@CodigoPlaza		varchar(20),	
	@FechaVencimiento	datetime2(7),
	@CodigoSexo			CHAR(1)	= NULL,
	@CodigoTitulo		CHAR(1)	= NULL

AS  
BEGIN  
	--Variables
	DECLARE	@L_TC_UsuarioRed			VARCHAR(30)		= @UsuarioRed,
			@L_TC_Nombre				VARCHAR(50)		= @Nombre,
			@L_TC_PrimerApellido		VARCHAR(50)		= @PrimerApellido,
			@L_TC_SegundoApellido		VARCHAR(50)		= @SegundoApellido,
			@L_TC_CodPlaza				VARCHAR(20)		= @CodigoPlaza,
			@L_TF_Fin_Vigencia			DATETIME2(7)	= @FechaVencimiento,
			@L_TC_CodSexo				CHAR(1)			= @CodigoSexo,
			@L_TC_CodTitulo				CHAR(1)			= @CodigoTitulo
	--Lógica
	IF(@L_TC_CodPlaza IS NOT NULL)
		Update	Catalogo.Funcionario
		Set		TC_Nombre				=	@L_TC_Nombre,
				TC_PrimerApellido		=	@L_TC_PrimerApellido,
				TC_SegundoApellido		=	@L_TC_SegundoApellido,
				TC_CodPlaza				=	@L_TC_CodPlaza,
				TF_Fin_Vigencia			=	@L_TF_Fin_Vigencia,
				TC_CodSexo				=	@L_TC_CodSexo,
				TC_CodTitulo			=	@L_TC_CodTitulo
		Where	TC_UsuarioRed			=	@L_TC_UsuarioRed
	ELSE
		Update	Catalogo.Funcionario
		Set		TC_Nombre				=	@L_TC_Nombre,
				TC_PrimerApellido		=	@L_TC_PrimerApellido,
				TC_SegundoApellido		=	@L_TC_SegundoApellido,
				TC_CodPlaza				=	DEFAULT,
				TF_Fin_Vigencia			=	@L_TF_Fin_Vigencia,
				TC_CodSexo				=	@L_TC_CodSexo,
				TC_CodTitulo			=	@L_TC_CodTitulo
		Where	TC_UsuarioRed			=	@L_TC_UsuarioRed
End




GO
