SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Miguel Avendaño>
-- Create date:					<30-10-2020>
-- Description:					<Traducci¢n de la Variables relacionadas con mostrar un funcionario asociado a un expediente>
-- ====================================================================================================================================================================================
-- Modificaci¢n:				<21/06/2021> <Isaac Santiago M‚ndez Castillo> <- Se lista m s de un funcionario dependiendo del c¢digo del tipo de puesto de trabajo 
--																				 agregados como parametros en TiposPuestoTrabajo separados por coma (Ejm: '1,2,3'). 
--																			   - Se elimina el parametro TipoFuncionario>
-- Modificaci¢n:				<19/07/2021> <Jose Miguel Avendaño Rosales>   <- Se modifica para que la validacion del puesto de trabajo la haga con la tabla ContextoPuestoTrabajo>
-- Modificaci¢n:				<06/08/2021> <Isaac Santiago M‚ndez Castillo> <- Se toma en cuenta si la variable se est  usando desde un legajo, se agrega parametro y se evalua
--																				 dentro de la l¢gica de donde se toma la informaci¢n>
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_FuncionarioExpediente]
	@NumeroExpediente		AS CHAR(14),
	@CodigoLegajo			AS VARCHAR(40)	= NULL,
	@Contexto				AS VARCHAR(4),
	@TiposPuestoTrabajo		AS VARCHAR(MAX)
AS
BEGIN
	DECLARE		@L_NumeroExpediente     AS CHAR(14)				= @NumeroExpediente,
				@L_CodigoLegajo			AS VARCHAR(40)			= @CodigoLegajo,	
				@L_Contexto             AS VARCHAR(4)			= @Contexto,
				@L_TiposPuestoTrabajo	AS VARCHAR(MAX)			= @TiposPuestoTrabajo;
	DECLARE 	@L_Tipos				TABLE (Tipo INT);

	IF LEN(@L_TiposPuestoTrabajo) = 0
		INSERT INTO @L_Tipos
		SELECT	TN_CodTipoPuestoTrabajo
		FROM	Catalogo.TipoPuestoTrabajo WITH(NoLock)
	Else
		INSERT INTO @L_Tipos
		SELECT	convert(INT,RTRIM(LTRIM(value)))
		FROM	STRING_SPLIT(@L_TiposPuestoTrabajo, ',')
	
	IF @L_CodigoLegajo IS NULL OR @L_CodigoLegajo = '' --Cuando es expediente
		BEGIN
			SELECT		CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) AS Nombre
			FROM		Expediente.ExpedienteDetalle		A WITH(NoLock)
			INNER JOIN	Historico.ExpedienteASignado		B WITH(NoLock)
			ON			A.TC_NumeroExpediente				= B.TC_NumeroExpediente
			AND			B.TF_Inicio_Vigencia				<= GETDATE()
			AND			(B.TF_Fin_Vigencia					> GETDATE()
			OR			B.TF_Fin_Vigencia					IS NULL)
			INNER JOIN	Catalogo.PuestoTrabajoFuncionario	C WITH(NoLock)
			ON			C.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			AND			C.TF_Inicio_Vigencia				<= GETDATE()
			AND			(C.TF_Fin_Vigencia					> GETDATE()
			OR			C.TF_Fin_Vigencia					IS NULL)
			INNER JOIN	Catalogo.Funcionario				D WITH (NoLock)
			ON			D.TC_UsuarioRed						= C.TC_UsuarioRed
			INNER JOIN	Catalogo.PuestoTrabajo				E WITH (NoLock)
			ON			E.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			INNER JOIN	Catalogo.ContextoPuestoTrabajo		G WITH (NoLock)
			ON			G.TC_CodPuestoTrabajo				= E.TC_CodPuestoTrabajo
			AND			G.TC_CodContexto					= @L_Contexto
			INNER JOIN	Catalogo.TipoPuestoTrabajo			F WITH (NoLock)
			ON			E.TN_CodTipoPuestoTrabajo			= F.TN_CodTipoPuestoTrabajo
			WHERE		A.TC_NumeroExpediente				= @L_NumeroExpediente
			AND			A.TC_CodContexto					= @L_Contexto
			AND			F.TN_CodTipoPuestoTrabajo			IN (SELECT Tipo 
																FROM @L_Tipos)
		END -- END IF
	ELSE
		BEGIN
			SELECT		CONCAT(D.TC_Nombre, ' ', D.TC_PrimerApellido, ' ', D.TC_SegundoApellido) AS Nombre
			FROM		Expediente.LegajoDetalle			A WITH(NoLock)
			INNER JOIN	Historico.LegajoAsignado			B WITH(NoLock)
			ON			A.TU_CodLegajo						= B.TU_CodLegajo
			AND			B.TF_Inicio_Vigencia				<= GETDATE()
			AND			(B.TF_Fin_Vigencia					> GETDATE()
			OR			B.TF_Fin_Vigencia					IS NULL)
			INNER JOIN	Catalogo.PuestoTrabajoFuncionario	C WITH(NoLock)
			ON			C.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			AND			C.TF_Inicio_Vigencia				<= GETDATE()
			AND			(C.TF_Fin_Vigencia					> GETDATE()
			OR			C.TF_Fin_Vigencia					IS NULL)
			INNER JOIN	Catalogo.Funcionario				D WITH (NoLock)
			ON			D.TC_UsuarioRed						= C.TC_UsuarioRed
			INNER JOIN	Catalogo.PuestoTrabajo				E WITH (NoLock)
			ON			E.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
			INNER JOIN	Catalogo.ContextoPuestoTrabajo		G WITH (NoLock)
			ON			G.TC_CodPuestoTrabajo				= E.TC_CodPuestoTrabajo
			AND			G.TC_CodContexto					= @L_Contexto
			INNER JOIN	Catalogo.TipoPuestoTrabajo			F WITH (NoLock)
			ON			E.TN_CodTipoPuestoTrabajo			= F.TN_CodTipoPuestoTrabajo
			WHERE		A.TU_CodLegajo						= @L_CodigoLegajo
			AND			A.TC_CodContexto					= @L_Contexto
			AND			F.TN_CodTipoPuestoTrabajo			IN (SELECT Tipo 
																FROM @L_Tipos)
		END -- END ELSE
END
GO
