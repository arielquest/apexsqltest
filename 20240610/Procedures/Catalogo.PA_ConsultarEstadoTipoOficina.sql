SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:    <1.0>  
-- Creado por:   <Johan Acosta Ibañez>  
-- Fecha de creación: <26/08/2015>  
-- Descripción :  <Permite Consultar los estados que tiene un tipo de oficina.   
-- =================================================================================================================================================  
-- Modificación:  <03-9-2015> <Pablo Alvarez Espinoza> <Se modifica entidad intermedia por herencia>  
-- Modificacion:  <03-12-2015> <Pablo Alvarez Espinoza> <Se agrega la columna por defecto>  
-- Modificado :   <17/12/2015> <Olger Gamboa Castillo> <Se modifica el tipo de dato del codigo de estado a smallint.>   
-- Modificado:          <06/01/2015> <Pablo Alvarez Espinoza> <Se cambia la llave a smallint squence>  
-- Modificación:  <08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>  
-- Modificación:  <30/08/2017> <Jeffry Hernández> <Se agregan los datos de la tabla materia a la consulta.>  
-- Modificación:  <04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>  
-- Modificación:  <10/05/2018> <Andrés Díaz> <Se modifica la consulta para que se pueda cargar los datos por paginación.>  
-- Modificación:  <26/02/2019> <Isaac Dobles> <Se modifica la consulta para ajustarse a tabla EstadoTipoOficina.>  
-- Modificación:  <13/06/2019> <Isaac Dobles> <Se agrega los parámetros para indicar si el estado es para un legajo/expediente y el estado en el circulante.>  
-- Modificación:  <29/07/2019> <Isaac Dobles> <Se agrega el parámetro PASIVO para la consulta.>  
-- Modificación:  <02/02/2020> <Xinia Soto V> <Se agrega filtro de estado vigente.>  
-- Modificación:  <26/03/2021> <Ronny Ramírez R.> <Se agrega valor del campo TC_Circulante del Estado>  
-- Modificación:  <04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- Modificación:  <07/07/2021> <Roger Lara> <Se agrega validacion para considerar los estados que pertenecen a expediente y legajos sumultaneamente 'A'=Ambos>  
-- =================================================================================================================================================  
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoTipoOficina]  
 @CodTipoOficina		smallint	= Null,  
 @CodEstado				int			= Null,  
 @FechaAsociacion		datetime2	= Null,  
 @IniciaTramitacion		bit			= Null,  
 @CodMateria			varchar(5)  = Null,  
 @IndicePagina			smallint	= Null,  
 @CantidadPagina		smallint	= Null,  
 @CierreAcumulacion		bit			= Null,  
 @Circulante			char(1)		= Null,  
 @ExpedienteLegajo		char(1)		= Null,  
 @Pasivo				char(1)		= Null  
As  
Begin  
  
 If (@IndicePagina Is Null Or @CantidadPagina Is Null)  
 Begin  
  SET @IndicePagina = 0;  
  SET @CantidadPagina = 32767;  
 End  
 


 SELECT	A.TF_Inicio_Vigencia	AS FechaAsociacion,       
		B.TN_CodEstado			AS Codigo,   
		B.TC_Descripcion		AS Descripcion,   
		B.TF_Inicio_Vigencia	AS FechaActivacion,   
		B.TF_Fin_Vigencia		AS FechaDesactivacion,  
		A.TB_IniciaTramitacion  AS IniciaTramitacion,  
		A.TB_CierreAcumulacion  AS CierreAcumulacion,  
		'Split'					AS Split,  
		C.TN_CodTipoOficina		AS Codigo,   
		C.TC_Descripcion		AS Descripcion,   
		C.TF_Inicio_Vigencia	AS FechaActivacion,   
		C.TF_Fin_Vigencia		AS FechaDesactivacion,  
		'Split'					AS Split,  
		D.TC_CodMateria			AS Codigo,      
		D.TC_Descripcion		AS Descripcion,  
		D.TB_EjecutaRemate		AS EjecutaRemate,  
		D.TF_Inicio_Vigencia	AS FechaActivacion,   
		D.TF_Fin_Vigencia		AS FechaDesactivacion,  
		'Split'					AS Split,  
		B.TC_Circulante			AS Circulante,
		COUNT(*) OVER()			AS Total  
   
 FROM		Catalogo.EstadoTipoOficina  AS A WITH (Nolock)   
 INNER JOIN	Catalogo.Estado				AS B WITH (Nolock)  
 ON			B.TN_CodEstado				= A.TN_CodEstado   
 INNER JOIN Catalogo.TipoOficina		AS C WITH (Nolock)  
 ON			C.TN_CodTipoOficina			= A.TN_CodTipoOficina  
 INNER JOIN Catalogo.Materia			AS D WITH (Nolock)  
 ON			D.TC_CodMateria				= A.TC_CodMateria   
  
 WHERE  A.TN_CodTipoOficina				= COALESCE(@CodTipoOficina, A.TN_CodTipoOficina)   
 AND   A.TN_CodEstado					= COALESCE(@CodEstado, A.TN_CodEstado)  
 AND   D.TC_CodMateria					= COALESCE(@CodMateria, D.TC_CodMateria)  
 AND   A.TF_Inicio_Vigencia				<= CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END  
 AND   A.TB_IniciaTramitacion			= COALESCE(@IniciaTramitacion, A.TB_IniciaTramitacion)  
 AND   A.TB_CierreAcumulacion			= COALESCE(@CierreAcumulacion, A.TB_CierreAcumulacion)  
 AND   B.TC_Circulante					= COALESCE(@Circulante, B.TC_Circulante)  

 AND   (B.TC_ExpedienteLegajo			= COALESCE(@ExpedienteLegajo, B.TC_ExpedienteLegajo)  OR 

		--B.TC_ExpedienteLegajo			= CASE WHEN @ExpedienteLegajo IS NULL THEN B.TC_ExpedienteLegajo ELSE'A' END   )
		B.TC_ExpedienteLegajo			= CASE WHEN @ExpedienteLegajo IS NOT NULL THEN 'A' END   )

 AND   COALESCE(B.TC_Pasivo,'')			= COALESCE(@Pasivo, B.TC_Pasivo,'')  
 AND   B.TF_Inicio_Vigencia				<= GETDATE() 
 AND   (
			B.TF_Fin_Vigencia			>= GETDATE() 
			OR 
			B.TF_Fin_Vigencia is null
		)
  
 ORDER BY B.TC_Descripcion, C.TC_Descripcion  
 Offset  @IndicePagina * @CantidadPagina Rows  
 Fetch Next @CantidadPagina Rows Only;  
  
End  
GO
