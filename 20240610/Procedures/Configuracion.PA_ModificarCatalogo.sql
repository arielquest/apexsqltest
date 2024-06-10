SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    <1.0> 
-- Creado por:   <Wagner vargas> 
-- Fecha de creación: <24/02/2021> 
-- Descripción:   <Permite modificar un registro en la tabla: Catalogo.> 
-- ================================================================================================================================================================================== 
CREATE PROCEDURE [Configuracion].[PA_ModificarCatalogo]  
	@CodCatalogo     SMALLINT,
	@Controlador		BIT,
	@CodSistema		 SMALLINT,
	@Descripcion     VARCHAR(150),
	@DescripcionUrl  VARCHAR(255),
	@CatalogoSiagpj  VARCHAR(256)
AS BEGIN  
--Variables.  
DECLARE 
	@L_TN_CodCatalogo		SMALLINT	 = @CodCatalogo,
	@l_TB_Controlador		BIT			 =@Controlador,
	@L_TN_CodSistema		SMALLINT	 = @CodSistema,    
	@L_TC_Descripcion		VARCHAR(150) = @Descripcion,
	@L_TC_DescripcionUrl	VARCHAR(255) = @DescripcionUrl,   
	@L_TC_CatalogoSiagpj	VARCHAR(256) = @CatalogoSiagpj  
--Lógica.  
UPDATE Configuracion.Catalogo  WITH(ROWLOCK)  
SET  
	TN_CodSistema	= @L_TN_CodSistema,
	TB_Controlador	= @l_TB_Controlador,
	TC_Descripcion  = @L_TC_Descripcion,    
	TC_DescripcionUrl  = @L_TC_DescripcionUrl,
	TC_CatalogoSiagpj  = @L_TC_CatalogoSiagpj

WHERE TN_CodCatalogo   = @L_TN_CodCatalogo 
END 
GO
