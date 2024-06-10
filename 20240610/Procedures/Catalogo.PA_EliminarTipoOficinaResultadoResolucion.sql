SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<06/11/2015>
-- Descripción :			<Permite eliminar un ResultadoResolucion asociado a un tipo de oficina> 
-- =================================================================================================================================================
-- Modificado:				<16/12/2015, Johan Acosta, Cambio tipo smallint TC_CodResultadoResolucion >
-- Modificado:				<05/12/2016, Johan Acosta, Se cambio nombre de TC a TN>
--Modificación				<19/06/2018> <Jonathan Aguilar Navarro> <Se agrega la materia como filtro para ser eliminado>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarTipoOficinaResultadoResolucion]
   @CodTipoOficina			smallint,
   @CodResultadoResolucion	smallint,
   @CodMateria				Varchar(5)
 
AS 
    BEGIN
          
			 DELETE Catalogo.TipoOficinaResultadoResolucion
			 WHERE TN_CodTipoOficina			= @CodTipoOficina
			 AND   TN_CodResultadoResolucion	= @CodResultadoResolucion
			 AND   TC_CodMateria				= @CodMateria

   END
 



GO
