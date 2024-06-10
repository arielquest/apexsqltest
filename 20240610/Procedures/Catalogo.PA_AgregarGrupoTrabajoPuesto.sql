SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I>
-- Fecha de creación:		<11/07/2016>
-- Descripción :			<Permite Agregar puestos a un grupo de trabajo>
-- Modificación				<12/04/2018 - Jonathan Aguilar Navarro> <Se agrega el campo TC_CdoContexto para relacionar el puesto de trabajo con el grupo de trabajo del contexto.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarGrupoTrabajoPuesto]
   @CodGrupoTrabajo		smallint,
   @CodPuestoTrabajo	varchar(14),
   @Inicio_Vigencia		datetime2(7),
   @CodContexto			varchar(4)
AS 
    BEGIN          
		INSERT INTO Catalogo.GrupoTrabajoPuesto
		(
			TN_CodGrupoTrabajo,TC_CodPuestoTrabajo, TC_CodContexto, TF_Inicio_Vigencia
		)
			VALUES
		(
			@CodGrupoTrabajo,	@CodPuestoTrabajo, @CodContexto,@Inicio_Vigencia 
		)
    END

GO
