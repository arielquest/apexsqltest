SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Permite Consultar expedientes preasignados> 
-- =================================================================================================================================================
-- Modificación:			<27/11/2015> <Johan Acosta>				
-- Modificación:			<18/07/2016> <Johan Manuel Acosta Ibañez> <Se cambian los campos de Oficinafuncionario por código de puesto>
-- Modificación:			<Jonathan Aguilar Navarro> <Se cambian la tabla Puesto de trabajo por ContextoPuestoTrabajo para hacer la relacion entre los los puestos de trabajo del contexto>
-- Modificación:			<25/02/2020> <Daniel Ruiz Hernández> <Se modifica para que aunque se envie el contexto si viene nulo cuando se consulta con el numero de expediente.>
-- Modificación:			<08/06/2021> <Jose Gabriel Cordero Soto> <Se realiza ajuste en consulta dado que indicaba CodigoOficina en vez de CodigoContexto, lo que ocasionaba que en el Dapper asignara NULL>
-- Modificado por:			<Luis ALonso Leiva Tames><12/04/2022><Se agrega el nombre del funcionario y nombre de la oficina del Puesto de Trabajo, se elimina el contexto de los filtros>
-- Módificación:			<26/08/2022> <Isaac Dobles Mata> <Se agrega consulta que obtiene todos los consecutivos sin asignar en un contexto y además que consulte consecutivos para reutilizar por sistemas externos, se cambia formato del SP para mejor lectura>
-- ========================================================================================================================================================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_ConsultarExpedientePreasignado]
	@CodPreasignado			uniqueidentifier = null,
	@NumeroExpediente		varchar(14)		 = Null,
	@Estado					varchar(1)		 = Null,
	@CodContexto			Varchar(4)		= Null,
	@SistemaExterno			BIT					= 0
As
Begin
	DECLARE @L_CodPreasignado		UNIQUEIDENTIFIER	= @CodPreasignado,
			@L_NumeroExpediente		VARCHAR(14)			= @NumeroExpediente,
			@L_Estado				VARCHAR(1)			= @Estado,
			@L_CodContexto			VARCHAR(4)			= @CodContexto,
			@L_SistemaExterno		BIT					= @SistemaExterno
	--Obtiene los consecutivos disponibles para reutilizar en caso de sistemas externos (GL-CEREDOC)
	IF(@L_SistemaExterno = 1 AND @L_NumeroExpediente IS NULL)
	BEGIN
		SELECT		TOP 1 
					A.TU_CodPreasignado					AS	Codigo,				
					A.TF_Tramite						AS	FechaTramite,	
					A.TC_NumeroExpediente				AS	NumeroExpediente,
					A.TB_SistemaExterno					AS  SistemaExterno,
					'Split'								AS	Split,			
					A.TC_Estado							AS	EstadoPreasignado,	
					B.TC_CodPuestoTrabajo				AS  CodigoPuestoTrabajo,
					P.TC_Descripcion					AS	Descripcion,
					B.TC_CodContexto					AS  CodigoContexto
	    FROM		Expediente.ExpedientePreasignado	AS	A
		INNER JOIN	Expediente.ConsecutivoReutilizar	AS	D 
		ON			A.TU_CodPreasignado					=	D.TU_CodPreasignado
		INNER JOIN  Catalogo.PuestoTrabajo				AS  P
		ON			P.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
	    INNER JOIN	Catalogo.ContextoPuestoTrabajo		AS	B
	    ON			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
		AND			A.TC_CodContexto					=	B.TC_CodContexto
		INNER JOIN	Catalogo.Contexto					AS	C
	    ON			A.TC_CodContexto					=	C.TC_CodContexto
	    WHERE		A.TC_CodContexto					=	@L_CodContexto
		AND			A.TC_Estado							<>  'A'
		AND			A.TB_SistemaExterno					=	@L_SistemaExterno
		ORDER BY	A.TF_Tramite ASC
	END

	--Obtiene el preasignado para un sistema externo
	ELSE IF(@L_NumeroExpediente IS NOT NULL AND @L_SistemaExterno = 1)
	BEGIN
		SELECT		A.TU_CodPreasignado					AS	Codigo,				
					A.TF_Tramite						AS	FechaTramite,	
					A.TC_NumeroExpediente				AS	NumeroExpediente,	
					'Split'								AS	Split,			
					A.TC_Estado							AS	EstadoPreasignado,	
					B.TC_CodPuestoTrabajo				AS  CodigoPuestoTrabajo, 
					B.TC_CodContexto					AS  CodigoContexto
		FROM		Expediente.ExpedientePreasignado	AS	A WITH(NOLOCK)
		INNER JOIN	Catalogo.ContextoPuestoTrabajo		AS	B WITH(NOLOCK)
		ON			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
		WHERE		A.TC_NumeroExpediente				=	@L_NumeroExpediente
		AND			A.TC_Estado							=	COALESCE(@L_Estado, A.TC_Estado)
		AND			A.TC_CodContexto					=	COALESCE(@L_CodContexto, B.TC_CodContexto)
		AND			A.TB_SistemaExterno					=	1
	END 	

	--Obtiene todos los consecutivos del contexto
	ELSE IF(@L_CodContexto IS NOT NULL AND @L_NumeroExpediente IS NULL AND @L_CodPreasignado IS NULL AND @L_Estado IS NULL)
	BEGIN
		SELECT		A.TU_CodPreasignado					AS	Codigo,				
					A.TF_Tramite						AS	FechaTramite,	
					A.TC_NumeroExpediente				AS	NumeroExpediente,	
					'Split'								AS	Split,			
					A.TC_Estado							AS	EstadoPreasignado,	
					B.TC_CodPuestoTrabajo				AS  CodigoPuestoTrabajo,
					P.TC_Descripcion					AS	Descripcion,
					B.TC_CodContexto					AS  CodigoContexto
	    FROM		Expediente.ExpedientePreasignado	AS	A WITH(NOLOCK)
		INNER JOIN  Catalogo.PuestoTrabajo				AS  P WITH(NOLOCK)
		ON			P.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
	    INNER JOIN	Catalogo.ContextoPuestoTrabajo		AS	B WITH(NOLOCK)
	    ON			B.TC_CodPuestoTrabajo				=	A.TC_CodPuestoTrabajo
		AND			A.TC_CodContexto					=	B.TC_CodContexto
		INNER JOIN	Catalogo.Contexto					AS	C WITH(NOLOCK)
	    ON			A.TC_CodContexto					=	C.TC_CodContexto
	    WHERE		A.TC_CodContexto					=	@L_CodContexto
		AND			A.TC_Estado							<>  'A'
		AND			A.TB_SistemaExterno					=	0
		AND			A.TC_NumeroExpediente				NOT IN
		(
			SELECT		TC_NumeroExpediente 
			FROM		Expediente.ExpedienteDetalle
			WHERE		TC_NumeroExpediente				=	A.TC_NumeroExpediente
		)
		ORDER BY	A.TF_Tramite ASC
	END

	--Por llave
	If @CodPreasignado is not null and @CodPreasignado <> '00000000-0000-0000-0000-000000000000'
	Begin
	  SELECT	DISTINCT
			A.TU_CodPreasignado					As	Codigo,				
			A.TF_Tramite						As	FechaTramite,	
			A.TC_NumeroExpediente				As	NumeroExpediente,	
			'Split'								As	Split,			
			A.TC_Estado							As	EstadoPreasignado,	
			B.TC_CodPuestoTrabajo				As  CodigoPuestoTrabajo, 
			B.TC_CodContexto					As  CodigoContexto, 
			E.TC_CodOficina						AS	CodigoOficina,
			E.TC_Descripcion					As  DescripcionOficina,
			ISNULL(D.TC_Nombre,NULL)			AS Nombre,
			ISNULL(D.TC_PrimerApellido, NULL)	AS PrimerApellido,
			ISNULL(D.TC_SegundoApellido, NULL)	AS SegundoApellido
		FROM			
		Expediente.ExpedientePreasignado A WITH(NOLOCK)
			INNER JOIN	Catalogo.ContextoPuestoTrabajo B WITH(NOLOCK)
			ON	B.TC_CodPuestoTrabajo	=	A.TC_CodPuestoTrabajo
			INNER JOIN Catalogo.PuestoTrabajoFuncionario C WITH(NOLOCK) 
			ON B.TC_CodPuestoTrabajo = C.TC_CodPuestoTrabajo
			INNER JOIN Catalogo.Funcionario D WITH(NOLOCK) 
			ON C.TC_UsuarioRed = D.TC_UsuarioRed
			INNER JOIN Catalogo.Contexto E WITH(NOLOCK) 
			ON B.TC_CodContexto = E.TC_CodContexto
	   WHERE	
				A.TU_CodPreasignado			=	@CodPreasignado

	End
	--Por número de expediente
	Else If @NumeroExpediente is not null
	Begin
		 SELECT	DISTINCT
			A.TU_CodPreasignado					As	Codigo,				
			A.TF_Tramite						As	FechaTramite,	
			A.TC_NumeroExpediente				As	NumeroExpediente,	
			'Split'								As	Split,			
			A.TC_Estado							As	EstadoPreasignado,	
			B.TC_CodPuestoTrabajo				As  CodigoPuestoTrabajo, 
			B.TC_CodContexto					As  CodigoContexto, 
			E.TC_CodOficina						AS	CodigoOficina,
			E.TC_Descripcion					As  DescripcionOficina,
			ISNULL(D.TC_Nombre,NULL)			AS Nombre,
			ISNULL(D.TC_PrimerApellido, NULL)	AS PrimerApellido,
			ISNULL(D.TC_SegundoApellido, NULL)	AS SegundoApellido
		FROM			
			Expediente.ExpedientePreasignado A WITH(NOLOCK)
			INNER JOIN	Catalogo.ContextoPuestoTrabajo B WITH(NOLOCK)
			ON	B.TC_CodPuestoTrabajo	=	A.TC_CodPuestoTrabajo 
			INNER JOIN Catalogo.PuestoTrabajoFuncionario C WITH(NOLOCK) 
			ON B.TC_CodPuestoTrabajo = C.TC_CodPuestoTrabajo
			INNER JOIN Catalogo.Funcionario D WITH(NOLOCK) 
			ON C.TC_UsuarioRed = D.TC_UsuarioRed
			INNER JOIN Catalogo.Contexto E WITH(NOLOCK) 
			ON B.TC_CodContexto = E.TC_CodContexto
	   WHERE		
			A.TC_NumeroExpediente		=	@NumeroExpediente
			AND	A.TC_Estado				=	ISNULL(@Estado, A.TC_Estado)
   end
   	
End		
GO
