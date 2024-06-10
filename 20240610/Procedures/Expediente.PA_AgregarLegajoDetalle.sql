SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<07/03/2019>
-- Descripcion:			<Crear el detalle de un legajo.>
-- =================================================================================================================================================
-- Modificación:		<13/01/2021> <Aida Elena Siles R> <Se presentaba error al crear legajo debido a que el tipo dato del codigoclaseasunto en la 
--									tabla catalogo se cambio por BIGINT.>
-- Modificación:		<Luis Alonso Leiva Tames> <18/01/2021> <Se agrega el campo de CARPETA para asociar a los sistemas de Gestión>
-- Modificación:		<Karol Jiménez Sánchez> <05/02/2021> <Se elimina el campo de CARPETA, dado que solamente se guardaría en la tabla Expediente.Legajo>
-- Modificación:		<Roger Lara> <07/04/2021> <Se agrega el campo proceso>

-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarLegajoDetalle] 
	@CodigoLegajo				UNIQUEIDENTIFIER,
	@Contexto					VARCHAR(4),		
	@FechaEntrada				DATETIME2(7), 
	@CodigoAsunto				INT, 
	@CodigoClaseAsunto			BIGINT,
	@ContextoProcedencia		VARCHAR(4),
	@CodigoGrupoTrabajo			SMALLINT,
	@Habilitado					BIT,
	@CodigoProceso				SMALLINT
AS
BEGIN
	INSERT INTO Expediente.LegajoDetalle
	(
		TU_CodLegajo,
		TC_CodContexto,
		TF_Entrada,
		TN_CodAsunto,
		TN_CodClaseAsunto,
		TC_CodContextoProcedencia,
		TN_CodGrupoTrabajo,
		TB_Habilitado,
		TN_CodProceso
	)
	VALUES
	(
		@CodigoLegajo,  
		@Contexto, 
		@FechaEntrada,
		@CodigoAsunto,
		@CodigoClaseAsunto,
		@ContextoProcedencia,
		@CodigoGrupoTrabajo,
		@Habilitado,
		@CodigoProceso
	)
END
GO
