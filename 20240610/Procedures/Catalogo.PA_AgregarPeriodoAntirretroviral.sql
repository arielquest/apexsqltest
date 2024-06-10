SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<27/08/2015>
-- Descripción :			<Permite Agregar un nuevo Periodo de suministracion de antirretrovirales en la tabla Catalogo.PeriodoAntirretroviral> 
-- =================================================================================================================================================
   Modificacion: 08/12/2015  Gerardo Lopez <Generar llave por sequence> 
*/
CREATE PROCEDURE [Catalogo].[PA_AgregarPeriodoAntirretroviral]
	@Descripcion			varchar(150),
	@InicioVigencia			datetime2,
	@FinVigencia			datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.PeriodoAntirretroviral 	( TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia )
	                                             Values (   @Descripcion,		@InicioVigencia,		@FinVigencia )
End



GO
