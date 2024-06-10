SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================
-- Autor:					<Aida E Siles>
-- Fecha Creación:			<07/02/2019>
-- Descripcion:				<Modificar un estado de representación>
-- =======================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoRepresentacion] 
	@Codigo					smallint, 
	@Descripcion			varchar(150),
	@Circulante				char(1),
	@CirculantePasivo		char(1),	
	@FechaDesactivacion		datetime2
AS
BEGIN
	UPDATE	Catalogo.EstadoRepresentacion
	SET		TC_Descripcion				=	@Descripcion,
			TC_Circulante				=	@Circulante,
			TC_Pasivo					=	@CirculantePasivo,
			TF_Fin_Vigencia				=	@FechaDesactivacion			
	WHERE	TN_CodEstadoRepresentacion	=	@Codigo
END
GO
