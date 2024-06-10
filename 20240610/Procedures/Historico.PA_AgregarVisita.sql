SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<14/09/2015>
-- Descripción :			<Permite Agregar una nueva Visita carcelaria o a celdas.> 
-- Modificacion:			14/12/2015  Modificar tipo dato CodMotivo a smallint Johan Acosta
-- Modificacion:			04/01/2016  Modificar tipo dato CodMotivoVisita a smallint Alejandro Villalta
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<05/01/2016>
-- Descripción :			<Generar automáticamente el codigo de tipo de visita - item 5782.> 	
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificación			<Jonathan Aguilar Navarro> <27/06/2018> <Se cambios el parametro y campo @CodOficina por @CodContexto> 
CREATE PROCEDURE [Historico].[PA_AgregarVisita] 
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
	INSERT INTO Historico.Visita
	(
		TU_CodVisita,	TU_CodInterviniente,	TC_UsuarioRed,		TN_CodTipoVisita,	
		TC_Lugar,		TF_InicioVisita,		TF_FinalizaVisita,	TN_CodMotivoVisita,	
		TN_CodMotivo,	TC_CodContexto,			TC_Observaciones
	)
	VALUES
	(
		@CodVisita,		@CodInterviniente,		@UsuarioRed,		@CodTipoVisita,	
		@Lugar,			@InicioVisita,			@FinalizaVisita,	@CodMotivoVisita,	
		@CodMotivo,		@CodContexto,			@Observaciones
		
	)
END



GO
