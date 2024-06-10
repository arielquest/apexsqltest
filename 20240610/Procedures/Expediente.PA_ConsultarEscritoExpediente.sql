SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Andrew Allen DAwson>  
-- Fecha de creación:  <11/10/2018>  
-- Descripción :   <Permite Consultar los escritos entrantes en un despacho>  
-- =================================================================================================================================================  
-- Modificacion:    <26/05/2020><Xinia Soto V.><Se agrega al select el valor de varias gestiones>  
-- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ConsultarEscritoExpediente]  
  @Codigo     uniqueidentifier = NULL,  
  @CodPuestoTrabajo  varchar(14)   = NULL,  
  @NumeroExpediente  char(14)   = NULL,  
     @CodTipoEscrito   smallint   = NULL,  
  @CodContexto   varchar(4)   = NULL,  
  @Descripcion   varchar(255)  = NULL,  
  @FechaIngresoOficina datetime2(2)  = NULL,  
  @IDARCHIVO    uniqueidentifier = NULL,  
  @FechaEnvio    datetime2(2)  = NULL,  
  @CantidadPagina   smallint   = Null,  
  @IndicePagina   smallint   = Null  
AS  
Begin   
  
 If (@IndicePagina Is Null Or @CantidadPagina Is Null)  
 Begin  
  SET @IndicePagina = 0;  
  SET @CantidadPagina = 32767;  
 End  
  
 SELECT A.TU_CodEscrito   AS  Codigo  
    ,A.TC_Descripcion   AS  Descripcion  
    ,A.TF_FechaIngresoOficina AS  FechaIngresoOficina  
    ,A.TF_FechaEnvio   AS  FechaEnvio  
    ,'split'     AS  Split  
    ,B.TC_CodContexto   AS  Codigo  
    ,B.TC_Descripcion   AS  Descripcion  
    ,'split'     AS  Split  
    ,C.TC_CodPuestoTrabajo AS  Codigo  
    ,C.TC_Descripcion   AS  Descripcion  
    ,'split'     AS  Split  
    ,D.TC_NumeroExpediente AS  NumeroExpediente  
    ,D.TC_Descripcion   AS  Descripcion  
    ,'split'     AS  Split  
    ,A.TN_CodTipoEscrito  AS  Codigo  
    ,E.TC_Descripcion   AS  Descripcion  
    ,'split'     AS  Split  
    ,A.TC_IDARCHIVO   AS  Codigo  
	,A.TB_VariasGestiones as VariasGestiones
 FROM Expediente.EscritoExpediente A With(Nolock)  
   
 INNER JOIN   
 (  
  SELECT  EE.TU_CodEscrito  
  FROM  Expediente.EscritoExpediente EE  
  WHERE  EE.TC_NumeroExpediente = ISNULL(@NumeroExpediente, EE.TC_NumeroExpediente)  
  EXCEPT  
  SELECT  EL.TU_CodEscrito  
  FROM  Expediente.EscritoLegajo EL  
  JOIN  Expediente.Legajo L  
  ON   EL.TU_CodLegajo = L.TU_CodLegajo  
  WHERE  L.TC_NumeroExpediente = ISNULL(@NumeroExpediente, L.TC_NumeroExpediente)  
 ) AS X  
 ON   X.TU_CodEscrito     = A.TU_CodEscrito   
  
 INNER JOIN Catalogo.Contexto    B WITH(Nolock)  
 ON   A.TC_CodContexto   = B.TC_CodContexto  
  
 INNER JOIN Catalogo.PuestoTrabajo   C WITH(Nolock)  
 ON   A.TC_CodPuestoTrabajo   = C.TC_CodPuestoTrabajo  
  
 INNER JOIN Expediente.Expediente   D WITH(Nolock)  
 ON   A.TC_NumeroExpediente   = D.TC_NumeroExpediente  
  
 INNER JOIN Catalogo.TipoEscrito   E WITH(Nolock)  
 ON   A.TN_CodTipoEscrito    = E.TN_CodTipoEscrito  
  
 WHERE A.TU_CodEscrito    =  ISNULL(@Codigo, A.TU_CodEscrito)  
 AND  (A.TC_Descripcion   LIKE '%' + ISNULL(@Descripcion ,A.TC_Descripcion) + '%' OR @Descripcion IS NULL)  
 AND  A.TC_CodPuestoTrabajo    =  ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)  
 AND  A.TC_NumeroExpediente  =  ISNULL(@NumeroExpediente, A.TC_NumeroExpediente)  
 AND  A.TN_CodTipoEscrito   =  ISNULL(@CodTipoEscrito, A.TN_CodTipoEscrito)  
  
 ORDER BY A.TF_FechaEnvio  Asc  
 Offset  @IndicePagina * @CantidadPagina Rows  
 Fetch Next @CantidadPagina Rows Only;  
  
END  
GO
