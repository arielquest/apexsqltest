SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
  
-- ==================================================================================================================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Jonathan Aguilar Navarro>  
-- Fecha de creación:  <13/03/2018>  
-- Descripción :   <Permite Consultar los Contextos>   
-- ==================================================================================================================================================================================  
-- Modificación    <Jonathan Aguilar Navarro> <01/06/2018> <Se agrega al al SELECT para obtener la información de la defensa publica   
--       asociada a la oficina del contexto.>   
-- Modificación:   <Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>  
-- Modificación:   <Andrés Díaz><10/09/2018><Se agrega filtro por código de circuito>  
-- Modificación    <Johan Acosta Ibañez> <27/03/2020> <Se agregan los campos que corresponden a PBI - 80629 HU 02 Envío de Escritos GL- Funcionalidad Agregar servicios externos a una oficina judicial en SIAGPJ>  
-- Modificación    <Kirvin Bennett Mathurin> <04/05/2020> <Se agregan campos de provincia>  
-- Modificación    <Kirvin Bennett Mathurin> <22/05/2020> <Se incluye filtro por TB_ConsultaPublicaCiudadano, TB_ConsultaPrivadaCiudadano, TB_EnvioEscrito_GL_AM, TB_EnvioDemandaDenuncia_GL_AM>  
-- Modificación    <Isaac Dobles Mata> <13/08/2020> <Se agrega domicilio, descripción abreviada y categoría de oficina en la consulta.>  
-- Modificación    <Aida Elena Siles R> <31/08/2020> <Se agrega la categoría de la oficina defensa ya que se requiere en el módulo de solicitudes de defensor.>  
-- Modificación    <Xinia Soto> <06/10/2020> <Se retorna la propiedad de TB_SolicitudCitas_GL_AM>  
-- ==================================================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarContextoPrueba]  
 @CodOficina    VARCHAR(4)  = NULL,  
 @CodContexto   VARCHAR(4)  = NULL,  
 @Descripcion   VARCHAR(255) = NULL,  
 @FechaDesactivacion  DATETIME2(3) = NULL,  
 @FechaActivacion  DATETIME2(3) = NULL,  
 @CodCircuito   SMALLINT  = NULL,  
 @CodCategoriaOficina CHAR(1)   = NULL,  
 @EnvioDemandaGL   BIT    = NULL,  
 @EnvioEscritoGL   BIT    = NULL,  
 @ConsultaPublicaGL  BIT    = NULL,  
 @ConsultaPrivadaGL  BIT    = NULL  
AS  
BEGIN  
 --Variables  
 DECLARE @L_TC_CodOficina     VARCHAR(4)  = @CodOficina,  
   @L_TC_CodContexto     VARCHAR(4)  = @CodContexto,  
   @L_TC_Descripcion     VARCHAR(255) = @Descripcion,  
   @L_TF_Inicio_Vigencia    DATETIME2(3) = @FechaDesactivacion,  
   @L_TF_Fin_Vigencia     DATETIME2(3) = @FechaActivacion,  
   @L_TB_@Envio_DemandaGL    BIT    = @EnvioDemandaGL,  
   @L_TB_@Envio_EscritoGL    BIT    = @EnvioEscritoGL,  
   @L_TB_@Consulta_PublicaGL   BIT    = @ConsultaPublicaGL,  
   @L_TB_@Consulta_PrivadaGL   BIT    = @ConsultaPrivadaGL  
  
 DECLARE @L_TC_ExpresionLike     VARCHAR(257) = IIF(@L_TC_Descripcion IS NOT NULL,'%' + @L_TC_Descripcion + '%',NULL);  
   
 IF  @L_TF_Inicio_Vigencia Is Null AND @L_TF_Fin_Vigencia Is Null  
 BEGIN   
  SELECT  A.TC_CodContexto      AS Codigo,   
     A.TC_Descripcion      AS Descripcion,  
     A.TF_Inicio_Vigencia     AS FechaActivacion,   
     A.TF_Fin_Vigencia      AS FechaDesactivacion,  
     A.TC_Telefono       AS Telefono,  
     A.TC_Fax        AS Fax,   
     A.TC_Email        AS Email,  
     A.TB_EnvioEscrito_GL_AM     AS EnvioEscrito_GL_AM,  
     A.TB_EnvioDemandaDenuncia_GL_AM   AS EnvioDemandaDenuncia_GL_AM,  
     A.TB_ConsultaPublicaCiudadano   AS ConsultaPublicaCiudadano,  
     A.TB_ConsultaPrivadaCiudadano   AS ConsultaPrivadaCiudadano, 
	 A.TB_SolicitudCitas_GL_AM		 AS SolicitudCitas,
     'Split'         AS Split,  
     B.TC_CodMateria       AS Codigo,  
     B.TC_Descripcion      AS Descripcion,  
     B.TF_Inicio_Vigencia     AS FechaActivacion,  
     B.TF_Fin_Vigencia      AS FechaDesactivacion,  
     'Split'         AS Split,  
     C.TC_CodOficina       AS Codigo,  
     C.TC_Nombre        AS Descripcion,  
     C.TF_Inicio_Vigencia     AS FechaActivacion,  
     C.TF_Fin_Vigencia      AS FechaDesactivacion,  
     C.TC_Domicilio       AS Domicilio,  
     C.TC_DescripcionAbreviada    AS DescripcionAbreviada,  
     'Split'         AS Split,   
     D.TN_CodTipoOficina      AS Codigo,   
     D.TC_Descripcion      AS Descripcion,   
     D.TF_Inicio_Vigencia     AS FechaActivacion,   
     D.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,   
     E.TN_CodCircuito      AS Codigo,   
     E.TC_Descripcion      AS Descripcion,   
     E.TF_Inicio_Vigencia     AS FechaActivacion,   
     E.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,  
     H.TC_CodOficina       AS CodigoDefensa,  
     H.TC_Nombre        AS DescripcionDefensa,  
     H.TC_CodCategoriaOficina    AS CategoriaDefensa,  
     H.TF_Inicio_Vigencia     AS FechaActivacionDefensa,  
     H.TF_Fin_Vigencia      AS FechaDesactivacionDefensa,   
     F.TC_CodContexto      AS CodigoOCJ,  
     F.TC_Descripcion      AS DescripcionOCJ,  
     F.TF_Inicio_Vigencia     AS FechaActivacionOCJ,  
     F.TF_Fin_Vigencia      AS FechaDesactivacionOCJ,  
     G.TC_CodOficina       AS CodigoOficinaOCJ,  
     G.TC_Nombre        AS DescripcionOficinaOCJ,  
     G.TF_Inicio_Vigencia     AS FechaActivacionOficinaOCJ,  
     G.TF_Fin_Vigencia      AS FechaDesactivacionOficinaOCJ,  
     I.TN_CodProvincia      AS CodigoProvincia,   
     I.TC_Descripcion      AS DescripcionProvincia,   
     I.TF_Inicio_Vigencia     AS FechaActivacionProvincia,   
     I.TF_Fin_Vigencia      AS FechaVencimientoProvincia,  
     C.TC_CodCategoriaOficina    AS CategoriaOficina  
	
  FROM  Catalogo.Contexto      A WITH(NOLOCK)   
  INNER JOIN Catalogo.Materia      B WITH(NOLOCK)  
  ON          B.TC_CodMateria       = A.TC_CodMateria  
  INNER JOIN Catalogo.Oficina      C WITH(NOLOCK)  
  ON          C.TC_CodOficina       = A.TC_CodOficina  
  INNER JOIN Catalogo.TipoOficina     D WITH(NOLOCK)   
  ON   D.TN_CodTipoOficina      = C.TN_CodTipoOficina  
  INNER JOIN Catalogo.Circuito      E WITH(NOLOCK)  
  ON   E.TN_CodCircuito      = C.TN_CodCircuito  
  LEFT JOIN Catalogo.Contexto      F WITH(NOLOCK)   
  ON   F.TC_CodContexto      = A.TC_CodContextoOCJ  
  LEFT JOIN Catalogo.Oficina      G WITH(NOLOCK)  
  ON   G.TC_CodOficina       = F.TC_CodOficina  
  LEFT JOIN Catalogo.Oficina      H WITH(NOLOCK)  
  ON   H.TC_CodOficina       = C.TC_CodOficinaDefensa  
  INNER JOIN Catalogo.Provincia      I WITH(NOLOCK)  
  ON   I.TN_CodProvincia      = E.TN_CodProvincia 
  WHERE  dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@L_TC_ExpresionLike , A.TC_Descripcion))  
  AND   A.TC_CodOficina       = COALESCE(@L_TC_CodOficina,A.TC_CodOficina)  
  AND   A.TC_CodContexto      = COALESCE(@L_TC_CodContexto,A.TC_CodContexto)  
  AND   C.TN_CodCircuito      = COALESCE(@CodCircuito,C.TN_CodCircuito)  
  AND   COALESCE(C.TC_CodCategoriaOficina, '') = COALESCE(@CodCategoriaOficina, C.TC_CodCategoriaOficina, '')  
  AND   A.TB_EnvioDemandaDenuncia_GL_AM   = COALESCE(@L_TB_@Envio_DemandaGL, A.TB_EnvioDemandaDenuncia_GL_AM)  
  AND   A.TB_EnvioEscrito_GL_AM     = COALESCE(@L_TB_@Envio_EscritoGL, A.TB_EnvioEscrito_GL_AM)  
  AND   A.TB_ConsultaPublicaCiudadano   = COALESCE(@L_TB_@Consulta_PublicaGL, A.TB_ConsultaPublicaCiudadano)  
  AND   A.TB_ConsultaPrivadaCiudadano   = COALESCE(@L_TB_@Consulta_PrivadaGL, A.TB_ConsultaPrivadaCiudadano)  
  ORDER BY A.TC_Descripcion;  
 END  
 --Por descripcion si hay. Si estan activos o desactivos depEndiEndo de valor de @L_TF_Inicio_Vigencia  
 ELSE IF @L_TF_Inicio_Vigencia Is Null AND @L_TF_Fin_Vigencia Is Not Null  
 BEGIN   
  SELECT  A.TC_CodContexto      AS Codigo,   
     A.TC_Descripcion      AS Descripcion,  
     A.TF_Inicio_Vigencia     AS FechaActivacion,   
     A.TF_Fin_Vigencia      AS FechaDesactivacion,  
     A.TC_Telefono       AS Telefono,  
     A.TC_Fax        AS Fax,   
     A.TC_Email        AS Email,  
     A.TB_EnvioEscrito_GL_AM     AS EnvioEscrito_GL_AM,       A.TB_EnvioDemandaDenuncia_GL_AM   AS EnvioDemandaDenuncia_GL_AM,  
     A.TB_ConsultaPublicaCiudadano   AS ConsultaPublicaCiudadano,  
     A.TB_ConsultaPrivadaCiudadano   AS ConsultaPrivadaCiudadano,  
     'Split'         AS Split,  
     B.TC_CodMateria       AS Codigo,  
     B.TC_Descripcion      AS Descripcion,  
     B.TF_Inicio_Vigencia     AS FechaActivacion,  
     B.TF_Fin_Vigencia      AS FechaDesactivacion,  
     'Split'         AS Split,  
     C.TC_CodOficina       AS Codigo,  
     C.TC_Nombre        AS Descripcion,  
     C.TF_Inicio_Vigencia     AS FechaActivacion,  
     C.TF_Fin_Vigencia      AS FechaDesactivacion,  
     C.TC_Domicilio       AS Domicilio,  
     C.TC_DescripcionAbreviada    AS DescripcionAbreviada,  
     'Split'         AS Split,   
     D.TN_CodTipoOficina      AS Codigo,   
     D.TC_Descripcion      AS Descripcion,   
     D.TF_Inicio_Vigencia     AS FechaActivacion,   
     D.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,   
     E.TN_CodCircuito      AS Codigo,   
     E.TC_Descripcion      AS Descripcion,   
     E.TF_Inicio_Vigencia     AS FechaActivacion,   
     E.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,  
     H.TC_CodOficina       AS CodigoDefensa,  
     H.TC_Nombre        AS DescripcionDefensa,  
     H.TC_CodCategoriaOficina    AS CategoriaDefensa,  
     H.TF_Inicio_Vigencia     AS FechaActivacionDefensa,  
     H.TF_Fin_Vigencia      AS FechaDesactivacionDefensa,   
     F.TC_CodContexto      AS CodigoOCJ,  
     F.TC_Descripcion      AS DescripcionOCJ,  
     F.TF_Inicio_Vigencia     AS FechaActivacionOCJ,  
     F.TF_Fin_Vigencia      AS FechaDesactivacionOCJ,  
     G.TC_CodOficina       AS CodigoOficinaOCJ,  
     G.TC_Nombre        AS DescripcionOficinaOCJ,  
     G.TF_Inicio_Vigencia     AS FechaActivacionOficinaOCJ,  
     G.TF_Fin_Vigencia      AS FechaDesactivacionOficinaOCJ,  
     I.TN_CodProvincia      AS CodigoProvincia,   
     I.TC_Descripcion      AS DescripcionProvincia,   
     I.TF_Inicio_Vigencia     AS FechaActivacionProvincia,   
     I.TF_Fin_Vigencia      AS FechaVencimientoProvincia,  
     C.TC_CodCategoriaOficina    AS CategoriaOficina  
  FROM  Catalogo.Contexto      A WITH(NOLOCK)   
  INNER JOIN Catalogo.Materia      B WITH(NOLOCK)  
  ON          B.TC_CodMateria       = A.TC_CodMateria  
  INNER JOIN Catalogo.Oficina      C WITH(NOLOCK)  
  ON          C.TC_CodOficina       = A.TC_CodOficina  
  INNER JOIN Catalogo.TipoOficina     D WITH(NOLOCK)   
  ON   D.TN_CodTipoOficina      = C.TN_CodTipoOficina  
  INNER JOIN Catalogo.Circuito      E WITH(NOLOCK)  
  ON   E.TN_CodCircuito      = C.TN_CodCircuito  
  LEFT JOIN Catalogo.Contexto      F WITH(NOLOCK)   
  ON   F.TC_CodContexto      = A.TC_CodContextoOCJ  
  LEFT JOIN Catalogo.Oficina      G WITH(NOLOCK)  
  ON   G.TC_CodOficina       = F.TC_CodOficina  
  LEFT JOIN Catalogo.Oficina      H WITH(NOLOCK)  
  ON   H.TC_CodOficina       = C.TC_CodOficinaDefensa  
  INNER JOIN Catalogo.Provincia      I WITH(NOLOCK)  
  ON   I.TN_CodProvincia      = E.TN_CodProvincia  
  WHERE  dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@L_TC_ExpresionLike , A.TC_Descripcion))  
  AND   A.TF_Inicio_Vigencia     < GETDATE ()  
  AND   (A.TF_Fin_Vigencia Is Null    Or A.TF_Fin_Vigencia >= GETDATE ())  
  AND   A.TC_CodOficina       = COALESCE(@L_TC_CodOficina,A.TC_CodOficina)  
  AND   A.TC_CodContexto      = COALESCE(@L_TC_CodContexto,A.TC_CodContexto)  
  AND   C.TN_CodCircuito      = COALESCE(@CodCircuito,C.TN_CodCircuito)  
  AND   COALESCE(C.TC_CodCategoriaOficina, '') = COALESCE(@CodCategoriaOficina, C.TC_CodCategoriaOficina, '')    
  AND   A.TB_EnvioDemandaDenuncia_GL_AM   = COALESCE(@L_TB_@Envio_DemandaGL, A.TB_EnvioDemandaDenuncia_GL_AM)  
  AND   A.TB_EnvioEscrito_GL_AM     = COALESCE(@L_TB_@Envio_EscritoGL, A.TB_EnvioEscrito_GL_AM)  
  AND   A.TB_ConsultaPublicaCiudadano   = COALESCE(@L_TB_@Consulta_PublicaGL, A.TB_ConsultaPublicaCiudadano)  
  AND   A.TB_ConsultaPrivadaCiudadano   = COALESCE(@L_TB_@Consulta_PrivadaGL, A.TB_ConsultaPrivadaCiudadano)  
  ORDER BY A.TC_Descripcion;   
 END  
 ELSE IF @L_TF_Inicio_Vigencia Is Not Null AND @L_TF_Fin_Vigencia Is Null  
 BEGIN  
  SELECT  A.TC_CodContexto      AS Codigo,   
     A.TC_Descripcion      AS Descripcion,  
     A.TF_Inicio_Vigencia     AS FechaActivacion,   
     A.TF_Fin_Vigencia      AS FechaDesactivacion,  
     A.TC_Telefono       AS Telefono,  
     A.TC_Fax        AS Fax,   
     A.TC_Email        AS Email,  
     A.TB_EnvioEscrito_GL_AM     AS EnvioEscrito_GL_AM,  
     A.TB_EnvioDemandaDenuncia_GL_AM   AS EnvioDemandaDenuncia_GL_AM,  
     A.TB_ConsultaPublicaCiudadano   AS ConsultaPublicaCiudadano,  
     A.TB_ConsultaPrivadaCiudadano   AS ConsultaPrivadaCiudadano,  
     'Split'         AS Split,  
     B.TC_CodMateria       AS Codigo,  
     B.TC_Descripcion      AS Descripcion,  
     B.TF_Inicio_Vigencia     AS FechaActivacion,  
     B.TF_Fin_Vigencia      AS FechaDesactivacion,  
     'Split'         AS Split,  
     C.TC_CodOficina       AS Codigo,  
     C.TC_Nombre        AS Descripcion,  
     C.TF_Inicio_Vigencia     AS FechaActivacion,  
     C.TF_Fin_Vigencia      AS FechaDesactivacion,  
     C.TC_Domicilio       AS Domicilio,  
     C.TC_DescripcionAbreviada    AS DescripcionAbreviada,  
     'Split'         AS Split,   
     D.TN_CodTipoOficina      AS Codigo,   
     D.TC_Descripcion      AS Descripcion,   
     D.TF_Inicio_Vigencia     AS FechaActivacion,   
     D.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,   
     E.TN_CodCircuito      AS Codigo,   
     E.TC_Descripcion      AS Descripcion,   
     E.TF_Inicio_Vigencia     AS FechaActivacion,   
     E.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,  
     H.TC_CodOficina       AS CodigoDefensa,  
     H.TC_Nombre        AS DescripcionDefensa,  
     H.TC_CodCategoriaOficina    AS CategoriaDefensa,  
     H.TF_Inicio_Vigencia     AS FechaActivacionDefensa,  
     H.TF_Fin_Vigencia      AS FechaDesactivacionDefensa,   
     F.TC_CodContexto      AS CodigoOCJ,  
     F.TC_Descripcion      AS DescripcionOCJ,  
     F.TF_Inicio_Vigencia     AS FechaActivacionOCJ,  
     F.TF_Fin_Vigencia      AS FechaDesactivacionOCJ,  
     G.TC_CodOficina       AS CodigoOficinaOCJ,  
     G.TC_Nombre        AS DescripcionOficinaOCJ,  
     G.TF_Inicio_Vigencia     AS FechaActivacionOficinaOCJ,  
     G.TF_Fin_Vigencia      AS FechaDesactivacionOficinaOCJ,  
     I.TN_CodProvincia      AS CodigoProvincia,   
     I.TC_Descripcion      AS DescripcionProvincia,   
     I.TF_Inicio_Vigencia     AS FechaActivacionProvincia,   
     I.TF_Fin_Vigencia      AS FechaVencimientoProvincia,  
     C.TC_CodCategoriaOficina    AS CategoriaOficina  
  FROM  Catalogo.Contexto      A WITH(NOLOCK)   
  INNER JOIN Catalogo.Materia      B WITH(NOLOCK)  
  ON          B.TC_CodMateria       = A.TC_CodMateria  
  INNER JOIN Catalogo.Oficina      C WITH(NOLOCK)  
  ON          C.TC_CodOficina       = A.TC_CodOficina  
  INNER JOIN Catalogo.TipoOficina     D WITH(NOLOCK)   
  ON   D.TN_CodTipoOficina      = C.TN_CodTipoOficina  
  INNER JOIN Catalogo.Circuito      E WITH(NOLOCK)  
  ON   E.TN_CodCircuito      = C.TN_CodCircuito  
  LEFT JOIN Catalogo.Contexto      F WITH(NOLOCK)   
  ON   F.TC_CodContexto      = A.TC_CodContextoOCJ  
  LEFT JOIN Catalogo.Oficina      G WITH(NOLOCK)  
  ON   G.TC_CodOficina       = F.TC_CodOficina  
  LEFT JOIN Catalogo.Oficina      H WITH(NOLOCK)  
  ON   H.TC_CodOficina       = C.TC_CodOficinaDefensa  
  INNER JOIN Catalogo.Provincia      I WITH(NOLOCK)  
  ON   I.TN_CodProvincia      = E.TN_CodProvincia  
  WHERE  dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@L_TC_ExpresionLike , A.TC_Descripcion))  
  AND   (A.TF_Inicio_Vigencia     > GETDATE () Or A.TF_Fin_Vigencia < GETDATE ())  
  AND   A.TC_CodOficina       = COALESCE(@L_TC_CodOficina,A.TC_CodOficina)  
  AND   A.TC_CodOficina       = COALESCE(@L_TC_CodContexto,A.TC_CodContexto)  
  AND   C.TN_CodCircuito      = COALESCE(@CodCircuito,C.TN_CodCircuito)  
  AND   COALESCE(C.TC_CodCategoriaOficina, '') = COALESCE(@CodCategoriaOficina, C.TC_CodCategoriaOficina, '')  
  AND   A.TB_EnvioDemandaDenuncia_GL_AM   = COALESCE(@L_TB_@Envio_DemandaGL, A.TB_EnvioDemandaDenuncia_GL_AM)  
  AND   A.TB_EnvioEscrito_GL_AM     = COALESCE(@L_TB_@Envio_EscritoGL, A.TB_EnvioEscrito_GL_AM)  
  AND   A.TB_ConsultaPublicaCiudadano   = COALESCE(@L_TB_@Consulta_PublicaGL, A.TB_ConsultaPublicaCiudadano)  
  AND   A.TB_ConsultaPrivadaCiudadano   = COALESCE(@L_TB_@Consulta_PrivadaGL, A.TB_ConsultaPrivadaCiudadano)  
  ORDER BY A.TC_Descripcion;  
 END  
 ELSE IF @L_TF_Inicio_Vigencia Is Not Null AND @L_TF_Fin_Vigencia Is Not Null  
 BEGIN  
  SELECT  A.TC_CodContexto      AS Codigo,   
     A.TC_Descripcion      AS Descripcion,  
     A.TF_Inicio_Vigencia     AS FechaActivacion,   
     A.TF_Fin_Vigencia      AS FechaDesactivacion,  
     A.TC_Telefono       AS Telefono,  
     A.TC_Fax        AS Fax,   
     A.TC_Email        AS Email,  
     A.TB_EnvioEscrito_GL_AM     AS EnvioEscrito_GL_AM,  
     A.TB_EnvioDemandaDenuncia_GL_AM   AS EnvioDemandaDenuncia_GL_AM,  
     A.TB_ConsultaPublicaCiudadano   AS ConsultaPublicaCiudadano,  
     A.TB_ConsultaPrivadaCiudadano   AS ConsultaPrivadaCiudadano,  
     'Split'         AS Split,  
     B.TC_CodMateria       AS Codigo,  
     B.TC_Descripcion      AS Descripcion,  
     B.TF_Inicio_Vigencia     AS FechaActivacion,  
     B.TF_Fin_Vigencia      AS FechaDesactivacion,  
     'Split'         AS Split,  
     C.TC_CodOficina       AS Codigo,  
     C.TC_Nombre        AS Descripcion,  
     C.TF_Inicio_Vigencia     AS FechaActivacion,  
     C.TF_Fin_Vigencia      AS FechaDesactivacion,  
     C.TC_Domicilio       AS Domicilio,  
     C.TC_DescripcionAbreviada    AS DescripcionAbreviada,  
     'Split'         AS Split,   
     D.TN_CodTipoOficina      AS Codigo,   
     D.TC_Descripcion      AS Descripcion,   
     D.TF_Inicio_Vigencia     AS FechaActivacion,   
     D.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,   
     E.TN_CodCircuito      AS Codigo,   
     E.TC_Descripcion      AS Descripcion,   
     E.TF_Inicio_Vigencia     AS FechaActivacion,   
     E.TF_Fin_Vigencia      AS FechaVencimiento,  
     'Split'         AS Split,  
     H.TC_CodOficina       AS CodigoDefensa,  
     H.TC_Nombre        AS DescripcionDefensa,  
     H.TC_CodCategoriaOficina    AS CategoriaDefensa,  
     H.TF_Inicio_Vigencia     AS FechaActivacionDefensa,  
     H.TF_Fin_Vigencia      AS FechaDesactivacionDefensa,   
     F.TC_CodContexto      AS CodigoOCJ,  
     F.TC_Descripcion      AS DescripcionOCJ,  
     F.TF_Inicio_Vigencia     AS FechaActivacionOCJ,  
     F.TF_Fin_Vigencia      AS FechaDesactivacionOCJ,  
     G.TC_CodOficina       AS CodigoOficinaOCJ,  
     G.TC_Nombre        AS DescripcionOficinaOCJ,  
     G.TF_Inicio_Vigencia     AS FechaActivacionOficinaOCJ,  
     G.TF_Fin_Vigencia      AS FechaDesactivacionOficinaOCJ,  
     I.TN_CodProvincia      AS CodigoProvincia,   
     I.TC_Descripcion      AS DescripcionProvincia,   
     I.TF_Inicio_Vigencia     AS FechaActivacionProvincia,   
     I.TF_Fin_Vigencia      AS FechaVencimientoProvincia,  
     C.TC_CodCategoriaOficina    AS CategoriaOficina  
  FROM  Catalogo.Contexto      A WITH(NOLOCK)   
  INNER JOIN Catalogo.Materia      B WITH(NOLOCK)  
  ON          B.TC_CodMateria       = A.TC_CodMateria  
  INNER JOIN Catalogo.Oficina      C WITH(NOLOCK)  
  ON          C.TC_CodOficina       = A.TC_CodOficina  
  INNER JOIN Catalogo.TipoOficina     D WITH(NOLOCK)   
  ON   D.TN_CodTipoOficina      = C.TN_CodTipoOficina  
  INNER JOIN Catalogo.Circuito      E WITH(NOLOCK)  
  ON   E.TN_CodCircuito      = C.TN_CodCircuito  
  LEFT JOIN Catalogo.Contexto      F WITH(NOLOCK)   
  ON   F.TC_CodContexto      = A.TC_CodContextoOCJ  
  LEFT JOIN Catalogo.Oficina      G WITH(NOLOCK)  
  ON   G.TC_CodOficina       = F.TC_CodOficina  
  LEFT JOIN Catalogo.Oficina      H WITH(NOLOCK)  
  ON   H.TC_CodOficina       = C.TC_CodOficinaDefensa  
  INNER JOIN Catalogo.Provincia      I WITH(NOLOCK)  
  ON   I.TN_CodProvincia      = E.TN_CodProvincia  
  WHERE  dbo.FN_RemoverTildes(A.TC_Descripcion) LIKE dbo.FN_RemoverTildes(COALESCE(@L_TC_ExpresionLike , A.TC_Descripcion))  
  AND   A.TF_Inicio_Vigencia     >= @L_TF_Fin_Vigencia  
  AND   A.TF_Fin_Vigencia      <= @L_TF_Inicio_Vigencia  
  AND   A.TC_CodOficina       = COALESCE(@L_TC_CodOficina,A.TC_CodOficina)   
  AND   A.TC_CodContexto      = COALESCE(@L_TC_CodOficina,A.TC_CodContexto)   
  AND   C.TN_CodCircuito      = COALESCE(@CodCircuito,C.TN_CodCircuito)  
  AND   COALESCE(C.TC_CodCategoriaOficina, '') = COALESCE(@CodCategoriaOficina, C.TC_CodCategoriaOficina, '')  
  AND   A.TB_EnvioDemandaDenuncia_GL_AM   = COALESCE(@L_TB_@Envio_DemandaGL, A.TB_EnvioDemandaDenuncia_GL_AM)  
  AND   A.TB_EnvioEscrito_GL_AM     = COALESCE(@L_TB_@Envio_EscritoGL, A.TB_EnvioEscrito_GL_AM)  
  AND   A.TB_ConsultaPublicaCiudadano   = COALESCE(@L_TB_@Consulta_PublicaGL, A.TB_ConsultaPublicaCiudadano)  
  AND   A.TB_ConsultaPrivadaCiudadano   = COALESCE(@L_TB_@Consulta_PrivadaGL, A.TB_ConsultaPrivadaCiudadano)  
  ORDER BY A.TC_Descripcion;  
 END  
END  
GO
