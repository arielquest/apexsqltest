SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<11/08/2015>
-- Descripción :			<Permite Consultar una Fase> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Incluir fecha de activación para realizar la consulta de activos.>
-- Modificado por:			<Alejandro Villalta><07/01/2016><Modificar el tipo de dato del codigo de fase.>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFase]
	@Codigo smallint				= Null,
	@Descripcion varchar(255)		= Null,
	@FechaActivacion datetime2(3)	= Null,
	@FechaDesactivacion datetime2(3)= Null
 As
Begin
	--Variable para almacenar la descripcion 
	DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%',null)
	
	--Activos e inactivos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
				
			Select		TN_CodFase			As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion

			From		Catalogo.Fase With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			TN_CodFase	=		COALESCE(@Codigo,TN_CodFase)
			Order By	TC_Descripcion;
	End
	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodFase			As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Fase
			Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			TN_CodFase		=			COALESCE(@Codigo,TN_CodFase)
			And			TF_Inicio_Vigencia  <		GETDATE ()
			And			(TF_Fin_Vigencia	Is		Null 
			OR			TF_Fin_Vigencia		>=		GETDATE ())
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		TN_CodFase			As	Codigo,				TC_Descripcion	As	Descripcion,
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.Fase
		Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			TN_CodFase			=		COALESCE(@Codigo,TN_CodFase)
	    And			(TF_Inicio_Vigencia >		GETDATE () 
		Or			TF_Fin_Vigencia		<		GETDATE ())
		Order By	TC_Descripcion;
	End

	--Por rango
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		TN_CodFase			As	Codigo,				TC_Descripcion	As	Descripcion,
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.Fase
		Where		dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		and			TN_CodFase			=		COALESCE(@Codigo,TN_CodFase)
		And			(TF_Fin_Vigencia	<=		@FechaDesactivacion 
		and			TF_Inicio_Vigencia	>=		@FechaActivacion) 
		Order By	TC_Descripcion;
	End

end



GO
