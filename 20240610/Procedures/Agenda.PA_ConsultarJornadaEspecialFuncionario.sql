SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Wilbert Gamboa>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Este SP me permite recorrer una lIsta de TC_CodPuestoTrabajo de funciOnarios y extraer, para cada uno de ellos,> 
--                          <los cruces o choques de jOrnadAs especiales. Recibe como parámetro la lIsta de TC_CodPuestoTrabajo>
-- Modificacion:			<Se cambio el nombre del SP>
-- Modificado:              <14/09/2016><Diego Navarrete>
-- Descripción:				<se elimino el case se agrego la funcion FN_ObtenerDiaSemana>
-- ===========================================================================================
CREATE procedure [Agenda].[PA_ConsultarJornadaEspecialFuncionario]
	@FechaInicial Datetime2,
	@FechaFinal Datetime2,
	@usuarioRed Varchar(2000),
	@Color      Varchar(30)
As
Begin

	--Se esTablece que el primer día de la semana es el domingo
	Set Datefirst 7; 

	-- ******************  VARIABLES  **************************
	Declare @ContadorFecha Datetime2
	Set @ContadorFecha = @FechaInicial
	Declare @lIstaFunciOnariosParaJOrnadaEspecial Varchar(1000)
	-- ****************  FIN TABLAs TEMPOrALES  ************************

	-- ******************  TABLAs TEMPOrALES  **************************
	Declare @TablaTempOralOcupados As Table (FechaHOraInicio Datetime2, FechaHOraFin Datetime2)
	Declare @HOrarioOcupadoTrAslapes As Table (FechaHOraInicio Datetime2, FechaHOraFin Datetime2, ColOr Varchar(20));
	-- ****************  FIN TABLAs TEMPOrALES  ************************

	While @ContadorFecha <= @FechaFinal
	Begin

		;With 
		CTE_PUESTOS 
		As(
			Select	TC_CodPuestoTrabajo As Puesto
			From	[Catalogo].[PuestoTrabajoFuncionario]
			Where	TC_UsuarioRed = @usuarioRed
			And		TF_Inicio_Vigencia				<= GETDATE()
	        And		(
					TF_Fin_Vigencia					Is Null 
						Or
					TF_Fin_Vigencia					>= GETDATE()
					)
		)
	
		Insert Into @TablaTempOralOcupados ( FechaHOraInicio, FechaHOraFin)
		
		Select 
			Cast(Cast(Convert(Date,@ContadorFecha) As Varchar) + ' ' + Cast(JTE.TF_HOraInicio As Varchar)As Datetime2)  As INICIO,
			Cast(Cast(Convert(Date,@ContadorFecha) As Varchar) + ' ' + Cast(JTE.TF_HOraFin As Varchar)As Datetime2)     As FIN
		
		From	[AgEnda].[JOrnadaTrabajoEspecial] JTE
		Inner Join
				CTE_PUESTOS IDS 
		On		IDS.Puesto				=	JTE.TC_CodPuestoTrabajo

		Where 
			Agenda.FN_ObtenerDiaSemana(@ContadorFecha)= JTE.TC_DiAsemana

			And
			@ContadorFecha 
			Between JTE.TF_Inicio_Vigencia And JTE.TF_Fin_Vigencia

		Set  @ContadorFecha = Dateadd(Day, 1, @ContadorFecha)
	End

	--Obtiene el merge de horarios ocupados
	--Insertamos un color quemado para marcar las jornadAs especiales
	Insert Into @HOrarioOcupadoTrAslapes (FechaHOraInicio, FechaHOraFin, ColOr)

	Select 
	s1.FechaHOraInicio,
	Min(t1.FechaHOraFin) As FechaFin,
	@Color

	From @TablaTempOralOcupados s1 
	Inner Join @TablaTempOralOcupados t1 
	On s1.FechaHOraInicio <= t1.FechaHOraFin
	And 
	Not Exists(Select * 
				From @TablaTempOralOcupados t2 
				Where t1.FechaHOraFin >= t2.FechaHOraInicio 
				And
				t1.FechaHOraFin < t2.FechaHOraFin) 

	Where 
	Not Exists(Select * 
				From @TablaTempOralOcupados s2 
				Where s1.FechaHOraInicio > s2.FechaHOraInicio 
				And
				s1.FechaHOraInicio <= s2.FechaHOraFin) 
	Group By s1.FechaHOraInicio 
	Order By s1.FechaHOraInicio

	Select * From @HOrarioOcupadoTrAslapes
	
End
GO
