SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<07/07/2021>
-- Descripción :			<Registra un equipo de reparto> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEquipoReparto]     
	@CodConfiguracion			uniqueidentifier ,
	@CodEquipo					uniqueidentifier ,
	@NombreEquipo				varchar(100)
AS  
BEGIN  
	Declare 
			@L_NombreEquipo			varchar(100)      = @NombreEquipo,
			@L_CodConfiguracion		uniqueidentifier  = @CodConfiguracion,
			@L_CodEquipo			uniqueidentifier  = @CodEquipo
			

	Insert Into Catalogo.EquiposReparto (
				TU_CodEquipo,	TU_CodConfiguracionReparto,	 TC_NombreEquipo,	TF_FechaCreacion, TF_FechaParticion, TB_UbicaExpedientesNuevos) Values (
				@L_CodEquipo,	    @L_CodConfiguracion,	  @L_NombreEquipo,	GETDATE(),		  GETDATE(),		  0)
	
END
GO
