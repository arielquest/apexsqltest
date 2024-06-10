SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<06/05/2016>
-- Descripción :			<Permite Agregar realacion de parentesco entre dos intervinientes > 
-- =================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteParentesco] 
     @CodigoInterviniente1 uniqueidentifier,
     @CodigoInterviniente2 uniqueidentifier,
     @CodigoLegajo uniqueidentifier,
	 @CodigoParentesco varchar(2)

AS  
BEGIN  


 Declare @ParentescoRelacionado varchar(2)=null

 --//Buscar parentesco relacionado
 Select @ParentescoRelacionado=TC_CodParentescoB
 From Catalogo.RelacionParentesco with(nolock)
 Where TC_CodParentescoA = @CodigoParentesco

 if (@ParentescoRelacionado is not null)
 begin
    --//Parentesco A-> B
	Insert Into		Expediente .IntervinienteParentesco 
	   ( TU_CodInterviniente1, TU_CodInterviniente2,	TU_CodLegajo,  TC_CodParentesco, TF_Actualizacion		  )
	Values
	   (@CodigoInterviniente1, @CodigoInterviniente2, @CodigoLegajo, @CodigoParentesco, GETDATE ()  )
   --//Parentesco B-> A
	 Insert Into		Expediente .IntervinienteParentesco 
	   ( TU_CodInterviniente1, TU_CodInterviniente2,	TU_CodLegajo,  TC_CodParentesco, TF_Actualizacion		  )
	Values
	   ( @CodigoInterviniente2, @CodigoInterviniente1, @CodigoLegajo, @ParentescoRelacionado, GETDATE ()  )

 end
	  


End



GO
