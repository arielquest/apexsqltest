SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Donald Vargas>
-- Fecha de creación:		<18/04/2016>
-- Descripción :			<Permite Agregar una Sección> 
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_AgregarSeccion]
 @Nombre varchar(50),
 @InicioVigencia datetime2,
 @FinVigencia datetime2
 
AS 
    BEGIN
          
		INSERT INTO Consulta.Seccion
		(
			TC_Nombre,	TF_Inicio_Vigencia, TF_Fin_Vigencia
		)
		VALUES
		(
			@Nombre,	@InicioVigencia,	@FinVigencia
		)   
		       
    END
 
GO
