SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<26/08/2019>
-- Descripción :			<Permite consultar el número de expediente acumulado> 
-- =================================================================================================================================================
-- Modificación :			<10/10/2021><Karol Jiménez Sánchez><Se modifica para consultar el contexto del expediente acumulado, para la generación de consecutivo IDINT de las intervenciones que se van a desacumular> 
-- =================================================================================================================================================
CREATE Procedure [Expediente].[PA_ConsultarExpedienteAcumulado]
	@NumeroExpedienteAcumula			varchar(14)
As
Begin

	Select		A.TC_NumeroExpediente		Numero,
				'Split'						Split,
				B.TC_CodContexto			Codigo
	from		Historico.ExpedienteAcumulacion A With(NoLock)
	Inner Join	Expediente.Expediente			B With(NoLock)	
	On			B.TC_NumeroExpediente			= A.TC_NumeroExpediente
	where		TC_NumeroExpedienteAcumula		= @NumeroExpedienteAcumula 
	and			TF_InicioAcumulacion			= (	select	MAX(TF_InicioAcumulacion) 
													from	Historico.ExpedienteAcumulacion With(NoLock)
													where	TC_NumeroExpedienteAcumula		= @NumeroExpedienteAcumula 
													and		TF_FinAcumulacion				is null)		
End
GO
