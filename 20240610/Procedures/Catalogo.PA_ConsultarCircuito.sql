SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Olger Ariel Gamboa C>
-- Fecha de creación:		<11/08/2015>
-- Descripción :			<Permite Consultar un circuito> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<13/10/2015>
-- Descripción :			<Se modifica para eliminar el filtro por fecha de activación> 

-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Se agrega el filtro por fecha de activación para consultar los activos> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:			<Andrés Díaz> <28/10/2016> <Se agrega el código de provincia.>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- Modificación				<Johan Acosta><24/08/2018> <Se agrega el código de provincia. en los where>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarCircuito]
	@Codigo					smallint		= Null,
	@Descripcion			varchar(255)	= Null,
	@CodProvincia			smallint		= Null,
	@FechaDesactivacion		datetime2		= Null,
	@FechaActivacion		datetime2		= Null
As
BEGIN
	DECLARE @ExpresionLike varchar(270)
	Set @ExpresionLike = iif(@Descripcion is not null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion Is Null
	begin
			Select		A.TN_CodCircuito		As Codigo,				
						A.TC_Descripcion		As Descripcion,
						A.TF_Inicio_Vigencia	As FechaActivacion,	
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'Split'					As Split,
						A.TN_CodProvincia		As Codigo,
						B.TC_Descripcion		As Descripcion
			From		Catalogo.Circuito		A With(Nolock)
			Inner Join	Catalogo.Provincia		B With(NoLock)
			On			B.TN_CodProvincia		= A.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And         A.TN_CodCircuito        = Coalesce(@Codigo, A.TN_CodCircuito)
			And         A.TN_CodProvincia       = Coalesce(@CodProvincia, A.TN_CodProvincia)
			Order By	A.TC_Descripcion;
	end
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null 
	begin
			Select		A.TN_CodCircuito		As Codigo,				
						A.TC_Descripcion		As Descripcion,
						A.TF_Inicio_Vigencia	As FechaActivacion,	
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'Split'					As Split,
						A.TN_CodProvincia		As Codigo,
						B.TC_Descripcion		As Descripcion
			From		Catalogo.Circuito		A With(Nolock)
			Inner Join	Catalogo.Provincia		B With(NoLock)
			On			B.TN_CodProvincia		= A.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And         A.TN_CodCircuito        = Coalesce(@Codigo, A.TN_CodCircuito)
			And         A.TN_CodProvincia       = Coalesce(@CodProvincia, A.TN_CodProvincia)
			And			A.TF_Inicio_Vigencia	<=		GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	end
	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
	begin
			Select		A.TN_CodCircuito		As Codigo,				
						A.TC_Descripcion		As Descripcion,
						A.TF_Inicio_Vigencia	As FechaActivacion,	
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'Split'					As Split,
						A.TN_CodProvincia		As Codigo,
						B.TC_Descripcion		As Descripcion
			From		Catalogo.Circuito		A With(Nolock)
			Inner Join	Catalogo.Provincia		B With(NoLock)
			On			B.TN_CodProvincia		= A.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And         A.TN_CodCircuito        = Coalesce(@Codigo, A.TN_CodCircuito)
			And         A.TN_CodProvincia       = Coalesce(@CodProvincia, A.TN_CodProvincia)
			And			(A.TF_Inicio_Vigencia	> GETDATE () 
			Or			A.TF_Fin_Vigencia		< GETDATE ())
			Order By	A.TC_Descripcion;
	end
	Else
	--Por rango de fechas
	  If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	begin
			Select		A.TN_CodCircuito		As Codigo,				
						A.TC_Descripcion		As Descripcion,
						A.TF_Inicio_Vigencia	As FechaActivacion,	
						A.TF_Fin_Vigencia		As FechaDesactivacion,
						'Split'					As Split,
						A.TN_CodProvincia		As Codigo,
						B.TC_Descripcion		As Descripcion
			From		Catalogo.Circuito		A With(Nolock)
			Inner Join	Catalogo.Provincia		B With(NoLock)
			On			B.TN_CodProvincia		= A.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And         A.TN_CodCircuito        = Coalesce(@Codigo, A.TN_CodCircuito)
			And         A.TN_CodProvincia       = Coalesce(@CodProvincia, A.TN_CodProvincia)
			And			(A.TF_Inicio_Vigencia	>= @FechaActivacion
			And			A.TF_Fin_Vigencia		<= @FechaDesactivacion)
			Order By	A.TC_Descripcion;
	end
	
END




GO
