SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Roger LAra>
-- Fecha Creación:	<28/10/2015>
-- Descripcion:		<Modificar una distrito>
--
-- Modificación:	<Andrés Díaz><15/12/2016><Se agrega el campo TG_UbicacionPunto.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarDistrito] 
	@CodigoProvincia		smallint, 
	@CodigoCanton			smallint, 
	@CodigoDistrito			smallint, 
	@Descripcion			varchar(150),
	@Latitud				float			= Null,
	@Longitud				float			= Null,
	@FechaDesactivacion		datetime2		= Null
AS
BEGIN
	Update	Catalogo.Distrito
	Set 	TC_Descripcion			= @Descripcion,
			TG_UbicacionPunto		= Iif(@Latitud Is Not Null And @Longitud Is Not Null, geography::Point(@Latitud,@Longitud,4326), Null),
			TF_Fin_Vigencia			= @FechaDesactivacion
	Where	TN_CodDistrito			= @CodigoDistrito
	And		TN_CodProvincia			= @CodigoProvincia
	And		TN_CodCanton			= @CodigoCanton;
END
GO
