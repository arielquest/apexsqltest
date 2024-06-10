SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I>
-- Fecha de creación:		<11/07/2016>
-- Descripción :			<Permite eliminar puestos a un grupo de trabajo>
-- Modificación :			<Jonathan Aguilar Navarro><17/04/2018><Se agrega el campo TC_CodContexto para la eliminación>
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_EliminarGrupoTrabajoPuesto]
   @CodGrupoTrabajo		Smallint,
   @CodPuestoTrabajo	Varchar(14),
   @CodContexto			Varchar(4)
 As 
    Begin
          
			 Delete	Catalogo.GrupoTrabajoPuesto
			 Where	TN_CodGrupoTrabajo  = @CodGrupoTrabajo And TC_CodPuestoTrabajo	= @CodPuestoTrabajo and TC_CodContexto = @CodContexto

   END
 


GO
