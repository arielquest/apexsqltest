SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<02/12/2020>
-- Descripción:				<Consulta los sectores para la sincronización en la aplicación móvil>
-- Modificación				<09/08/2021><Cristian Cerdas C.><Se ingresa en el where para que obtenga solo los sectores que utilizan app móvil>
-- ===========================================================================================
CREATE   PROCEDURE [Biztalk].[PA_ConsultaSectorAppMovil]
(	
	@CodOficina VARCHAR(4)
)
AS
BEGIN

	DECLARE	@TempCodOficina				VARCHAR(4)
    SET @TempCodOficina = REPLICATE ('0', 4-len( @CodOficina)) + cast( @CodOficina as varchar)	  

	SELECT  REPLICATE ('0', 4-len( s.TN_CodSector)) + cast( s.TN_CodSector as varchar) Codigo, 
		        s.TC_Descripcion as Descripcion
	FROM [Comunicacion].[Sector] AS s WITH(NOLOCK)
	WHERE TC_CodOficinaOCJ = @TempCodOficina
	AND	TF_Inicio_Vigencia		<=	GETDATE ()
	AND	(TF_Fin_Vigencia		Is	Null OR TF_Fin_Vigencia  >= GETDATE ()) 
	AND TB_UtilizaAppMovil = 1	

END

GO
