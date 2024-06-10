SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Consultar los recordatorios relacionados a los eventos> 
-- Modificación             <Se cambia el nombre del SP>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarRecordatoriosEvento] 

@CodEvento Uniqueidentifier

As
Begin

    Select	        R.[TU_CodRecordatorio]              As Codigo,
                    R.[TC_NumeroMovil]                  As NumeroMovil,
                    R.[TF_FechaInicioEvento]            As FechaInicioEvento,
                    R. [TC_Mensaje]                     As Mensaje,
                    'SplitEvento'						As SplitEvento,
                    e.[TU_CodEvento]				    As Codigo,
				    'SplitInterviniente'				As SplitInterviniente,
                    i.[TU_CodInterviniente]				As CodigoInterviniente                												
	From		    [Agenda].[Recordatorio]	            As	R  With(Nolock)
	Inner Join      [Agenda].[Evento]                   As E  With(Nolock)
	On              R.TU_CodEvento                      =  e.TU_CodEvento
	Inner Join      [Expediente].[Interviniente]        As  i  With(Nolock)
	On              R.TU_CodInterviniente               =  i.TU_CodInterviniente
		
	Where			(R.TU_CodEvento						= @CodEvento)
	
End

GO
