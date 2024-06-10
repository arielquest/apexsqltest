SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Navarrete Alvarez>
-- Fecha de creación:		<27/07/2017>
-- Descripción:				<Consulta los ParticipantesFechaEvento> 
-- Modificación:			<27/07/2017><Diego Navarrete Alvarez><Cambio del nombre del SP>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarParticipantesFechaEvento] 

@CodigoEvento Uniqueidentifier

As
Begin

	Select
		PFE.TB_ParticipacionParcial		AS ParticipacionParcial,
		'SplitParticipanteEvento'		As SplitParticipanteEvento,		
		 PFE.TU_CodParticipacion		AS Codigo, 
		 'SplitFechaEvento'				As SplitFechaEvento,
		 PFE.TU_CodFechaEvento			AS Codigo
		
					
	From			[Agenda].[FechaEvento]				As	FE   With(Nolock)
	Inner Join      [Agenda].[ParticipanteFechaEvento] 	As  PFE  With(Nolock)
	On              FE.TU_CodFechaEvento					=   PFE.TU_CodFechaEvento 	
	Where			(FE.TU_CodEvento						=	@CodigoEvento)  

End





GO
