SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar>
-- Fecha de creación:		<17/04/2018>
-- Descripción :			<Permite asociar una prioridad a un contexto>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarContextoPrioridad]
   @CodContexto varchar(4),
   @CodPrioridad smallint,
   @Inicio_Vigencia datetime2(7)
AS 
    BEGIN
          
			 INSERT INTO Catalogo.ContextoPrioridad
			   (TC_CodContexto,TN_CodPrioridad, TF_Inicio_Vigencia)
			 VALUES
				   (@CodContexto,@CodPrioridad, @Inicio_Vigencia )
    END
 


GO
