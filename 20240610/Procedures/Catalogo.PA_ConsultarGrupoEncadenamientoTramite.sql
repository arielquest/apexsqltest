SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Autor:			<Daniel Ruiz Hernández>
-- Fecha Creaci¢n:	<16/06/2022>
-- Descripcion:		<Consulta registros de grupo de formato juridico.>
-- =============================================
-- Modificado por:  <Jose Gabriel Cordero Soto><27/07/2022><Se realiza ajustes en el SP para filtrar por fecha desctivacion y para devolver los vigentes o todos los registros> 
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarGrupoEncadenamientoTramite]
	@Codigo					UNIQUEIDENTIFIER	= Null,
	@Descripcion			VARCHAR(150)		= Null,
	@FechaActivacion		DATETIME2			= Null,
	@FechaDesactivacion		DATETIME2			= Null
 AS
 BEGIN
  
   --***********************************************************************************************
   --Declaacion de variables
   DECLARE 	@L_Codigo				UNIQUEIDENTIFIER	= @Codigo,
			@L_Descripcion			VARCHAR(150)		= @Descripcion,
			@L_FechaActivacion		DATETIME2			= @FechaActivacion,
			@L_FechaDesactivacion	DATETIME2			= @FechaDesactivacion

   DECLARE @ExpresionLike VARCHAR(200) = iIf(@L_Descripcion Is Not Null,'%' + @L_Descripcion + '%','%');

   --***********************************************************************************************
   --CONSULTA DE PROCEDIMIENTO

	--Todos
	If  @L_FechaActivacion IS NULL AND @L_FechaDesactivacion IS NULL
		BEGIN
			SELECT	 G.TU_CodGrupoEncadenamientoTramite			AS	Codigo,				
					 G.TU_CodGrupoEncadenamientoTramitePadre	AS	CodigoPadre,		
					 G.TC_Descripcion							AS	Descripcion,	
					 G.TF_Inicio_Vigencia						AS	FechaActivacion,	
					 G.TF_Fin_Vigencia							AS	FechaDesactivacion,
					 G.TC_Nombre								AS	Nombre
			FROM	 Catalogo.GrupoEncadenamientoTramite		AS	G  WITH(NOLOCK) 							
			ORDER BY G.TC_Descripcion
		END
	ELSE	

	--ACTIVOS
	If  @L_FechaActivacion IS NOT NULL 
		BEGIN
			SELECT	 G.TU_CodGrupoEncadenamientoTramite			AS	Codigo,				
					 G.TU_CodGrupoEncadenamientoTramitePadre	AS	CodigoPadre,		
					 G.TC_Descripcion							AS	Descripcion,		
					 G.TF_Inicio_Vigencia						AS	FechaActivacion,	
					 G.TF_Fin_Vigencia							AS	FechaDesactivacion,	
					 G.TC_Nombre								AS	Nombre
			FROM	 Catalogo.GrupoEncadenamientoTramite		AS	G  WITH(NOLOCK) 		
			WHERE	 G.TF_Inicio_Vigencia						<= GETDATE()	
			AND		(G.TF_Fin_Vigencia							IS NULL
			OR		 G.TF_Fin_Vigencia							>= GETDATE())
			ORDER BY G.TC_Descripcion
		END
	
		 
	----Inactivos
	--Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	--BEGIN
		
 --   END
	--ELSE
	----Activos
	--If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null 
	--BEGIN

	--END	
	--ELSE
	----Por rango
	--BEGIN

	--END			

END
GO
