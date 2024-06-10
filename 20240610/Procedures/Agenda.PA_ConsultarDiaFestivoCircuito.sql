SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<18/11/2016>
-- Descripción:				<Permite consultar registros de Agenda.DiaFestivoCircuito.> 
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarDiaFestivoCircuito]
	@FechaFestivo		datetime2		= Null,
	@CodCircuito		smallint		= Null,
	@FechaActivaciOn	Datetime2		= Null --Línea agregada por Babel
 As
 Begin
	Select		B.TN_CodCircuito				As Codigo,
				B.TC_Descripcion				As Descripcion,
				A.TF_Inicio_Vigencia			As FechaAsociacion, 
				'Split'							As Split,
				C.TF_FechaFestivo				As FechaFestivo,
				C.TC_Descripcion				As Descripcion
	From		Agenda.DiaFestivoCircuito		A With(NoLock)
	Inner Join	Catalogo.Circuito				B With(NoLock)
	On			B.TN_CodCircuito				= A.TN_CodCircuito
	Inner Join	Agenda.DiaFestivo				C With(NoLock)
	On			C.TF_FechaFestivo				= A.TF_FechaFestivo
	Where		A.TF_FechaFestivo				= COALESCE(@FechaFestivo, A.TF_FechaFestivo)
	And			A.TN_CodCircuito				= COALESCE(@CodCircuito, A.TN_CodCircuito) 
	And			(A.TF_Inicio_Vigencia	<= @FechaActivaciOn Or @FechaActivaciOn Is Null) --Línea agregada por Babel
	Order By	B.TC_Descripcion, C.TF_FechaFestivo;
 End


GO
