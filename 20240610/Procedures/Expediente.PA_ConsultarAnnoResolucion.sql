SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Jonathan Aguilar Navarro> 
-- Fecha Creación:	<20/08/2018>
-- Descripcion:		<Permite consultar los años del libro de sentencia para listar en los filtro de búsquea>
-- =================================================================================================================================================
-- Moficación:		<12/07/2021> <Isaac Santiago Méndez Castillo> <A solicitud de incidente, se ordena de manera descendente la información
--																   obtenida.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarAnnoResolucion] 	
	@CodContexto			varchar(4)
AS
begin
	Begin try
		Begin tran
		
		select distinct				A.TC_AnnoSentencia as AnnoSentencia 
		from						Expediente.LibroSentencia A
		where A.TC_CodContexto		= @CodContexto	
		ORDER BY					A.TC_AnnoSentencia DESC

		COMMIT TRAN
	End try  
		Begin Catch  
			Rollback tran;
			throw;
		End Catch  
END
GO
