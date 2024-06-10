SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguila Navarro>
-- Fecha de creación:		<25/03/2021>
-- Descripción :			<Permite Consultar si un número de resolucón esta asociado a una resolución> 
-- =================================================================================================================================================

CREATE  PROCEDURE [Expediente].[PA_ConsultarNumeroResolucion]
@Anno						varchar(4),
@Contexto					varchar(4),
@NumeroResolucion			bigint	

As
Begin
declare @L_Anno					varchar(4) = @Anno			
declare @L_Contexto				varchar(4) = @Contexto		
declare @L_NumeroResolucion		bigint	   = @NumeroResolucion	


SELECT	TU_CodResolucion
FROM	Expediente.LibroSentencia	A
WHERE	TC_AnnoSentencia			= @L_Anno
AND		TC_CodContexto				= @L_Contexto	
AND		TC_NumeroResolucion			= @L_NumeroResolucion
AND		TU_CodResolucion			IS not NULL

End
GO
