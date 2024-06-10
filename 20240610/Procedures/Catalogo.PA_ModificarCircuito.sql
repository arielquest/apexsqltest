SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Sigifredo Leitón Luna>
-- Fecha Creación: <06/08/2015>
-- Descripcion:	<Crear una nueva clase de asunto>
--
-- Modificación: <Andrés Díaz> <28/10/2016> <Se agrega el código de provincia.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarCircuito] 
	@CodCircuito			smallint, 
	@Descripcion			varchar(255),
	@CodProvincia			smallint,
	@FechaVencimiento		datetime2 = Null	
AS
BEGIN
	UPDATE	Catalogo.Circuito
	Set		TC_Descripcion		= @Descripcion,
			TN_CodProvincia		= @CodProvincia,
			TF_Fin_Vigencia		= @FechaVencimiento
	Where	TN_CodCircuito		= @CodCircuito
END
GO
