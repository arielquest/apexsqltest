SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO






-- ===========================================================================================================================================
-- Autor:			<Isaac Dobles Mata>
-- Fecha Creación:	<04/04/2019>
-- Descripcion:		<Modifica un detalle de un legajo asociado a un expediente.>
-- ===========================================================================================================================================
-- Modificación:	<Aida Elena Siles Rojas> <18/11/2020> <Se agrega el campo fecha entrada para actualizarlo cuando se recibe itineración>
-- Modificación:	<Daniel Ruiz Hernández> <14/01/2021> <Se modifica el tamaño del parametro @CodClaseAsunto ya que corresponde a un INT>
-- Modificación:	<Aida Elena Siles Rojas> <02/03/2021> <Se agrega el parámetro CodContexto para modificar el legajoDetalle de la oficina que corresponda.>
-- Modificación:	<Wagner Vargas Sanabria> <26/11/2021> <Se agrega el parámetro CodProceso para modificar el proceso del legajoDetalle>
-- ===========================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ModificarLegajoDetalle]	
	@CodLegajo				UNIQUEIDENTIFIER,
	@CodAsunto				INT,	
	@CodClaseAsunto			INT,
	@CodProceso				SMALLINT,
	@CodGrupoTrabajo		SMALLINT,
	@Habilitado				BIT = 1,
	@FechaEntrada			DATETIME2(7)		= NULL,
	@CodContexto			VARCHAR(4)

AS
BEGIN
	--Variables
	DECLARE @L_CodLegajo		UNIQUEIDENTIFIER	= @CodLegajo,
			@L_CodAsunto		INT					= @CodAsunto,
			@L_CodClaseAsunto	INT					= @CodClaseAsunto,
			@L_CodProceso		INT					= @CodProceso,
			@L_CodGrupoTrabajo	SMALLINT			= @CodGrupoTrabajo,
			@L_Habilitado		BIT					= @Habilitado,
			@L_FechaEntrada		DATETIME2(7)		= @FechaEntrada,
			@L_CodContexto		VARCHAR(4)			= @CodContexto
	--Lógica
	UPDATE	Expediente.LegajoDetalle	WITH(ROWLOCK)
	SET		TN_CodAsunto				=	@L_CodAsunto,	 
			TN_CodClaseAsunto			=	@L_CodClaseAsunto,
			TN_CodProceso				=	@L_CodProceso,
			TN_CodGrupoTrabajo			=	@L_CodGrupoTrabajo,
			TB_Habilitado				=	@L_Habilitado,
			TF_Entrada					=	COALESCE(@L_FechaEntrada, TF_Entrada),
			TF_Actualizacion			=	GETDATE()
	WHERE	TU_CodLegajo				=	@L_CodLegajo	
	AND		TC_CodContexto				=	@L_CodContexto
END
GO
