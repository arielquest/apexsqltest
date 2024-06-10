SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Esteban Cordero Benavides>
-- Fecha Creación:	<26 de febrero de 2016.>
-- Descripcion:		<Modificar una licencia.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE Procedure [Persona].[PA_ModificarLicencia]
	@TU_CodPersona		uniqueidentifier, 
	@TC_CodTipoLicencia	SmallInt,
	@TF_Caducidad		DateTime2,
	@TF_Expedicion		DateTime2
As
Begin
	Update	Persona.Licencia	With(RowLock)
	Set		TF_Expedicion		= @TF_Expedicion,
			TF_Tramite			= GetDate(),
			TF_Actualizacion	= GetDate()
	Where	TU_CodPersona		= @TU_CodPersona
	And		TN_CodTipoLicencia	= @TC_CodTipoLicencia
	And		TF_Caducidad		= @TF_Caducidad
End

GO
