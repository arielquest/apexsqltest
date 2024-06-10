SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Roger Lara>
-- Fecha Creación:	<22/09/2015>
-- Descripcion:		<Modificar un delito a un intervininte>
-- Modificado :		<Alejandro Villalta><08/01/2016><Modificar el tipo de dato del codigo de motivo absolutoria> 
-- Modificado :		<Donald Vargas><02/12/2016><Se corrige el nombre de los campos TC_CodDelito y TC_CodMotivoAbsolutoria a TN_CodDelito y TN_CodMotivoAbsolutoria de acuerdo al tipo de dato> 
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ModificarIntervinienteDelito] 
    @CodigoInterviniente uniqueidentifier, 
    @CodigoDelito int,
    @FechaCalificacionDelito datetime2,
    @CrimenOrganizado bit,
    @FechaHecho datetime2,
    @FechaPrescripcion datetime2,
    @Indagado bit,
    @CodigoMotivoAbsolutoria smallint=null
      
AS
BEGIN
	update  Expediente.IntervinienteDelito
	set		TF_CalificacionDelito	=	@FechaCalificacionDelito,
			TB_CrimenOrganizado		=	@CrimenOrganizado,
			TF_Hecho				=	@FechaHecho,
			TF_Prescripcion			=	@FechaPrescripcion,
			TB_Indagado				=	@Indagado,
			TN_CodMotivoAbsolutoria	=	@CodigoMotivoAbsolutoria,
			TF_Actualizacion		=	GETDATE()
	where	TU_CodInterviniente		=	@CodigoInterviniente
	and		TN_CodDelito			=	@CodigoDelito
	
END

GO
