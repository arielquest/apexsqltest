SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<22/09/2015>
-- Descripción :			<Permite Agregar una nueva Etnia en la tabla Catalogo.Etnia> 
-- =================================================================================================================================================
--   Modificacion: 14/12/2015  Gerardo Lopez <Generar llave por sequence> 

CREATE PROCEDURE [Catalogo].[PA_AgregarEtnia] 
	@Descripcion varchar(100),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.Etnia
	( TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia )
	Values
	( @Descripcion,		@InicioVigencia,		@FinVigencia )
End



GO
