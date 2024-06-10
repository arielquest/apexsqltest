SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Daniel Ruiz Hernández>
-- Fecha de creación:		<15/07/2021>
-- Descripción :			<Permite consultar los motivos de devolucion de la tabla Catalogo.MotivoDevolucionPaseFallo> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoDevolucionPaseFallo]
@Codigo					SMALLINT		= NULL,
@Descripcion			VARCHAR(150)	= NULL,			
@FechaActivacion		DATETIME2		= NULL,
@FechaDesactivacion		DATETIME2		= NULL,
@CodMateria				VARCHAR(5)		= NULL

AS
BEGIN
		
	 DECLARE @ExpresionLike VARCHAR(200)
	 SET @ExpresionLike = iIf(@Descripcion IS NOT NULL,'%' + @Descripcion + '%',NULL)

	--Todos
	IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NULL
	BEGIN
		IF @CodMateria IS NULL
		BEGIN
			SELECT		F.TN_CodMotivoDevolucion					Codigo,				
						F.TC_Descripcion							Descripcion,		
						F.TF_Inicio_Vigencia						FechaActivacion,	
						F.TF_Fin_Vigencia							FechaDesactivacion,
						'Split'										Split,
						F.TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			F WITH(NOLOCK) 		
			WHERE		dbo.FN_RemoverTildes(F.TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike, F.TC_Descripcion)) 
			AND			F.TN_CodMotivoDevolucion					= COALESCE(@Codigo, F.TN_CodMotivoDevolucion)
			ORDER BY	F.TC_Descripcion;
		END
		ELSE
		BEGIN
			SELECT		F.TN_CodMotivoDevolucion					Codigo,				
						F.TC_Descripcion							Descripcion,		
						F.TF_Inicio_Vigencia						FechaActivacion,	
						F.TF_Fin_Vigencia							FechaDesactivacion,
						'Split'										Split,
						F.TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			F WITH(NOLOCK) 
			LEFT JOIN	Catalogo.MotivoDevolucionPaseFalloMateria	M WITH(NOLOCK)
			ON			F.TN_CodMotivoDevolucion					= M.TN_CodMotivoDevolucion			
			WHERE		dbo.FN_RemoverTildes(F.TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike, F.TC_Descripcion)) 
			AND			F.TN_CodMotivoDevolucion					= COALESCE(@Codigo, F.TN_CodMotivoDevolucion)
			AND			M.TC_CodMateria								= @CodMateria
			ORDER BY	F.TC_Descripcion;
		END
	END	
	--Activos 
	ELSE IF @FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NULL
	BEGIN
		IF @CodMateria IS NULL
		BEGIN
			SELECT		TN_CodMotivoDevolucion					Codigo,				
						TC_Descripcion							Descripcion,		
						TF_Inicio_Vigencia						FechaActivacion,	
						TF_Fin_Vigencia							FechaDesactivacion,
						'Split'									Split,
						TC_TipoMotivo							TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo		WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion)	LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) 
			AND			TN_CodMotivoDevolucion					= COALESCE(@Codigo,TN_CodMotivoDevolucion)
			AND			TF_Inicio_Vigencia						< GETDATE ()
			AND			(TF_Fin_Vigencia						IS NULL 
			OR			TF_Fin_Vigencia							>= GETDATE ())
			ORDER BY	TC_Descripcion;
		END
		ELSE
		BEGIN
			SELECT		F.TN_CodMotivoDevolucion					Codigo,				
						F.TC_Descripcion							Descripcion,		
						F.TF_Inicio_Vigencia						FechaActivacion,	
						F.TF_Fin_Vigencia							FechaDesactivacion,
						'Split'										Split,
						F.TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			F WITH(NOLOCK)
			LEFT JOIN	Catalogo.MotivoDevolucionPaseFalloMateria	M WITH(NOLOCK)
			ON			F.TN_CodMotivoDevolucion					= M.TN_CodMotivoDevolucion	
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike , F.TC_Descripcion)) 
			AND			F.TN_CodMotivoDevolucion					= COALESCE(@Codigo, F.TN_CodMotivoDevolucion)
			AND			M.TC_CodMateria								= @CodMateria
			AND			F.TF_Inicio_Vigencia						< GETDATE ()
			AND			(F.TF_Fin_Vigencia							IS NULL 
			OR			F.TF_Fin_Vigencia							>= GETDATE ())
			ORDER BY	F.TC_Descripcion;
		END

	END	 
	--Inactivos
	ELSE IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL
	BEGIN
		IF @CodMateria IS NULL
		BEGIN
			SELECT		TN_CodMotivoDevolucion						Codigo,				
						TC_Descripcion								Descripcion,		
						TF_Inicio_Vigencia							FechaActivacion,	
						TF_Fin_Vigencia								FechaDesactivacion,
						'Split'										Split,
						TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike, TC_Descripcion)) 
			AND			TN_CodMotivoDevolucion						= COALESCE(@Codigo, TN_CodMotivoDevolucion)
			AND			(TF_Inicio_Vigencia							> GETDATE () 
			Or			TF_Fin_Vigencia								< GETDATE ())
			ORDER BY	TC_Descripcion;
		END
		ELSE
		BEGIN
			SELECT		F.TN_CodMotivoDevolucion					Codigo,				
						F.TC_Descripcion							Descripcion,		
						F.TF_Inicio_Vigencia						FechaActivacion,	
						F.TF_Fin_Vigencia							FechaDesactivacion,
						'Split'										Split,
						F.TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			F WITH(NOLOCK)
			LEFT JOIN	Catalogo.MotivoDevolucionPaseFalloMateria	M WITH(NOLOCK)
			ON			F.TN_CodMotivoDevolucion					= M.TN_CodMotivoDevolucion	
			WHERE		dbo.FN_RemoverTildes(F.TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike, F.TC_Descripcion)) 
			AND			F.TN_CodMotivoDevolucion					= COALESCE(@Codigo, F.TN_CodMotivoDevolucion)
			AND			M.TC_CodMateria								= @CodMateria			
			AND			(F.TF_Inicio_Vigencia						> GETDATE () 
			Or			F.TF_Fin_Vigencia							< GETDATE ())
			ORDER BY	F.TC_Descripcion;
		END
	END	
	--Por Rango de Fechas
	ELSE IF @FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL
	BEGIN
		IF @CodMateria IS NULL
		BEGIN
			SELECT		TN_CodMotivoDevolucion						Codigo,				
						TC_Descripcion								Descripcion,		
						TF_Inicio_Vigencia							FechaActivacion,	
						TF_Fin_Vigencia								FechaDesactivacion,
						'Split'										Split,
						TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			WITH(NOLOCK)
			WHERE		dbo.FN_RemoverTildes(TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion)) 
			AND			TN_CodMotivoDevolucion						= COALESCE(@Codigo,TN_CodMotivoDevolucion)
		    AND			(TF_Fin_Vigencia							<= @FechaDesactivacion 
			AND			TF_Inicio_Vigencia							>=@FechaActivacion)
			ORDER BY	TC_Descripcion;
		END
		ELSE
		BEGIN
			SELECT		F.TN_CodMotivoDevolucion					Codigo,				
						F.TC_Descripcion							Descripcion,		
						F.TF_Inicio_Vigencia						FechaActivacion,	
						F.TF_Fin_Vigencia							FechaDesactivacion,
						'Split'										Split,
						F.TC_TipoMotivo								TipoMotivo
			FROM		Catalogo.MotivoDevolucionPaseFallo			F WITH(NOLOCK)
			LEFT JOIN	Catalogo.MotivoDevolucionPaseFalloMateria	M WITH(NOLOCK)
			ON			F.TN_CodMotivoDevolucion					= M.TN_CodMotivoDevolucion	
			WHERE		dbo.FN_RemoverTildes(F.TC_Descripcion)		LIKE dbo.FN_RemoverTildes(COALESCE(@ExpresionLike, F.TC_Descripcion)) 
			AND			F.TN_CodMotivoDevolucion					= COALESCE(@Codigo, F.TN_CodMotivoDevolucion)
			AND			M.TC_CodMateria								= @CodMateria	
		    AND			(F.TF_Fin_Vigencia							<= @FechaDesactivacion 
			AND			F.TF_Inicio_Vigencia						>=@FechaActivacion)
			ORDER BY	TC_Descripcion;
		END
	END	 
END

GO
