SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<02/09/2015>
-- Descripción :			<Permite Agregar un nuevo estado de itineracion en la tabla Catalogo.EstadoItineracion> 
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <18/12/2015>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoItineracion]

	@Descripcion varchar(150),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	

AS  
BEGIN  

	Insert Into		Catalogo.EstadoItineracion
	(
			TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
			@Descripcion,		@InicioVigencia,		@FinVigencia
	)
End



GO
