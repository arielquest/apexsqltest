SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<22/03/2017>
-- Descripción :			<Consulta las entradas o salidas de las comunicaciones(sus cambios de oficina)> 
-- =================================================================================================================================================
-- Modificación				<Jonthan Aguilar Navarro> <29/05/2018> <Se cambian los campos correspondiente a oficina por contexto> 
-- Modificación				<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
CREATE PROCEDURE [Comunicacion].[PA_ConsultarComunicacionEntradaSalida]
	@CodigoComunicacion	UNIQUEIDENTIFIER
AS
BEGIN
	  
	SELECT		CES.TU_CodComunicacionEntradaSalida	AS	CodigoCominicacionEntradaSalida,
				CES.TU_CodComunicacion				AS	CodigoComunicacion,
				CES.TC_CodContextoOCJOrigen			AS	CodigoOCJDOrigen,
				CES.TC_CodContextoOCJDestino		AS	CodigoOCJDestino,
				CES.TF_Entrada						AS	FechaEntrada,
				CES.TF_Envio						AS	FechaEnvio,
				CES.TC_UsuarioCrea					AS	Usuario,
				'SplitContextoOrigen'				AS	SplitContextoOrigen,
				OO.TC_Descripcion					AS	Descripcion,
				OO.TC_Telefono						AS	Telefono,
				OO.TC_Fax							AS	Fax,
				OO.TC_Email							AS	Email,
				'SplitContextoDestino'				AS	SplitContextoDestino,
				OD.TC_Descripcion					AS	Descripcion,
				OD.TC_Telefono						AS	Telefono,
				OD.TC_Fax							AS	Fax,
				OD.TC_Email							AS	Email,
				'SplitFuncionarioRegistra'			AS	SplitFuncionarioRegistra,
				F.TC_Nombre							AS	Nombre,
				F.TC_PrimerApellido					AS	PrimerApellido,
				F.TC_SegundoApellido				AS	SegundoApellido,
				F.TC_CodPlaza						AS	CodigoPlaza

	FROM		[Comunicacion].[ComunicacionEntradaSalida] CES WITH(NOLOCK)
	LEFT JOIN	[Catalogo].[Contexto] OD WITH(NOLOCK) ON	CES.TC_CodContextoOCJDestino = OD.TC_CodContexto
	JOIN		[Catalogo].[Contexto] OO WITH(NOLOCK) ON	CES.TC_CodContextoOCJOrigen = OO.TC_CodContexto
	LEFT JOIN	[Catalogo].[Funcionario] F WITH(NOLOCK) ON CES.TC_UsuarioCrea = F.TC_UsuarioRed
	WHERE		CES.TU_CodComunicacion = @CodigoComunicacion
	ORDER BY	CES.TF_Entrada DESC
END
GO
