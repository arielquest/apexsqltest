SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<07/12/2016>
-- Descripción :			<Consulta el funcionario actual asignado a un puesto de trabajo.> 
-- =================================================================================================================================================
-- Modificación :			<12/08/2020> <Isaac Dobles Mata> <Se agrega el código de asignación PuestoTrabajoFuncionario y las fechas de asignacion>
-- =================================================================================================================================================
-- Modificación :			<16/06/2022> <Jose Gabriel Cordero Soto> <Se agrega validacion de fechas de vigencia en cuanto a Funcionario>
-- =================================================================================================================================================
CREATE   FUNCTION [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo]
(	
	@CodPuestoTrabajo		varchar(14)
)
RETURNS TABLE
AS
RETURN 
(
	Select		A.TU_CodPuestoFuncionario			As Codigo,
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
	And			A.TF_Inicio_Vigencia				<= GETDATE()
	And			(A.TF_Fin_Vigencia					Is Null Or A.TF_Fin_Vigencia >= GETDATE())
	And			B.TF_Inicio_Vigencia				<= GETDATE()
	And			(B.TF_Fin_Vigencia					Is Null Or B.TF_Fin_Vigencia >= GETDATE())
)

GO
