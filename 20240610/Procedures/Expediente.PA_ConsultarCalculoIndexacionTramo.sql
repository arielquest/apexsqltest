SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
 
-- =================================================================================================================================================  
-- Versión:     <1.1>  
-- Creado por:    <Johan Manuel Acosta Ibañez>  
-- Fecha de creación:  <04/01/2019>  
-- Descripción :   <Permite consultar los datos básicos de cálculos de indexación>   
-- Modificado por:   <Ronny Ramírez Rojas>  
-- Fecha de modificación <21/05/2019>  
-- Modificación    <Se cambian los nombres de las columnas IPCInicial e IPCFinal, para que coincidan con las de las BD>  
-- Modificación  <01/10/2020>  Xinia Soto V.  <Se cambian los nombres de las columnas IndicadorInicial e IndicadorFinal, para que coincidan con la clase> 
-- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ConsultarCalculoIndexacionTramo]  
 @CodigoCalculoIndexacion    uniqueidentifier  
As  
Begin  
 Select  A.TU_CodigoTramoIndexacion   As Codigo,  
    A.TF_FechaInicio     As FechaActivacion,  
    A.TF_FechaFinal      As FechaDesactivacion,  
    A.TN_IndicadorInicial    As IndicadorInicial,  
    A.TN_IndicadorFinal     As IndicadorFinal,  
    A.TN_MontoAIndexar     As MontoAIndexar,  
    A.TN_MontoIndexado     As MontoIndexado,  
    A.TN_MontoTotalIndexado    As MontoTotalIndexado,  
    A.TN_MontoAguinaldoIndexado   As MontoAguinaldoIndexado,  
    'Split'        As SplitCalculoIndexado,  
    B.TU_CodigoCalculoIndexacion  As Codigo,  
    B.TC_Descripcion     As Descripcion     
 From  Expediente.CalculoIndexacionTramo As A With(Nolock)    
 Inner Join Expediente.CalculoIndexacion  As B With(Nolock)    
 On   B.TU_CodigoCalculoIndexacion  = A.TU_CodigoCalculoIndexacion   
 Where  A.TU_CodigoCalculoIndexacion  = @CodigoCalculoIndexacion    
 End  
GO
