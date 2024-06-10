SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<26/01/2016>
-- Descripción :			<Permite consultar los responsables de un expediente.
-- Modificación:			<23/02/2016> <Cambio en estructura de tabla con OficinaFuncionario>
-- Modificación:			<15/03/2016><Sigifredo Leitón Luna> <Se modifican los filtros de consulta, para que se realice por el codigo de oficina.
-- Modificación:			<05/04/2016> <Johan Acosta Ibañez> <Se modifica la relación con funcionario.
-- Modificación:			<20/07/2016> <Gerardo lopez> <Se quita relacion con oficina funcionario y se asocia a puesto trabajo>
-- Modificación				<Jonathan Aguilar Navarro> <01/06/2018> <Se cambia la información de oficina por contexto.> 
-- Modificación:			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificado por:			<25/03/2019> <Isaac Dobles> <Se ajusta para tabla Historico.ExpedienteAsignado.>
-- Modificado por:			<28/05/2019> <Jonathan Aguilar Navarro> Se cambio el tipo del parametro NumeroExpediente por varchar>
-- Modificado por:		    <05/08/2019> <Aida Elena Siles Rojas> Se realiza ajuste para que tome los activos e inactivos correctamente.
-- Modificado por:			<21/06/2020> <Daniel Ruiz Hernandez> Se agrega COLLATE DATABASE_DEFAULT a los campos que lo necesitan para corregir un error de diferencias de idioma.
-- Modificado por:			<20/08/2020> <Kirvin Bennett Mathurin> Se agrega el codigo y descripcion del tipo de puesto de trabajo en los valores de retorno
-- Modificado por:			<26/01/2021> <Karol Jim‚nez S nchez> Se corrige consulta de asignados inactivos, se agrega par‚ntesis al validar fechas
-- Modificado por:			<12/05/2021> <Johan Acosta Ibañez> Se agrega el retono de la nueva columna que indica si se asigno por reparto>
-- Modificado por:			<18/10/2021> <Jose Gabriel Cordero Soto> <Se agrega campo ESRESPONSABLE en resultado de la consulta>
-- Modificado por:			<19/11/2021> <Xinia Soto V> Se agrega convert a filtro de fecha fin asignado>
-- Modificado por:			<31/03/2022> <Luis Alonso Leiva Tames><Se agrega el filtro de codigo de contexto, esto para mostrar solo los asignados de un expediente de un contexto determinado>
-- =========================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarExpedienteAsignado]
    @CodPuestoTrabajo  				varchar(25)	= Null,
	@NumeroExpediente				varchar(14),
	@Fecha_Activacion				datetime2	= Null, 
	@CodContexto					varchar(4) = NULL
As
Begin
	Set NoCount ON

	--====================================================================================================================================
	-- DECLARACION DE VARIABLES Y TABLAS TEMPORALES
	--====================================================================================================================================

	DECLARE		@L_NumeroExpediente			VARCHAR(14)			= @NumeroExpediente,
				@L_Fecha_Activacion			DATETIME2			= @Fecha_Activacion,
				@L_CodPuestoTrabajo			VARCHAR(25)			= @CodPuestoTrabajo, 
				@L_CodContexto				VARCHAR(4)			= @CodContexto


	Create Table #Asignados
	(  
		--Asignado
		CodExpedienteAsignado			varchar(25), 
		FechaActivacion					Datetime2(7), 
		FechaDesActivacion				Datetime2(7),
		AsignadoPorReparto				bit,
		EsResponsable					BIT,
		CodContextoAsignado				VARCHAR(4),
	    --ExpedienteDetalle
		NumeroExpediente				char(14),
		CodProceso						smallint,
		DescripcionProceso				VarChar(100),
		Habilitado						bit,

		--Puesto Trabajo
		CodPuestoTrabajo				VarChar(14),
		DescripPuestoTrabajo			Varchar(255),

		--Contexto
		CodContexto						VarChar(4),
		NombreContexto					VarChar(255),
			
		--Tipo Funcionario
		CodTipoFuncionario				Smallint,
		DescripTipoFuncionario			Varchar(255),

		--PuestoTrabajoFuncionario
		CodPuestoTrabajoFuncionario		UniqueIdentifier,
		FecActivacion					Datetime2(7), 
		FecDesActivacion				Datetime2(7), 

		--Funcionario
		UsuarioRed						VarChar(30),
		Nombre							VarChar(50),
		PrimerApellido					VarChar(50),
		SegundoApellido					VarChar(50),
		CodPlaza						VarChar(20),

		--Tipo Puesto Trabajo
		CodTipoPuestoTrabajo			Smallint,
		DescripTipoPuestoTrabajo		Varchar(100)
	)

	--====================================================================================================================================
	-- CONSULTA FINAL
	--====================================================================================================================================

	--Codigo de puesto de trabajo
	If @CodPuestoTrabajo Is Not Null
	Begin
		Insert Into #Asignados
		(
				CodExpedienteAsignado,		
				FechaActivacion,		
				FechaDesActivacion,	
				AsignadoPorReparto,
				CodPuestoTrabajo,				
				NumeroExpediente,
				EsResponsable
		)
		Select	TC_CodPuestoTrabajo,	
				TF_Inicio_Vigencia, 
				TF_Fin_Vigencia,	
				TB_AsignadoPorReparto,
				TC_CodPuestoTrabajo,		    
				TC_NumeroExpediente,
				TB_EsResponsable
		From	Historico.ExpedienteAsignado					With(Nolock)
		Where	TC_CodPuestoTrabajo								= @CodPuestoTrabajo
		And		TC_NumeroExpediente								= @NumeroExpediente
	End

	--Los asignados activos de un expediente
	Else If  @Fecha_Activacion Is Null
	Begin
		Insert Into #Asignados
		(
				CodExpedienteAsignado,	
				FechaActivacion,	
				FechaDesActivacion,
				AsignadoPorReparto,
				CodPuestoTrabajo,		
				NumeroExpediente,
				EsResponsable, 
				CodContextoAsignado
		)
		Select	TC_CodPuestoTrabajo,	
				TF_Inicio_Vigencia, 
				TF_Fin_Vigencia,
				TB_AsignadoPorReparto,
				TC_CodPuestoTrabajo,		    
				TC_NumeroExpediente,
				TB_EsResponsable, 
				A.TC_CodContexto
		From	Historico.ExpedienteAsignado	A				With(Nolock) 
		Where	TC_NumeroExpediente								= @NumeroExpediente
		And		TF_Inicio_Vigencia								<=	CONVERT(DATETIME2(7), GETDATE())
		And		(TF_Fin_Vigencia Is Null	
		Or		TF_Fin_Vigencia  > CONVERT(DATETIME2(7), GETDATE()))
	End

	--Los asignados inactivos de un expediente
	If  @Fecha_Activacion Is Not Null
	Begin
		Insert Into #Asignados
		(
				CodExpedienteAsignado,	
				FechaActivacion,	
				FechaDesActivacion,
				AsignadoPorReparto,
				CodPuestoTrabajo,		
				NumeroExpediente,
				EsResponsable
		)
		Select	TC_CodPuestoTrabajo,	
				TF_Inicio_Vigencia, 
				TF_Fin_Vigencia,
				TB_AsignadoPorReparto,
				TC_CodPuestoTrabajo,		
				TC_NumeroExpediente,
				TB_EsResponsable
		From	Historico.ExpedienteAsignado					With(Nolock)
		Where	TC_NumeroExpediente								= @NumeroExpediente				
		And		(TF_Inicio_Vigencia								> CONVERT(DATETIME2(7), GETDATE())		
			Or		TF_Fin_Vigencia								< CONVERT(DATETIME2(7), GETDATE()))
	End

	-- Legajo
	Update		A
	Set			A.NumeroExpediente								= B.TC_NumeroExpediente,
				A.CodProceso									= B.TN_CodProceso,
				A.Habilitado									= B.TB_Habilitado
	From		#Asignados										A With(Nolock)
	Inner Join 	Expediente.ExpedienteDetalle					B With(Nolock)
	On			B.TC_NumeroExpediente COLLATE DATABASE_DEFAULT	= A.NumeroExpediente

	-- Expediente detalle
	Update		A
	Set			A.CodContexto									= B.TC_CodContexto
	From		#Asignados										A with(NoLock)
	Inner Join	Expediente.ExpedienteDetalle					B with (Nolock)
	on			B.TC_NumeroExpediente COLLATE DATABASE_DEFAULT	= A.NumeroExpediente 	

	-- Proceso
	Update		A
	Set			A.DescripcionProceso							= B.TC_Descripcion
	From		#Asignados										A With(Nolock)
	Inner Join 	Catalogo.Proceso								B With(Nolock)
	On			B.TN_CodProceso									= A.CodProceso

	-- Puesto tabajo
	Update		A
	Set			A.DescripPuestoTrabajo							= B.TC_Descripcion ,
				A.CodTipoFuncionario							= B.TN_CodTipoFuncionario, 
				A.CodTipoPuestoTrabajo							= C.TN_CodTipoPuestoTrabajo,
				A.DescripTipoPuestoTrabajo						= C.TC_Descripcion
	From		#Asignados										A With(Nolock)
	Inner Join	Catalogo.PuestoTrabajo  						B With(Nolock)
    On			B.TC_CodPuestoTrabajo COLLATE DATABASE_DEFAULT	= A.CodPuestoTrabajo  
	Left Join	Catalogo.TipoPuestoTrabajo						C With(Nolock)
	ON			B.TN_CodTipoPuestoTrabajo						= C.TN_CodTipoPuestoTrabajo 

    -- Contexto
	Update		A
	Set			A.NombreContexto								= B.TC_Descripcion
	From		#Asignados										A With(Nolock)
	Inner Join	Catalogo.Contexto								B With(Nolock)
	On			B.TC_CodContexto COLLATE DATABASE_DEFAULT		= A.CodContexto

	--Tipo Funcionario
	Update		A
	Set			A.DescripTipoFuncionario 						= B.TC_Descripcion
	From		#Asignados										A With(Nolock)
	Inner Join	Catalogo.TipoFuncionario  						B With(Nolock)
	On			B.TN_CodTipoFuncionario 						= A.CodTipoFuncionario 

	--Puesto Trabajo Funcionario activo
	Update		B
	Set      	B.CodPuestoTrabajoFuncionario					= A.TU_CodPuestoFuncionario,					
			    B.FecActivacion									= A.TF_Inicio_Vigencia,		
				B.FecDesactivacion								= A.TF_Fin_Vigencia,		 
				B.UsuarioRed									= C.TC_UsuarioRed,
				B.Nombre										= C.TC_Nombre,
				B.PrimerApellido								= C.TC_PrimerApellido,	
				B.SegundoApellido								= C.TC_SegundoApellido,
				B.CodPlaza										= C.TC_CodPlaza					 		 								
	From		#Asignados B
	Inner join	Catalogo.PuestoTrabajoFuncionario				As	A With(Nolock)
	On			B.CodPuestoTrabajo COLLATE DATABASE_DEFAULT		= 	A.TC_CodPuestoTrabajo				
	Inner Join	Catalogo.Funcionario							As	C With(Nolock)
	On			C.TC_UsuarioRed									=	A.TC_UsuarioRed	 
	Where		A.TF_Inicio_Vigencia							<	CONVERT(DATETIME2(7), GETDATE())
				And	   (A.TF_Fin_Vigencia is null 
				Or		A.TF_Fin_Vigencia >= CONVERT(DATETIME2(7), GETDATE()))	

	If   @CodPuestoTrabajo Is Null
	Begin	
		Select
		CodPuestoTrabajo										As CodExpedienteAsignado, 
		FechaActivacion,	  
		FechaDesactivacion,	
		AsignadoPorReparto,
		COALESCE(EsResponsable, 0)								As EsResponsable,
        'Split1'												As Split1,   
		CodPuestoTrabajoFuncionario								As Codigo,
		FecActivacion											As FechaActivacion,   
		FecDesActivacion										As FechaDesActivacion,  
		'Split2'												As Split2,
		UsuarioRed												As UsuarioRed,		                    
		Nombre													As Nombre,				  
		PrimerApellido											As PrimerApellido,
		SegundoApellido											As SegundoApellido,
		CodPlaza												AS CodPlaza,
		CodContexto												As CodContexto,
		NombreContexto											As NombreContexto,
		NumeroExpediente										As NumeroExpediente,
		CodProceso												As CodProceso,
		DescripcionProceso										As DescripcionProceso,
		Habilitado												As Habilitado,
		CodPuestoTrabajo										As CodPuestoTrabajo,
		DescripPuestoTrabajo									As DescripPuestoTrabajo,
		CodTipoFuncionario										As CodTipoFuncionario,
		DescripTipoFuncionario									As DescripTipoFuncionario,
		CodTipoPuestoTrabajo									As CodTipoPuestoTrabajo,
		DescripTipoPuestoTrabajo								As DescripTipoPuestoTrabajo
		From													#Asignados 
		Where CodContextoAsignado =								COALESCE(@L_CodContexto, CodContextoAsignado)
	End
	Else If @CodPuestoTrabajo Is Not Null
	Begin	
		Select	
		CodPuestoTrabajo										As CodExpedienteAsignado, 
		FechaActivacion,	  
		FechaDesactivacion,
		AsignadoPorReparto,
		COALESCE(EsResponsable, 0)								As EsResponsable,
		'Split1'												As Split1,   
		CodPuestoTrabajoFuncionario								As Codigo,
		FecActivacion											As FechaActivacion,   
		FecDesActivacion										As FechaDesActivacion,      
		'Split2'												As Split2,
		UsuarioRed												As UsuarioRed,		                    
		Nombre													As Nombre,				  
		PrimerApellido											As PrimerApellido,
		SegundoApellido											As SegundoApellido,
		CodPlaza												AS CodPlaza,
		CodContexto												As CodContexto,
		NombreContexto											As NombreContexto,
		NumeroExpediente										As NumeroExpediente,
		CodProceso												As CodProceso,
		DescripcionProceso										As DescripcionProceso,
		Habilitado												As Habilitado,
		CodPuestoTrabajo										As CodPuestoTrabajo,
		DescripPuestoTrabajo									As DescripPuestoTrabajo,
		CodTipoFuncionario										As CodTipoFuncionario,
		DescripTipoFuncionario									As DescripTipoFuncionario,
		CodTipoPuestoTrabajo									As CodTipoPuestoTrabajo,
		DescripTipoPuestoTrabajo								As DescripTipoPuestoTrabajo
		From													#Asignados 
		Where													CodPuestoTrabajo = @CodPuestoTrabajo
		AND CodContextoAsignado =								COALESCE(@L_CodContexto, CodContextoAsignado)
	End
	
	Drop Table #Asignados
	Set NoCount OFF
End
GO
