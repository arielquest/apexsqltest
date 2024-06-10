SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <11/10/2018>
-- Descripcion:	   <Agregar los datos generales del archivo>
-- =================================================================================================================================================  
-- Modificación: <18/03/2021>	<Ronny Ramírez R.> <Se agrega código de formato jurídico utilizado para generar el archivo del documento e indicador
--								de voto automático que se le asignó cuando se generó.>
-- Modificación: <24/06/2021>	<Ronny Ramírez R.> <Se agrega parámetro opcional de FechaCrea para utilizar la fecha que se indica desde el BE, pues
--								es necesario mantener las fechas de los archivos de itineraciones.>
-- Modificación: <31/05/2022>	<Aida Elena Siles R.> <Se agrega parámetro Multimedia. PBI 252289> 
-- Modificación: <26/08/2022>	<Aaron Rios Retana> <Bug 274509 - Se modifica el parametro @Multimedia para que sea opcional y pueda ser obviado por el API> 
-- =================================================================================================================================================

CREATE PROCEDURE [Archivo].[PA_AgregarArchivo] 
       @CodArchivo 						UNIQUEIDENTIFIER,
       @Descripcion 					VARCHAR(255),
       @CodigoContexto 					VARCHAR(4),
       @CodFormatoArchivo 				INT,
       @UsuarioCrea 					VARCHAR(30),	  
	   @CodEstado  						TINYINT,
	   @CodFormatoJuridico				VARCHAR(8)		= NULL,
	   @GenerarVotoAutomatico			BIT				= NULL,
	   @FechaCrea						DATETIME2(7)	= NULL,
	   @Multimedia						BIT				= 0		
AS

BEGIN
		DECLARE   
			@L_TU_CodArchivo			UNIQUEIDENTIFIER	= @CodArchivo,       
			@L_TC_Descripcion			VARCHAR(255)        = @Descripcion,   
			@L_TC_CodContextoCrea		VARCHAR(4)			= @CodigoContexto,    
			@L_TN_CodFormatoArchivo		INT					= @CodFormatoArchivo,   
			@L_TC_UsuarioCrea			VARCHAR(30)			= @UsuarioCrea,       
			@L_TN_CodEstado				TINYINT				= @CodEstado,
			@L_TC_CodFormatoJuridico	VARCHAR(8)			= @CodFormatoJuridico,
			@L_TB_GenerarVotoAutomatico	BIT					= @GenerarVotoAutomatico,
			@L_TF_FechaCrea				DATETIME2(7)		= ISNULL(@FechaCrea, GETDATE()),
@L_Multimedia				BIT					= @Multimedia

		INSERT INTO [Archivo].[Archivo]
        (
			   [TU_CodArchivo],
			   [TC_Descripcion],
			   [TC_CodContextoCrea],
			   [TN_CodFormatoArchivo],
			   [TC_UsuarioCrea],
			   [TF_FechaCrea],
			   [TN_CodEstado],
			   [TF_Actualizacion],
			   [TC_CodFormatoJuridico],
			   [TB_GenerarVotoAutomatico],
			   [TB_Multimedia]
		)
		VALUES
        (	
			   @L_TU_CodArchivo,
			   @L_TC_Descripcion,
			   @L_TC_CodContextoCrea,
			   @L_TN_CodFormatoArchivo,
			   @L_TC_UsuarioCrea,
			   @L_TF_FechaCrea,
			   @L_TN_CodEstado,
			   GETDATE(),
			   @L_TC_CodFormatoJuridico,
			   @L_TB_GenerarVotoAutomatico,
			   @L_Multimedia
		)
END
GO
