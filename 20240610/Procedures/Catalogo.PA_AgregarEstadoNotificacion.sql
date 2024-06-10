SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Donald Vargas>
-- Fecha de creación:		<09/05/2016>
-- Descripción :			<Permite agregar un nuev estado de notificación en la tabla Catalogo.EstadoNotificacion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoNotificacion] 
	@Descripcion varchar(50),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
	
AS  
BEGIN  

	Insert Into	Catalogo.EstadoNotificacion
		( TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia )
	Values
		( @Descripcion,		@InicioVigencia,		@FinVigencia )
End

GO
