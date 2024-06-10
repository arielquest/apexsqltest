SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Jose Gabriel Cordero Soto>
-- Fecha Creación:		<25/10/2019>
-- Descripcion:			<Permite agregar un registro a la tabla Catalogo.TipoItineracionResultadoLegajo>
-- =================================================================================================================================================
-- Autor:				<Andrew Allen Dawson>
-- Fecha Creación:		<14/11/2019>
-- Descripcion:			<Se modifica el parametro de fecha de inicio de vigencia>
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoItineracionResultadoLegajo]
	@CodTipoItineracion  	smallInt,
	@CodResultadoLegajo  	smallint,
	@InicioVigencia		datetime2,
	@PorDefecto				bit=0
As
Begin

	Insert Into	Catalogo.TipoItineracionResultadoLegajo
	(
		TN_CodTipoItineracion,			TN_CodResultadoLegajo,		TF_Inicio_Vigencia, TB_PorDefecto 
	)
	Values
	(
		@CodTipoItineracion,			@CodResultadoLegajo,		@InicioVigencia,			@PorDefecto
	)
End;
GO
