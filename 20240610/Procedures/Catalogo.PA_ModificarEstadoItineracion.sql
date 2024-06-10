SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<02/09/2015>
-- Descripción :			<Permite Modificar un estado de itineracion en la tabla Catalogo.EstadoItineracion> 
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <18/12/2015>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarEstadoItineracion]

	@CodEstadoItineracion smallint,
	@Descripcion varchar(150),	
	@FinVigencia datetime2	
	

AS  
BEGIN  

	Update	Catalogo.EstadoItineracion
	Set		TC_Descripcion				=	@Descripcion,		
			TF_Fin_Vigencia				=	@FinVigencia				
	Where	TN_CodEstadoItineracion		=	@CodEstadoItineracion
End





GO
