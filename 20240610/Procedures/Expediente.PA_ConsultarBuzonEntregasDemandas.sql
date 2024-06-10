SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<14/02/2020>
-- Descripción :			<Permite Consultar las entregas de las demandas>
-- =================================================================================================================================================
-- Modificado por: <Andrew Allen Dawson>
-- Modificación: <Se cambia la fecha de recepcion a RDD por fecha de ingreso al sistema>
-- Fecha de creación: <18/06/2020>
-- =================================================================================================================================================
-- Modificado por: <Ronny Ramírez R.>
-- Modificación: <Se modifica el SP para eliminar campos relacionados con la columna que John eliminó de la tabla TU_CodEscrito, para que cargue>
-- Fecha de creación: <21/07/2020>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarBuzonEntregasDemandas]   
 	@NumeroPagina				INT,
	@CantidadRegistros			INT,
	@FechaDesde					DATETIME2		= NULL,
	@FechaHasta					DATETIME2		= NULL,
	@CodClase					INT,
	@Estado						CHAR(1)			= NULL,
	@Contexto					VARCHAR(4)		

As
begin
	DECLARE @Entregas AS TABLE
	(
		NumeroExpediente			char(14),
		CodEntregaDemanda			uniqueidentifier,
		FechaIngresoRDD				datetime2(2),
		Estado						char(1),
        CodClase					int,
        DescripcionClase			varchar(200),
		CodProceso					smallint,
        DecripcionProceso			varchar(100),
        FechaRecibido				datetime2(2),
		FechaEstadoExpediente		datetime2(2),
		CodEntrega					varchar(12),
		DescripcionEscrito			varchar(255),
		CodigoArchivo				uniqueidentifier

	)

  if( @NumeroPagina is null) set @NumeroPagina=1;

     INSERT INTO @Entregas(
	     NumeroExpediente					
		,CodEntregaDemanda		
		,FechaIngresoRDD			
		,Estado
		,CodClase
		,DescripcionClase
		,CodProceso
		,DecripcionProceso
		,FechaRecibido			
		,FechaEstadoExpediente
	) 
		SELECT A.TC_NumeroExpediente
			  ,A.TU_CodEntregaDemanda
			  ,A.TF_FechaIngresoRDD
			  ,A.TC_Estado
			  ,D.TN_CodClase
			  ,D.TC_Descripcion
			  ,F.TN_CodProceso
			  ,F.TC_Descripcion
			  ,A.TF_FechaRecibido
			  ,A.TF_FechaEstadoExpediente
		FROM Expediente.EntregaDemanda A With(Nolock)
		
		JOIN Expediente.Expediente					B WITH(NOLOCK)
		ON	 A.TC_NumeroExpediente				  = B.TC_NumeroExpediente

		JOIN Expediente.ExpedienteDetalle			C WITH(Nolock)
		ON	(A.TC_NumeroExpediente				  = C.TC_NumeroExpediente
		AND	 C.TF_Entrada = (SELECT TOP 1 ED.TF_Entrada 
							 FROM ExpedienteDetalle ED WITH(Nolock) 
							 WHERE ED.TC_NumeroExpediente = A.TC_NumeroExpediente 
							 ORDER BY TF_Entrada)) 

		JOIN		Catalogo.Clase 					D WITH(Nolock)
		ON			C.TN_CodClase				  = D.TN_CodClase

		JOIN		Catalogo.Proceso				F WITH(Nolock)
		ON			C.TN_CodProceso				  = F.TN_CodProceso
		
		WHERE	C.TN_CodClase					=		ISNULL(@CodClase, C.TN_CodClase)
		AND		C.TC_CodContexto				=		ISNULL(@Contexto, C.TC_CodContexto)
		AND		A.TC_Estado						=		ISNULL(@Estado, A.TC_Estado)
		AND		(@FechaHasta				IS NULL OR DATEDIFF(day, A.TF_FechaRecibido,@FechaHasta) >= 0)
		AND		(@FechaDesde				IS NULL OR DATEDIFF(day, A.TF_FechaRecibido,@FechaDesde) <= 0)
		

		ORDER BY	A.TF_FechaIngresoRDD		Asc

		--Obtener cantidad registros de la consulta
		DECLARE @TotalRegistros AS INT = @@rowcount; 

		--retornar consultar
		SELECT  x.NumeroExpediente				AS		Numero  
			   ,x.CodEntregaDemanda				AS		Codigo
			   ,x.FechaIngresoRDD				AS		FechaIngresoRDD
			   ,x.FechaRecibido					AS		FechaRecibido
			   ,x.FechaEstadoExpediente			AS		FechaEstadoExpediente
			   ,x.Estado						AS		Estado
			   ,@TotalRegistros					AS		TotalRegistros
			   ,@NumeroPagina					AS		NumeroPagina
			   ,'Split'							AS		split
			   ,x.CodClase						AS		Codigo
			   ,x.DescripcionClase				AS		Descripcion
			   ,'Split'							AS		split
			   ,x.CodProceso					AS		Codigo
			   ,x.DecripcionProceso				AS		Descripcion
			   ,'Split'							AS		split
			   ,x.CodEntrega					AS		CodigoEntrega
			   ,x.DescripcionEscrito			AS		Descripcion
			   ,'Split'							AS		split
			   ,x.CodigoArchivo					AS      Codigo
		FROM (
			SELECT NumeroExpediente					
				  ,CodEntregaDemanda		
				  ,FechaIngresoRDD	
				  ,FechaRecibido			
				  ,FechaEstadoExpediente
				  ,Estado
				  ,CodClase
				  ,DescripcionClase
				  ,CodProceso
				  ,DecripcionProceso	
				  ,CodEntrega				
				  ,DescripcionEscrito
				  ,CodigoArchivo
					
			FROM		@Entregas
			ORDER BY	FechaIngresoRDD		Asc
			OFFSET		(@NumeroPagina - 1) * @CantidadRegistros ROWS 
			FETCH NEXT	@CantidadRegistros ROWS ONLY
		)	As x
		ORDER BY	x.FechaIngresoRDD		Asc 
end
GO
