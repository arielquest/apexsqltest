SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<07/12/2016>
-- Descripción :			<Consulta el funcionario actual y futuro asignado a un puesto de trabajo.> 

CREATE FUNCTION [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajoFuturo]
(	
	@CodPuestoTrabajo		varchar(14)
)
RETURNS TABLE
AS
RETURN 
(
Select			Top(1)
				A.TU_CodPuestoFuncionario			As Codigo,
				B.TC_UsuarioRed						As UsuarioRed,
				B.TC_Nombre							As Nombre,
				B.TC_PrimerApellido					As PrimerApellido,
				B.TC_SegundoApellido				As SegundoApellido,
				B.TC_CodPlaza						As CodigoPlaza,
				B.TF_Inicio_Vigencia				As FechaActivacion,
				B.TF_Fin_Vigencia					As FechaDesactivacion,
				A.TF_Inicio_Vigencia				As FechaActivacionAsignacion,
				A.TF_Fin_Vigencia					As FechaDesactivacionAsignacion
	From		Catalogo.PuestoTrabajoFuncionario	A With(NoLock)
	Inner Join	Catalogo.Funcionario				B With(NoLock)
	On			B.TC_UsuarioRed						= A.TC_UsuarioRed
	Where		A.TC_CodPuestoTrabajo				= @CodPuestoTrabajo
	And			(A.TF_Inicio_Vigencia				<= GETDATE()
	And			(A.TF_Fin_Vigencia					Is Null Or A.TF_Fin_Vigencia >= GETDATE()) 
	OR			(A.TF_Inicio_Vigencia				>= GETDATE()))
	ORDER	by	A.TF_Inicio_Vigencia asc
)

GO
