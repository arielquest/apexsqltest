SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta>
-- Fecha de creación:		<08/06/2016>
-- Descripción :			<Permite Consultar las tablas relacionadas con el interviniente
-- =================================================================================================================================================
-- Modificacion				<22/10/2019> <Isaac Dobles> <Se ajusta a estructura de intervenciones>
-- =================================================================================================================================================

  
CREATE PROCEDURE [Expediente].[PA_ConsultarTablasAsociadasInterviniente]
  @CodigoInterviniente uniqueidentifier
   As
Begin
 
	Declare @Resultado Varchar(Max);

	Declare @Tabla_Asociados Table
	(
		Nombre_Tabla			Varchar(150),
		TU_CodInterviniente		Uniqueidentifier,
		Count_Registros			Smallint	
	)
	
	Declare		@Nombre_Tabla	Varchar(150)

	Insert Into @Tabla_Asociados
	Select		'Delito',	TU_CodInterviniente,			Count(*)
	From		Expediente.IntervinienteDelito				With(NoLock)
	Where		TU_CodInterviniente							=	@CodigoInterviniente
	Group by	TU_CodInterviniente
	Having		(Count(*) > 0) 	

	Insert Into @Tabla_Asociados
	Select		'Visita carcelaria',	TU_CodInterviniente,			Count(*)
	From		Historico.Visita							With(NoLock)
	Where		TU_CodInterviniente							=	@CodigoInterviniente
	Group by	TU_CodInterviniente
	Having		(Count(*) > 0) 

	IF(Exists(Select * From @Tabla_Asociados))
		Set @Resultado = 'Se ha encontrado que el interviniente tiene datos asociados en: '

	While Exists(Select * From @Tabla_Asociados)
	Begin
		Set Rowcount 1
			Select @Nombre_Tabla = Nombre_Tabla From @Tabla_Asociados Order by Nombre_Tabla Asc
		Set Rowcount 0


		Set @Resultado = @Resultado + @Nombre_Tabla + ', ';


		Delete @Tabla_Asociados Where Nombre_Tabla = @Nombre_Tabla

	End

	Select SUBSTRING(@Resultado, 0, Len(@Resultado)) As Resultado

End


GO
