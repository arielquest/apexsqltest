SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Pablo Alvarez>
-- Fecha:			<24/09/2015>
-- Descripción :	<Permite Consultar grupo de trabajo> 
-- Modificacion:	<Gerardo Lopez> <02/11/2015> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificado:		<Alejandro Villalta> <15-12-2015> <Modificar tipo de dato del campo codigo de grupo>
-- Modificado por:	<Sigifredo Leitón Luna>
-- Fecha:			<15/01/2016>
-- Descripción :	<Se corrige error que se presenta a la hora de extraer todos los registros.> 
-- Modificación:	<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:		<08/03/2017> <Roger Lara> <agrego if para que considere la busqueda por codigo en activos e inactivos>
-- Modificación:	<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- Modificación		<05/04/2018> <Se cambio "CodOficina" por "CodContexto" ya que ahora los grupos de trabajo van relacionados al contexto>
-- Modificación		<22/08/2018> <Tatiana Flores> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarGrupoTrabajo]
	@Codigo smallint=Null,
	@CodContexto Varchar(4)=Null,
	@Descripcion Varchar(255)=Null,
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
 As
 Begin
  
   DECLARE	@ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion Is Null
	Begin
			SELECT  G.TN_CodGrupoTrabajo AS Codigo, 
					G.TC_Descripcion AS Descripcion, 
					G.TF_Inicio_Vigencia AS FechaActivacion, 
                    G.TF_Fin_Vigencia AS FechaDesactivacion, 
					'Split' AS Split, 
					O.TC_CodContexto AS Codigo, 
					O.TC_Descripcion AS Descripcion, 
					O.TF_Inicio_Vigencia		As	FechaActivacion,
					O.TF_Fin_Vigencia			As	FechaDesactivacion
            FROM    Catalogo.GrupoTrabajo G WITH (Nolock) INNER JOIN
                    Catalogo.Contexto O With(Nolock)  ON G.TC_CodContexto = O.TC_CodContexto
           Where    dbo.FN_RemoverTildes(G.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		   And      G.TC_CodContexto		=  Coalesce(@CodContexto, G.TC_CodContexto) 
		   And      G.TN_CodGrupoTrabajo	=  Coalesce(@Codigo, G.TN_CodGrupoTrabajo) 
		   Order By	G.TC_Descripcion; 
	End	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null 
	Begin
			SELECT		G.TN_CodGrupoTrabajo AS Codigo, 
						G.TC_Descripcion AS Descripcion, 
						G.TF_Inicio_Vigencia AS FechaActivacion, 
						G.TF_Fin_Vigencia AS FechaDesactivacion, 
						'Split' AS Split, 
						O.TC_CodContexto AS Codigo, 
						O.TC_Descripcion AS Descripcion, 
						O.TF_Inicio_Vigencia		As	FechaActivacion,
						O.TF_Fin_Vigencia			As	FechaDesactivacion
            FROM		Catalogo.GrupoTrabajo G WITH (Nolock) INNER JOIN
						Catalogo.Contexto O With(Nolock)  ON G.TC_CodContexto = O.TC_CodContexto           
			
			Where		dbo.FN_RemoverTildes(G.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			G.TC_CodContexto		=  Coalesce(@CodContexto, G.TC_CodContexto)
			And         G.TN_CodGrupoTrabajo	=  Coalesce(@Codigo, G.TN_CodGrupoTrabajo) 
			And			G.TF_Inicio_Vigencia	<=		GETDATE ()
			And			(G.TF_Fin_Vigencia		Is	Null OR G.TF_Fin_Vigencia  >= GETDATE ()) 
			Order By	G.TC_Descripcion;
	End

	--Inactivos
	else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
	Begin
			SELECT		G.TN_CodGrupoTrabajo AS Codigo, 
						G.TC_Descripcion AS Descripcion, 
						G.TF_Inicio_Vigencia AS FechaActivacion, 
						G.TF_Fin_Vigencia AS FechaDesactivacion, 
						'Split' AS Split, 
						O.TC_CodContexto AS Codigo, 
						O.TC_Descripcion AS Descripcion, 
						O.TF_Inicio_Vigencia		As	FechaActivacion,
						O.TF_Fin_Vigencia			As	FechaDesactivacion
            FROM		Catalogo.GrupoTrabajo G WITH (Nolock) INNER JOIN
						Catalogo.Contexto O With(Nolock)  ON G.TC_CodContexto = O.TC_CodContexto  
						         
			Where		dbo.FN_RemoverTildes(G.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			G.TC_CodContexto		=  Coalesce(@CodContexto, G.TC_CodContexto) 
			And			G.TN_CodGrupoTrabajo	=  Coalesce(@Codigo, G.TN_CodGrupoTrabajo) 
			And			(G.TF_Inicio_Vigencia >		GETDATE () 
			Or			G.TF_Fin_Vigencia		<		GETDATE ())
			Order By	G.TC_Descripcion;
	End	
 
	--Por rango de fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin	     
			SELECT		G.TN_CodGrupoTrabajo AS Codigo, 
						G.TC_Descripcion AS Descripcion, 
						G.TF_Inicio_Vigencia AS FechaActivacion, 
						G.TF_Fin_Vigencia AS FechaDesactivacion, 
						'Split' AS Split,
						O.TC_CodContexto AS Codigo, 
						O.TC_Descripcion AS Descripcion,
						O.TF_Inicio_Vigencia		As	FechaActivacion,
						O.TF_Fin_Vigencia			As	FechaDesactivacion
            FROM		Catalogo.GrupoTrabajo G WITH (Nolock) INNER JOIN
						Catalogo.Contexto O With(Nolock)  ON G.TC_CodContexto = O.TC_CodContexto
           
		   	Where		dbo.FN_RemoverTildes(G.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			G.TC_CodContexto			=  Coalesce(@CodContexto, G.TC_CodContexto)
			And			G.TN_CodGrupoTrabajo	=  Coalesce(@Codigo, G.TN_CodGrupoTrabajo) 
			And			(G.TF_Inicio_Vigencia	>= @FechaActivacion
			And			G.TF_Fin_Vigencia		<= @FechaDesactivacion)
			Order By	G.TC_Descripcion;
		
	End
		
 End
GO
