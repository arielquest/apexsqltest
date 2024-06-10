SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Roger LAra>
-- Fecha Creación:		<11/09/2015>
-- Descripcion:			<Agregar un delito a un intervininte>
-- Modificado :			<Alejandro Villalta><08/01/2016><Modificar el tipo de dato del codigo de motivo absolutoria> 
-- Modificado :			<Donald Vargas>     <02/12/2016><Se corrige el nombre de los campos TC_CodDelito y TC_CodMotivoAbsolutoria a TN_CodDelito y TN_CodMotivoAbsolutoria de acuerdo al tipo de dato> 
-- =============================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteDelito] 
          @CodigoInterviniente uniqueidentifier, 
          @CodigoDelito int,
          @FechaCalificacionDelito datetime2,
          @CrimenOrganizado bit,
          @FechaHecho datetime2,
          @FechaDescripcion datetime2,
          @Indagado bit,
          @CodigoMotiboObsolutoria smallint=null
      
AS
BEGIN
	INSERT INTO Expediente.IntervinienteDelito
	(
		TU_CodInterviniente,	TN_CodDelito,		TF_CalificacionDelito,		TB_CrimenOrganizado,
		TF_Hecho,				TF_Prescripcion,	TB_Indagado,				TN_CodMotivoAbsolutoria, TF_Actualizacion

	)
	VALUES
	(
		@CodigoInterviniente,	@CodigoDelito,		@FechaCalificacionDelito,	@CrimenOrganizado,
		@FechaHecho,			@FechaDescripcion,	@Indagado,					@CodigoMotiboObsolutoria,   GETDATE()
	)
	
END

GO
