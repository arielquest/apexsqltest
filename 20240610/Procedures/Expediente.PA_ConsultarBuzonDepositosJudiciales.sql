SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<AIDA ELENA SILES ROJAS>
-- Fecha de creación:		<18/01/2021>
-- Descripción :			<Permite Consultar los expedientes que cumplan con los filtros indicados para el SIAGPJ en el buzón de cuentas para depósitos judiciales>
-- Modificacion: 			<19/02/2021> Jose Miguel Avendaño: Se modifica para que retorne la informacion relacionada con cuantia y moneda
-- ================================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarBuzonDepositosJudiciales]   
	@CodContexto				VARCHAR(4),
	@Circulante					CHAR(1)			= NULL,	
	@FechaDesde					DATETIME2		= NULL,
	@FechaHasta					DATETIME2		= NULL,
	@NumeroExpediente			VARCHAR(14)		= NULL,	
	@CodPuestoTrabajo			VARCHAR(14)     = NULL
AS
BEGIN
--VARIABLES
DECLARE @L_CodContexto						VARCHAR(4)		= @CodContexto,
		@L_Circulante						CHAR(1)			= @Circulante,	
		@L_FechaDesde						DATETIME2		= @FechaDesde,
		@L_FechaHasta						DATETIME2		= @FechaHasta,
		@L_NumeroExpediente					VARCHAR(14)		= @NumeroExpediente,	
		@L_CodPuestoTrabajo					VARCHAR(14)     = @CodPuestoTrabajo,
		@L_CodigoTipoFuncionarioTecnico		INT				= (	SELECT		TC_Valor
																FROM		Configuracion.ConfiguracionValor	WITH(NOLOCK)
																WHERE		TC_CodConfiguracion					= 'C_TipoFuncionarioTecnico')

	IF (@L_CodPuestoTrabajo IS NULL)
		BEGIN
		WITH EXPEDIENTES	AS	(
									SELECT		B.TF_Entrada,						
												E.TC_Circulante,
												A.TC_NumeroExpediente,
												A.TC_CodContexto,
												A.TN_MontoCuantia,
												F.TC_CodOficina,
												E.TN_CodEstado,
												E.TC_Descripcion Estado,
												B.TN_CodClase,
												G.TC_Descripcion Clase,
												B.TN_CodProceso,
												H.TC_Descripcion Proceso,
												A.TN_CodMoneda,
												I.TC_Descripcion Moneda
									FROM		Expediente.Expediente			A WITH(NOLOCK)
									INNER JOIN  Expediente.ExpedienteDetalle	B WITH(NOLOCK)
									ON			A.TC_NumeroExpediente			= B.TC_NumeroExpediente
									AND			A.TC_CodContexto				= B.TC_CodContexto
									AND			A.TC_CodContexto				= @L_CodContexto
									OUTER APPLY	(
													SELECT TOP (1)	C.TN_CodEstado,
																	D.TC_Descripcion,
																	D.TC_Circulante
													FROM			Historico.ExpedienteMovimientoCirculante	C WITH(NOLOCK)
													INNER JOIN		Catalogo.Estado								D WITH(NOLOCK)
													ON				D.TN_CodEstado								= C.TN_CodEstado
													WHERE			C.TC_NumeroExpediente						= A.TC_NumeroExpediente
													AND				C.TC_CodContexto							= A.TC_CodContexto
													ORDER BY		C.TF_Fecha	DESC
												) E
									INNER JOIN	Catalogo.Contexto				F WITH(NOLOCK)
									ON			F.TC_CodContexto				= A.TC_CodContexto
									INNER JOIN	Catalogo.Clase					G WITH(NOLOCK)
									ON			G.TN_CodClase					= B.TN_CodClase
									INNER JOIN	Catalogo.Proceso				H WITH(NOLOCK)
									ON			H.TN_CodProceso					= B.TN_CodProceso
									AND			B.TF_Entrada					BETWEEN @L_FechaDesde AND @L_FechaHasta
									LEFT JOIN	Catalogo.Moneda					I WITH(NOLOCK)
									ON			A.TN_CodMoneda					= I.TN_CodMoneda									
									WHERE		A.TC_NumeroExpediente			= COALESCE (@L_NumeroExpediente, A.TC_NumeroExpediente)
									AND			A.TC_CodContexto				= @L_CodContexto
								),
								TECNICOS AS	(
												SELECT		A.TC_NumeroExpediente,
															A.TF_Entrada,
															A.TN_MontoCuantia,
															A.TN_CodClase,
															A.TN_CodProceso,
															A.TC_Circulante,
															A.TN_CodEstado,
															A.TN_CodMoneda,
															A.Estado,
															A.TC_CodContexto,
															A.TC_CodOficina,
															A.Clase,
															A.Proceso,
															A.Moneda,
															F.TC_CodPuestoTrabajo,
															F.TC_Nombre,
															F.TC_PrimerApellido,
															F.TC_SegundoApellido
												FROM		EXPEDIENTES						A WITH(NOLOCK)
												OUTER APPLY	(												
																SELECT TOP (1)	B.TC_CodPuestoTrabajo,
																				G.TC_Nombre,
																				G.TC_PrimerApellido,
																				G.TC_SegundoApellido
																FROM			Historico.ExpedienteAsignado		B WITH(NOLOCK)
																INNER JOIN		Catalogo.PuestoTrabajo				C WITH(NOLOCK)
																ON				C.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
																INNER JOIN		Catalogo.PuestoTrabajoFuncionario	D WITH(NOLOCK)
																ON				D.TC_CodPuestoTrabajo				= C.TC_CodPuestoTrabajo
																INNER JOIN		Catalogo.TipoPuestoTrabajo			E WITH(NOLOCK)
																ON				E.TN_CodTipoPuestoTrabajo			= C.TN_CodTipoPuestoTrabajo
																INNER JOIN		Catalogo.TipoFuncionario			F WITH(NOLOCK)
																ON				F.TN_CodTipoFuncionario				= E.TN_CodTipoFuncionario
																AND				F.TN_CodTipoFuncionario				= @L_CodigoTipoFuncionarioTecnico
																INNER JOIN		Catalogo.Funcionario				G WITH(NOLOCK)
																ON				G.TC_UsuarioRed						= D.TC_UsuarioRed
																WHERE			B.TC_NumeroExpediente				= A.TC_NumeroExpediente
																AND				G.TF_Inicio_Vigencia				<= GETDATE()
																AND				(G.TF_Fin_Vigencia					IS NULL OR G.TF_Fin_Vigencia >= GETDATE())			
																AND				B.TF_Inicio_Vigencia				<=   GETDATE()
																AND				(B.TF_Fin_Vigencia					IS NULL OR B.TF_Fin_Vigencia >= GETDATE())
																ORDER BY		B.TF_Inicio_Vigencia				ASC
															) F
												)
												SELECT	0						AS TotalRegistros, --Se asigna en el negocio el total de registros
														'Split'					AS	Split,
														A.TF_Entrada			AS FechaEntrada,
														A.TC_Circulante			AS Circulante ,
														A.TC_NumeroExpediente	AS NumeroExpediente,
														A.TN_MontoCuantia		AS MontoCuantia,
														A.TC_CodContexto		AS CodContextoExpediente,
														A.TC_CodOficina			AS CodOficinaExpediente,
														A.TN_CodEstado			AS CodEstado,
														A.Estado				AS EstadoDescrip,
														A.TN_CodClase			AS CodClase,
														A.Clase					AS ClaseDescrip,
														A.TN_CodProceso			AS CodProceso,
														A.Proceso				AS ProcesoDescrip,
														A.TN_CodMoneda			AS CodMoneda,
														A.Moneda				AS MonedaDescrip,
														A.TC_CodPuestoTrabajo	AS CodPuestoTrabajo,
														A.TC_Nombre				AS NombreFuncionario,
														A.TC_PrimerApellido		AS PrimerApellido,
														A.TC_SegundoApellido	AS SegundoApellido
												FROM	TECNICOS	A			
												WHERE	A.TC_Circulante			=	@L_Circulante
		END
	ELSE -- IF (@L_CodPuestoTrabajo IS NOT NULL)
		BEGIN
		WITH EXPEDIENTES	AS	(
									SELECT		B.TF_Entrada,						
												E.TC_Circulante,
												A.TC_NumeroExpediente,
												A.TC_CodContexto,
												A.TN_MontoCuantia,
												F.TC_CodOficina,
												E.TN_CodEstado,
												E.TC_Descripcion Estado,
												B.TN_CodClase,
												G.TC_Descripcion Clase,
												B.TN_CodProceso,
												H.TC_Descripcion Proceso,
												A.TN_CodMoneda,
												I.TC_Descripcion Moneda
									FROM		Expediente.Expediente			A WITH(NOLOCK)
									INNER JOIN  Expediente.ExpedienteDetalle	B WITH(NOLOCK)
									ON			A.TC_NumeroExpediente			= B.TC_NumeroExpediente
									AND			A.TC_CodContexto				= B.TC_CodContexto
									AND			A.TC_CodContexto				= @L_CodContexto
									OUTER APPLY	(
													SELECT TOP (1)	C.TN_CodEstado,
																	D.TC_Descripcion,
																	D.TC_Circulante
													FROM			Historico.ExpedienteMovimientoCirculante	C WITH(NOLOCK)
													INNER JOIN		Catalogo.Estado								D WITH(NOLOCK)
													ON				D.TN_CodEstado								= C.TN_CodEstado
													WHERE			C.TC_NumeroExpediente						= A.TC_NumeroExpediente
													AND				C.TC_CodContexto							= A.TC_CodContexto
													ORDER BY		C.TF_Fecha	DESC
												) E
									INNER JOIN	Catalogo.Contexto				F WITH(NOLOCK)
									ON			F.TC_CodContexto				= A.TC_CodContexto
									INNER JOIN	Catalogo.Clase					G WITH(NOLOCK)
									ON			G.TN_CodClase					= B.TN_CodClase
									INNER JOIN	Catalogo.Proceso				H WITH(NOLOCK)
									ON			H.TN_CodProceso					= B.TN_CodProceso
									AND			B.TF_Entrada					BETWEEN @L_FechaDesde AND @L_FechaHasta
									LEFT JOIN	Catalogo.Moneda					I WITH(NOLOCK)
									ON			A.TN_CodMoneda					= I.TN_CodMoneda									
									WHERE		A.TC_NumeroExpediente			= COALESCE (@L_NumeroExpediente, A.TC_NumeroExpediente)
									AND			A.TC_CodContexto				= @L_CodContexto
								),
								TÉCNICOS AS	(
												SELECT		A.TC_NumeroExpediente,
															A.TF_Entrada,
															A.TN_MontoCuantia,
															A.TN_CodClase,
															A.TN_CodProceso,
															A.TC_Circulante,
															A.TN_CodEstado,
															A.TN_CodMoneda,
															A.Estado,
															A.TC_CodContexto,
															A.TC_CodOficina,
															A.Clase,
															A.Proceso,
															A.Moneda,
															F.TC_CodPuestoTrabajo,
															F.TC_Nombre,
															F.TC_PrimerApellido,
															F.TC_SegundoApellido
												FROM		EXPEDIENTES						A WITH(NOLOCK)
												OUTER APPLY	(												
																SELECT TOP (1)	B.TC_CodPuestoTrabajo,
																				G.TC_Nombre,
																				G.TC_PrimerApellido,
																				G.TC_SegundoApellido
																FROM			Historico.ExpedienteAsignado		B WITH(NOLOCK)
																INNER JOIN		Catalogo.PuestoTrabajo				C WITH(NOLOCK)
																ON				C.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
																INNER JOIN		Catalogo.PuestoTrabajoFuncionario	D WITH(NOLOCK)
																ON				D.TC_CodPuestoTrabajo				= C.TC_CodPuestoTrabajo
																INNER JOIN		Catalogo.TipoPuestoTrabajo			E WITH(NOLOCK)
																ON				E.TN_CodTipoPuestoTrabajo			= C.TN_CodTipoPuestoTrabajo
																INNER JOIN		Catalogo.TipoFuncionario			F WITH(NOLOCK)
																ON				F.TN_CodTipoFuncionario				= E.TN_CodTipoFuncionario
																AND				F.TN_CodTipoFuncionario				= @L_CodigoTipoFuncionarioTecnico
																INNER JOIN		Catalogo.Funcionario				G WITH(NOLOCK)
																ON				G.TC_UsuarioRed						= D.TC_UsuarioRed
																WHERE			B.TC_NumeroExpediente				= A.TC_NumeroExpediente
																AND				G.TF_Inicio_Vigencia				<= GETDATE()
																AND				(G.TF_Fin_Vigencia					IS NULL OR G.TF_Fin_Vigencia >= GETDATE())			
																AND				B.TF_Inicio_Vigencia				<=   GETDATE()
																AND				(B.TF_Fin_Vigencia					IS NULL OR B.TF_Fin_Vigencia >= GETDATE())  
																AND				B.TC_CodPuestoTrabajo				= @L_CodPuestoTrabajo
																ORDER BY		B.TF_Inicio_Vigencia				ASC
															) F			
												)
												SELECT	0						AS TotalRegistros, --Se asigna en el negocio el total de registros
														'Split'					AS	Split,
														A.TF_Entrada			AS FechaEntrada,
														A.TC_Circulante			AS Circulante ,
														A.TC_NumeroExpediente	AS NumeroExpediente,
														A.TN_MontoCuantia		AS MontoCuantia,
														A.TC_CodContexto		AS CodContextoExpediente,
														A.TC_CodOficina			AS CodOficinaExpediente,
														A.TN_CodEstado			AS CodEstado,
														A.Estado				AS EstadoDescrip,
														A.TN_CodClase			AS CodClase,
														A.Clase					AS ClaseDescrip,
														A.TN_CodProceso			AS CodProceso,
														A.Proceso				AS ProcesoDescrip,
														A.TN_CodMoneda			AS CodMoneda,
														A.Moneda				AS MonedaDescrip,
														A.TC_CodPuestoTrabajo	AS CodPuestoTrabajo,
														A.TC_Nombre				AS NombreFuncionario,
														A.TC_PrimerApellido		AS PrimerApellido,
														A.TC_SegundoApellido	AS SegundoApellido
												FROM	TÉCNICOS	A			
												WHERE	A.TC_Circulante			=	@L_Circulante
												AND		A.TC_CodPuestoTrabajo	=	@L_CodPuestoTrabajo
		END						
END
GO
