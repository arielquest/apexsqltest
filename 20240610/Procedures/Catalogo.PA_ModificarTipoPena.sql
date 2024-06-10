SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<31/08/2015>
-- Descripcion:		<Modificar un tipo de pena>
-- Modificado por:	<Sigifredo Leitón Luna>
-- Fecha:			<07/01/2016>
-- Descripción :	<Modificar para autogenerar el código del tipo de pena - item 5734>
-- ==========================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoPena] 
	@Codigo				smallint, 
	@Descripcion		varchar(150),
	@FechaVencimiento	datetime2
AS
BEGIN
	UPDATE	Catalogo.TipoPena
	SET		TC_Descripcion		=	@Descripcion,
			TF_Fin_Vigencia		=	@FechaVencimiento
	WHERE	TN_CodTipoPena		=	@Codigo
END
GO
