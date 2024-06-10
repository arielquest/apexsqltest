SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Pablo Alvarez Espinoza>
-- Fecha de creación:	<03/05/2016>
-- Descripción :		<Permite Agregar un nuevo tipo de resolución en la tabla Catalogo.TipoResolucion> 
-- =================================================================================================================================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- Modificación			<Jonathan Aguilar Navarro> <20/06/2018> < Se elimina el parametro de @CodTipoOficina> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoResolucion]
	@Descripcion		varchar(100),
	@InicioVigencia		datetime2,
	@FinVigencia		datetime2,
	@EnvioSCIJ bit
AS  
BEGIN
	Insert Into		Catalogo.TipoResolucion
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia, TB_EnvioSCIJ
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia,  @EnvioSCIJ 
	)
End
GO
