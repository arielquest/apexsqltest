SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<19/04/2016>
-- Descripción :			<Permite Agregar una columna de presentacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Consulta].[PA_AgregarColumnaPresentacion]
 @CodModulo smallint,
 @NombreColumna varchar(50),
 @Nombre varchar(50)=null,
 @Predeterminado bit = null,
 @InicioVigencia datetime2,
 @FinVigencia datetime2= null
 
AS 
    BEGIN
          
		INSERT INTO Consulta.Presentacion
		(
			TN_CodModulo,TC_NombreColumna,TC_Nombre,TB_Predeterminada,TF_Inicio_Vigencia, TF_Fin_Vigencia
		)
		VALUES
		(
			@CodModulo,@NombreColumna,@Nombre,@Predeterminado,@InicioVigencia,	@FinVigencia
		)   
    END
 
GO
