SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<21/06/2019>
-- Descripción :			<Permite consultar las vulnerabilidades de una representación
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ConsultarRepresentacionVulnerabilidad]
		@CodRepresentacion	uniqueidentifier
As
Begin
		Select		A.TN_CodVulnerabilidad							As Codigo,
					B.TC_Descripcion								As Descripcion,
					B.TF_Inicio_Vigencia							As FechaActivacion,
					B.TF_Fin_Vigencia								As FechaDesactivacion

		From		DefensaPublica.RepresentacionVulnerabilidad		A With (NoLock)
		Inner Join	Catalogo.Vulnerabilidad							B With (NoLock)
		On			A.TN_CodVulnerabilidad							= B.TN_CodVulnerabilidad	    
		Where		A.TU_CodRepresentacion							= @CodRepresentacion		 
End
GO
