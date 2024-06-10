SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ailyn López> 
-- Fecha de creación:		<01/05/2018>
-- Descripción:				<Se consultan todas las configuraciones>
-- ===========================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarConfiguracion]
AS
BEGIN
	Select 
				C.TC_CodConfiguracion	                  As Codigo,					C.TC_Nombre    				    As Nombre,
				C.TC_Descripcion                          As Descripcion,				C.TB_EsValorGeneral		        As EsValorGeneral,		
				C.TB_EsMultiple							  As EsMultiple,				C.TC_NombreEstructura           As NombreEstructura,				
				C.TC_CampoIdentificador					  As CampoIdentificador,		C.TC_CampoMostrar				As CampoMostrar,				
				'SplitTipo'								  As SplitTipo,				    C.TC_TipoConfiguracion			As TipoConfiguracion
		
	From		Configuracion.Configuracion C WITH(NOLOCK)
	order by    (Nombre) Asc
END
GO
