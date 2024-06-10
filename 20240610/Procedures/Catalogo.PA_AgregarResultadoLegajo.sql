SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<10/09/2019>
-- Descripción :			<Permite Agregar un nuevo Resultado de legajo
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarResultadoLegajo]
	@Descripcion varchar(255),
	@InicioVigencia datetime2,
	@FinVigencia datetime2	

AS  
BEGIN  

INSERT INTO [Catalogo].[ResultadoLegajo]
            ([TC_Descripcion]
           ,[TF_FechaInicioVigencia]
           ,[TF_FechaFinVigencia])
     VALUES
           (@Descripcion
           ,@InicioVigencia
           ,@FinVigencia)

End
GO
