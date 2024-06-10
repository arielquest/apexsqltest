SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

	-- =================================================================================================================================================
	-- Versión:					<1.0>
	-- Creado por:				<Mario Camacho Flores>
	-- Fecha de creación:		<03/01/2023>
	-- Descripción :			<Permite agregar una institucion> 
	-- =================================================================================================================================================

	CREATE   PROCEDURE [Catalogo].[PA_AgregarInstitucion]
	@CodInstitucion				uniqueidentifier,
	@CedulaJuridica		        varchar(20),
	@Descripcion				varchar(255),
	@Siglas						varchar(10),
	@InicioVigencia				datetime2(7),
	@FinVigencia				datetime2(7)
	AS 

	DECLARE
		@L_CodInstitucion			uniqueidentifier		=	@CodInstitucion,
		@L_CedulaJuridica			varchar(20)				=	@CedulaJuridica,
		@L_Descripcion				varchar(255)			=	@Descripcion,
		@L_Siglas					varchar(10)				=	@Siglas,
		@L_InicioVigencia			datetime2(7)			=	@InicioVigencia,
		@L_FinVigencia				datetime2(7)			=	@FinVigencia

		BEGIN          
			INSERT INTO Catalogo.Institucion
			(
				[TU_CodInstitucion],
				[TC_Cedula_Juridica],
				[TC_Descripcion],
				[TC_Siglas],
				[TF_Inicio_Vigencia],
				[TF_Fin_Vigencia]
			)
			VALUES
			(
				@CodInstitucion,
				@L_CedulaJuridica,	
				@L_Descripcion,	
				@L_Siglas,
				@L_InicioVigencia,
				@L_FinVigencia
			)          
		END
GO
