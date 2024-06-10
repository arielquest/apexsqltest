SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<30/10/2015>
-- Descripción :			<Permite eliminar una Tarea asociada a un perfil de puesto> 
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:			<17/12/2015>
-- Descripcion:			    <Se cambia la llave a smallint squence>
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- Modificado : Pablo Alvarez
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarPerfilPuestoTarea]
   --@CodPerfilPuesto		smallint,
   @CodTarea			smallint
AS 
    BEGIN
          
			 DELETE Catalogo.PerfilPuestoTarea
			 WHERE-- TN_CodPerfilPuesto	= @CodPerfilPuesto AND
			    TN_CodTarea			= @CodTarea

   END
 


GO
