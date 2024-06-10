SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta I>
-- Fecha de creación:		<26/07/2016>
-- Descripción :			<Permite consultar Puesto de trabajo por funcionario para validar si no estan ocupados>
-- =================================================================================================================================================
-- Modificacion:			<11-08-2020> <Isaac Dobles> <Se modifica para validacion para rango de fechas en caso que venga el usuario>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ValidaAsignacionPuestoTrabajoFuncionario]
	@CodOficina			Varchar(4),
	@CodPuestoTrabajo	Varchar(14)=Null,
	@UsuarioRed			Varchar(30)=Null,
	@FechaActivacion	Datetime2, 
	@FechaDesactivacion	Datetime2=Null 
 As
 Begin 	
	if (@UsuarioRed Is Not null)
	Begin
			If(@FechaDesactivacion is null)
			Begin
				Select		A.TU_CodPuestoFuncionario			As	Codigo,					A.TF_Inicio_Vigencia	As	FechaActivacion,		
							A.TF_Fin_Vigencia					As	FechaDesactivacion			
				From		Catalogo.PuestoTrabajoFuncionario	As	A With(Nolock)
				Inner Join	Catalogo.PuestoTrabajo				As	B With(Nolock)
				ON			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
				Where		A.TC_UsuarioRed						=	@UsuarioRed
				And			B.TC_CodOficina						=	@CodOficina
				And			( (A.TF_Inicio_Vigencia				<=	@FechaActivacion
				And			(A.TF_Fin_Vigencia	Is	Null )))
				or
				(		(A.TF_Inicio_Vigencia				>	@FechaActivacion
				 And			(A.TF_Fin_Vigencia	Is	Null or A.TF_Fin_Vigencia >getdate())))
			End
			else
			Begin
				Select		A.TU_CodPuestoFuncionario			As	Codigo,					A.TF_Inicio_Vigencia	As	FechaActivacion,		
							A.TF_Fin_Vigencia					As	FechaDesactivacion			
				From		Catalogo.PuestoTrabajoFuncionario	As	A With(Nolock)
				Inner Join	Catalogo.PuestoTrabajo				As	B With(Nolock)
				ON			B.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
				Where		A.TC_UsuarioRed						=	@UsuarioRed
				And			B.TC_CodOficina						=	@CodOficina
				And			( 
								(	
									A.TF_Inicio_Vigencia		between 	@FechaActivacion and @FechaDesactivacion							
								)
								Or  
								(	
									A.TF_Inicio_Vigencia				<	@FechaActivacion
									)	
							)
				And			( A.TF_Fin_Vigencia >= GETDATE() OR A.TF_Fin_Vigencia IS NULL)
			End
	End
	Else If (@CodPuestoTrabajo Is Not Null)
	Begin	
			If(@FechaDesactivacion is null)
			Begin
				Select		A.TU_CodPuestoFuncionario			As	Codigo,					A.TF_Inicio_Vigencia	As	FechaActivacion,		
							A.TF_Fin_Vigencia					As	FechaDesactivacion			
				From		Catalogo.PuestoTrabajoFuncionario	As	A With(Nolock)
				Inner Join	Catalogo.PuestoTrabajo				As	B With(Nolock)
				ON			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
				Where		A.TC_CodPuestoTrabajo				=	@CodPuestoTrabajo
				And			B.TC_CodOficina						=	@CodOficina
				And			( (A.TF_Inicio_Vigencia				<=	@FechaActivacion
				And			(A.TF_Fin_Vigencia	Is	Null )))
				or
				(		(A.TF_Inicio_Vigencia				>	@FechaActivacion
				 And			(A.TF_Fin_Vigencia	Is	Null )))--or A.TF_Fin_Vigencia >getdate())))
			End
			else
			Begin
				Select		A.TU_CodPuestoFuncionario			As	Codigo,					A.TF_Inicio_Vigencia	As	FechaActivacion,		
							A.TF_Fin_Vigencia					As	FechaDesactivacion			
				From		Catalogo.PuestoTrabajoFuncionario	As	A With(Nolock)
				Inner Join	Catalogo.PuestoTrabajo				As	B With(Nolock)
				ON			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
				Where		A.TC_CodPuestoTrabajo				=	@CodPuestoTrabajo
				And			B.TC_CodOficina						=	@CodOficina
				and         (A.TF_Fin_Vigencia is null )
				And			( 
								(	
									A.TF_Inicio_Vigencia		between 	@FechaActivacion and @FechaDesactivacion							
								)
								Or  
								(	
									A.TF_Inicio_Vigencia				<	@FechaActivacion
									)	
							)		
			End
	End
End

GO
