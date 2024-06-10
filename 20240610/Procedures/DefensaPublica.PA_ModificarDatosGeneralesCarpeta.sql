SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================================================================================
-- Autor:		   <Aida Elena Siles R>
-- Fecha Creación: <13/08/2019>
-- Descripcion:	   <Modifica los datos generales de una carpeta.>
-- ==================================================================================================================================================================================
-- Modificación:   <08/07/2021> <Josué Quirós Batista> <Se agrega a la modificación el campo de observaciones.>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE [DefensaPublica].[PA_ModificarDatosGeneralesCarpeta]
	@NRD				varchar(14),
	@CodTipoCaso		smallint,
	@Observaciones      varchar(255)
AS
BEGIN

	Update  DefensaPublica.Carpeta
	set		TN_CodTipoCaso		=	@CodTipoCaso,
			TF_Actualizacion	=	GETDATE(),
			TC_Observaciones	=   @Observaciones
	Where	TC_NRD				=	@NRD

END

GO
