SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<06/09/2016>
-- Descripcion:		<Crear un nuevo estado del evento>
--
-- Modificación:	<Andrés Díaz><07/12/2016><Se agrega el campo TB_FinalizaEvento.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoEvento] 
	@Descripcion			varchar(50),
	@FinalizaEvento			bit,
	@FechaActivacion		datetime2,
	@FechaDesactivacion		datetime2
AS
BEGIN
	INSERT INTO Catalogo.EstadoEvento
	(
	TC_Descripcion, TB_FinalizaEvento,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	) 
	VALUES
	(
	@Descripcion,	@FinalizaEvento,	@FechaActivacion,	@FechaDesActivacion
	)
END

GO
