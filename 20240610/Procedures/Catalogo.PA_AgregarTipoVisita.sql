SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<24/08/2015>
-- Descripción :			<Permite agregar un nuevo tipo de vista a la tabla Catalogo.TipoVisita> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<05/01/2016>
-- Descripción :			<Generar automáticamente el codigo de tipo de visita - item 5782.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoVisita]
	@Descripcion	varchar(150),
	@InicioVigencia datetime2,
	@FinVigencia	datetime2
AS  
BEGIN  

	Insert Into		Catalogo.TipoVisita
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End







GO
