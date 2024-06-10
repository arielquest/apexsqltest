SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<16/09/2016>
-- Descripción:				<Permite modificar un motivo de estado de evento.>
--
-- Modificación:			<2017/05/26><Andrés Díaz><Se cambia el tipo de los parámetros de códigos de int a smallint.>
-- Modificación:			<2021/01/22><Roger Lara><Se correge sentencia de sql ya que estaba mal.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoEstadoEvento] 
	@CodMotivoEstado			smallint		= Null,
	@Descripcion				varchar(150)	= Null,
	@FechaDesactivacion			datetime2		= Null
AS
BEGIN
	UPDATE	Catalogo.MotivoEstadoEvento
	SET		TN_CodMotivoEstado			=	@CodMotivoEstado,
			TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaDesactivacion
	WHERE	TN_CodMotivoEstado			=	@CodMotivoEstado;
END

GO
