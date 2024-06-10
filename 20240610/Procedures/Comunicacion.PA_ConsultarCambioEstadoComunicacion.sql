SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<21/03/2017>
-- Descripción :			<Consulta el cambio de estado de las comunicaciones> 
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarCambioEstadoComunicacion]
	@CodigoComunicacion	UNIQUEIDENTIFIER
AS
BEGIN
	  
	  SELECT	CEC.TU_CodCambioEstado		AS	CodCambioEstado,
				CEC.TU_CodComunicacion		AS	CodComunicacion,
				CEC.TF_Fecha				AS	Fecha,
				CEC.TC_Observaciones		AS	Observaciones,
				CEC.TC_UsuarioRed			AS	UsuarioRed,
				'SplitEnumerados'			AS	SplitEnumerados,
				CEC.TC_Estado				AS	Estado,
				'SplitFuncionarioRegistra'	AS	SplitFuncionarioRegistra,
				F.TC_Nombre					AS	Nombre,
				F.TC_PrimerApellido			AS	PrimerApellido,
				F.TC_SegundoApellido		AS	SegundoApellido,
				F.TC_CodPlaza				AS	CodigoPlaza

	  FROM		[Comunicacion].[CambioEstadoComunicacion] CEC WITH(NOLOCK)
	  LEFT JOIN [Catalogo].[Funcionario] F WITH(NOLOCK) 
	  ON		CEC.TC_UsuarioRed = F.TC_UsuarioRed

	  WHERE 	CEC.TU_CodComunicacion = @CodigoComunicacion 
END

GO
