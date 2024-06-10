SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/12/2016>
-- Descripción :			<Permite consultar registros de Comunicacion.Perimetro.> 
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarPerimetro]
	@CodPerimetro			smallint		= Null,
	@Descripcion			varchar(100)	= Null,
	@CodOficinaOCJ			varchar(4)		= Null,
	@FechaActivacion		datetime2		= Null,
	@FechaDesactivacion		datetime2		= Null
 As
 Begin
 
	Declare @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaActivacion Is Null And @FechaDesactivacion Is Null And @CodPerimetro Is Null  
	Begin
		Select		A.TN_CodPerimetro		As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TC_CodOficina			As Codigo,
					B.TC_Nombre				As Descripcion
		From		Comunicacion.Perimetro	A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		Where		A.TC_Descripcion		Like @ExpresionLike
		And			A.TC_CodOficinaOCJ		= ISNULL(@CodOficinaOCJ, A.TC_CodOficinaOCJ)
		Order By	A.TC_Descripcion;
	End
	 
	--Por Llave
	Else If  @CodPerimetro Is Not Null
	Begin
		Select		A.TN_CodPerimetro		As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TC_CodOficina			As Codigo,
					B.TC_Nombre				As Descripcion
		From		Comunicacion.Perimetro	A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		Where		A.TN_CodPerimetro		= @CodPerimetro
		And			A.TC_CodOficinaOCJ		= ISNULL(@CodOficinaOCJ, A.TC_CodOficinaOCJ)
		Order By	A.TC_Descripcion;
	End

	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
		Select		A.TN_CodPerimetro		As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TC_CodOficina			As Codigo,
					B.TC_Nombre				As Descripcion
		From		Comunicacion.Perimetro	A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		Where		A.TC_Descripcion		Like @ExpresionLike 
		And			A.TF_Inicio_Vigencia	< GETDATE ()
		And			(A.TF_Fin_Vigencia		Is Null Or A.TF_Fin_Vigencia >= GETDATE())
		And			A.TC_CodOficinaOCJ		= ISNULL(@CodOficinaOCJ, A.TC_CodOficinaOCJ)
		Order By	A.TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodPerimetro		As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TC_CodOficina			As Codigo,
					B.TC_Nombre				As Descripcion
		From		Comunicacion.Perimetro	A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		Where		A.TC_Descripcion		Like @ExpresionLike 
	    And			(A.TF_Inicio_Vigencia	> GETDATE() Or A.TF_Fin_Vigencia < GETDATE())
		And			A.TC_CodOficinaOCJ		= ISNULL(@CodOficinaOCJ, A.TC_CodOficinaOCJ)
		Order By	A.TC_Descripcion;
	End

	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodPerimetro		As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TC_CodOficina			As Codigo,
					B.TC_Nombre				As Descripcion
		From		Comunicacion.Perimetro	A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		Where		A.TC_Descripcion		Like @ExpresionLike 
		And			(A.TF_Fin_Vigencia		<= @FechaDesactivacion And A.TF_Inicio_Vigencia >= @FechaActivacion)
		And			A.TC_CodOficinaOCJ		= ISNULL(@CodOficinaOCJ, A.TC_CodOficinaOCJ)
		Order By	A.TC_Descripcion;
	End
			
 End




GO
