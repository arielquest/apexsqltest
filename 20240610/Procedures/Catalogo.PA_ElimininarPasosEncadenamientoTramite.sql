SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================================
-- Autor:            <Rafa Badilla A.> 
-- Fecha Creación:   <2022/junio/20>
-- Descripcion:      <Elimina el paso de un encadenamiento de trámites>
-- =========================================================================================================================================
-- Modificacion:     <22/07/2022><Jose Gabriel Cordero Soto><Se actualiza metodo de eliminacion en pasos del encadenamiento>
-- =========================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ElimininarPasosEncadenamientoTramite] 
	@CodEncadenamiento	UNIQUEIDENTIFIER
AS
BEGIN
	--Variables locales
	DECLARE @L_CodEncadenamiento	UNIQUEIDENTIFIER			= @CodEncadenamiento

	--Aplicación de eliminaciónde los parámetros relacionados a algún paso	
	--Si existen registros de parametros asociados el codigo del encadenamiento se eliminar
	IF(EXISTS ( SELECT      B.*
				FROM 		Catalogo.EncadenamientoTramitePaso			A WITH(NOLOCK)
				INNER JOIN  Catalogo.EncadenamientoTramitePasoParametro B WITH(NOLOCK)
				ON			B.TU_CodEncadenamientoTramitePaso			= A.TU_CodEncadenamientoTramitePaso 
				WHERE		A.TU_CodEncadenamientoTramite				= @L_CodEncadenamiento))
	BEGIN
				DELETE 
				FROM		Catalogo.EncadenamientoTramitePasoParametro WITH(ROWLOCK) 
				WHERE	    TU_CodEncadenamientoTramitePaso in ( SELECT TU_CodEncadenamientoTramitePaso 
																 FROM   Catalogo.EncadenamientoTramitePaso WITH(NOLOCK)
																 WHERE  TU_CodEncadenamientoTramite = @L_CodEncadenamiento )	
	END

	--Aplicación de eliminación de los pasos relacionados a un encadenamiento trámite
	DELETE	
	FROM	Catalogo.EncadenamientoTramitePaso WITH(ROWLOCK) 
	WHERE	TU_CodEncadenamientoTramite = @L_CodEncadenamiento 
END
GO
