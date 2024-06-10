SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<04/09/2015>
-- Descripción :			<Permite Consultar los delitos de un interviniente 
-- Modificado :				<Donald Vargas><02/12/2016><Se corrige el nombre de los campos TC_CodDelito, TC_CodMotivoAbsolutoria y TC_CodCategoriaDelito a TN_CodDelito, TN_CodMotivoAbsolutoria y TN_CodCategoriaDelito de acuerdo al tipo de dato> 
-- =================================================================================================================================================
  
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteDelito]
 @CodigoInterviniente uniqueidentifier
    As
 Begin
 		SELECT  a.TU_CodInterviniente AS CodigoInterviniente,			 a.TF_CalificacionDelito AS FechaCalificacion, 
				a.TB_CrimenOrganizado AS CrimenOrganizado,				 a.TF_Hecho AS FechaHecho, 
				a.TF_Prescripcion AS FechaPrescripcion,					 a.TB_Indagado AS Indagado, 'Split' AS Split,
				a.TN_CodDelito as CodigoDelito,							 b.TC_Descripcion as DelitoDescrip,
				c.TN_CodCategoriaDelito as CodigoCategoriaDelito,		 c.TC_Descripcion as CategoriaDelitoDescrip,
				a.TN_CodMotivoAbsolutoria as CodigoMotivoAbsolutoria,	 d.TC_Descripcion as MotivoAbsolutoriaDescrip 
		FROM    Expediente.IntervinienteDelito as a WITH (Nolock)
		join			Catalogo.Delito				as b on a.TN_CodDelito=b.TN_CodDelito
		join			Catalogo.CategoriaDelito	as c on b.TN_CodCategoriaDelito=c.TN_CodCategoriaDelito
		left outer join	Catalogo.MotivoAbsolutoria	as d on a.TN_CodMotivoAbsolutoria=d.TN_CodMotivoAbsolutoria
		WHERE   a.TU_CodInterviniente= @CodigoInterviniente
End




GO
