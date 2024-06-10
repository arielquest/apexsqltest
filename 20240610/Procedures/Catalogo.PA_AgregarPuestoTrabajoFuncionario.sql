SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I>
-- Fecha de creación:		<15/07/2016>
-- Descripción :			<Permite Agregar funcionario a un puesto de trabajo>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarPuestoTrabajoFuncionario]
   @Codigo				uniqueidentifier,
   @CodPuestoTrabajo	varchar(14),
   @UsuarioRed			varchar(30),
   @FechaActivacion		datetime2,
   @FechaVencimiento	datetime2	=	null
AS 
    BEGIN          
		INSERT INTO Catalogo.PuestoTrabajoFuncionario
		(
			TU_CodPuestoFuncionario,	TC_CodPuestoTrabajo,	TC_UsuarioRed,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
		)
			VALUES
		(
			@Codigo,	@CodPuestoTrabajo, @UsuarioRed,	@FechaActivacion, @FechaVencimiento 
		)
    END
 



GO
