SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Permite consultar registros de Agenda.DiaFestivo.> 
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarDiaFestivo]
	@FechaFestivo		datetime2		= Null,
	@Descripcion		varchar(250)	= Null
 As
 Begin
	Declare @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	Select		A.TF_FechaFestivo			As FechaFestivo,
				A.TC_Descripcion			As Descripcion
	From		Agenda.DiaFestivo			A With(NoLock)
	Where		A.TF_FechaFestivo			= COALESCE(@FechaFestivo, A.TF_FechaFestivo)
	And			A.TC_Descripcion			Like @ExpresionLike 
	Order By	A.TC_Descripcion;
 End


GO
