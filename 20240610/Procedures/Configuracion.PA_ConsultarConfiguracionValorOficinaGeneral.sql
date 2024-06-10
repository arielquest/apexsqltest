SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

 --===========================================================================================
 --Versión:					<1.0>
 --Creado por:				<Ailyn López> 
 --Fecha de creación:		<02/05/2018>
 --Descripción:				<Consulta los valores de configuraciones generales y también de no generales que pertenezcan a la oficina especificada>
 --Modifiación:				<Jeffry Hernández> <17/07/2018> <Se separa la consulta en dos para evitar el operador or en el where y utilizar índices al realizarse la búsqueda.
--							 Se crea la variable @FechaActual>
 -- Modificación:           <Tatiana Flores> <17/08/2018> Se agrega relación a tabla Contexto y de ahí se toman los datos de la oficina
 --===========================================================================================
CREATE PROCEDURE [Configuracion].[PA_ConsultarConfiguracionValorOficinaGeneral]
(
	 @CodContexto		Varchar(4)
)
AS
BEGIN

	DECLARE @FechaActual DATETIME2 = Getdate()	

	SELECT 
					CV.TU_Codigo						As Codigo,						
					CV.TF_FechaCreacion					As FechaCreacion,				CV.TF_FechaActivacion			As FechaActivacion,
					CV.TF_FechaCaducidad				As FechaCaducidad,				CV.TC_Valor						As Valor,
					'SplitOficina'						As SplitOficina,			    CO.TC_CodOficina				AS Codigo,
					'SplitConfiguracion'				As SplitConfiguracion,  		C.TC_CodConfiguracion			AS Codigo,
					'SplitMateria'						As SplitMateria,				CO.TC_CodMateria				AS Codigo,
					'SplitContexto'						As SplitContexto,				CO.TC_CodContexto				AS Codigo	
						
	FROM			Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
	INNER JOIN		Configuracion.Configuracion			C  WITH(NOLOCK)
	on				C.TC_CodConfiguracion		=		CV.TC_CodConfiguracion
	INNER JOIN		Catalogo.Contexto			        CO  WITH(NOLOCK)
	on				CO.TC_CodContexto			=		CV.TC_CodContexto

	WHERE			CV.TC_CodContexto		    =		@CodContexto 	  
	AND				@FechaActual				>=		CV.TF_FechaActivacion 
	AND				(TF_FechaCaducidad			is		NULL 
	OR				@FechaActual				<=		CV.TF_FechaCaducidad)

	UNION ALL

	SELECT 
					CV.TU_Codigo						As Codigo,						
					CV.TF_FechaCreacion					As FechaCreacion,				CV.TF_FechaActivacion			As FechaActivacion,
					CV.TF_FechaCaducidad				As FechaCaducidad,				CV.TC_Valor						As Valor,
					'SplitOficina'						As SplitOficina,			    CO.TC_CodOficina				AS Codigo,
					'SplitConfiguracion'				As SplitConfiguracion,  		C.TC_CodConfiguracion			AS Codigo,
					'SplitMateria'						As SplitMateria,				CO.TC_CodMateria				AS Codigo,
					'SplitContexto'						As SplitContexto,				CO.TC_CodContexto				AS Codigo	
						
	FROM			Configuracion.ConfiguracionValor	CV WITH(NOLOCK)
	INNER JOIN		Configuracion.Configuracion			C  WITH(NOLOCK)
	on				C.TC_CodConfiguracion		=		CV.TC_CodConfiguracion
	INNER JOIN		Catalogo.Contexto			        CO  WITH(NOLOCK)
	on				CO.TC_CodContexto			=		CV.TC_CodContexto
	WHERE			C.TB_EsValorGeneral			=		1  
	AND				@FechaActual				>=		CV.TF_FechaActivacion 
	AND				(TF_FechaCaducidad			is		NULL 
	OR				@FechaActual				<=		CV.TF_FechaCaducidad)
END
GO
