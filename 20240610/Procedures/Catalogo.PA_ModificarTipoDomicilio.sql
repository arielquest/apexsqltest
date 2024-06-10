SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Roger Lara>
-- Fecha Creación: <08/09/2015>
-- Descripcion:	<Modificar datos de un tipo de domicilio>
-- =============================================
---- Modificado por:			<15/12/2015> <GerardoLopez> 	<Se cambia tipo dato  CodTipoDomicilio  a smallint>
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarTipoDomicilio] 
	@CodTipoDomicilio smallint, 
	@Descripcion varchar(50),
	@FechaVencimiento datetime2=null
AS
BEGIN
	UPDATE	Catalogo.TipoDomicilio
	SET		TC_Descripcion	=	@Descripcion,
			TF_Fin_Vigencia	=	@FechaVencimiento
	WHERE	TN_CodTipoDomicilio	=	@CodTipoDomicilio
END
GO
