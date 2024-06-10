SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    <1.0> -- Creado por:   <Wagner Vargas S> 
-- Fecha de creación: <09/02/2021> 
-- Descripción:   <Permite modificar un registro en la tabla: Sistema.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Configuracion].[PA_ModificarSistema]  
		@CodSistema    SMALLINT,  
		@Descripcion  VARCHAR(150),
		@Siglas				varchar(20),
		@FinVigencia  DATETIME2(3) = NULL
AS
BEGIN
		--Variables.  
		DECLARE 
		@L_TN_CodSistema    SMALLINT     = @CodSistema,    
		@L_TC_Descripcion   VARCHAR(150) = @Descripcion,
		@L_TC_Siglas        VARCHAR(20)  = @Siglas,
		@L_TF_Fin_Vigencia  DATETIME2(3) = @FinVigencia  
		--Lógica.  
		UPDATE Configuracion.Sistema  WITH(ROWLOCK)  
		SET  
		TC_Descripcion  = @L_TC_Descripcion,
		TC_Siglas		= @Siglas,
		TF_Fin_Vigencia  = @L_TF_Fin_Vigencia  
		WHERE TN_CodSistema   = @L_TN_CodSistema 
END
GO
