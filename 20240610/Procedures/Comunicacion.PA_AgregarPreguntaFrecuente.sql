SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<06/09/2019>
-- Descripción:				<Permite agregar un registro a [Comunicacion].[PreguntasFrecuentes].>
-- ===========================================================================================

CREATE PROCEDURE [Comunicacion].[PA_AgregarPreguntaFrecuente]
	@CodPregunta smallint
	,@Pregunta varchar(255)
	,@Respuesta varchar(500)
	,@Sistema varchar(3)
	,@Inicio_Vigencia datetime2(7)
	,@Fin_Vigencia datetime2(7)

As
Begin

If @CodPregunta Is Null 
Begin
	Select  @CodPregunta = (Max([TN_CodPregunta]) + 1) From [Comunicacion].[PreguntasFrecuentes]
End

INSERT INTO [Comunicacion].[PreguntasFrecuentes]
           ([TN_CodPregunta]
           ,[TC_Pregunta]
           ,[TC_Respuesta]
           ,[TC_Sistema]
           ,[TF_Inicio_Vigencia]
           ,[TF_Fin_Vigencia])
     VALUES
           (@CodPregunta
           ,@Pregunta
           ,@Respuesta
           ,@Sistema
           ,@Inicio_Vigencia
           ,@Fin_Vigencia)

End
GO
