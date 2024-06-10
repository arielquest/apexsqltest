SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Mendez Chavarria>
-- Fecha de creación:	<31/08/2015>
-- Descripción :		<Permite Agregar un nuevo tipo de pena en la tabla Catalogo.TipoPena> 
-- Modificado por:		<Sigifredo Leitón Luna>
-- Fecha:				<07/01/2016>
-- Descripción :		<Modificar para autogenerar el código del tipo de pena - item 5734> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoPena]
	@Descripcion		varchar(150),
	@InicioVigencia		datetime2,
	@FinVigencia		datetime2
AS  
BEGIN
	Insert Into		Catalogo.TipoPena
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End
GO
