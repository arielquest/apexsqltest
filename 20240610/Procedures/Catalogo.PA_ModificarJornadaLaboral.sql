SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Descripción :			<Permite Modificar una nueva Jornada Laboral en la tabla Catalogo.Jornada Laboral> 
-- Fecha Creacion:			<12/12/2016>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarJornadaLaboral]
	@Codigo smallint,
	@Descripcion varchar(50),
	@HoraInicio time,
	@HoraFinal time,
	@FinVigencia datetime2
AS  
BEGIN  

	UPDATE Catalogo.JornadaLaboral
	SET TC_Descripcion=@Descripcion, TF_HoraInicio=@HoraInicio,TF_HoraFin=@HoraFinal,TF_Fin_Vigencia=@FinVigencia
	WHERE
		TN_CodJornadaLaboral=@Codigo	
End



GO
