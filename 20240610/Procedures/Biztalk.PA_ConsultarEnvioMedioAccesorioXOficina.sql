SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<13/04/2020>
-- Descripción:				<Consulta si el contexto permite el envió del medio accesorio> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarEnvioMedioAccesorioXOficina]


(
	 @CodContexto		        VARCHAR(4),
     @CodConfiguracion		    VARCHAR(27)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @TempCodContexto				  VARCHAR(4)
	DECLARE @TempCodConfiguracion             VARCHAR(27)
	DECLARE @TempValor						  VARCHAR(50)

	SELECT @TempCodContexto      = @CodContexto
	SELECT @TempCodConfiguracion = @CodConfiguracion 

	
	
	IF NOT EXISTS  (SELECT 	CV.TC_Valor								As Valor									
					FROM			Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
					INNER JOIN		Catalogo.Contexto			        CO  WITH(NOLOCK)
					ON				CO.TC_CodContexto			=		CV.TC_CodContexto
					WHERE			CV.TC_CodContexto			=		@TempCodContexto  AND
									CV.TC_CodConfiguracion		=		@TempCodConfiguracion AND
									 Getdate()					>=		CV.TF_FechaActivacion AND
									(Getdate()					<=		CV.TF_FechaCaducidad OR 
									TF_FechaCaducidad			is		NULL))
	BEGIN
		
		SELECT @TempValor = 0
	END
   ELSE
   BEGIN
		SELECT @TempValor = (SELECT 	CV.TC_Valor								As Valor									
							FROM			Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
							INNER JOIN		Catalogo.Contexto			        CO  WITH(NOLOCK)
							ON				CO.TC_CodContexto			=		CV.TC_CodContexto
							WHERE			CV.TC_CodContexto			=		@TempCodContexto  AND
											CV.TC_CodConfiguracion		=		@TempCodConfiguracion AND
											 Getdate()					>=		CV.TF_FechaActivacion AND
											(Getdate()					<=		CV.TF_FechaCaducidad OR
											TF_FechaCaducidad			is		NULL))
   END
   
   SELECT @TempValor AS Valor
END



GO
