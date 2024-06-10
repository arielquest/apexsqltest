SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Roger Lara>
-- Fecha Creación: <27/04/2016>
-- Descripcion:	   <Modificar un modulo.>
-- =============================================
CREATE PROCEDURE [Consulta].[PA_ModificarModulo] 
	@CodModulo smallint, 
	@Nombre varchar(50),
	@CodSeccion smallint,
	@CodMateria varchar(5),
	@FinVigencia datetime2=null	
AS
BEGIN
	UPDATE	Consulta.Modulo
	Set		TC_Nombre			= @Nombre,
			TN_CodSeccion		= @CodSeccion,
			TC_CodMateria		=@CodMateria,
			TF_Fin_Vigencia		= @FinVigencia
	where	TN_CodModulo		= @CodModulo
END
GO
