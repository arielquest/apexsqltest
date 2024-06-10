SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Diego Navarrete Alarez>
-- Fecha de creación:		<25/2/2017>
-- Descripción:				<Obtiene las fechas de los eventos de los representantes de los intevinientes
--                           recibidos como parámetro> 
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarFechasEventosRespresentante] 
  @ListaCodigoInterviniente varchar(Max),       
  @FechasEvento varchar(Max)--Recibe un string con el siguiente formato "25/06/2016  , 27/09/2016 | 25/06/2016 ,  27/09/2016"  
														--Significado -> "FechaInicio , FechaFin   | FechaInicio,  FechaFin" 
As
Begin

	BEGIN TRY  
		;With
		
		Fechas --Almacena en una columna un registro por cada FechaInicio,FechaFin que contenga @FechasEvento
		As(
			Select S  As TN_FechaInicioFechaFin
			From [dbo].[SplitString] (@FechasEvento, '|')
		),

		--El siguiente proceso separa los registros (FechInicio,FechaFin) de la tabla FechasInicioFin. 
		FechasEvento -- Se separa FechaInicio y FechaFin en dos columnas ()
		As
		(
			Select      left(TN_FechaInicioFechaFin,Charindex(',',TN_FechaInicioFechaFin)-1)		As         Inicio,
						Substring(TN_FechaInicioFechaFin,Charindex(',',TN_FechaInicioFechaFin)+1,
						Len(TN_FechaInicioFechaFin)-Charindex(',',TN_FechaInicioFechaFin))			As			Fin
			From        Fechas
		)
		,
		ListaIntervinientes 
		As
		(
			Select  S As   TN_CodInterviniente
			From    [dbo].[SplitString] (@ListaCodigoInterviniente, ',')
		)
		,
		CodigosPersona		
		As
		(
			Select Distinct TU_CodPersona
			From		[Expediente].[Intervencion]	As	R
			Inner Join	ListaIntervinientes				As	I
			On			I.TN_CodInterviniente			=	R.TU_CodInterviniente		
		)
		,
		CodigosIntervinientes
		As
		(		
			Select Distinct TU_CodInterviniente
			From			[Expediente].[Intervencion]	As	R
			Inner Join		CodigosPersona					As	CP
			On				R.TU_CodPersona					=	CP.TU_CodPersona		
		)
		
		Select Distinct  FE.TF_FechaInicio														AS FechaInicio,
						 FE.TF_FechaFin														    AS FechaFin,
						 E.TC_Titulo															AS Titulo,
						 E.TU_CodEvento															AS CodigoEvento,
		                 PF.TC_Nombre + ' ' +PF.TC_PrimerApellido + ' ' + PF.TC_SegundoApellido As NombreFuncionario

		From			 [Agenda].[IntervinienteEvento] IE
		Inner Join       CodigosIntervinientes CI
		On				 IE.TU_CodInterviniente = CI.TU_CodInterviniente
		Inner Join       [Agenda].[Evento] E
		On				 E.TU_CodEvento = IE.TU_CodEvento			
		Inner Join		 [Agenda].[FechaEvento] FE
        On				 E.TU_CodEvento = FE.TU_CodEvento
		Inner Join		 [Expediente].[Intervencion] I
		On				 IE.TU_CodInterviniente = I.TU_CodInterviniente
		Inner Join		 [Persona].[PersonaFisica] PF
		On				 PF.TU_CodPersona = I.TU_CodPersona
		Inner Join		 FechasEvento LFE
		On				 LFE.Inicio >= FE.TF_FechaInicio 
		And              LFE.Inicio < FE.TF_FechaFin 
		Or               LFE.Fin > FE.TF_FechaInicio 
		And              LFE.Fin <=  FE.TF_FechaFin
		Or               FE.TF_FechaInicio >= LFE.Inicio 
		And              FE.TF_FechaInicio < LFE.Fin 
		Or               FE.TF_FechaFin > LFE.Inicio 
		And              FE.TF_FechaFin <= LFE.Fin

	END TRY  
	BEGIN CATCH  
		RETURN NULL; 
	END CATCH  

End

GO
