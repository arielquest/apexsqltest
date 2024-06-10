SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<30/09/2022>
-- Descripción :			<Permite agregar un estado de medida> 
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarEstadoMedida]
   @Descripcion					varchar(200),
   @FechaActivacion				datetime2(7),
   @FechaDesactivacion			datetime2(7)
 AS 

 DECLARE
	@L_Descripcion				varchar(255)	=	@Descripcion,
	@L_FechaActivacion			datetime2(7)	=	@FechaActivacion,
	@L_FechaDesactivacion		datetime2(7)	=	@FechaDesactivacion

    BEGIN          
		INSERT INTO Catalogo.EstadoMedida
		(
			[TC_Descripcion],
			[TF_Inicio_Vigencia],
			[TF_Fin_Vigencia]
		)
		VALUES
		(
			@L_Descripcion,	
			@L_FechaActivacion,
			@L_FechaDesactivacion
		)          
    END
GO
