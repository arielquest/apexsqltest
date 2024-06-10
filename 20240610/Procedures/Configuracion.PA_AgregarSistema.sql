SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<21/01/2021>
-- Descripción :			<Permite Agregar un nuevo sistema en la tabla Catalogo.Sistema> 
-- =================================================================================================================================================

CREATE PROCEDURE [Configuracion].[PA_AgregarSistema]
	@Siglas				varchar(20),
	@Descripcion		varchar(150),
	@InicioVigencia		datetime2,
	@FinVigencia		datetime2
AS  
BEGIN  

	Insert Into			Configuracion.Sistema
	(
		TC_Siglas,		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Siglas,		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End

GO
