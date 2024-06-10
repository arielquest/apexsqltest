SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoTelefono] 	
	@Descripcion varchar(150),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
AS
BEGIN
-- =============================================
-- Autor:		<Gerardo Lopez>
-- Fecha Creación: <09/11/2015>
-- Descripcion:	<Crear un nuevo tipo telefono>
-- =============================================
	
	INSERT INTO Catalogo.TipoTelefono(TC_Descripcion,TF_Inicio_Vigencia,TF_Fin_Vigencia) 
	VALUES(@Descripcion,@InicioVigencia,@FinVigencia)
END

GO
