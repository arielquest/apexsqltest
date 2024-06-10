SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<20/12/2016>
-- Descripción :			<Permite Agregar un nuevo HorarioMedioComunicacion en la tabla Catalogo.HorarioMedioComunicacion> 
-- =================================================================================================================================================


CREATE PROCEDURE [Catalogo].[PA_AgregarHorarioMedioComunicacion] 
	@Descripcion varchar(50),
	@HoraInicio time,
	@HoraFinal time,
	@InicioVigencia datetime2,
	@FinVigencia datetime2
AS  
BEGIN  

	Insert Into		Catalogo.HorarioMedioComunicacion
	( TC_Descripcion, TF_HoraInicio,TF_HoraFin,TF_Inicio_Vigencia, TF_Fin_Vigencia)
	Values
	( @Descripcion, @HoraInicio,@HoraFinal,		@InicioVigencia,		@FinVigencia )
End


GO
