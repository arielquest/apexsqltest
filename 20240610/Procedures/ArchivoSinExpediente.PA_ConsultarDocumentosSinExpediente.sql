SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================================================  
-- Autor:			<Jonathan Aguilar Navarro>  
-- Fecha Creación:	<04/10/2018>  
-- Descripcion:		<Consultar los documentos sin expediente>  
-- Modificación		<Isaac Dobles Mata> <20/0/2018> Se agrega Nombre y Apellidos del funcionario  
-- Modificacion		<Jonathan Aguilar Navarro> <30/11/2018> <Se agrega el coalesce para comparar valores vacios y no nulos>   
-- Modificacion		<Adrián Arias Abarca> <03/12/2019> <Se castean los datetime a date en las comparaciones para evitar que nunca se encuentre un registro por diferencia de minutos  
--					Se aplico la recomendación de pasar los parámetros a variables internas para maximizar la eficacia del procedimiento almacenado  
--					Se agregaron los campos FechaColision y PlacaVehiculo a las consultas de retorno, pues se requieren para reportear>  
-- Modificación		<Adrián Arias Abarca> <12/12/2019> <Se modifica la consulta para que no liste los documentos con estado Trasladado, ya que estos trasladados deben ser   
--					consultados únicamente desde el buzon de escritos sin expediente recibidos de otro Despacho>  
-- Modificación		<Xinia Soto V> <13/08/2020> <Se corrige filtro de rango de fechas>  
-- Modificación		<Daniel Ruiz H.> <05/10/2020> <Se obtiene el codigo de la asignacion de firma>  
-- Modificación		<Fabian Sequeira G.> <02/03/2021> <Se cambia la cantidad del tipo de dato en boleta y placa>  
-- Modificación		<Ronny Ramírez R.> <17/05/2021> <Se aplica corrección en filtro de rangos de fecha y formato a todo el SP para facilitar lectura>
-- Modificación		<Ronny Ramírez R.> <14/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--													problema de no uso de índices por el mal uso de COALESCE en el WHERE>
-- =================================================================================================================================================================================  
CREATE PROCEDURE [ArchivoSinExpediente].[PA_ConsultarDocumentosSinExpediente]  
 @CodArchivo			Uniqueidentifier = NULL,  
 @Condicion				Varchar(5)		= NULL,  
 @BoletaCitacion		Varchar(29)		= NULL,  
 @PlacaVehiculo			Varchar(20)		= NULL,  
 @FechaColision			Datetime2		= NULL,  
 @FechaRegistroInicio	Datetime2		= NULL,  
 @FecharegistroFinal	Datetime2		= NULL,  
 @CodContextoCrea		Varchar(4)		= NULL,  
 @TipoIdentificacion	Varchar(2)		= NULL,  
 @Identificacion		Varchar(15)		= NULL,  
 @ServidorJudicial		Varchar(15)		= NULL,     
 @Descripcion			Varchar(255)	= NULL,  
 @IndicePagina			Smallint		= NULL,  
 @CantidadPagina		Smallint		= NULL  
AS  
BEGIN  
	Declare 
	@CodArchivoD   Uniqueidentifier			= @CodArchivo,  
	@CondicionD    Varchar(5)				= @Condicion,  
	@BoletaCitacionD  Varchar(29)			= @BoletaCitacion,  
	@PlacaVehiculoD   Varchar(20)			= @PlacaVehiculo,  
	@FechaColisionD   Datetime2				= @FechaColision,  
	@FechaRegistroInicioD Datetime2			= @FechaRegistroInicio,  
	@FecharegistroFinalD Datetime2			= @FecharegistroFinal,  
	@CodContextoCreaD  Varchar(4)			= @CodContextoCrea,  
	@TipoIdentificacionD Varchar(2)			= @TipoIdentificacion,  
	@IdentificacionD  Varchar(15)			= @Identificacion,  
	@ServidorJudicialD  Varchar(15)			= @ServidorJudicial,     
	@DescripcionD   Varchar(255)			= @Descripcion,  
	@IndicePaginaD   Smallint				= @IndicePagina,  
	@CantidadPaginaD  Smallint				= @CantidadPagina  
  
	Declare @DescripcionLike  varchar(255)  
	Set  @DescripcionLike  = iIf(@DescripcionD Is Not Null,'%' + @DescripcionD + '%','%')  
 
	If (@IndicePaginaD Is Null Or @CantidadPaginaD Is Null)  
	Begin  
		SET @IndicePaginaD = 0;  
		SET @CantidadPaginaD = 32767;  
	End  
   
 --Sin Fechas de registro  
 If @FechaRegistroInicioD is NULL and @FecharegistroFinalD is null  
 Begin  
	Select  
	A.TU_CodArchivo				AS Codigo,  
	A.TC_BoletaCitacion			AS BoletaCitacion,  
	A.TC_PlacaVehiculo			AS  PlacaVehiculo,  
	A.TF_Colision				AS  FechaColision,  
	'Split'						AS Split,  
	B.TC_Descripcion			AS Descripcion,  
	B.TF_FechaCrea				AS FechaCrea,  
	B.TN_CodEstado				AS Estado,  
	'Split'						AS  Split,  
	B.TN_CodFormatoArchivo		AS Codigo,  
	'Split'						AS Split,  
	F.TC_CodContexto			AS Codigo,  
	F.TC_Descripcion			AS Descripcion,  
	'Split'						AS Split,  
	E.TC_UsuarioRed				AS  UsuarioRed,  
	H.TC_Nombre					AS Nombre,  
	H.TC_PrimerApellido			AS  PrimerApellido,  
	H.TC_SegundoApellido		AS  SegundoApellido,  
	'Split'						AS Split,  
	I.TU_CodAsignacionFirmado	AS CodigoAsignacionFirma,
	C.TC_NumeroExpediente		AS NumeroExpediente,  
	A.TC_Condicion				AS Condicion,  
	COUNT(*) OVER()				AS Total  

	from  ArchivoSinExpediente.ArchivoSinExpediente			AS A With(NoLock)  
	inner  Join Archivo.Archivo								AS B With(NoLock)  
	on   B.TU_CodArchivo									= A.TU_Codarchivo   
	left  Join Expediente.ArchivoExpediente					AS C With(NoLock)   
	on   C.TU_CodArchivo									= A.TU_CodArchivo  
	Inner  Join Historico.ArchivoSinExpedienteMovimiento	AS E With(NoLock)  
	on   E.TU_CodArchivo									= A.TU_CodArchivo  
	inner Join Catalogo.Contexto							AS F With (NoLock)  
	on   F.TC_CodContexto									= B.TC_CodContextoCrea   
	inner Join Catalogo.Funcionario							AS H With(NoLock)  
	On   E.TC_UsuarioRed									= H.TC_UsuarioRed 
	left join Archivo.AsignacionFirmado						AS I With(NoLock)  
	on	a.TU_CodArchivo										= i.TU_CodArchivo 
	Where  B.TC_CodContextoCrea								= COALESCE(@CodContextoCreaD, B.TC_CodContextoCrea)  
	And   A.TU_CodArchivo									= COALESCE(@CodArchivoD, A.TU_CodArchivo)  
	And   A.TC_Condicion									In  (Select Value From String_Split(@Condicion, ','))  
	And   COALESCE(A.TC_BoletaCitacion,'')					= COALESCE(@BoletaCitacionD, A.TC_BoletaCitacion,'')  
	And   COALESCE(A.TC_PlacaVehiculo,'')					= COALESCE(@PlacaVehiculoD, A.TC_PlacaVehiculo,'')  
	and   COALESCE(Cast(A.TF_Colision as Date),'')			= COALESCE(Cast(@FechaColisionD As Date), Cast(A.TF_Colision As Date),'')  
	and   B.TC_Descripcion									like @DescripcionLike  
	and   (@TipoIdentificacionD								IS NULL OR A.TU_CodArchivo IN (SELECT PU.TU_CodArchivo FROM ArchivoSinExpediente.PersonaUsuaria PU WHERE TN_CodTipoIdentificacion = @TipoIdentificacionD))  
	and   (@IdentificacionD									IS NULL OR A.TU_CodArchivo IN (SELECT PU.TU_CodArchivo FROM ArchivoSinExpediente.PersonaUsuaria PU WHERE TC_Identificacion = @IdentificacionD))  
	And   E.TC_UsuarioRed									= COALESCE(@ServidorJudicialD, E.TC_UsuarioRed)  
	And   E.TF_Movimiento									= (
																Select Max(TF_Movimiento) From Historico.ArchivoSinExpedienteMovimiento  
																Where [TU_CodArchivo] = A.TU_CodArchivo
															)  
	order by            B.TC_Descripcion asc  
	Offset  @IndicePaginaD * @CantidadPaginaD Rows  
	Fetch Next @CantidadPaginaD Rows Only
	OPTION(RECOMPILE);
 End  
 else  
 Begin  
	Select 
	A.TU_CodArchivo        AS Codigo,  
    A.TC_BoletaCitacion			AS BoletaCitacion,  
    A.TC_PlacaVehiculo			AS  PlacaVehiculo,  
    A.TF_Colision				AS  FechaColision,  
    'Split'						AS Split,  
    B.TC_Descripcion			AS Descripcion,  
    B.TF_FechaCrea				AS FechaCrea,  
    B.TN_CodEstado				AS Estado,  
    'Split'						AS  Split,  
    B.TN_CodFormatoArchivo      AS Codigo,  
    'Split'						AS Split,  
    F.TC_CodContexto			AS Codigo,  
    F.TC_Descripcion			AS Descripcion,  
    'Split'						AS Split,  
    E.TC_UsuarioRed				AS  UsuarioRed,  
    H.TC_Nombre					AS Nombre,  
     H.TC_PrimerApellido		AS  PrimerApellido,  
     H.TC_SegundoApellido		AS  SegundoApellido,  
    'Split'						AS Split,  
	I.TU_CodAsignacionFirmado	AS CodigoAsignacionFirma,
    C.TC_NumeroExpediente		AS NumeroExpediente,  
    A.TC_Condicion				AS Condicion,  
    COUNT(*) OVER()				AS Total  

	From ArchivoSinExpediente.ArchivoSinExpediente		AS A With(NoLock)  
	Inner Join Archivo.Archivo							AS B With(NoLock)  
	On  B.TU_CodArchivo									= A.TU_Codarchivo   
	Left Join Expediente.ArchivoExpediente				AS C With(NoLock)   
	On  C.TU_CodArchivo									= A.TU_CodArchivo  
	Inner Join Historico.ArchivoSinExpedienteMovimiento	AS E With(NoLock)  
	On  E.TU_CodArchivo									= A.TU_CodArchivo   
	Inner Join Catalogo.Contexto						AS F With (NoLock)  
	On  F.TC_CodContexto								= B.TC_CodContextoCrea  
	inner Join Catalogo.Funcionario						AS H With(NoLock)  
	On   E.TC_UsuarioRed								= H.TC_UsuarioRed  
	left join Archivo.AsignacionFirmado					AS I With(NoLock)  
	on	a.TU_CodArchivo									= i.TU_CodArchivo 
	Where B.TC_CodContextoCrea							= COALESCE(@CodContextoCreaD, B.TC_CodContextoCrea)  
	And  A.TU_CodArchivo								= COALESCE(@CodArchivoD, A.TU_CodArchivo)  
	And  A.TC_Condicion									In  (Select Value From String_Split(@Condicion, ','))  
	And  COALESCE(A.TC_BoletaCitacion,'')				= COALESCE(@BoletaCitacionD, A.TC_BoletaCitacion,'')  
	And  COALESCE(A.TC_PlacaVehiculo,'')				= COALESCE(@PlacaVehiculoD, A.TC_PlacaVehiculo,'')  
	And  COALESCE(Cast(A.TF_Colision As Date),'')		= COALESCE(Cast(@FechaColisionD As Date), Cast(A.TF_Colision As Date),'')  
	And (
			DATEDIFF(DAY, B.TF_FechaCrea, @FechaRegistroInicioD)	<= 0   
		AND	
			DATEDIFF(DAY, B.TF_FechaCrea, @FechaRegistroFinalD)		>= 0
		)  
	And  B.TC_Descripcion								like case @DescripcionLike when '%' then B.TC_Descripcion   else  @DescripcionLike end
	And	(	@TipoIdentificacionD						IS NULL 
		 OR	A.TU_CodArchivo								IN (SELECT PU.TU_CodArchivo FROM ArchivoSinExpediente.PersonaUsuaria PU WHERE TN_CodTipoIdentificacion = @TipoIdentificacionD)
		)  
	And	(	@IdentificacionD							IS NULL 
		 OR	A.TU_CodArchivo								IN (SELECT PU.TU_CodArchivo FROM ArchivoSinExpediente.PersonaUsuaria PU WHERE TC_Identificacion = @IdentificacionD)
		)  
	And  E.TC_UsuarioRed								= COALESCE(@ServidorJudicialD, E.TC_UsuarioRed)  
	And  E.TF_Movimiento								= (
															Select Max(TF_Movimiento) From Historico.ArchivoSinExpedienteMovimiento  
															Where [TU_CodArchivo] = A.TU_CodArchivo
														)  
	Order By            B.TC_Descripcion asc  
	Offset  @IndicePaginaD * @CantidadPaginaD Rows  
	Fetch Next @CantidadPaginaD Rows Only
	OPTION(RECOMPILE);
 End  


END  
GO
