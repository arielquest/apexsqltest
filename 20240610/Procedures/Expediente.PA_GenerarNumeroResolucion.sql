SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Jonathan Aguilar Navarro> 
-- Fecha Creación:	<26/07/2018>
-- Descripcion:		<Permite generar número de resolución>
-- =================================================================================================================================================
-- Modificación		<Jonathan Aguilar Navarro> <22/08/2018> <Se modifica por cambios en los tipos de datos>
-- Modificacion     <Roger Lara Hernande><02/03/2021><Se aplicas cast a max de TC_NumeroResolucion, para que funciones correctamente la logina>
-- Modificación		<Jonathan Aguilar Navarro> <24/03/2021> <Se modifica debido a cambios en la tabla para migracion de datos de Sistema de Gestión>
-- Modificación		<Daniel Ruiz Hernández> <19/04/2021> <Se modifica para agregar como parametro el estado.>
 -- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_GenerarNumeroResolucion] 	
	@Codigo					uniqueidentifier,
	@CodContexto			varchar(4),
	@CodPuestoTrabajo		varchar(14),
	@CodPuestoFuncionario	uniqueidentifier,
	@Estado					varchar(1) = 'P',
	@CodigoResolucion		uniqueidentifier = NULL
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

			Declare @AnnoSentencia int
			Set		@AnnoSentencia = DATEPART(YEAR, Getdate())

			Declare @Return	Table	(
										TU_CodLibroSentencia	uniqueidentifier,
										TC_AnnoSentencia		varchar(4),
										TC_CodContexto			varchar(4),
										TC_CodPuestoTrabajo		VarChar(14),
										TC_NumeroResolucion		BigInt,
										TF_FechaAsignacion		datetime,
										TC_Estado				char(1),
										TU_CodResolucion		uniqueidentifier,
										TU_CodPuestoFuncionario	uniqueidentifier
									)
			Insert Into	Expediente.LibroSentencia
				(		
						TU_CodLibroSentencia,
						TC_AnnoSentencia,	
						TC_CodContexto,			
						TC_CodPuestoTrabajo,	
						TC_NumeroResolucion,
						TF_FechaAsignacion,	
						TC_Estado,				
						TU_CodResolucion,		
						TU_UsuarioCrea,
						TU_UsuarioConfirma,	
						TC_JustificacionNoUso,
						TF_Actualizacion
				)
				OutPut		inserted.TU_CodLibroSentencia,
							inserted.TC_AnnoSentencia, 
							inserted.TC_CodContexto, 
							inserted.TC_CodPuestoTrabajo,
							inserted.TC_NumeroResolucion,
							inserted.TF_FechaAsignacion,
							inserted.TC_Estado,
							inserted.TU_CodResolucion,
							inserted.TU_UsuarioCrea
							Into @Return
				Select		@Codigo,
							@AnnoSentencia,	
							@CodContexto,		
							@CodPuestoTrabajo,	
							Case
								When Max(Cast(A.TC_NumeroResolucion as bigint)) Is Null Then 1
								Else Max(Cast(A.TC_NumeroResolucion as bigint)) + 1
							End TC_NumeroResolucion,
							GetDate(),			
							@Estado,					
							@CodigoResolucion,
							@CodPuestoFuncionario,
							NULL,
							NULL,
							GetDate()
				From		Expediente.LibroSentencia	A With(RowLock)
				Where		A.TC_AnnoSentencia			= @AnnoSentencia
				And			A.TC_CodContexto			= @CodContexto

				Select		A.TU_CodPuestoFuncionario			AS Codigo,
							A.TC_AnnoSentencia					As Anno,	
							A.TC_NumeroResolucion				AS ConsecutivoResolucion,
							A.TF_FechaAsignacion				AS FechaAsignado,							
							'SplitContexto'						AS SplitContexto,
							B.TC_CodContexto					AS Codigo,
							B.TC_Descripcion					AS Descripcion,
							'SplitPuestoTrabajo'				AS SplitPuestoTrabajo,
							C.TC_CodPuestoTrabajo				AS Codigo,
							C.TC_Descripcion					AS Descripcion,
							'SplitPuestoTrabajoFuncionario'		AS SplitPuestoTrabajoFuncionario,
							D.TU_CodPuestoFuncionario			AS Codigo,
							'SplitFuncionario'					As	SplitFuncionario,		
							E.TC_UsuarioRed						As	UsuarioRed,				
							E.TC_Nombre							As	Nombre,					
							E.TC_PrimerApellido					As	PrimerApellido,			
							E.TC_SegundoApellido				As	SegundoApellido,		
							E.TC_CodPlaza						As	CodigoPlaza,			
							E.TF_Inicio_Vigencia				As	FechaActivacion,		
							E.TF_Fin_Vigencia					As	FechaDesactivacion,
							'SplitEstado'						AS SplitEstado,
							A.TC_Estado							AS Estado
				From		@Return								A
				Inner Join	Catalogo.Contexto					B with (NoLock)
				on			B.TC_CodContexto					= A.TC_CodContexto
				Inner Join	Catalogo.PuestoTrabajo				C
				On			C.TC_CodPuestoTrabajo				= A.TC_CodPuestoTrabajo
				Inner Join	Catalogo.PuestoTrabajoFuncionario	D with(NoLock)
				on			D.TU_CodPuestoFuncionario			= A.TU_CodPuestoFuncionario
				Inner Join	Catalogo.Funcionario				E With (NoLock)
				on			E.TC_UsuarioRed						= D.TC_UsuarioRed
				where		A.TC_CodContexto					= @CodContexto
				and			A.TC_CodPuestoTrabajo				= @CodPuestoTrabajo

		COMMIT TRAN
	END TRY  
		BEGIN CATCH  
			ROLLBACK TRAN;
			THROW;
		END CATCH  
END
GO
