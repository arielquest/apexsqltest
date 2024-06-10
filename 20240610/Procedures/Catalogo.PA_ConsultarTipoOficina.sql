SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez Espinoza>
-- Fecha de creación:		<07/08/2015>
-- Descripción :			<Permite Consultar un TipoDespacho> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Incluir el filtro por fecha de activación> 
-- Modificado:				<Alejandro Villalta Ruiz><18/12/2015><Autogenerar el codigo del tipo de oficina>
-- Modificado por:			<Donald Vargas Zúñiga>
-- Fecha de creación:		<03/02/2016>
-- Descripción :			<En la consulta de "Todos" se agrega el parámetro @FechaActivacion y se corrige el alias de las columnas de materia> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<30/08/2017> <Diego Navarrete> <Se eliminan los datos de Materia de la consulta>
-- Modificación:			<04/10/2017> <Diego Navarrete> <Se elimina la consulta única por codigo. Se agrega el filtro código en todas las consultas.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoOficina]
	@Codigo smallint=Null,
	@Descripcion Varchar(255)=Null,
	@FechaActivacion datetime2(3)	= Null,
	@FechaVencimiento Datetime2= Null
 As
 Begin
  
  --Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaVencimiento Is Null
	Begin	
			SELECT		Catalogo.TipoOficina.TN_CodTipoOficina AS Codigo, 
						Catalogo.TipoOficina.TC_Descripcion AS Descripcion, 
						Catalogo.TipoOficina.TF_Inicio_Vigencia AS FechaActivacion, 
						Catalogo.TipoOficina.TF_Fin_Vigencia AS FechaDesactivacion					
			FROM		Catalogo.TipoOficina 
			Where		dbo.FN_RemoverTildes(Catalogo.TipoOficina.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			Catalogo.TipoOficina.TN_CodTipoOficina =COALESCE(@Codigo,TN_CodTipoOficina)
			Order By	Catalogo.TipoOficina.TC_Descripcion;
	End
		
	--Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaVencimiento Is Null And @FechaActivacion Is Not Null
	Begin
			SELECT		Catalogo.TipoOficina.TN_CodTipoOficina AS Codigo, 
						Catalogo.TipoOficina.TC_Descripcion AS Descripcion, 
						Catalogo.TipoOficina.TF_Inicio_Vigencia AS FechaActivacion, 
						Catalogo.TipoOficina.TF_Fin_Vigencia AS FechaDesactivacion

			FROM		Catalogo.TipoOficina 						
			where		dbo.FN_RemoverTildes(Catalogo.TipoOficina.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			Catalogo.TipoOficina.TF_Inicio_Vigencia		< GETDATE ()
			And			(	Catalogo.TipoOficina.TF_Fin_Vigencia		Is Null 
						OR	Catalogo.TipoOficina.TF_Fin_Vigencia		>= GETDATE ())
			And			Catalogo.TipoOficina.TN_CodTipoOficina =COALESCE(@Codigo,TN_CodTipoOficina)
			Order By	Catalogo.TipoOficina.TC_Descripcion;
	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Null
	Begin
			SELECT		Catalogo.TipoOficina.TN_CodTipoOficina AS Codigo, 
						Catalogo.TipoOficina.TC_Descripcion AS Descripcion, 
						Catalogo.TipoOficina.TF_Inicio_Vigencia AS FechaActivacion, 
						Catalogo.TipoOficina.TF_Fin_Vigencia AS FechaDesactivacion
					
			FROM		Catalogo.TipoOficina 
			where		dbo.FN_RemoverTildes(Catalogo.TipoOficina.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(	Catalogo.TipoOficina.TF_Inicio_Vigencia  > GETDATE ()
						Or	Catalogo.TipoOficina.TF_Fin_Vigencia  < GETDATE ())
			And			Catalogo.TipoOficina.TN_CodTipoOficina =COALESCE(@Codigo,TN_CodTipoOficina)
			Order By	Catalogo.TipoOficina.TC_Descripcion;
	End
	Else If @FechaVencimiento Is Not Null And @FechaActivacion Is Not Null
	Begin
			SELECT		Catalogo.TipoOficina.TN_CodTipoOficina AS Codigo, 
						Catalogo.TipoOficina.TC_Descripcion AS Descripcion, 
						Catalogo.TipoOficina.TF_Inicio_Vigencia AS FechaActivacion, 
						Catalogo.TipoOficina.TF_Fin_Vigencia AS FechaDesactivacion

			FROM		Catalogo.TipoOficina 
			where		dbo.FN_RemoverTildes(Catalogo.TipoOficina.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			Catalogo.TipoOficina.TF_Inicio_Vigencia	>= @FechaActivacion
			And			Catalogo.TipoOficina.TF_Fin_Vigencia		<= @FechaVencimiento 
			And			Catalogo.TipoOficina.TN_CodTipoOficina =COALESCE(@Codigo,TN_CodTipoOficina)
			Order By	Catalogo.TipoOficina.TC_Descripcion;
	End
			
 End

GO
