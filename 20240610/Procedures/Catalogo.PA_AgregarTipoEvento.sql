SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEvento] 
	@Descripcion		varchar(50),
	@ColorEvento		nvarchar(50),
	@EsRemate			bit,
	@FechaActivacion	datetime2,
	@FechaDesactivacion datetime2
AS
BEGIN
-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<08/09/2016>
-- Descripcion:		<Crear un nuevo tipo de evento>
--
-- Modificación:	<Andrés Díaz><28/11/2016><Se agrega el campo TB_EsRemate.>
-- =============================================
	
	INSERT INTO Catalogo.TipoEvento
	(
	TC_Descripcion,	TC_ColorEvento, TB_EsRemate, TF_Inicio_Vigencia,	TF_Fin_Vigencia
	) 
	VALUES
	(
	@Descripcion, @ColorEvento, @EsRemate,	@FechaActivacion,	@FechaDesActivacion
	)
END


GO
