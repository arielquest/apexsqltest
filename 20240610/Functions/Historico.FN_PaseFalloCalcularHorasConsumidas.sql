SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================================
--	Author:			<Aida Elena Siles R>
--	Create date:	<19/08/2021>
--	Description:	<Función para determinar la cantidad de horas consumidas del ultimo pase a fallo de un expediente o legajo. 
--					Su último registro debe tener un motivo de devolución de tipo suspende el plazo.>
-- =================================================================================================================================================================================

CREATE FUNCTION [Historico].[FN_PaseFalloCalcularHorasConsumidas]
(
	@TC_NumeroExpediente	CHAR(14)			= NULL,
	@TU_CodLegajo			UNIQUEIDENTIFIER	= NULL,
	@TC_CodOficina			VARCHAR(5),
	@TC_CodContexto			VARCHAR(4)
)

RETURNS SMALLINT
AS
BEGIN	

--Variables
DECLARE @L_NumeroExpediente				CHAR(14)			= @TC_NumeroExpediente,
		@L_CodLegajo					UNIQUEIDENTIFIER	= @TU_CodLegajo,
		@L_CodOficina					VARCHAR(5)			= @TC_CodOficina,
		@L_CodContexto					VARCHAR(4)			= @TC_CodContexto

DECLARE @Table_Registros				AS TABLE
		(
			TU_CodPaseFallo				UNIQUEIDENTIFIER	NOT NULL,
			TF_FechaAsignacion			DATETIME2(7)		NOT NULL,
			TF_FechaDevolucion			DATETIME2(7)		NULL,
			TC_TipoMotivo				CHAR				NULL
		)
DECLARE		@L_CodPaseFalloActual		UNIQUEIDENTIFIER,
			@L_FechaAsignacionActual	DATETIME2(7),
			@L_FechaDevolucionActual	DATETIME2(7),
			@L_TipoMotivoActual			CHAR,
			@L_CantidadHorasConsumidas	SMALLINT = 0


	IF (@L_CodLegajo IS NULL)
	BEGIN
		IF EXISTS (	SELECT		* 
					FROM		Historico.PaseFallo					A WITH(NOLOCK)
					INNER JOIN  Catalogo.MotivoDevolucionPaseFallo	B WITH(NOLOCK)
					ON			A.TN_CodMotivoDevolucion			= B.TN_CodMotivoDevolucion
					WHERE		A.TU_CodPaseFallo					= (		SELECT TOP	1 C.TU_CodPaseFallo
																			FROM		Historico.PaseFallo		C WITH(NOLOCK)
																			WHERE		C.TC_NumeroExpediente	= @L_NumeroExpediente
																			AND			C.TC_CodContexto		= @L_CodContexto
																			AND			C.TU_CodLegajo			IS NULL
																			ORDER BY	C.TF_FechaAsignacion	DESC)
					AND			B.TC_TipoMotivo						= 'P' --Suspende plazo		
				   )
		BEGIN
			INSERT INTO
			@Table_Registros
			SELECT		A.TU_CodPaseFallo, A.TF_FechaAsignacion, A.TF_FechaDevolucion, B.TC_TipoMotivo
			FROM		Historico.PaseFallo					A WITH(NOLOCK)
			LEFT JOIN	Catalogo.MotivoDevolucionPaseFallo	B WITH(NOLOCK)
			ON			A.TN_CodMotivoDevolucion			= B.TN_CodMotivoDevolucion
			WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
			AND			A.TC_CodContexto					= @L_CodContexto
			AND			A.TU_CodLegajo						IS NULL
			ORDER BY	A.TF_FechaAsignacion				DESC
		END
	END--IF (@L_CodLegajo IS NULL)
	ELSE
	BEGIN
		IF EXISTS (	SELECT		* 
					FROM		Historico.PaseFallo					A WITH(NOLOCK)
					INNER JOIN  Catalogo.MotivoDevolucionPaseFallo	B WITH(NOLOCK)
					ON			A.TN_CodMotivoDevolucion			= B.TN_CodMotivoDevolucion
					WHERE		A.TU_CodPaseFallo					= (		SELECT TOP	1 C.TU_CodPaseFallo
																			FROM		Historico.PaseFallo		C WITH(NOLOCK)
																			WHERE		C.TU_CodLegajo			= @L_CodLegajo
																			AND			C.TC_CodContexto		= @L_CodContexto
																			ORDER BY	C.TF_FechaAsignacion	DESC)
					AND			B.TC_TipoMotivo						= 'P' --Suspende plazo		
				   )
		BEGIN
			INSERT INTO
			@Table_Registros
			SELECT		A.TU_CodPaseFallo, A.TF_FechaAsignacion, A.TF_FechaDevolucion, B.TC_TipoMotivo
			FROM		Historico.PaseFallo					A WITH(NOLOCK)
			LEFT JOIN	Catalogo.MotivoDevolucionPaseFallo	B WITH(NOLOCK)
			ON			A.TN_CodMotivoDevolucion			= B.TN_CodMotivoDevolucion
			WHERE		A.TU_CodLegajo						= @L_CodLegajo
			AND			A.TC_CodContexto					= @L_CodContexto
			ORDER BY	A.TF_FechaAsignacion				DESC
		END --IF EXISTS
	END

	IF (@L_NumeroExpediente IS NOT NULL OR @L_CodLegajo IS NOT NULL)
	BEGIN
		--Recorrido de registros de pase a fallo
		WHILE EXISTS	(
							SELECT			*									
							FROM			@Table_Registros
						)
		BEGIN

			--Obtenemos el primer registro para validarlo
			SELECT	TOP 1	@L_CodPaseFalloActual		= A.TU_CodPaseFallo,
							@L_FechaAsignacionActual	= A.TF_FechaAsignacion,
							@L_FechaDevolucionActual	= A.TF_FechaDevolucion,
							@L_TipoMotivoActual			= A.TC_TipoMotivo
			FROM			@Table_Registros		A
			ORDER BY		A.TF_FechaAsignacion	DESC;	

			IF (@L_TipoMotivoActual = 'P')
			BEGIN
				SET @L_CantidadHorasConsumidas = @L_CantidadHorasConsumidas + (SELECT [Utilitario].[FN_CantidadHorasEntreDosFechas] (@L_CodOficina, @L_FechaAsignacionActual, @L_FechaDevolucionActual))		
		
				--Se elimina de la tabla el registro de pase a fallo actual. para continuar con el siguiente
				DELETE
				FROM	@Table_Registros
				WHERE	TU_CodPaseFallo	= @L_CodPaseFalloActual;
			END
			ELSE
			BEGIN
				DELETE FROM @Table_Registros --Borramos todos los registros
			END
		END -- while
	END --IF (@L_NumeroExpediente IS NOT NULL OR @L_CodLegajo IS NOT NULL)
RETURN @L_CantidadHorasConsumidas
END
GO
