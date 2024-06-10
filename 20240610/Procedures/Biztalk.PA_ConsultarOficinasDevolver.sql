SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<12/09/2017>
-- Descripción:				<Consulta los datos de las oficinas judiciales que tengan comunicaciones que se deben devolver> 
-- Modificación:            <Tatiana Flores><21/08/2018> Se utiliza la tabla Contexto en lugar de la tabla Oficina
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarOficinasDevolver]
AS
BEGIN

	Select	O.TC_CodOficina		As CodigoOficina,		O.TC_Nombre		As	NombreOficina,	CO.TC_Email	As EmailOficina
	From	Catalogo.Oficina			O	WITH(NOLOCK)
	Join	[Catalogo].[Contexto]		CO WITH(NOLOCK)
	ON		CO.TC_CodOficina			= O.TC_CodOficina
	Join	Comunicacion.Comunicacion	C	WITH(NOLOCK)
	On		C.TC_CodContexto			=	CO.TC_CodContexto
	Where	C.TC_Estado					=	'I'
	And		C.TC_Resultado				Is Not Null

END


GO
