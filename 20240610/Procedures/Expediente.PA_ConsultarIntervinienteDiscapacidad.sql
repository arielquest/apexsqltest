SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<27/11/2015>
-- Descripcion:		<Consultar discapacidades de un interviniente.>
--
-- Modificación:	<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodDiscapacidad a TN_CodDiscapacidad de acuerdo al tipo de dato.>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteDiscapacidad]   
	@CodInterviniente	uniqueidentifier
AS
BEGIN
	   SELECT A.TN_CodDiscapacidad  AS Codigo,
	          B.TC_Descripcion  as Descripcion,
			  B.TF_Inicio_Vigencia as FechaActivacion,
			  B.TF_Fin_Vigencia  as FechaDesactivacion
	   from   Expediente.IntervinienteDiscapacidad A INNER JOIN 
	    Catalogo.Discapacidad B on A.TN_CodDiscapacidad = B.TN_CodDiscapacidad 
       Where TU_CodInterviniente  = @CodInterviniente
	 
END
GO
