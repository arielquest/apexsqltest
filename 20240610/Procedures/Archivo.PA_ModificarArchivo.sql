SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
  
-- =================================================================================================================================================  
-- Autor:     <Isaac Dobles Mata>  
-- Fecha Creación: <28/11/2018>  
-- Descripcion:    <Modificar los datos generales del archivo>  
-- =================================================================================================================================================  
-- Modificación: <29/05/2020> <Isaac Dobles> <Se agregan variables locales>  
-- =================================================================================================================================================  
-- Modificación: <17/06/2020> <Xinia Soto V> <Se corrige porque asignaba mal las variables locales>  
-- =================================================================================================================================================  
-- Modificación: <08/03/2021> <Daniel Ruiz Hernández> <Se modifican parametros para no tener que actualizar todos.>  
-- =================================================================================================================================================  
CREATE PROCEDURE [Archivo].[PA_ModificarArchivo]   
       @CodArchivo			UNIQUEIDENTIFIER,  
       @Descripcion			VARCHAR(255) = null,  
       @CodContexto			VARCHAR(4) = null,  
       @CodFormatoArchivo   INT = null,  
       @UsuarioCrea			VARCHAR(30) = null,     
	   @CodEstado			TINYINT =null 
AS  
  
BEGIN  
  
  DECLARE   @L_TU_CodArchivo			UNIQUEIDENTIFIER	= @CodArchivo,       
			@L_TC_Descripcion			VARCHAR(255)        = @Descripcion,   
			@L_TC_CodContextoCrea		VARCHAR(4)			= @CodContexto,    
			@L_TN_CodFormatoArchivo		INT					= @CodFormatoArchivo,   
			@L_TC_UsuarioCrea			VARCHAR(30)			= @UsuarioCrea,       
			@L_TN_CodEstado				TINYINT				= @CodEstado  
  
  UPDATE  [Archivo].[Archivo]  
  SET     
  [TC_Descripcion]			=  ISNULL(@L_TC_Descripcion,TC_Descripcion),  
  [TC_CodContextoCrea]		=  ISNULL(@L_TC_CodContextoCrea,TC_CodContextoCrea),  
  [TN_CodFormatoArchivo]    =  ISNULL(@L_TN_CodFormatoArchivo,TN_CodFormatoArchivo),  
  [TC_UsuarioCrea]			=  ISNULL(@L_TC_UsuarioCrea,TC_UsuarioCrea),  
  [TN_CodEstado]			=  ISNULL(@L_TN_CodEstado,TN_CodEstado),  
  [TF_Actualizacion]		=  getdate()  
    
  WHERE  
  [TU_CodArchivo]			=  @L_TU_CodArchivo  
END  
GO
