SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<04/05/2016>
-- Descripcion:		<Consulta registros de grupo de formato jurídico.>
--
-- Modificación:	<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
---Modificación:	<11/07/2017><Andrés Díaz><Se simplifica el procedimiento a cuatro consultas y se tabula.>
-- Modificación:	<18/07/2017> <Diego Navarrete> <Se simplifica el procedimiento a dos consultas. Se modifica la consulta para que delvuelva el dato nombre>
-- Modificacion:    <10/07/2018><Jefry Hernández><Se agrega nuevo parámetro @Ordenamiento.>
-- Modificación		<25/09/2018> <Jonathan Aguilar Navarro> <Se agrega filtro para la consulta de formatos de expediente o sin expediente> 
-- Modificación		<24/03/2021> <Jose Gabriel Cordero Soto> <Se agrega indicador de generar voto automatico> 
-- Modificación		<13/08/2021> <Isaac Santiago Méndez Castillo> <Se agrega a todas las consultas, donde se obtienen los grupos de formatos jurídicos
--																   que son padres, ya que si los grupos no tienen formatos jurídicos, pero tiene hijos
--																   que si tienen, no se obtienen estos grupos hijos.> 
-- =============================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarGrupoFormatoJuridico]
	@Codigo						SMALLINT		= Null,
	@Descripcion				VARCHAR(150)	= Null,
	@FechaActivacion			DATETIME2		= Null,
	@FechaDesactivacion			DATETIME2		= Null,
	@GenerarVotoAutomatico		BIT				= Null,
	@DocumentoSinExpediente		BIT 
 As
 Begin
  
   --***********************************************************************************************
   --Declaacion de variables
   DECLARE 	@L_Codigo						SMALLINT		= @Codigo,
			@L_Descripcion					VARCHAR(150)	= @Descripcion,
			@L_FechaActivacion				DATETIME2		= @FechaActivacion,
			@L_FechaDesactivacion			DATETIME2		= @FechaDesactivacion,
			@L_GenerarVotoAutomatico		BIT				= @GenerarVotoAutomatico,
			@L_DocumentoSinExpediente		BIT				= @DocumentoSinExpediente

   DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

   --***********************************************************************************************
   --CONSULTA DE PROCEDIMIENTO

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
			If @DocumentoSinExpediente = 1
			BEGIN
				IF @GenerarVotoAutomatico = 1
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
							G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
							G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
							G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 
						inner join	Catalogo.FormatoJuridico		AS  H  With(NoLock)
						on			G.TN_CodGrupoFormatoJuridico	=	H.TN_CodGrupoFormatoJuridico		
						Where		G.TC_Descripcion like @ExpresionLike 
						AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND			H.TB_GenerarVotoAutomatico			=	@L_GenerarVotoAutomatico
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = F.TN_CodGrupoFormatoJuridico 
											AND F.TB_DocumentoSinExpediente = @DocumentoSinExpediente)
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
				ELSE
					BEGIN 
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
							G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
							G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
							G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 
						inner join	Catalogo.FormatoJuridico		AS  H  With(NoLock)
						on			G.TN_CodGrupoFormatoJuridico	=	H.TN_CodGrupoFormatoJuridico		
						Where		G.TC_Descripcion like @ExpresionLike 
						AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = F.TN_CodGrupoFormatoJuridico 
											AND F.TB_DocumentoSinExpediente = @DocumentoSinExpediente)
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
			END
			ELSE
			BEGIN
				IF @GenerarVotoAutomatico = 1
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
									G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
									G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
									G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 						
						Where		G.TC_Descripcion like @ExpresionLike 
						AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico  = F.TN_CodGrupoFormatoJuridico
											AND	  F.TB_GenerarVotoAutomatico	= @L_GenerarVotoAutomatico	)
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
				ELSE
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
							G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
							G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
							G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 							
						Where		G.TC_Descripcion like @ExpresionLike 
						AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = F.TN_CodGrupoFormatoJuridico)
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
			END		
	End
		 
	--Inactivos
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			If @DocumentoSinExpediente = 1
			BEGIN
				IF @GenerarVotoAutomatico = 1
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre			As	CodigoPadre,		
							G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
							G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre								As	Nombre,
							G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico		AS  G  With(Nolock) 
						inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
						on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico					
						Where		G.TC_Descripcion					like	@ExpresionLike
						AND			G.TN_CodGrupoFormatoJuridico		=	COALESCE(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND			H.TB_GenerarVotoAutomatico			=	@L_GenerarVotoAutomatico
						AND		   (G.TF_Inicio_Vigencia  > GETDATE () Or G.TF_Fin_Vigencia  < GETDATE ())
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
											AND F.TB_DocumentoSinExpediente = @DocumentoSinExpediente
											AND F.TF_Inicio_Vigencia  > GETDATE () Or F.TF_Fin_Vigencia  < GETDATE ())
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
				ELSE
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre			As	CodigoPadre,		
							G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
							G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre								As	Nombre,
							G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico		AS  G  With(Nolock) 
						inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
						on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico					
						Where		G.TC_Descripcion					like	@ExpresionLike
						AND			G.TN_CodGrupoFormatoJuridico		=	COALESCE(@Codigo, G.TN_CodGrupoFormatoJuridico)					
						AND		   (G.TF_Inicio_Vigencia  > GETDATE () Or G.TF_Fin_Vigencia  < GETDATE ())
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
											AND F.TB_DocumentoSinExpediente = @DocumentoSinExpediente
											AND F.TF_Inicio_Vigencia  > GETDATE () Or F.TF_Fin_Vigencia  < GETDATE ())
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
			END
			ELSE
			BEGIN
				IF @GenerarVotoAutomatico = 1
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
									G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia				As	FechaActivacion,	
									G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
									G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock) 
						inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
						on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico					
						Where		G.TC_Descripcion					like	@ExpresionLike
						AND			G.TN_CodGrupoFormatoJuridico		=	COALESCE(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND			H.TB_GenerarVotoAutomatico			=	@L_GenerarVotoAutomatico
						AND		   (G.TF_Inicio_Vigencia  > GETDATE ()	Or	G.TF_Fin_Vigencia  < GETDATE ())
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
											AND F.TF_Inicio_Vigencia  > GETDATE () Or F.TF_Fin_Vigencia  < GETDATE ())
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
				ELSE
					BEGIN
						Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
									G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia				As	FechaActivacion,	
									G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
									G.TN_Ordenamiento					As	Ordenamiento
						From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock) 
						inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
						on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico					
						Where		G.TC_Descripcion					like	@ExpresionLike
						AND			G.TN_CodGrupoFormatoJuridico		=	COALESCE(@Codigo, G.TN_CodGrupoFormatoJuridico)
						AND		   (G.TF_Inicio_Vigencia  > GETDATE () Or G.TF_Fin_Vigencia  < GETDATE ())
						AND			(EXISTS( SELECT TOP 1 * 
											FROM Catalogo.FormatoJuridico F 
											WHERE F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
											AND F.TF_Inicio_Vigencia  > GETDATE () Or F.TF_Fin_Vigencia  < GETDATE ())
						OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
						ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
					END
			END		
	End
	ELSE
	--Activos
	If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null 
	Begin
		If @DocumentoSinExpediente = 1
		BEGIN
			IF @GenerarVotoAutomatico = 1
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 				
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND			G.TF_Inicio_Vigencia				<=	getdate()					
					AND		   (G.TF_Fin_Vigencia					>	getdate()	    OR 	G.TF_Fin_Vigencia IS null)
					AND			(EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE F.TN_CodGrupoFormatoJuridico  = G.TN_CodGrupoFormatoJuridico 
										AND F.TB_DocumentoSinExpediente		= @DocumentoSinExpediente
										AND F.TB_GenerarVotoAutomatico		= @L_GenerarVotoAutomatico
										AND			F.TF_Inicio_Vigencia				<=	getdate()					
										AND		   (F.TF_Fin_Vigencia					>	getdate() OR 	F.TF_Fin_Vigencia IS null))
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
			ELSE
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 				
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND			G.TF_Inicio_Vigencia				<=	getdate()					
					AND		   (G.TF_Fin_Vigencia					>	getdate()	    OR 	G.TF_Fin_Vigencia IS null)
					AND			(EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
										AND F.TB_DocumentoSinExpediente = @DocumentoSinExpediente
										AND			F.TF_Inicio_Vigencia				<=	getdate()					
										AND		   (F.TF_Fin_Vigencia					>	getdate() OR 	F.TF_Fin_Vigencia IS null))
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
		END
		ELSE
		BEGIN
			IF @GenerarVotoAutomatico = 1
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock) 				
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND			G.TF_Inicio_Vigencia				<=	getdate()					
					AND		   (G.TF_Fin_Vigencia					>	getdate()	    OR 	G.TF_Fin_Vigencia IS null)
					AND			(EXISTS( SELECT  TOP 1 * 
										FROM	Catalogo.FormatoJuridico F 
										WHERE	F.TN_CodGrupoFormatoJuridico	= G.TN_CodGrupoFormatoJuridico 
										AND		F.TB_GenerarVotoAutomatico		= @L_GenerarVotoAutomatico	
										AND		F.TF_Inicio_Vigencia			<=	getdate()					
										AND		(F.TF_Fin_Vigencia				>	getdate() OR 	F.TF_Fin_Vigencia IS null))
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
			ELSE				
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico	AS	G  With(Nolock) 				
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND			G.TF_Inicio_Vigencia				<=	getdate()					
					AND		   (G.TF_Fin_Vigencia					>	getdate()	    OR 	G.TF_Fin_Vigencia IS null)
					AND		   (EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
										AND			F.TF_Inicio_Vigencia				<=	getdate()					
										AND		   (F.TF_Fin_Vigencia					>	getdate() OR 	F.TF_Fin_Vigencia IS null))
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si tiene Grupos hijos
										WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
		END			
	End
	ELSE
	--Por rango
	Begin
		If @DocumentoSinExpediente = 1
		BEGIN
			IF @GenerarVotoAutomatico = 1
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock)
					inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
					on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico				 	
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND	        G.TF_Inicio_Vigencia	            >=	@FechaActivacion 
					AND	        G.TF_Fin_Vigencia				    <=  @FechaDesactivacion
					AND			(EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE	F.TN_CodGrupoFormatoJuridico	= G.TN_CodGrupoFormatoJuridico 
										AND		F.TB_DocumentoSinExpediente		= @DocumentoSinExpediente
										AND		F.TB_GenerarVotoAutomatico		= @L_GenerarVotoAutomatico
										AND		F.TF_Inicio_Vigencia			<=	getdate()					
										AND		(F.TF_Fin_Vigencia				>	getdate() OR 	F.TF_Fin_Vigencia IS null))
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
			ELSE
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock)
					inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
					on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico				 	
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND	        G.TF_Inicio_Vigencia	            >=	@FechaActivacion 
					AND	        G.TF_Fin_Vigencia				    <=  @FechaDesactivacion
					AND			(EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE	F.TN_CodGrupoFormatoJuridico		= G.TN_CodGrupoFormatoJuridico 
										AND		F.TB_DocumentoSinExpediente			= @DocumentoSinExpediente
										AND		F.TF_Inicio_Vigencia				<=	getdate()					
										AND	   (F.TF_Fin_Vigencia					>	getdate() OR 	F.TF_Fin_Vigencia IS null))
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
		END
		ELSE
		BEGIN
			IF @GenerarVotoAutomatico = 1
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock)
					inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
					on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico				 	
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND			H.TB_GenerarVotoAutomatico			=	@L_GenerarVotoAutomatico
					AND	        G.TF_Inicio_Vigencia	            >=	@FechaActivacion 
					AND	        G.TF_Fin_Vigencia				    <=  @FechaDesactivacion
					AND			(EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE	F.TN_CodGrupoFormatoJuridico = G.TN_CodGrupoFormatoJuridico 
										AND		F.TF_Inicio_Vigencia		 <=	getdate()					
										AND	   (F.TF_Fin_Vigencia			 >	getdate() OR 	F.TF_Fin_Vigencia IS null))	
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
			ELSE
				BEGIN
					Select		G.TN_CodGrupoFormatoJuridico		As	Codigo,				TN_CodGrupoFormatoJuridicoPadre		As	CodigoPadre,		
								G.TC_Descripcion					As	Descripcion,		G.TF_Inicio_Vigencia					As	FechaActivacion,	
								G.TF_Fin_Vigencia					As	FechaDesactivacion,	G.TC_Nombre							As	Nombre,
								G.TN_Ordenamiento					As	Ordenamiento
					From		Catalogo.GrupoFormatoJuridico		AS	G  With(Nolock)
					inner join	Catalogo.FormatoJuridico			AS  H  With(NoLock)
					on			G.TN_CodGrupoFormatoJuridico		=	H.TN_CodGrupoFormatoJuridico				 	
					Where		G.TC_Descripcion like @ExpresionLike
					AND			G.TN_CodGrupoFormatoJuridico		=	Coalesce(@Codigo, G.TN_CodGrupoFormatoJuridico)
					AND	        G.TF_Inicio_Vigencia	            >=	@FechaActivacion 
					AND	        G.TF_Fin_Vigencia				    <=  @FechaDesactivacion
					AND			(EXISTS( SELECT TOP 1 * FROM Catalogo.FormatoJuridico F 
										WHERE	F.TN_CodGrupoFormatoJuridico	= G.TN_CodGrupoFormatoJuridico 
										AND		F.TF_Inicio_Vigencia			<=	getdate()					
										AND	   (F.TF_Fin_Vigencia				>	getdate() OR 	F.TF_Fin_Vigencia IS null))	
					OR			EXISTS( SELECT TOP 1 * FROM Catalogo.GrupoFormatoJuridico AS GH --Comprueba si son padres de otros grupos
											WHERE GH.TN_CodGrupoFormatoJuridicoPadre = G.TN_CodGrupoFormatoJuridico))
					ORDER BY CASE WHEN G.TN_Ordenamiento IS NULL THEN 1 ELSE 0 END, G.TN_Ordenamiento, G.TC_Descripcion;
				END
		END			
	End			
 End

GO
