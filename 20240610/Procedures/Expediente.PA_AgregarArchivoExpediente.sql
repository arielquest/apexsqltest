SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Pablo Alvarez Espinoza>
-- Fecha de creación:	<23/02/2016>
-- Descripción :		<Permite registrar los archivos de un expediente> 
-- =================================================================================================================================================
-- TODO:Se debe definir el papel del campo TN_CodFormatoArchivo
-- Modificación:    <Donald Vargas> <25/04/2016> <Se cambia el campo TN_CodTipoArchivo por TN_CodFormatoArchivo>
-- Modificación:    <Donald Vargas> <05/05/2016> <Se agrega los campos de grupo de trabajo y estado>
-- Modificación:	<Johan Acosta> <05/12/2016> <Se cambio nombre de TC a TN>
-- Modificación:	<Jeffry Hernández> <02/10/2017> <Se agregan Columnas. [TB_Notifica] y [TB_Eliminado]>
-- Modificación:	<Jeffry Hernández> <17/10/2017>	<Se inserta el primer valor en la columna TN_CodFormatoArchivo.>
-- Modificación:	<Jonathan Aguilar Navarro> <30/04/2018> <Se cambioa el campo TC_CodOficinaCrea por TC_CodContextoCrea>
-- Modificación:	<Isaac Dobles Mata> <11/09/2018> <Se cambia nombre de SP por PA_AgregarArchivo y se cambia ingreso para tablas Archivo y ArchivoExpediente>
-- Modificación:	<Jonathan Agilar Navarro> <28/09/2018> <Se actualiza el esquema de la tabla Archivo.> 
-- Modificación:	<Isaac Dobles Mata> <15/04/2020> <Se agrega TN_Consecutivo.> 
-- Modificación:	<Isaac Dobles Mata> <29/05/2020> <Se agrega variables internas.> 
-- Modificación:	<Isaac Dobles Mata> <26/08/2020> <Se agrega que el parámetro eliminado tenga valor predeterminado.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarArchivoExpediente] 
	@CodArchivo     				uniqueidentifier,		
	@NumeroExpediente				char(14),
	@CodGrupoTrabajo				smallint,			
	@Notifica						bit,			
	@Eliminado						bit = 0,
	@ConsecutivoHistorialProcesal	int = null
AS
BEGIN

	DECLARE
	
	@L_TU_CodArchivo                uniqueidentifier    = @CodArchivo,    
	@L_TC_NumeroExpediente          char(14)            = @NumeroExpediente,
	@L_TN_CodGrupoTrabajo			smallint			= @CodGrupoTrabajo, 
	@L_TB_Notifica					bit					= @Notifica,
	@L_TB_Eliminado					bit					= @Eliminado,
	@L_TN_Consecutivo				int					= @ConsecutivoHistorialProcesal

	INSERT INTO Expediente.ArchivoExpediente 
		(
			 TU_CodArchivo,    			TC_NumeroExpediente,   	TN_CodGrupoTrabajo,   				
			 TB_Notifica,				TB_Eliminado,			TN_Consecutivo			
		)
		VALUES
		(
			@L_TU_CodArchivo,				@L_TC_NumeroExpediente,			@L_TN_CodGrupoTrabajo,
			@L_TB_Notifica,					@L_TB_Eliminado,				@L_TN_Consecutivo	 
		)
END
GO
