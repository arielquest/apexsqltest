SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Permite Consultar una Visita carcelaria o a celdas.> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de modificación:	<05/01/2016>
-- Descripción :			<Generar automáticamente el codigo de tipo de visita - item 5782.> 	
-- =================================================================================================================================================
-- Modificación:			<05/12/2016> <Johan Acosta Fecha> Se cambio nombre de TC a TN 
-- Modificación:			<27/06/2018> <Jonathan Aguilar Navarro> <Se cambios el parametro y campo @CodOficina por @CodContexto> 
-- Modificación:			<22/08/2018> <Tatiana Flores> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:			<01/11/2019> <Isaac Dobles> <Se modifica para ajustar a estructura de expedientes>
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_ConsultarVisita] 
	@CodVisita	      uniqueidentifier	= null,
	@InicioVisita	  datetime2			= null,
	@FinalizaVisita   datetime2			= null,
	@CodTipoVisita	  smallint			= null,
	@CodContexto	  varchar(4)		= null,
	@NumeroExpediente char(14)			= null
AS
BEGIN
   IF @NumeroExpediente is null	

		SELECT  
		Historico.Visita.TU_CodVisita AS Codigo, 
		Historico.Visita.TC_Lugar AS Lugar, 
		Historico.Visita.TF_InicioVisita AS InicioVisita, 
		Historico.Visita.TF_FinalizaVisita AS FinalizaVisita,
		Historico.Visita.TC_Observaciones AS Observaciones, 

		'Split' AS Split, 
		Expediente.Interviniente.TU_CodInterviniente AS CodigoInterviniente, 
		Catalogo.Funcionario.TC_UsuarioRed AS UsuarioRed,
		Catalogo.Funcionario.TC_Nombre AS Nombre, 
		Catalogo.Funcionario.TC_PrimerApellido AS PrimerApellido, 
		Catalogo.Funcionario.TC_SegundoApellido AS SegundoApellido, 
		Catalogo.TipoVisita.TN_CodTipoVisita AS CodigoTipoVisita,
		Catalogo.TipoVisita.TC_Descripcion AS DescripcionTipoVisita, 
		Catalogo.MotivoVisita.TN_CodMotivoVisita AS CodigoMotivoVisita, 
		Catalogo.MotivoVisita.TC_Descripcion AS DescripcionMotivoVisita, 
		Catalogo.MotivoSuspensionVisita.TN_CodMotivo AS CodigoMotivoSuspension, 
		Catalogo.MotivoSuspensionVisita.TC_Descripcion AS DescripcionMotivoSuspension, 
		Catalogo.Contexto.TC_CodContexto AS CodigoContexto, 
		Catalogo.Contexto.TC_Descripcion AS DescripcionContexto 
				
		FROM    Historico.Visita 
		INNER JOIN Expediente.Interviniente 
		ON Historico.Visita.TU_CodInterviniente = Expediente.Interviniente.TU_CodInterviniente 
		INNER JOIN Catalogo.Funcionario 
		ON Historico.Visita.TC_UsuarioRed = Catalogo.Funcionario.TC_UsuarioRed 
		INNER JOIN Catalogo.TipoVisita 
		ON Historico.Visita.TN_CodTipoVisita = Catalogo.TipoVisita.TN_CodTipoVisita 
		INNER JOIN Catalogo.MotivoVisita 
		ON Historico.Visita.TN_CodMotivoVisita = Catalogo.MotivoVisita.TN_CodMotivoVisita 
		INNER JOIN Catalogo.MotivoSuspensionVisita 
		ON Historico.Visita.TN_CodMotivo = Catalogo.MotivoSuspensionVisita.TN_CodMotivo 
		LEFT OUTER JOIN Catalogo.Contexto 
		ON Historico.Visita.TC_CodContexto = Catalogo.Contexto.TC_CodContexto

		WHERE   Historico.Visita.TU_CodVisita = @CodVisita OR
			    Historico.Visita.TF_InicioVisita BETWEEN @InicioVisita AND @FinalizaVisita OR
			    Historico.Visita.TC_CodContexto = @CodContexto OR
				Historico.Visita.TN_CodTipoVisita = @CodTipoVisita
	ELSE	
	   SELECT   
	   Historico.Visita.TU_CodVisita AS Codigo, 
	   Historico.Visita.TC_Lugar AS Lugar, 
	   Historico.Visita.TF_InicioVisita AS InicioVisita,
	   Historico.Visita.TF_FinalizaVisita AS FinalizaVisita, 
       Historico.Visita.TC_Observaciones AS Observaciones,
	   'Split' AS Split, 
       Expediente.Interviniente.TU_CodInterviniente AS CodigoInterviniente, 
	   Catalogo.Funcionario.TC_UsuarioRed AS UsuarioRed, 
       Catalogo.Funcionario.TC_Nombre AS Nombre, 
	   Catalogo.Funcionario.TC_PrimerApellido AS PrimerApellido, 
	   Catalogo.Funcionario.TC_SegundoApellido AS SegundoApellido, 
       Catalogo.TipoVisita.TN_CodTipoVisita AS CodigoTipoVisita,
	   Catalogo.TipoVisita.TC_Descripcion AS DescripcionTipoVisita, 
	   Catalogo.MotivoVisita.TN_CodMotivoVisita AS CodigoMotivoVisita, 
       Catalogo.MotivoVisita.TC_Descripcion AS DescripcionMotivoVisita, 
	   Catalogo.Contexto.TC_CodContexto AS CodigoContexto, 
	   Catalogo.Contexto.TC_Descripcion AS DescripcionContexto
       FROM     Historico.Visita 
	   INNER JOIN Expediente.Interviniente 
	   ON Historico.Visita.TU_CodInterviniente = Expediente.Interviniente.TU_CodInterviniente
	   INNER JOIN Catalogo.Funcionario 
	   ON Historico.Visita.TC_UsuarioRed = Catalogo.Funcionario.TC_UsuarioRed 
	   INNER JOIN Catalogo.TipoVisita 
	   ON Historico.Visita.TN_CodTipoVisita = Catalogo.TipoVisita.TN_CodTipoVisita 
	   INNER JOIN Catalogo.MotivoVisita 
	   ON Historico.Visita.TN_CodMotivoVisita = Catalogo.MotivoVisita.TN_CodMotivoVisita 
	   INNER JOIN Catalogo.Contexto 
	   ON Historico.Visita.TC_CodContexto = Catalogo.Contexto.TC_CodContexto 
	   INNER JOIN Expediente.Interviniente AS Interviniente_1 
	   ON Historico.Visita.TU_CodInterviniente = Interviniente_1.TU_CodInterviniente 
	   INNER JOIN Expediente.Intervencion
	   ON Expediente.Intervencion.TU_CodInterviniente = Expediente.Interviniente.TU_CodInterviniente 
	   AND Interviniente_1.TU_CodInterviniente = Expediente.Intervencion.TU_CodInterviniente
	   INNER JOIN Expediente.Expediente
	   ON Expediente.Intervencion.TC_NumeroExpediente =  Expediente.Expediente.TC_NumeroExpediente
       WHERE   (Expediente.Intervencion.TC_NumeroExpediente = @NumeroExpediente)	
END
GO
