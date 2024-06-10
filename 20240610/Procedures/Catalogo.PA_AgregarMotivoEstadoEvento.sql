SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<16/09/2016>
-- Descripción:				<Permite agregar un motivo del estado del evento.>
--
-- Modificación:			<2017/05/26><Andrés Díaz><Se cambia el tipo del parámetro de código de int a smallint.>
-- Modificación             <2021/01/22><Roger Lara><Se corrige sentencia..ya que estaba mal.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoEstadoEvento]
   @Descripcion			varchar(150)	= Null,
   @FechaActivacion		datetime2		= Null,
   @FechaDesactivacion	datetime2		= Null
AS 
BEGIN
	INSERT INTO Catalogo.MotivoEstadoEvento
		(TC_Descripcion,
		TF_Inicio_Vigencia,
		TF_Fin_Vigencia)
	VALUES
		(@Descripcion,
		@FechaActivacion,
		@FechaDesactivacion);
END;

GO
