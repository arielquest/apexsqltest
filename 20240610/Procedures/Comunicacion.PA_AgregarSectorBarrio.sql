SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez R>
-- Fecha de creación:		<28-03-2023>
-- Descripción :			<Permite asignar un barrio a un sector>
-- ===========================================================================================
CREATE     PROCEDURE [Comunicacion].[PA_AgregarSectorBarrio] 
    @CodSector				smallint,
    @ListaBarrios  SectorBarriosType      READONLY
As
Begin
 
 --//Valida si hay barrios que ya estan registrados en el sector para evitar duplicidad
 
	  Insert Into [Comunicacion].[SectorBarrio]
			   ([TN_CodSector]
			   ,[TN_CodProvincia]
			   ,[TN_CodCanton]
			   ,[TN_CodDistrito]
			   ,[TN_CodBarrio] )
       SELECT   @CodSector,			    
			    LB.Provincia
			   ,LB.Canton
			   ,LB.Distrito
			   ,LB.Barrio 
        FROM   @ListaBarrios	  AS LB
        LEFT JOIN (      Select   TN_CodSector
		                         ,TN_CodProvincia
								 ,TN_CodCanton
								 ,TN_CodDistrito
			                     ,TN_CodBarrio
			             From  Comunicacion.SectorBarrio With(Nolock)  
			              WHERE TN_CodSector  = @CodSector
			      ) AS S
			On			LB.Barrio				=   S.TN_CodBarrio
			And			LB.Distrito			     =	S.TN_CodDistrito
			And			LB.Canton				=	S.TN_CodCanton
			And			LB.Provincia			=	S.TN_CodProvincia
		WHERE S.TN_CodSector   IS NULL
End




GO
