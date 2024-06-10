SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Alejandro Villalta Ruiz>
-- Fecha Creación:	<12/08/2015>
-- Descripcion:		<Modifica un tipo de funcionario>
-- Modificado por:	<Sigifredo Leitón Luna.>
-- Fecha:			<06/01/2016>
-- Descripcion:		<Se modifica para autogenerar el código de tipo de funcionario - item 5678.>
-- =============================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoFuncionario] 
	@Codigo				smallint, 
	@Descripcion		varchar(255),
	@FechaVencimiento	datetime2
AS
BEGIN
	UPDATE Catalogo.TipoFuncionario 
	SET
		TC_Descripcion=@Descripcion,
		TF_Fin_Vigencia=@FechaVencimiento			
	WHERE
		TN_CodTipoFuncionario=@Codigo
END

GO
