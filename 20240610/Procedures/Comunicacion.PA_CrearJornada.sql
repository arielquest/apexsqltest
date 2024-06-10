SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Gómez Gómez>
-- Fecha de creación:		<20/12/2016>
-- Descripción :			<Permite crear una nueva jornada de comunicaciones>
---------------------------------------------------------------------------------------------
-- Fecha :					<31/10/2017>
-- Modificado por:			<Diego Navarrete>
-- Descripción :			<Se agrega el campo [TF_Actualizacion] para actualizarlo>

-- Fecha :					<15/11/2017>
-- Modificado por:			<Jeffry Hernández>
-- Descripción :			<Se agrega parámetro @EstadoComunicacion>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_CrearJornada]
	@CodPuestoTrabajo		varchar(50),
	@FechaApertura			Datetime2,
	@Observaciones			varchar(250) = null,
	@ListaComunicaciones	varchar(max),
	@EstadoComunicacion		char
As
Begin
	Declare @UidJornada uniqueidentifier = newid();
Declare @CodComunicacion uniqueidentifier

	Begin Transaction 

	Begin Try

	Insert into [Comunicacion].JornadaComunicacion
				(TU_CodJornadaComunicacion
				,TC_CodPuestoTrabajo
				,TC_Observaciones
				,TF_Apertura)
	Values 
				(@UidJornada
				,@CodPuestoTrabajo
				,@Observaciones
				,@FechaApertura);

	With Cte_DetalleJornada as 
				(Select [value] as CodComunicacion, 
				        @UidJornada	as CodJornadaComunicacion
				From    string_split(@ListaComunicaciones,','))
		   
	Insert into Comunicacion.JornadaComunicacionDetalle 
				(TU_CodJornadaComunicacion
				,TU_CodComunicacion
				,TB_Realizada) 
	Select		CodJornadaComunicacion
				,CodComunicacion
				,0 From Cte_DetalleJornada;

	Update		[Comunicacion].Comunicacion
	set			[TC_Estado]			= @EstadoComunicacion,
				[TF_Actualizacion]	= GETDATE()
	where		TU_CodComunicacion in (Select [value] as CodComunicacion
				From string_split(@ListaComunicaciones,','))

	Commit Transaction 
	Select @UidJornada;

End Try
Begin Catch
	Rollback Tran 
	THROW;
End Catch
End

GO
