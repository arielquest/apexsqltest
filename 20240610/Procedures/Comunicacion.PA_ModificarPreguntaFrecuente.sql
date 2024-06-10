SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Comunicacion].[PA_ModificarPreguntaFrecuente]
	 @CodPregunta smallint,
	 @Pregunta varchar(255),
	 @Respuesta varchar(500),
	 @Sistema varchar(3),
	 @Inicio_Vigencia datetime2(7),
	 @Fin_Vigencia datetime2(7)
As
Begin
UPDATE [Comunicacion].[PreguntasFrecuentes]
   SET [TN_CodPregunta] = @CodPregunta
      ,[TC_Pregunta] = @Pregunta
      ,[TC_Respuesta] = @Respuesta
      ,[TC_Sistema] = @Sistema
      ,[TF_Inicio_Vigencia] = @Inicio_Vigencia
      ,[TF_Fin_Vigencia] = @Fin_Vigencia
 WHERE [TN_CodPregunta] = @CodPregunta

END


GO
