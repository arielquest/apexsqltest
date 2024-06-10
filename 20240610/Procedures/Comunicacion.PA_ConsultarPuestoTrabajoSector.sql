SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<06/02/2017>
-- Descripción :			<Permite consultar registros de Comunicacion.PuestoTrabajoSector.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarPuestoTrabajoSector]
	@CodPuestoTrabajo		varchar(14)		= Null,
	@CodSector				smallint	   = Null,
	@FechaAsociacion		datetime2		= Null
	 As
 Begin
 
	
		--Registros activos
	If @FechaAsociacion Is  Null  
	Begin
		Select		B.TC_CodPuestoTrabajo	As Codigo,
					B.TC_Descripcion		As Descripcion,
					B.TF_Inicio_Vigencia	As FechaActivacion,
					B.TF_Fin_Vigencia		As FechaDesactivacion,
					A.TF_Inicio_Vigencia	AS FechaAsociacion, 
					'Split'					As Split,
					C.TN_CodSector			As Codigo,
					c.TC_Descripcion		As Descripcion,
					c.TF_Inicio_Vigencia	AS FechaActivacion,
					c.TF_Fin_Vigencia		AS FechaDesactivacion

		From		Comunicacion.PuestoTrabajoSector	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo	 B With(NoLock)
		On			B.TC_CodPuestoTrabajo	= A.TC_CodPuestoTrabajo
		Inner Join	Comunicacion.Sector		c With(NoLock)
		On			c.TN_CodSector			= A.TN_CodSector
		Where		(a.TC_CodPuestoTrabajo	= @CodPuestoTrabajo
		or			a.TN_CodSector			= @CodSector)
		and 		A.TF_Inicio_Vigencia	<	GETDATE ()
		Order By	b.TC_Descripcion
	End
	else
		-- todos registros 	
		Select		B.TC_CodPuestoTrabajo	As Codigo,
					B.TC_Descripcion		As Descripcion,
					B.TF_Inicio_Vigencia	As FechaActivacion,
					B.TF_Fin_Vigencia		As FechaDesactivacion,
					A.TF_Inicio_Vigencia	AS FechaAsociacion, 
					'Split'					As Split,
					C.TN_CodSector			As Codigo,
					c.TC_Descripcion		As Descripcion,
					c.TF_Inicio_Vigencia	AS FechaActivacion,
					c.TF_Fin_Vigencia		AS FechaDesactivacion

		From		Comunicacion.PuestoTrabajoSector	A With(NoLock)
		Inner Join	Catalogo.PuestoTrabajo	 B With(NoLock)
		On			B.TC_CodPuestoTrabajo	= A.TC_CodPuestoTrabajo
		Inner Join	Comunicacion.Sector		c With(NoLock)
		On			c.TN_CodSector			= A.TN_CodSector
		Where		(a.TC_CodPuestoTrabajo	= @CodPuestoTrabajo
		or			a.TN_CodSector			= @CodSector)
		Order By	b.TC_Descripcion
			
 End
GO
