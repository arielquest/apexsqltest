SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<24/06/2019>
-- Descripción :			<Permite consultar las discapacidades de una representación
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_ConsultarRepresentacionDiscapacidad]
		@CodRepresentacion	uniqueidentifier
As
Begin
		Select		A.TN_CodDiscapacidad							As Codigo,
					B.TC_Descripcion								As Descripcion,
					B.TF_Inicio_Vigencia							As FechaActivacion,
					B.TF_Fin_Vigencia								As FechaDesactivacion

		From		DefensaPublica.RepresentacionDiscapacidad		A With (NoLock)
		Inner Join	Catalogo.Discapacidad							B With (NoLock)
		On			A.TN_CodDiscapacidad							= B.TN_CodDiscapacidad
		Where		A.TU_CodRepresentacion							= @CodRepresentacion
End
GO
