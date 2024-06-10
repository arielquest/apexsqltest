SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Adrián Arias Abarca>
-- Fecha Creación:	<11/12/2019>
-- Descripcion:		<Consultar los documentos sin expediente trasladados a otra oficina - Bug 180>
-- =================================================================================================================================================
-- Modificación		<Xinia Soto V> <13/08/2020> <Se corrige filtro de rango de fechas>
-- Modificación		<Daniel Ruiz Hernandez> <19/08/2020> <se modifica filtro por despachos>
-- Modificación		<Fabian Sequeira Gamboa> <19/08/2021> <Se modifica la cantidad de caracteres a recibir por placa y boleta>
--===================================================================================================================================================


CREATE Procedure [ArchivoSinExpediente].[PA_ConsultarDocumentosSinExpedienteTrasladados]
	@CodArchivo						Uniqueidentifier		=	NULL,
	@Condicion						Char(1)					=	NULL,
	@BoletaCitacion					Varchar(29)				=	NULL,
	@PlacaVehiculo					Varchar(20)				=	NULL,
	@FechaColision					Datetime2				=	NULL,
	@FechaRegistroInicio			Datetime2				=	NULL,
	@FecharegistroFinal				Datetime2				=	NULL,
	@CodContextoCrea				Varchar(4)				=	NULL,
	@TipoIdentificacion				Varchar(2)				=	NULL,
	@Identificacion					Varchar(15)				=	NULL,
	@ServidorJudicial				Varchar(15)				=	NULL,			
	@Descripcion					Varchar(255)			=	NULL,
	@IndicePagina					Smallint				=	NULL,
	@CantidadPagina					Smallint				=	NULL

As
Begin
	Declare @CodArchivoD				Uniqueidentifier		=	@CodArchivo,
			@CondicionD					Char(1)					=	@Condicion,
			@BoletaCitacionD			Varchar(29)				=	@BoletaCitacion,
			@PlacaVehiculoD				Varchar(20)				=	@PlacaVehiculo,
			@FechaColisionD				Datetime2				=	@FechaColision,
			@FechaRegistroInicioD		Datetime2				=	@FechaRegistroInicio,
			@FecharegistroFinalD		Datetime2				=	@FecharegistroFinal,
			@CodContextoCreaD			Varchar(4)				=	@CodContextoCrea,
			@TipoIdentificacionD		Varchar(2)				=	@TipoIdentificacion,
			@IdentificacionD			Varchar(15)				=	@Identificacion,
			@ServidorJudicialD			Varchar(15)				=	@ServidorJudicial,			
			@DescripcionD				Varchar(255)			=	@Descripcion,
			@IndicePaginaD				Smallint				=	@IndicePagina,
			@CantidadPaginaD			Smallint				=	@CantidadPagina,
  			@DescripcionLike			varchar(255)
	
	Set		@DescripcionLike			= iIf(@DescripcionD Is Not Null,'%' + @DescripcionD + '%','%')

	If (@IndicePaginaD Is Null Or @CantidadPaginaD Is Null)
	Begin
		SET @IndicePaginaD				= 0;
		SET @CantidadPaginaD			= 32767;
	End

		--Sin Fechas de registro
	If @FechaRegistroInicioD is NULL and @FecharegistroFinalD is null
	Begin

		Select		A.TU_CodArchivo									As	Codigo, 
					C.TC_BoletaCitacion								As	BoletaCitacion, 
					C.TC_PlacaVehiculo								As	PlacaVehiculo, 
					C.TF_Colision									As	FechaColision, 
					'Split'											As	Split,
					B.TC_Descripcion								As	Descripcion, 
					B.TF_FechaCrea									As	FechaCrea, 
					B.TN_CodEstado									As	Estado, 
					'Split'											As	Split,
					B.TN_CodFormatoArchivo							As	Codigo, 
					'Split'											As	Split,
					D.TC_CodContexto								As	Codigo, 
					D.TC_Descripcion								As	Descripcion, 
					'Split'											As	Split,
					A.TC_UsuarioRed									As	UsuarioRed, 
					E.TC_Nombre										As	Nombre, 
					E.TC_PrimerApellido								As	PrimerApellido, 
					E.TC_SegundoApellido							As	SegundoApellido, 
					'Split'											As	Split,
					F.TC_NumeroExpediente							As	NumeroExpediente, 
					C.TC_Condicion									As	Condicion, 
					COUNT(*) OVER()									As	Total
		From		Historico.ArchivoSinExpedienteMovimiento		A	With(NoLock)		
		Inner Join	Archivo.Archivo									B	With(NoLock)
		On			A.TU_CodArchivo									=	B.TU_CodArchivo		
		Inner Join	ArchivoSinExpediente.ArchivoSinExpediente		C	With(NoLock)
		On			A.TU_CodArchivo									=	C.TU_CodArchivo		
		Inner Join	Catalogo.Contexto								D	With(NoLock)
		On			B.TC_CodContextoCrea							=	D.TC_CodContexto		
		Inner Join	Catalogo.Funcionario							E	With(NoLock)
		On			A.TC_UsuarioRed									=	E.TC_UsuarioRed		
		left Join	Expediente.ArchivoExpediente					F	With(NoLock)
		On			F.TU_CodArchivo									=	A.TU_CodArchivo		
		Where		A.TC_CodContexto								=	COALESCE(@CodContextoCreaD, A.TC_CodContexto)
		And			B.TC_CodContextoCrea							!=	COALESCE(@CodContextoCreaD, A.TC_CodContexto)
		And			A.TU_CodArchivo									=	COALESCE(@CodArchivoD, A.TU_CodArchivo)
		And			C.TC_Condicion									=	COALESCE(@CondicionD, C.TC_Condicion)
		And			COALESCE(C.TC_BoletaCitacion,'')				=	COALESCE(@BoletaCitacionD, C.TC_BoletaCitacion,'')							
		And			COALESCE(C.TC_PlacaVehiculo,'')					=	COALESCE(@PlacaVehiculoD, C.TC_PlacaVehiculo,'')
		And			COALESCE(Cast(C.TF_Colision as Date),'')		=	COALESCE(Cast(@FechaColisionD As Date), Cast(C.TF_Colision As Date),'')
		And			B.TC_Descripcion								Like @DescripcionLike
		And			(@TipoIdentificacionD							IS NULL OR 
					A.TU_CodArchivo									IN (SELECT	PU.TU_CodArchivo 
																		FROM	ArchivoSinExpediente.PersonaUsuaria PU 
																		WHERE	TN_CodTipoIdentificacion = @TipoIdentificacionD))
		And			(@IdentificacionD								IS NULL OR 
					A.TU_CodArchivo									IN (SELECT	PU.TU_CodArchivo 
																		FROM	ArchivoSinExpediente.PersonaUsuaria PU 
																		WHERE	TC_Identificacion = @IdentificacionD))
		And			A.TC_UsuarioRed									=	COALESCE(@ServidorJudicialD, A.TC_UsuarioRed)								
		And			A.TF_Movimiento									=	(Select Max(TF_Movimiento) 
																		 From	Historico.ArchivoSinExpedienteMovimiento
																		 Where	[TU_CodArchivo] = A.TU_CodArchivo 
																		 AND TC_CodContexto = A.TC_CodContexto)
		Order By													B.TC_Descripcion asc
		Offset		@IndicePaginaD * @CantidadPaginaD Rows
		Fetch Next	@CantidadPaginaD Rows Only;
	End
	Else
	Begin
		Select		A.TU_CodArchivo									As	Codigo, 
					C.TC_BoletaCitacion								As	BoletaCitacion, 
					C.TC_PlacaVehiculo								As	PlacaVehiculo, 
					C.TF_Colision									As	FechaColision, 
					'Split'											As	Split,
					B.TC_Descripcion								As	Descripcion, 
					B.TF_FechaCrea									As	FechaCrea, 
					B.TN_CodEstado									As	Estado, 
					'Split'											As	Split,
					B.TN_CodFormatoArchivo							As	Codigo, 
					'Split'											As	Split,
					D.TC_CodContexto								As	Codigo, 
					D.TC_Descripcion								As	Descripcion, 
					'Split'											As	Split,
					A.TC_UsuarioRed									As	UsuarioRed, 					
					'Split'											As	Split,
					E.TC_NumeroExpediente							As	NumeroExpediente, 
					C.TC_Condicion									As	Condicion, 
					COUNT(*) OVER()									As	Total
		From		Historico.ArchivoSinExpedienteMovimiento		A	With(NoLock)		
		Inner Join	Archivo.Archivo									B	With(NoLock)
		On			A.TU_CodArchivo									=	B.TU_CodArchivo		
		Inner Join	ArchivoSinExpediente.ArchivoSinExpediente		C	With(NoLock)
		On			A.TU_CodArchivo									=	C.TU_CodArchivo		
		Inner Join	Catalogo.Contexto								D	With(NoLock)
		On			B.TC_CodContextoCrea							=	D.TC_CodContexto		
		left Join	Expediente.ArchivoExpediente					E	With(NoLock)
		On			E.TU_CodArchivo									=	A.TU_CodArchivo		
		Where		A.TC_CodContexto								=	COALESCE(@CodContextoCreaD, A.TC_CodContexto)
		And			B.TC_CodContextoCrea							!=	COALESCE(@CodContextoCreaD, A.TC_CodContexto)
		And			A.TU_CodArchivo									=	COALESCE(@CodArchivoD, A.TU_CodArchivo)
		And			C.TC_Condicion									=	COALESCE(@CondicionD, C.TC_Condicion)
		And			COALESCE(C.TC_BoletaCitacion,'')				=	COALESCE(@BoletaCitacionD, C.TC_BoletaCitacion,'')							
		And			COALESCE(C.TC_PlacaVehiculo,'')					=	COALESCE(@PlacaVehiculoD, C.TC_PlacaVehiculo,'')
		And			COALESCE(Cast(C.TF_Colision as Date),'')		=	COALESCE(Cast(@FechaColisionD As Date), Cast(C.TF_Colision As Date),'')
		And			B.TF_FechaCrea									>=	@FechaRegistroInicioD And
					B.TF_FechaCrea									<=	dateadd(d,1,@FecharegistroFinalD)
		And			B.TC_Descripcion								Like @DescripcionLike
		And			(@TipoIdentificacionD							IS	NULL OR 
					A.TU_CodArchivo									IN	(SELECT	PU.TU_CodArchivo 
																		FROM	ArchivoSinExpediente.PersonaUsuaria PU 
																		WHERE	TN_CodTipoIdentificacion = @TipoIdentificacionD))
		And			(@IdentificacionD								IS	NULL OR 
					A.TU_CodArchivo									IN	(SELECT	PU.TU_CodArchivo 
																		FROM	ArchivoSinExpediente.PersonaUsuaria PU 
																		WHERE	TC_Identificacion = @IdentificacionD))
		And			A.TC_UsuarioRed									=	COALESCE(@ServidorJudicialD, A.TC_UsuarioRed)								
		And			A.TF_Movimiento									=	(Select Max(TF_Movimiento) 
																		 From	Historico.ArchivoSinExpedienteMovimiento
																		 Where	[TU_CodArchivo] = A.TU_CodArchivo 
																		 AND TC_CodContexto = A.TC_CodContexto)
		Order By													B.TC_Descripcion asc
		Offset		@IndicePaginaD * @CantidadPaginaD Rows
		Fetch Next	@CantidadPaginaD Rows Only;
	End
End	
GO
