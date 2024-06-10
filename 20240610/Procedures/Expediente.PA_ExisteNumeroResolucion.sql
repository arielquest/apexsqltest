SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Autor:					<Gerardo Lopez>
-- Fecha Creación:			<03/06/2016>
-- Descripcion:				<Validar que existe un numero de resolucion en una oficina>
-- ====================================================================================================================================================================================
-- Modificación:			<31/10/2019> <Isaac Dobles> Se ajusta a estructura de expedientes	
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ExisteNumeroResolucion] 
	@NumeroResolucion		uniqueidentifier
AS
BEGIN
    SELECT	COUNT(*)				AS	EXISTE
    FROM	Expediente.Resolucion 	As	A With(NoLock)
	WHERE	A.TU_CodResolucion 	=	@NumeroResolucion
END
GO
