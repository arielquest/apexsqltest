SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<16/08/2021>
-- Descripción :			<Permite agregar una Entidad Jurídica> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEntidadJuridica]
   @Identificacion				varchar(10),
   @Descripcion					varchar(255),
   @Siglas						varchar(255),
   @InicioVigencia				datetime2(7),
   @FinVigencia					datetime2(7)
 AS 

 DECLARE
	@L_Identificacion			varchar(10)		=	@Identificacion,
	@L_Descripcion				varchar(255)	=	@Descripcion,
	@L_Siglas					varchar(255)	=	@Siglas,
	@L_InicioVigencia			datetime2(7)	=	@InicioVigencia,
	@L_FinVigencia				datetime2(7)	=	@FinVigencia

    BEGIN          
		INSERT INTO Catalogo.EntidadJuridica
		(
			[TC_Identificacion],
			[TC_Descripcion],
			[TC_Siglas],
			[TF_Inicio_Vigencia],
			[TF_Fin_Vigencia]
		)
		VALUES
		(
			@L_Identificacion,	
			@L_Descripcion,	
			@L_Siglas,
			@L_InicioVigencia,
			@L_FinVigencia
		)          
    END
GO
