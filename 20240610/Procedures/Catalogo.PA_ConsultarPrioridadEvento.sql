SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<07/11/2016>
-- Descripción :			<Permite consultar registros de Catalogo.PrioridadEvento.> 
-- Modificado	:           <Se elimina>				 							
-- Modificación:            <10/10/2017><Diego Chavarria><Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPrioridadEvento]
	@CodPrioridadEvento		smallint		= Null,
	@Descripcion			varchar(150)	= Null,
	@FechaActivacion		datetime2		= Null,
	@FechaDesactivacion		datetime2		= Null
 As
 Begin
 
	Declare @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
		Select		A.TN_CodPrioridadEvento		As Codigo,
					A.TC_Descripcion			As Descripcion,
					A.TF_Inicio_Vigencia		As FechaActivacion,
					A.TF_Fin_Vigencia			As FechaDesactivacion
		From		Catalogo.PrioridadEvento	A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And         A.TN_CodPrioridadEvento = COALESCE(@CodPrioridadEvento,A.TN_CodPrioridadEvento)
		Order By	A.TC_Descripcion;
	End
	 
	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
		Select		A.TN_CodPrioridadEvento		As Codigo,
					A.TC_Descripcion			As Descripcion,
					A.TF_Inicio_Vigencia		As FechaActivacion,
					A.TF_Fin_Vigencia			As FechaDesactivacion
		From		Catalogo.PrioridadEvento	A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			A.TF_Inicio_Vigencia		< GETDATE ()
		And			(A.TF_Fin_Vigencia			Is Null Or A.TF_Fin_Vigencia >= GETDATE())
		And         A.TN_CodPrioridadEvento = COALESCE(@CodPrioridadEvento,A.TN_CodPrioridadEvento)
		Order By	A.TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodPrioridadEvento		As Codigo,
					A.TC_Descripcion			As Descripcion,
					A.TF_Inicio_Vigencia		As FechaActivacion,
					A.TF_Fin_Vigencia			As FechaDesactivacion
		From		Catalogo.PrioridadEvento	A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
	    And			(A.TF_Inicio_Vigencia		> GETDATE() Or A.TF_Fin_Vigencia < GETDATE())
		And         A.TN_CodPrioridadEvento = COALESCE(@CodPrioridadEvento,A.TN_CodPrioridadEvento)
		Order By	A.TC_Descripcion;
	End

	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodPrioridadEvento		As Codigo,
					A.TC_Descripcion			As Descripcion,
					A.TF_Inicio_Vigencia		As FechaActivacion,
					A.TF_Fin_Vigencia			As FechaDesactivacion
		From		Catalogo.PrioridadEvento	A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(A.TF_Fin_Vigencia			<= @FechaDesactivacion And A.TF_Inicio_Vigencia >= @FechaActivacion)
		And         A.TN_CodPrioridadEvento = COALESCE(@CodPrioridadEvento,A.TN_CodPrioridadEvento)
		Order By	A.TC_Descripcion;
	End
			
 End





GO
