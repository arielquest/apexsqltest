SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Gabriel Cordero Soto
-- Create date: 06-10-2022
-- Description:	Realizar eliminación de registro sobre EstadoMedidaMateria
-- =============================================
CREATE   PROCEDURE [Catalogo].[PA_EliminarEstadoMedidaMateria]
@CodEstado	SMALLINT,
@CodMateria VARCHAR(5)
AS
BEGIN	
	DECLARE @L_CodEstado   SMALLINT		= @CodEstado,
			@L_CodMateria  VARCHAR(5)	= @CodMateria

	DELETE 
	FROM	  [Catalogo].[EstadoMedidaMateria]  WITH(ROWLOCK)
    WHERE     TN_CodEstado  = @L_CodEstado 
	AND		  TC_CodMateria = @L_CodMateria 
END
GO
