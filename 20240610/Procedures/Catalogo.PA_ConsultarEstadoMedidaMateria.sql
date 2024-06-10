SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<30/09/2022>
-- Descripción :			<Permite Consultar los estado de medida y materia activos.>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarEstadoMedidaMateria]
    @CodEstado			SMALLINT	= NULL,
	@CodMateria			VARCHAR(5)	= NULL,
	@FechaAsociacion	DATETIME2	= NULL    
AS
BEGIN
--Variables.
	DECLARE	@L_CodEstado				SMALLINT		= @CodEstado,
			@L_CodMateria				VARCHAR(5)		= @CodMateria,
			@L_FechaAsociacion			DATETIME2		= @FechaAsociacion			

	SELECT		
				B.TC_CodMateria			  				   Codigo, 
				B.TC_Descripcion						   Descripcion, 
				B.TF_Inicio_Vigencia					   FechaActivacion, 
				B.TF_Fin_Vigencia						   FechaDesactivacion,				
				'SplitEstadoMedida'						   SplitEstadoMedida, 
       			C.TN_CodEstado							   Codigo, 				
				C.TC_Descripcion						   Descripcion, 
				C.TF_Inicio_Vigencia					   FechaActivacion,				
				C.TF_Fin_Vigencia						   FechaDesactivacion,				
				'SplitOtros'							   SplitOtros,
				A.TF_Fecha_Asociacion					   FechaAsociacion

	FROM		Catalogo.EstadoMedidaMateria		       A WITH (NOLOCK) 
	INNER JOIN	Catalogo.Materia		      			   B WITH (NOLOCK)
	ON			B.TC_CodMateria							   = A.TC_CodMateria
	INNER JOIN	Catalogo.EstadoMedida	 				   C WITH (NOLOCK)
	ON			C.TN_CodEstado	  					       = A.TN_CodEstado
	
	WHERE		A.TN_CodEstado							   = COALESCE(@L_CodEstado, A.TN_CodEstado)
	AND			A.TC_CodMateria							   = COALESCE(@L_CodMateria, A.TC_CodMateria)
	AND			A.TF_Fecha_Asociacion					   <= CASE WHEN @L_FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Fecha_Asociacion END
	
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion
END
GO
