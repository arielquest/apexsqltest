SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<12/09/2017>
-- Descripción:				<Devuelve los días festivos de una oficina en un rango de tres meses a partir de la fecha en que se genera la consulta> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarDiasFestivos]
(
	@CodigoOficina varchar(4)
)
AS
BEGIN

	Declare	@FechaInicio	Date,
			@FechaFin		Date		
	
	--FechaInicio es la actual y FechaFin es la actual mas 3 meses 
	Select	@FechaInicio	=	GetDate(),
			@FechaFin		=	DATEADD(MONTH, 3, @FechaInicio)
	
	Select	A.TF_FechaFestivo	As FechaFestivo,	A.TC_Descripcion As Descripcion
	From	Agenda.DiaFestivo					A	WITH(NOLOCK)
	Join	Agenda.DiaFestivoCircuito			B	WITH(NOLOCK)
	On		A.TF_FechaFestivo			=		B.TF_FechaFestivo
	Join	Catalogo.Oficina					C	WITH(NOLOCK)
	On		C.TN_CodCircuito			=		B.TN_CodCircuito
	Where	C.TC_CodOficina				=		@CodigoOficina
	And		A.TF_FechaFestivo >= @FechaInicio
	And		A.TF_FechaFestivo <= @FechaFin

END
GO
