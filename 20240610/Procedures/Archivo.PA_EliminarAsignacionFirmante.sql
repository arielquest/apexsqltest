SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <21/12/2017>
-- Descripción:	   <Eliminar la asignación de la firma de documentos en el expediente>
-- =================================================================================================================================================
-- Modificación	   <Jonathan Aguilar Navarro> <18/09/2018> <Se crea el esquema Archivo y se renombra respectivamente en los sp y tablas> 
-- =================================================================================================================================================

CREATE PROCEDURE [Archivo].[PA_EliminarAsignacionFirmante] 
	   @CodAsignacionFirmado 			uniqueidentifier,
	   @CodPuestoTrabajo 				varchar(14)
AS

BEGIN
	DELETE [Archivo].[AsignacionFirmante]	  
	WHERE 
			@CodAsignacionFirmado = TU_CodAsignacionFirmado AND 
			@CodPuestoTrabajo = TC_CodPuestoTrabajo	

	UPDATE [Archivo].[AsignacionFirmante]
	SET [Archivo].[AsignacionFirmante].TN_Orden = ListaOrdenada.NuevoOrden
	FROM 
		(
			SELECT [Archivo].[AsignacionFirmante].TU_CodAsignacionFirmado, 
					ROW_NUMBER() OVER (ORDER BY [Archivo].[AsignacionFirmante].TN_Orden ASC) AS NuevoOrden, 
					[Archivo].[AsignacionFirmante].TC_CodPuestoTrabajo
			FROM [Archivo].[AsignacionFirmante]
			WHERE
				 TU_CodAsignacionFirmado = @CodAsignacionFirmado
		) AS ListaOrdenada
	WHERE 
			[Archivo].[AsignacionFirmante].TU_CodAsignacionFirmado = ListaOrdenada.TU_CodAsignacionFirmado AND
			[Archivo].[AsignacionFirmante].TC_CodPuestoTrabajo = ListaOrdenada.TC_CodPuestoTrabajo
END

GO
