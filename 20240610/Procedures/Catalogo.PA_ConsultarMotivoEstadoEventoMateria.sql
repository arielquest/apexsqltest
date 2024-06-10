SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<16/09/2016>
-- Descripción :			<Permite Consultar las MotivoEstadoEvento de una Materia
-- =================================================================================================================================================
-- Modificado:				<14/06/2018> <Ailyn López> <Se agrega split para obtener el código del estado del evento >
-- =================================================================================================================================================
 
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoEstadoEventoMateria]
    @CodMotivoEstado		smallint,
	@CodMateria				varchar(5),
	@FechaAsociacion		Datetime2= Null 
 As
 Begin 		
	--Registros activos
   If @FechaAsociacion  Is Null 
	Begin
	  
	  SELECT		B.TN_CodMotivoEstado	AS Codigo, 
					B.TC_Descripcion		AS Descripcion, 
					B.TF_Inicio_Vigencia	AS FechaActivacion, 
					B.TF_Fin_Vigencia		AS FechaDesactivacion,
					A.TF_Inicio_Vigencia	AS FechaAsociacion,
					'Split'					AS Split,
					C.TC_CodMateria			AS Codigo, 
					C.TC_Descripcion		AS Descripcion, 
					C.TF_Inicio_Vigencia	AS FechaActivacion, 
					C.TF_Fin_Vigencia		AS FechaDesactivacion,
					'Split'					AS Split
		FROM		Catalogo.MotivoEstadoEventoMateria	AS A WITH (Nolock) 
		INNER JOIN	Catalogo.MotivoEstadoEvento			AS B WITH (Nolock) 
		ON			B.TN_CodMotivoEstado	= A.TN_CodMotivoEstado 
		INNER JOIN	Catalogo.Materia					AS C WITH (Nolock) 
		ON			C.TC_CodMateria			= A.TC_CodMateria
		WHERE		(A.TC_CodMateria		= @CodMateria
		Or			A.TN_CodMotivoEstado	= @CodMotivoEstado)
		and			A.TF_Inicio_Vigencia    < GETDATE ()	 
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End
	Else
	-- todos registros 	
		SELECT		B.TN_CodMotivoEstado	AS Codigo, 
					B.TC_Descripcion		AS Descripcion, 
					B.TF_Inicio_Vigencia	AS FechaActivacion, 
					B.TF_Fin_Vigencia		AS FechaDesactivacion,
					A.TF_Inicio_Vigencia	AS FechaAsociacion,
					'Split'					AS Split,
					C.TC_CodMateria			AS Codigo, 
					C.TC_Descripcion		AS Descripcion, 
					C.TF_Inicio_Vigencia	AS FechaActivacion, 
					C.TF_Fin_Vigencia		AS FechaDesactivacion,
					'Split'					AS Split
		FROM		Catalogo.MotivoEstadoEventoMateria	AS A WITH (Nolock) 
		INNER JOIN	Catalogo.MotivoEstadoEvento			AS B WITH (Nolock) 
		ON			B.TN_CodMotivoEstado	= A.TN_CodMotivoEstado 
		INNER JOIN	Catalogo.Materia					AS C WITH (Nolock) 
		ON			C.TC_CodMateria			= A.TC_CodMateria
		WHERE		(A.TC_CodMateria		= @CodMateria
		Or			A.TN_CodMotivoEstado	= @CodMotivoEstado)
		Order By	B.TC_Descripcion, C.TC_Descripcion;

 End


GO
