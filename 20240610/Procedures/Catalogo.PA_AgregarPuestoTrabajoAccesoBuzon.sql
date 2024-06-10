SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================
-- Autor:		   <Luis Alonso Leiva Tames>
-- Fecha Creación: <27/10/2018>
-- Descripcion:    <Agregar un permiso al buzon del puesto de trabajo>
-- ==========================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarPuestoTrabajoAccesoBuzon]
	 @CodPuestoTrabajo				varchar(14),
	 @CodPuestoTrabajoSecundario	varchar(Max),
	 @UsuarioRedAsignaPermiso		varchar(30),
	 @FechaRegistro		datetime2(3)
 As
 Begin


	 Declare @L_CodPuestoTrabajo			varchar(14)  = @CodPuestoTrabajo
	 Declare @L_CodPuestoTrabajoSecundario	varchar(14)  
	 Declare @L_PuestoTrabajo				varchar(max)  = @CodPuestoTrabajoSecundario
	 Declare @L_UsuarioRedAsignaPermiso		varchar(30)  = @UsuarioRedAsignaPermiso
	 Declare @L_FechaRegistro				datetime2(3) = @FechaRegistro
	 Declare @L_contador					int			 = 1 


	SELECT ROW_NUMBER() OVER(ORDER BY value) AS num_row, value
	INTO #temp
	FROM STRING_SPLIT(@L_PuestoTrabajo, ',')  
	WHERE RTRIM(value) <> ''


	WHILE (@L_contador <= (SELECT count(1) FROM #temp))
	BEGIN
		SELECT @L_CodPuestoTrabajoSecundario = value FROM #temp WHERE num_row = @L_contador

		INSERT INTO [Catalogo].[PuestoTrabajoAccesoBuzon]  (
												TC_CodPuestoTrabajo,
												TC_CodPuestoTrabajoSecundario,
												TC_UsuarioRedAsignaPermiso,
												TF_FechaRegistro)
									   VALUES (	@L_CodPuestoTrabajo, 
												@L_CodPuestoTrabajoSecundario,
												@L_UsuarioRedAsignaPermiso, 
												@L_FechaRegistro)
		SET @L_contador = @L_contador + 1 
	END

	IF OBJECT_ID('tempdb.dbo.#temp', 'U') IS NOT NULL 
	BEGIN
	  DROP TABLE #temp; 
	END
    
 End 



GO
