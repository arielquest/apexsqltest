SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<18/04/2016>
-- Descripción :			<Permite Agregar una Módulo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_AgregarModulo]
 @Nombre varchar(50),
 @CodSeccion smallint,
 @CodMateria varchar(5),
 @InicioVigencia datetime2,
 @FinVigencia datetime2=null
 
AS 
    BEGIN
          
		INSERT INTO Consulta.Modulo
		(
			TC_Nombre, TN_CodSeccion, TC_CodMateria, TF_Inicio_Vigencia, TF_Fin_Vigencia
		)
		VALUES
		(
			@Nombre, @CodSeccion, @CodMateria,	@InicioVigencia,	@FinVigencia
		)   
		       
    END
 
GO
