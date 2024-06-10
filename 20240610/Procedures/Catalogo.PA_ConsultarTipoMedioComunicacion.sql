SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Mendez Chavarria>
-- Fecha de creación:	<10/09/2015>
-- Descripción :		<Permite Consultar los medios de comunicacion de la tabla Catalogo.MedioComunicacion> 
-- =================================================================================================================================================
-- Modificacion:		<22/10/2015> <Gerardo Lopez> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificacion:		<11/01/2016> <Alejandro Villalta> <Modificar el tipo de dato del codigo de medio de comunicacion.>
-- Modificación:		<04-03-2016> <Andrés Díaz> <Se agrega el campo TipoMedio. Se cambia la descripción a varchar(50).> 
-- Modificación:		<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:		<15-07-2016> <Andrés Díaz> <Se agregan los campos TB_TieneHorarioEspecial y TB_RequiereCopias.>
-- Modificación:		<02-12-2016> <Pablo Alvarez> <Se modifica TN_CodMedioComunicación por estandar.>
-- Modificación:		<19-01-2017> <Pablo Alvarez> <Se camnbia TB_RequiereCopias por PermiteCopias.>
-- Modificación:		<20-01-2017> <Pablo Alvarez> <Se camnbia el nombre del SP MedioComunicacion a TipoMedioComunicación.>											
-- Modificación:        <03/10/2017> <Diego Chavarria> <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--						también se elimina el IF Null de Código del select Todos>
-- Modificación:		<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:		<22-05-2018> <Andrés Díaz> <Se tabula la consulta. Se agrega "With(NoLock)" a la consulta.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoMedioComunicacion]
	@Codigo					smallint	= Null,
	@Descripcion			varchar(50)	= Null,			
	@FechaActivacion		datetime2	= Null,
	@FechaDesactivacion		datetime2	= Null
 As
Begin
	
	DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null  
	Begin
			Select		TN_CodMedio						As	Codigo,				
						TC_Descripcion					As	Descripcion,		
						TB_TieneHorarioEspecial			As TieneHorarioEspecial,
						TB_PermiteCopias				As PermiteCopias,
						TF_Inicio_Vigencia				As	FechaActivacion,	
						TF_Fin_Vigencia					As	FechaDesactivacion,
						'Split'							As	Split,				
						TC_TipoMedio					As	TipoMedio
			From		Catalogo.TipoMedioComunicacion	A With(NoLock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion)
														Like dbo.FN_RemoverTildes(@ExpresionLike)
			And         TN_CodMedio						= COALESCE(@Codigo,TN_CodMedio)
			Order By	TC_Descripcion;
	End

	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodMedio						As	Codigo,				
						TC_Descripcion					As	Descripcion,		
						TB_TieneHorarioEspecial			As TieneHorarioEspecial,
						TB_PermiteCopias				As PermiteCopias,
						TF_Inicio_Vigencia				As	FechaActivacion,	
						TF_Fin_Vigencia					As	FechaDesactivacion,
						'Split'							As	Split,				
						TC_TipoMedio					As	TipoMedio
			From		Catalogo.TipoMedioComunicacion	A With(NoLock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion)
														Like dbo.FN_RemoverTildes(@ExpresionLike)
			And         TN_CodMedio						= COALESCE(@Codigo,TN_CodMedio)
			And			TF_Inicio_Vigencia				< GETDATE ()
			And			(TF_Fin_Vigencia				Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodMedio						As	Codigo,				
						TC_Descripcion					As	Descripcion,		
						TB_TieneHorarioEspecial			As TieneHorarioEspecial,
						TB_PermiteCopias				As PermiteCopias,
						TF_Inicio_Vigencia				As	FechaActivacion,	
						TF_Fin_Vigencia					As	FechaDesactivacion,
						'Split'							As	Split,				
						TC_TipoMedio					As	TipoMedio
			From		Catalogo.TipoMedioComunicacion	A With(NoLock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion)
														Like dbo.FN_RemoverTildes(@ExpresionLike)
			And         TN_CodMedio						= COALESCE(@Codigo,TN_CodMedio)
			And			(TF_Inicio_Vigencia				> GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodMedio						As	Codigo,				
						TC_Descripcion					As	Descripcion,		
						TB_TieneHorarioEspecial			As TieneHorarioEspecial,
						TB_PermiteCopias				As PermiteCopias,
						TF_Inicio_Vigencia				As	FechaActivacion,	
						TF_Fin_Vigencia					As	FechaDesactivacion,
						'Split'							As	Split,				
						TC_TipoMedio					As	TipoMedio
			From		Catalogo.TipoMedioComunicacion	A With(NoLock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion)
														Like dbo.FN_RemoverTildes(@ExpresionLike)
			And         TN_CodMedio						= COALESCE(@Codigo,TN_CodMedio)
			And			(TF_Fin_Vigencia				<= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	TC_Descripcion;
	End
End


GO
