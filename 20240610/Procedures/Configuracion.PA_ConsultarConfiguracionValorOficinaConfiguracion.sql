SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ailyn López> 
-- Fecha de creación:		<02/05/2018>
-- Descripción:				<Consulta los valores vigentes de la configuración y oficina especificada>
 -- Modificación:            <Tatiana Flores><17/08/2018> Se agrega relación a tabla Contexto y de ahí se toman los datos de la oficina
-- ===========================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarConfiguracionValorOficinaConfiguracion]
( 
  @CodContexto		        Varchar(4),
  @CodConfiguracion		    Varchar(27)
)
AS
BEGIN

	SELECT 
					CV.TU_Codigo						As Codigo,						
					CV.TF_FechaCreacion					As FechaCreacion,				CV.TF_FechaActivacion					As FechaActivacion,	
					CV.TF_FechaCaducidad				As FechaCaducidad,				CV.TC_Valor								As Valor,
					'SplitOficina'						As SplitOficina,			    CO.TC_CodOficina						AS Codigo,
					'SplitConfiguracion'				As SplitConfiguracion,  		CV.TC_CodConfiguracion					AS Codigo,
					'SplitMateria'						As SplitMateria,				CO.TC_CodMateria						AS Codigo,
					'SplitContexto'						As SplitContexto,				CO.TC_CodContexto						AS Codigo
					
	FROM			Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
    INNER JOIN		Catalogo.Contexto			        CO  WITH(NOLOCK)
	on				CO.TC_CodContexto			=		CV.TC_CodContexto
	WHERE			CV.TC_CodContexto			=		@CodContexto  and
					CV.TC_CodConfiguracion		=		@CodConfiguracion and
					 Getdate()					>=		CV.TF_FechaActivacion and
					(Getdate()					<=		CV.TF_FechaCaducidad or 
					TF_FechaCaducidad			is		NULL)

END
GO
