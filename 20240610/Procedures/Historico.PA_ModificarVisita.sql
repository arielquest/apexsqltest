SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Permite Modificar una Visita carcelaria o a celdas.> 
-- Modificación :			<Alejandro Villalta><04/01/2016><Modificar el tipo de dato del campo CodMotivoVisita.> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<05/01/2016>
-- Descripción :			<Generar automáticamente el codigo de tipo de visita - item 5782.> 	
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificación			<Jonathan Aguilar Navarro> <27/06/2018> <Se cambios el parametro y campo @CodOficina por @CodContexto> 
CREATE PROCEDURE [Historico].[PA_ModificarVisita] 
	@CodVisita			uniqueidentifier,
	@CodInterviniente	uniqueidentifier = null,
	@UsuarioRed			varchar(30),
	@CodTipoVisita		smallint,
	@Lugar				varchar(255),
	@InicioVisita		datetime2,
	@FinalizaVisita		datetime2,
	@CodMotivoVisita	smallint,
	@CodMotivo			smallint,
	@CodContexto		varchar(4) = null,
	@Observaciones		varchar(max)=null
AS
BEGIN
    UPDATE Historico.Visita
	SET 
		TU_CodInterviniente = @CodInterviniente,
		TC_UsuarioRed       = @UsuarioRed,
		TN_CodTipoVisita    = @CodTipoVisita,
		TC_Lugar            = @Lugar,
		TF_InicioVisita     = @InicioVisita,
		TF_FinalizaVisita   = @FinalizaVisita,
		TN_CodMotivoVisita  = @CodMotivoVisita,
		TN_CodMotivo        = @CodMotivo,
		TC_CodContexto       = @CodContexto,
		TC_Observaciones    = @Observaciones
    WHERE 
	    TU_CodVisita        = @CodVisita	 	
END



GO
