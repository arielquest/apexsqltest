SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

/*
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<02/09/2015>
-- Descripción :			<Permite Consultar Canton> 
-- Modificacion:			<Gerardo Lopez> <22/10/2015> <Incluir fecha de activación para realizar la consulta de activos.>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:            <03/05/2017> <Diego GB>  <Se elimina la codicion que evalua las llaves ya que el primer if la incluye solamente se agrego el codigo de canton 
--                                                      para que la busqueda por codigo se realizara correctamente>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================

 */ 
CREATE PROCEDURE [Catalogo].[PA_ConsultarCanton]
 @CodigoProvincia smallint=Null,
 @CodigoCanton smallint=Null,
 @Descripcion Varchar(150)=Null,
 @FechaActivacion datetime2(3)	= Null,
 @FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

   --Si todo es nulo se devuelven todos los registros
	If  @FechaDesactivacion Is Null And @FechaActivacion Is Null
	Begin
			Select	
						A.TN_CodCanton	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split' as Split_Provincia,
						B.TN_CodProvincia		As	Codigo,			B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Canton AS A With(Nolock) 	
			INNER JOIN	Catalogo.Provincia AS B With(Nolock) 	
			ON			B.TN_CodProvincia = A.TN_CodProvincia 
			Where	    dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia	=	ISNULL(@CodigoProvincia,	A.TN_CodProvincia) 
			And			A.TN_CodCanton    	=	ISNULL(@CodigoCanton,	A.TN_CodCanton) 
			Order By	A.TC_Descripcion;
	End
	 
	--Por activos y filtro por descripcion
	Else If  @FechaDesactivacion Is Null And   @FechaActivacion Is Not Null
	Begin
			Select	
						A.TN_CodCanton	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split' as Split_Provincia,
						B.TN_CodProvincia		As	Codigo,			B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Canton AS A With(Nolock) 	
			INNER JOIN	Catalogo.Provincia AS B With(Nolock) 	
			ON			B.TN_CodProvincia = A.TN_CodProvincia 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			            And     A.TN_CodProvincia = IsNull(@CodigoProvincia, A.TN_CodProvincia)
						And	    A.TN_CodCanton    =	ISNULL(@CodigoCanton,	A.TN_CodCanton) 
						And		A.TF_Inicio_Vigencia < GETDATE ()
						And	   (A.TF_Fin_Vigencia	 Is Null  OR	A.TF_Fin_Vigencia >= GETDATE ())
			Order By	A.TC_Descripcion;
	End
		--Por inactivos y filtro por descripcion 
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
			Select	
						A.TN_CodCanton	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split' as Split_Provincia,
						B.TN_CodProvincia		As	Codigo,			B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Canton AS A With(Nolock) 	
			INNER JOIN	Catalogo.Provincia AS B With(Nolock) 	
			ON			B.TN_CodProvincia = A.TN_CodProvincia 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia = IsNull(@CodigoProvincia, A.TN_CodProvincia)
		    And	        A.TN_CodCanton    =	ISNULL(@CodigoCanton,	A.TN_CodCanton) 
			And			(A.TF_Inicio_Vigencia  > GETDATE ()  OR A.TF_Fin_Vigencia  < GETDATE ())
			Order By	A.TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	 Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null	
		Begin
			Select	
						A.TN_CodCanton	As	Codigo,				A.TC_Descripcion	As	Descripcion,		
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split' as Split_Provincia,
						B.TN_CodProvincia		As	Codigo,			B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Canton AS A With(Nolock) 	
			INNER JOIN	Catalogo.Provincia AS B With(Nolock) 	
			ON			B.TN_CodProvincia = A.TN_CodProvincia 
			where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia = IsNull(@CodigoProvincia, A.TN_CodProvincia)
			And	        A.TN_CodCanton    = ISNULL(@CodigoCanton,	A.TN_CodCanton) 
			And			A.TF_Inicio_Vigencia	>= @FechaActivacion
			And			A.TF_Fin_Vigencia		<= @FechaDesactivacion 
			Order By	A.TC_Descripcion;
	End
			
 End
GO
