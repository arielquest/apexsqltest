SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Olger Ariel Gamboa Castillo
-- Create date: <14-08-2015>
-- Description:	<Agrega un tipo de entidad jurídica
-- Modificado:	<Johan Acosta, 15/12/2015, Cambio tipo smallint código >
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEntidadJuridica]
@Descripcion varchar(255),
@FechaActivacion datetime2(3),
@FechaVencimiento datetime2(3)=null
AS
BEGIN
	INSERT INTO Catalogo.TipoEntidadJuridica
	(	TC_Descripcion,
		TF_Inicio_Vigencia,TF_Fin_Vigencia
	)
	VALUES
	(	@Descripcion,
		@FechaActivacion,@FechaVencimiento
	)
END

GO
