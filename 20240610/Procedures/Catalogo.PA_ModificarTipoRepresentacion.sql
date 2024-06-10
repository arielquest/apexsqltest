SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Roger Lara>
-- Fecha Creación:	<20/08/2015>
-- Descripcion:		<Modificar datos de un tipo de representacion>
-- Modificado por:	<Sigifredo Leitón Luna>
-- Fecha:			<07/01/2016>
-- Descripción :	<Modificación para autogenerar el código de tipo de representación - item 5758> 
-- =============================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoRepresentacion] 
	@CodTipoRepresentacion	smallint, 
	@Descripcion			varchar(100),
	@FechaVencimiento		datetime2=null
AS
BEGIN
	UPDATE	Catalogo.TipoRepresentacion
	SET		TC_Descripcion				=	@Descripcion,
			TF_Fin_Vigencia				=	@FechaVencimiento
	WHERE	TN_CodTipoRepresentacion	=	@CodTipoRepresentacion
END
GO
