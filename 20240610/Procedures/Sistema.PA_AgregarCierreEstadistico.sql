SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <20/08/2015>
-- Descripcion:	<Crear un nuevo registro de cierre estadístico.>
-- =============================================
CREATE PROCEDURE [Sistema].[PA_AgregarCierreEstadistico] 
	@CodOficina varchar(4), 
	@Mes smallint,
	@Anno smallint,
	@FechaCierre datetime2
AS
BEGIN
	INSERT INTO Sistema.CierreEstadistico 
	(
		TC_CodOficina,	TN_Mes,	TN_Anno,	TF_Fecha_Cierre
	)
	VALUES
	(
		@CodOficina,	@Mes,	@Anno,		@FechaCierre
	)
END
GO
