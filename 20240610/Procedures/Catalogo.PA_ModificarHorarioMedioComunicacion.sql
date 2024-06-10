SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Descripción :			<Permite Modificar una nueva HorarioMedioComunicacion en la tabla Catalogo.HorarioMedioComunicacion> 
-- Fecha Creacion:			<1/012/2016>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarHorarioMedioComunicacion]
	@Codigo smallint,
	@Descripcion varchar(50),
	@HoraInicio time,
	@HoraFinal time,
	@FinVigencia datetime2
AS  
BEGIN  

	UPDATE Catalogo.HorarioMedioComunicacion
	SET TC_Descripcion=@Descripcion, TF_HoraInicio=@HoraInicio,TF_HoraFin=@HoraFinal,TF_Fin_Vigencia=@FinVigencia
	WHERE
		TN_CodHorario=@Codigo	
End



GO
