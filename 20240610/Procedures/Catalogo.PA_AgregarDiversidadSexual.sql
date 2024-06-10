SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<30/08/2015>
-- Descripción :			<Permite agregar una nueva diversidad sexual> 
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <04/01/2016>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarDiversidadSexual]
	@Descripcion varchar(255),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	

AS  
BEGIN  

	Insert Into		DiversidadSexual
	(
			TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
			@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End






GO
