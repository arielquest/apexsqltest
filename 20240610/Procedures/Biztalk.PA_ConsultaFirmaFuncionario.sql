SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<09/11/2020>
-- Descripción:				<Consulta las firmas holográficas del funcionario.> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultaFirmaFuncionario]
(
	@UsuarioRed VARCHAR(30)
)
AS
BEGIN
		DECLARE @TempUsuarioRed VARCHAR(30) = @UsuarioRed

	    SELECT TU_CodFirma AS CodigoFirma
		,TC_Nombre AS NOMBRE
		,TC_PrimerApellido AS PrimerApellido
		,TC_SegundoApellido AS SegundoApellido
		,TC_CodPlaza AS CodigoPlaza
		FROM Catalogo.Funcionario WITH (NOLOCK)
		WHERE TC_UsuarioRed = @UsuarioRed

END


GO
