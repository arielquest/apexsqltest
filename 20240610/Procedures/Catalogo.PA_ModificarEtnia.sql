SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Descripción :			<Permite Modificar una nueva Etnia en la tabla Catalogo.Etnia> 
-- Modificado por:			<14/12/2015> <GerardoLopez> 	<Se cambia tipo dato Codigo a smallint>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEtnia]
	@CodEtnia smallint,
	@Descripcion varchar(100),
	@FinVigencia datetime2
AS  
BEGIN  

	UPDATE Catalogo.Etnia
	SET TC_Descripcion=@Descripcion,
		TF_Fin_Vigencia=@FinVigencia
	WHERE
		TN_CodEtnia=@CodEtnia
End



GO
