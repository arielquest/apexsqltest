SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

  
-- =================================================================================================================================================  
-- Version:				<1.1>  
-- Creado por:			<Jonathan Aguilar Navarro>  
-- Fecha de creacion:	<23/07/2018>  
-- Descripcion :		<Permite consultar Libro de Sentencias>  
-- =================================================================================================================================================  
-- Modificacion		<11/08/2020> <Xinia Soto V.> <Se corrige filtro de tipo de resolucion.>   
-- Modificacion:	<Jonathan Aguilar Navarro><24/03/2021><Se modifica para agregar le codigo a la consulta, se tabula el sp>
-- Modificacion:	<Isaac Santiago Mendez Castillo><24/03/2021><Se modifica que a la hora de ordenar el resultado, se ordene por el numero
--																 de resolucion en formato numero.>
-- Modificacion:	<Aaron Rios Retana><22/09/2022><Incidente Incidente 274922 - Se añade el inner join con la tabla Expediente.Resolucion, Catalogo.PuestoTrabajoFuncionario,
--													Catalogo.Funcionario para obtener el nombre y apellidos del redactor responsable>
-- =================================================================================================================================================  

CREATE PROCEDURE [Expediente].[PA_ConsultarLibroSentencias]  
 @CodContexto			varchar(4)	= null,  
 @Anno					varchar(4)	= null,  
 @CodPuestoTrabajo		varchar(14) = null,  
 @Estado				varchar(1)	= null,  
 @FechaAsignacionDesde	datetime2	= null,  
 @FechaAsignacionHasta	datetime2	= null,  
 @CodTipoResolucion		smallint	= null,  
 @NumeroResolucion		bigint		= null,  
 @Mes					integer		= null   
As  
Begin  

DECLARE 
@L_CodContexto			varchar(4)	= @CodContexto	,		
@L_Anno					varchar(4)	= @Anno		,			
@L_CodPuestoTrabajo		varchar(14) = @CodPuestoTrabajo	,	
@L_Estado				varchar(1)	= @Estado,				
@L_FechaAsignacionDesde	datetime2	= @FechaAsignacionDesde	,
@L_FechaAsignacionHasta	datetime2	= @FechaAsignacionHasta	,
@L_CodTipoResolucion	smallint	= @CodTipoResolucion	,	
@L_NumeroResolucion		bigint		= @NumeroResolucion	,	
@L_Mes					integer		= @Mes					

  
if (@Mes is not null )  
begin  
  SELECT
		A.TU_CodLibroSentencia						As Codigo,
		A.TC_NumeroResolucion						As ConsecutivoResolucion,  
		A.TC_AnnoSentencia							As Anno,  
		A.TF_FechaAsignacion						As FechaAsignacion,  
		A.TU_UsuarioConfirma						As UsuarioConfirma,  
		A.TC_JustificacionNoUso						As JustificacionNoUso,  
		A.TF_Actualizacion							As FechaActualizacion,  
		'SpitContexto'								As SplitContexto,  
		B.TC_CodContexto							As Codigo,  
		B.TC_Descripcion							AS Descripcion,  
		'SplitPuestoTrabajo'						As SplitPuestoTrabajo,  
		C.TC_CodPuestoTrabajo						As Codigo,  
		C.TC_Descripcion							As Descripcion, 
		'SplitFuncionarioCrea'						As SplitFuncionarioCrea,  
		E.UsuarioRed								As UsuarioRed,  
		E.Nombre									As Nombre,  
		E.PrimerApellido							As PrimerApellido,  
		E.SegundoApellido							As SegundoApellido,  
		E.CodigoPlaza								As CodigoPlaza,  
		E.FechaActivacion							As FechaActivacion,  
		E.FechaDesactivacion						As FechaDesactivacion,   
		'SplitResolucion'							As SplitResolucion,  
		F.TU_CodResolucion							As CodigoResolucion,  
		F.TU_CodArchivo								As CodigoArchivo,      
		'SplitTipoResolucion'						As SplitTipoResolucion,  
		G.TN_CodTipoResolucion						As Codigo,  
		G.TC_Descripcion							As Descripcion,
		'SplitOtros'								As SplitOtros,      
		A.TC_Estado									As Estado, 
		J.TC_UsuarioRed								As UsuarioRedResponsable,  
		J.TC_Nombre									As NombreResponsable,  
		J.TC_PrimerApellido							As PrimerApellidoResponsable,  
		J.TC_SegundoApellido						As SegundoApellidoResponsable  
   FROM			Expediente.LibroSentencia			A With (NoLock)  
   INNER JOIN   Catalogo.Contexto					B With (NoLock)  
   ON			B.TC_CodContexto					= A.TC_CodContexto  
   INNER JOIN   Catalogo.PuestoTrabajo				C With (NoLock)  
   ON			C.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo  
   INNER JOIN   Catalogo.PuestoTrabajoFuncionario	D with(Nolock)  
   ON			D.TU_CodPuestoFuncionario			= A.TU_UsuarioCrea  
   OUTER APPLY  Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(D.TC_CodPuestoTrabajo) As E   
   LEFT JOIN	Expediente.Resolucion				F With(NoLock)  
   ON			F.TU_CodResolucion					= A.TU_CodResolucion  
   LEFT JOIN	Catalogo.TipoResolucion				G With(NoLock)  
   ON			G.TN_CodTipoResolucion				= F.TN_CodTipoResolucion    
   LEFT JOIN	Expediente.Resolucion				H WITH(NOLOCK)
   ON			H.TU_CodResolucion					= A.TU_CodResolucion
   LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	I WITH(NOLOCK)
   ON			I.TU_CodPuestoFuncionario			= H.TU_RedactorResponsable
   LEFT JOIN	Catalogo.Funcionario				J WITH(NOLOCK)
   ON			J.TC_UsuarioRed						= I.TC_UsuarioRed
   WHERE		A.TC_CodContexto					= COALESCE(@L_CodContexto, A.TC_CodContexto)  
   AND			A.TC_AnnoSentencia					= COALESCE(@L_Anno, A.TC_AnnoSentencia)  
   AND			A.TC_CodPuestoTrabajo				= COALESCE(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo)  
   AND			A.TC_Estado							= COALESCE(@L_Estado, A.TC_Estado)  
   AND			A.TC_NumeroResolucion				= COALESCE(@L_NumeroResolucion, A.TC_NumeroResolucion)  
   AND			Month(A.TF_FechaAsignacion)			= @L_Mes  
   AND			((A.TU_CodResolucion				is not null 
   AND			F.TN_CodTipoResolucion				= COALESCE(@L_CodTipoResolucion, F.TN_CodTipoResolucion)) 
				or (A.TU_CodResolucion				is null 
					and @L_CodTipoResolucion		is null))  
   ORDER BY											CAST(TC_NumeroResolucion AS INT)  
   end  
else  
begin  
  Select    
		A.TU_CodLibroSentencia						As Codigo,
		A.TC_NumeroResolucion						As ConsecutivoResolucion,  
		A.TC_AnnoSentencia							As Anno,  
		A.TF_FechaAsignacion						As FechaAsignacion,  
		A.TU_UsuarioConfirma						As UsuarioConfirma,  
		A.TC_JustificacionNoUso						As JustificacionNoUso,  
		A.TF_Actualizacion							As FechaActualizacion,  
		'SpitContexto'								As SplitContexto,  
		B.TC_CodContexto							As Codigo,  
		B.TC_Descripcion							As Descripcion,  
		'SplitPuestoTrabajo'						As SplitPuestoTrabajo,  
		C.TC_CodPuestoTrabajo						As Codigo,  
		C.TC_Descripcion							As Descripcion,   
		'SplitFuncionarioCrea'						As SplitFuncionarioCrea,  
		E.UsuarioRed								As UsuarioRed,  
		E.Nombre									As Nombre,  
		E.PrimerApellido							As PrimerApellido,  
		E.SegundoApellido							As SegundoApellido,  
		E.CodigoPlaza								As CodigoPlaza,  
		E.FechaActivacion							As FechaActivacion,  
		E.FechaDesactivacion						As FechaDesactivacion,   
		'SplitResolucion'							As SplitResolucion,  
		F.TU_CodResolucion							As CodigoResolucion,  
		F.TU_CodArchivo								As CodigoArchivo,      
		'SplitTipoResolucion'						As SplitTipoResolucion,  
		G.TN_CodTipoResolucion						As Codigo,  
		G.TC_Descripcion							As Descripcion,   
		'SplitOtros'								As SplitOtros,   
		A.TC_Estado									As Estado,  
		J.TC_UsuarioRed								As UsuarioRedResponsable,  
		J.TC_Nombre									As NombreResponsable,  
		J.TC_PrimerApellido							As PrimerApellidoResponsable,  
		J.TC_SegundoApellido						As SegundoApellidoResponsable  
  FROM			Expediente.LibroSentencia			A With (NoLock)  
  INNER JOIN	Catalogo.Contexto					B With (NoLock)  
  ON			B.TC_CodContexto					= A.TC_CodContexto  
  INNER JOIN	Catalogo.PuestoTrabajo				C With (NoLock)  
  ON			C.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo  
  INNER JOIN	Catalogo.PuestoTrabajoFuncionario D with(Nolock)  
  ON			D.TU_CodPuestoFuncionario			= A.TU_UsuarioCrea  
  OUTER Apply   Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(D.TC_CodPuestoTrabajo) As E  
  LEFT JOIN		Expediente.Resolucion				F With(NoLock)  
  ON			F.TU_CodResolucion					= A.TU_CodResolucion  
  LEFT JOIN		Catalogo.TipoResolucion				G With(NoLock)  
  ON			G.TN_CodTipoResolucion				= F.TN_CodTipoResolucion   
  LEFT JOIN	Expediente.Resolucion					H WITH(NOLOCK)
  ON			H.TU_CodResolucion					= A.TU_CodResolucion
  LEFT JOIN	Catalogo.PuestoTrabajoFuncionario		I WITH(NOLOCK)
  ON			I.TU_CodPuestoFuncionario			= H.TU_RedactorResponsable
  LEFT JOIN	Catalogo.Funcionario					J WITH(NOLOCK)
  ON			J.TC_UsuarioRed						= I.TC_UsuarioRed
  WHERE		A.TC_CodContexto						= COALESCE(@CodContexto, A.TC_CodContexto)  
  And		A.TC_AnnoSentencia						= COALESCE(@Anno, A.TC_AnnoSentencia)  
  And		A.TC_CodPuestoTrabajo					= COALESCE(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo)  
  And		A.TC_Estado								= COALESCE(@Estado, A.TC_Estado)  
  And		A.TC_NumeroResolucion					= COALESCE(@NumeroResolucion, A.TC_NumeroResolucion)  
  And		((A.TU_CodResolucion					is not null 
			and F.TN_CodTipoResolucion				= COALESCE(@CodTipoResolucion, F.TN_CodTipoResolucion)) 
			or (A.TU_CodResolucion					is null and @CodTipoResolucion is null))  
  ORDER BY											CAST(TC_NumeroResolucion AS INT)  
end  
End
GO
