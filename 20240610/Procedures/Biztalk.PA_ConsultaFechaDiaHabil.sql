SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<20/10/2017>
-- Descripción:				<Consulta la fecha del día hábil en que se puede enviar la comunicación sin tomar en cuenta los días festivos> 
-- Modificación:			<Olger Gamboa C> 04/06/2021 se agrega instrucció SET NOCOUNT ON;

-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultaFechaDiaHabil]
(	
	@FechaIntentoConfiguracion	Datetime,
	@CodigoOficina				varchar(4),
	@DiaInicio					int,
	@DiaFin						int,				
	@HoraInicio					time(7),		
	@HoraFin					time(7)	
)
AS
BEGIN
SET NOCOUNT ON;
	Declare	@FechaInicio				Date,
			@FechaFin					Date,		
			@numeroDiaRecibido			int,
			@FechaIntento				DateTime

	--FechaInicio es la fecha del intento según la configuración y FechaFin es la actual mas 1 mes
	Select	@FechaInicio	=	@FechaIntentoConfiguracion,
			@FechaFin		=	DATEADD(MONTH, 1, @FechaInicio)

	Declare	@DiasFestivos	Table
		(
			FechaFestivo Date
		)

	--Se consultan los dias festivos
	Insert	Into @DiasFestivos(FechaFestivo)
	Select	A.TF_FechaFestivo	As FechaFestivo
	From	Agenda.DiaFestivo					A	WITH(NOLOCK)
	Join	Agenda.DiaFestivoCircuito			B	WITH(NOLOCK)
	On		A.TF_FechaFestivo			=		B.TF_FechaFestivo
	Join	Catalogo.Oficina					C	WITH(NOLOCK)
	On		C.TN_CodCircuito			=		B.TN_CodCircuito
	Where	C.TC_CodOficina				=		@CodigoOficina
	And		A.TF_FechaFestivo >= @FechaInicio
	And		A.TF_FechaFestivo <= @FechaFin

	If	Exists(Select	FechaFestivo	From	@DiasFestivos	Where	FechaFestivo	=	@FechaInicio)
	Begin
		While(Exists(Select	FechaFestivo	From	@DiasFestivos	Where	FechaFestivo	=	@FechaInicio))
		Begin	
			If(@DiaInicio < @DiaFin)
			Begin
			
				While(1=1)
				Begin
					Select @FechaInicio = DATEADD(DAY,  1, @FechaInicio)
					SET @numeroDiaRecibido  = ((DATEPART(weekday, @FechaInicio) + @@DATEFIRST - 2) % 7 + 1)
			
					If(@numeroDiaRecibido >= @DiaInicio And @numeroDiaRecibido <= @DiaFin)
					Begin
						Select @FechaInicio = DATEFROMPARTS(datepart(YEAR, @FechaInicio), datepart(MONTH, @FechaInicio), datepart(DAY, @FechaInicio))
						Break
					End
				End		
			End
		End	
	
		Select	@FechaIntento	=	DATETIMEFROMPARTS(datepart(YEAR, @FechaInicio), datepart(MONTH, @FechaInicio), datepart(DAY, @FechaInicio), datepart(HOUR, @HoraInicio), datepart(MINUTE, @HoraInicio), 0, 0)
	
	End
	Else
	Begin
		Select	@FechaIntento	=	@FechaIntentoConfiguracion
	End


	Select		@FechaIntento As FechaHoraIntento,	@HoraFin	As	HoraLimite
	
END

GO
