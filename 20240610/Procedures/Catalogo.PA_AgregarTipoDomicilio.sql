SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara
-- Fecha de creación:		<08/09/2015>
-- Descripción :			<Permite agregar un nuevo tipo de domicilio> 
-- =================================================================================================================================================
--   Modificacion: 15/12/2015  Gerardo Lopez <Generar llave por sequence> 

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoDomicilio]

	@Descripcion varchar(50),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
AS  
BEGIN  

	Insert Into		Catalogo.TipoDomicilio
	(
			TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
				@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End






GO
