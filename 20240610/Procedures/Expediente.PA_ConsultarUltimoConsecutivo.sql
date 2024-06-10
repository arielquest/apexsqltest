SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta>
-- Fecha de creación:		<28/10/2015>
-- Descripción :			<Permite Consultar el último consecutivo> 
--
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_Periodo a TN_Periodo de acuerdo al tipo de dato.>
-- =================================================================================================================================================
  
CREATE PROCEDURE [Expediente].[PA_ConsultarUltimoConsecutivo]
			@CodOficina varchar(4)			
 As
 Begin
	Begin
		Select	Isnull(TN_Consecutivo,-1)
		From	Expediente.ConsecutivoExpediente With(Nolock)          
		Where   TC_Oficina	=	@CodOficina	And
				TN_Periodo	=	DATEPART(YEAR, GETDATE())				
	End
End




GO
