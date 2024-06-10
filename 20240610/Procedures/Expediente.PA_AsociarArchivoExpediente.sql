SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<22/11/2018>
-- Descripción :			<Permite asociar los archivos a un expediente> 
-- =================================================================================================================================================

CREATE Procedure [Expediente].[PA_AsociarArchivoExpediente]
	@CodArchivo				Uniqueidentifier,
	@Codlegajo				uniqueidentifier,
	@NumeroExpediente		varchar(14),
	@Modo					char(1),
	@GrupoTrabajo			smallint,
	@Notifica				bit,
	@Eliminado				bit,
	@NumeroExpedienteNuevo	varchar(14)
As
Begin
BEGIN TRY
	BEGIN TRAN

	if @Modo = 'C'
		begin
			insert into Expediente.LegajoArchivo
			(
				TU_CodArchivo,
				TU_CodLegajo,
				TC_NumeroExpediente
			)
			values
			(
				@CodArchivo,
				@CodLegajo,
				@NumeroExpediente	
			)

			insert into Expediente.ArchivoExpediente
			(
				TU_CodArchivo,
				TC_NumeroExpediente,
				TN_CodGrupoTrabajo,
				TB_Notifica,
				TB_Eliminado
			)
			values
			(
				@CodArchivo,
				@NumeroExpediente,
				@GrupoTrabajo,
				@Notifica,
				@Eliminado
			)
		end
	else
	if @Modo = 'M'
		begin
			delete	Expediente.LegajoArchivo
			where	TU_CodArchivo = @CodArchivo

			insert into Expediente.LegajoArchivo
			(
				TU_CodArchivo,
				TU_CodLegajo
			)
			values
			(
				@CodArchivo,
				@CodLegajo
			)

			update	Expediente.ArchivoExpediente
			set		TC_NumeroExpediente		=	@NumeroExpediente
			where	TU_CodArchivo			=	@CodArchivo				

		end
	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
	BEGIN
		ROLLBACK TRAN;
	END;
	THROW;
END CATCH	
End
GO
