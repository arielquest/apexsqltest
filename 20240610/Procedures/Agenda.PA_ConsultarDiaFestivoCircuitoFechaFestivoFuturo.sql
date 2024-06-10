SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<16/12/2016>
-- Descripción:				<Permite consultar registros de Agenda.DiaFestivoCircuito dependiendo de la fecha del día festivo y los futuros  > 
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarDiaFestivoCircuitoFechaFestivoFuturo]
	@FechaFestivo		datetime2		= NULL,
	@CodCircuito		smallint		= NULL
 As
 Begin
	Declare @L_FechaFestivo		datetime2		 =  Convert(date, @FechaFestivo),
			@L_CodCircuito		smallint		 =  @CodCircuito

	Select		B.TN_CodCircuito				 As Codigo,
				B.TC_Descripcion				 As Descripcion,
				A.TF_Inicio_Vigencia			 As FechaAsociacion, 
				'Split'							 As Split,
				C.TF_FechaFestivo				 As FechaFestivo,
				C.TC_Descripcion				 As Descripcion
	From		Agenda.DiaFestivoCircuito		 A With(NoLock)
	Inner Join	Catalogo.Circuito				 B With(NoLock)
	On			B.TN_CodCircuito				 = A.TN_CodCircuito
	Inner Join	Agenda.DiaFestivo				 C With(NoLock)
	On			C.TF_FechaFestivo				 = A.TF_FechaFestivo
	Where		Convert(date, C.TF_FechaFestivo) >= @L_FechaFestivo		 
	And			A.TN_CodCircuito				 = @L_CodCircuito
	Order By	B.TC_Descripcion, C.TF_FechaFestivo;
 End
GO
