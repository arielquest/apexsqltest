SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<27/10/2015>
-- Descripción :			<Permite consultar el último cierres estadisticos realizado en la oficina.> 
-- Modificado:				<01/03/2021><Se modifica el parametro de entrada del sp, para que sea CodContexto>/

-- Creado por:				<Olger Gamboa Castillo>
-- Modificado:				<11/05/2021>
-- Descripción :			<Se debe validar por contexto de la oficina para extraer el cierre estadístico de la oficina, se debe analizar más el tema
-- para validar que efectivamente la configuración es por oficina ya que en este caso el cierre de la oficina le aplicaría a todos los contextos>/
-- =================================================================================================================================================
CREATE PROCEDURE [Sistema].[PA_ObtenerUltimoCierreEstadistico]
	@CodContexto Varchar(4)=Null
As
Begin
    DECLARE	@L_CodContexto		Varchar(4)	=	@CodContexto

	Select	A.TN_Mes as Mes,			A.TN_Anno as Annio,				A.TF_Fecha_Cierre as FechaCierre, 'Split' as Split,
			B.TC_CodOficina as Codigo,	B.TC_Nombre as Descripcion
	From	Sistema.CierreEstadistico A  WITH(NOLOCK)
	Inner Join	Catalogo.Oficina B  WITH(NOLOCK) On	a.TC_CodOficina = b.TC_CodOficina
	Inner join Catalogo.Contexto c on c.TC_CodOficina= b.TC_CodOficina
	Where	TF_Fecha_Cierre = (	Select	Max(TF_Fecha_Cierre)
								From	Sistema.CierreEstadistico 
								Where	TC_CodOficina = b.TC_CodOficina)
	and c.TC_CodContexto=@L_CodContexto
End
GO
