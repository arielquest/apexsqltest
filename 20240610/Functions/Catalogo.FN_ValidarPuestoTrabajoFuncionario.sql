SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<07/12/2016>
-- Descripción :			<Valida si los datos se pueden insertar/modificar en PuestoTrabajoFuncionario, retorna 1 cuando es válido.> 
-- =================================================================================================================================================
-- Modificacion				<Jonathan Aguilar Navarro> <06/08/2018> <Se modifica por mejora de contextos.>
-- =================================================================================================================================================
CREATE FUNCTION [Catalogo].[FN_ValidarPuestoTrabajoFuncionario]
(
	@CodPuestoFuncionario		uniqueidentifier,
	@CodPuestoTrabajo			varchar(14),
	@UsuarioRed					varchar(30),
	@FechaActivacion			datetime2,
	@FechaDesactivacion			datetime2 = Null
)
RETURNS bit
AS
BEGIN
	Declare	@PuestoTrabajoValido	As bit = 0;
	Declare	@FuncionarioValido		As bit = 0;
	Declare @CodOficina				As Varchar (4) = NULL;
	Declare @FechaMaxima			As Datetime2 = '9999-12-31';

	If (@FechaActivacion >= @FechaDesactivacion)
	Begin
		Return 0;
	End

	Set	@PuestoTrabajoValido =	Cast(
									Case When Exists(
														Select		A.TU_CodPuestoFuncionario
														From		Catalogo.PuestoTrabajoFuncionario		A With(NoLock)
														Where		A.TU_CodPuestoFuncionario				<> @CodPuestoFuncionario
														And			A.TC_CodPuestoTrabajo					= @CodPuestoTrabajo
														And			(
																	((A.TF_Fin_Vigencia						Is Null) And
																	(A.TF_Inicio_Vigencia					< @FechaDesactivacion))
														Or			((A.TF_Inicio_Vigencia					Between @FechaActivacion And COALESCE(@FechaDesactivacion,@FechaMaxima)) Or
																	(A.TF_Fin_Vigencia						Between @FechaActivacion And COALESCE(@FechaDesactivacion,@FechaMaxima)))
																	)
													) Then 0
									Else 1 End
								As bit);

	if (@PuestoTrabajoValido = 1)
	Begin
		Select @CodOficina = A.TC_CodOficina From Catalogo.PuestoTrabajo A With(NoLock) Where A.TC_CodPuestoTrabajo = @CodPuestoTrabajo;

		Set @FuncionarioValido =	Cast(
										Case When Exists(
															Select		A.TU_CodPuestoFuncionario
															From		Catalogo.PuestoTrabajoFuncionario		A With(NoLock)
															Inner Join	Catalogo.PuestoTrabajo					B With(NoLock)
															On			B.TC_CodPuestoTrabajo					= A.TC_CodPuestoTrabajo
															Where		A.TU_CodPuestoFuncionario				<> @CodPuestoFuncionario
															And			A.TC_UsuarioRed							= @UsuarioRed
															And			B.TC_CodOficina							= @CodOficina
															And			(
																		((A.TF_Fin_Vigencia						Is Null) And
																		(A.TF_Inicio_Vigencia					< @FechaDesactivacion))
															Or			((A.TF_Inicio_Vigencia					Between @FechaActivacion And COALESCE(@FechaDesactivacion,@FechaMaxima)) Or
																		(A.TF_Fin_Vigencia						Between @FechaActivacion And COALESCE(@FechaDesactivacion,@FechaMaxima)))
																		)
														) Then 0
										Else 1 End
									As bit); 
	End
	
	Return @PuestoTrabajoValido & @FuncionarioValido;
END
GO
