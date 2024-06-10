SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <13/09/2017>
-- Descripcion:	   Agregar el detalle de los firmantes en la asignación de la firma de documentos en el expediente
-- =================================================================================================================================================
-- Modificación	  <Jonathan Aguilar Navarro> <17/07/2018> <Se agregan los campos TB_Nota,TB_Salva y JustificacionSalvaVotoNota>
-- Modificación	  <Jonathan Aguilar Navarro> <17/09/2018> <Se crea el esquema Archivo y se renombre respectivamente en los sp y tablas> 
-- Modificación	  <Wagner Vargas Sanabria> <14/04/2021> <Se agrega parametro es firma digital y aplicafirma> 
-- Modificación	  <Wagner Vargas Sanabria> <27/09/2021> <Se agrega parametro para codigo de Barras> 
-- =================================================================================================================================================
CREATE PROCEDURE [Archivo].[PA_AgregarAsignacionFirmante] 
	   @CodAsignacionFirmado		uniqueidentifier,
       @CodPuestoTrabajo			varchar(14),
       @Orden						tinyint,
	   @FirmadoPor					uniqueidentifier,
	   @Salva						bit,
	   @Nota						bit,
	   @JustificacionSalvaVotoNota varchar (max),  
	   @EsFirmaDigital			BIT = NULL,
	   @AplicaFirma				BIT = 0,
	   @CodigoBarras			varchar(14)= NULL
AS

BEGIN
	DECLARE @FechaAplicaFirma		AS DATETIME2(7) = NULL
	
	IF (@AplicaFirma = 1)
	BEGIN
		SET @FirmadoPor = (select top 1 TU_CodPuestoFuncionario from Catalogo.PuestoTrabajoFuncionario where  TC_CodPuestoTrabajo = @CodPuestoTrabajo )
		SET @FechaAplicaFirma = GETDATE()
	END
	INSERT INTO [Archivo].[AsignacionFirmante]
				([TU_CodAsignacionFirmado]
				,[TC_CodPuestoTrabajo]
				,[TN_Orden]
				,[TU_FirmadoPor]
				,[TB_Salva]
				,[TB_Nota]
				,[TC_JustificacionSalvaVotoNota]
				,[TB_EsFirmaDigital]
				, [TF_FechaAplicado]
				, [TC_CodBarras])
     VALUES
			(	
				@CodAsignacionFirmado,
				@CodPuestoTrabajo,
				@Orden,
				@FirmadoPor,
				@Salva,
				@Nota,
				@JustificacionSalvaVotoNota,
			    @EsFirmaDigital,
				@FechaAplicaFirma, 
				@CodigoBarras)
	END
GO
