SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite agregar un nuevo motivo de suspencion de visita carcelaria en la tabla Catalogo.MotivoSuspencionVisita> 
-- Modificado por:			<Johan Acosta Ibañez>
-- Fecha de creación:		<14/12/2015>
-- Descripción :			<Generar llave por sequence> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoSuspensionVisita]
	@Descripcion varchar(200),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.MotivoSuspensionVisita
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End



GO
