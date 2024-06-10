SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Roger Lara>
-- Fecha Creación: <1/10/2015>
-- Descripcion:	<Crear un nuevo estado para un tipo de diligencia>
-- =============================================
--   Modificacion: 08/12/2015  Gerardo Lopez <Generar llave por sequence> 

CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoDiligencia] 
 	@Descripcion varchar(100),
	@InicioVigencia datetime2,
	@FinVigencia datetime2=null
AS
BEGIN
	INSERT INTO Catalogo.EstadoDiligencia
	(
			TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
			@Descripcion,	@InicioVigencia	,@FinVigencia
	)
END
GO
