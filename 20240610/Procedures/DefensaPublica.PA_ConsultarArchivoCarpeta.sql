SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<08/04/2021>
-- Descripción :			<Permite consultar las documentos de una carpeta> 
-- Modificación:			<Wagner Vargas Sanabria><7/5/2021> <Se agrega el puesto del funcionario que crea>
-- Modificación:			<Wagner Vargas Sanabria><11/5/2021> <se eliminan los duplicados identificando que puesto de trabajo creo el documento>
-- Modificación:			<Jose Gabriel Cordero Soto><16/8/2022> <Se agrega valor del grupo por cada documento asociado a la carpeta>
-- =================================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarArchivoCarpeta]
	@NRD				varchar(14)			= NULL,
	@CodArchivo   		uniqueidentifier	= NULL, 	
	@CodContextoCrea	varchar(4)			= NULL,
	@UsuarioCrea		varchar(30)			= NULL,
	@CodEstado			tinyint				= NULL,
	@NumeroExpediente	varchar(14)			= NULL,
	@PuestoTrabajo      varchar(14)			= NULL
AS  
BEGIN 
 				Declare 
				@L_TC_NRD						varchar(14)      		= @NRD,    
				@L_TU_CodArchivo				uniqueidentifier		= @CodArchivo,    
				@L_TC_CodContextoCrea			varchar(4)				= @CodContextoCrea, 
				@L_TC_UsuarioCrea				varchar(30)				= @UsuarioCrea,    
				@L_TN_CodEstado					tinyint					= @CodEstado, 
				@L_TC_NumeroExpediente          varchar(14)				= @NumeroExpediente,
				@L_TC_CodPuestoTrabajo          varchar(14)				= @PuestoTrabajo 

				SELECT	
						A.TU_CodArchivo					AS Codigo,
						A.TC_Descripcion				AS Descripcion,
						A.TF_FechaCrea					AS FechaCrea,
						'Split'							AS	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							AS	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							AS	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,

						'Split'							AS	Split,
						A.TN_CodEstado					AS Estado,
						EX.TC_NumeroExpediente			As Expediente,
						AE.TC_NRD						AS NRD,
						DGT.CantidadPropuesto			AS Propuesto,
						AE.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,

						'Split'							AS	Split,
						G.TC_CodPuestoTrabajo			AS  Codigo

			FROM		Archivo.Archivo				    A	WITH(NOLOCK)
			INNER JOIN	DefensaPublica.ArchivoCarpeta   AE	WITH(NOLOCK)
			ON			A.TU_CodArchivo					=	AE.TU_CodArchivo 
			AND			AE.TC_NRD						=	@L_TC_NRD
			LEFT JOIN	DefensaPublica.Carpeta			AS	EX WITH(NOLOCK)
			ON			EX.TC_NumeroExpediente			=	ISNULL(@L_TC_NumeroExpediente ,EX.TC_NumeroExpediente) and
						Ex.TC_NRD						=   AE.TC_NRD
			OUTER APPLY	(	
							SELECT		C.TN_CodGrupoTrabajo,IIF(COUNT(*)>0,1,0) CantidadPropuesto
							FROM		DefensaPublica.PropuestaDocumento	B WITH(NOLOCK)
							INNER JOIN	Catalogo.GrupoTrabajoPuesto			C WITH(NOLOCK)
							ON			C.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
							WHERE		B.TU_CodArchivo						= AE.TU_CodArchivo
							GROUP BY	TN_CodGrupoTrabajo
						) DGT			

			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			A.TC_CodContextoCrea			= D.TC_CodContexto
			INNER JOIN	Catalogo.FormatoArchivo			E WITH(NOLOCK)
			ON			A.TN_CodFormatoArchivo			= E.TN_CodFormatoArchivo
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed
			INNER JOIN	Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK)
			ON			A.TC_UsuarioCrea				= G.TC_UsuarioRed
			INNER JOIN Catalogo.GrupoTrabajoPuesto      H WITH(NOLOCK)
			ON           G.TC_CodPuestoTrabajo = H.TC_CodPuestoTrabajo
			WHERE		A.TU_CodArchivo					= COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
			AND			A.TC_CodContextoCrea			= COALESCE(@L_TC_CodContextoCrea, A.TC_CodContextoCrea)
			AND			A.TN_CodEstado					IN (3,4) --2 = borrador, 3 = borrador público, 4 = terminado
			AND			AE.TC_NRD						=COALESCE(@L_TC_NRD, AE.TC_NRD)
			AND			H.TC_CodContexto				=COALESCE(@L_TC_CodContextoCrea,A.TC_CodContextoCrea)
			AND			H.TC_CodPuestoTrabajo    in (select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario PT where A.TF_FechaCrea between PT.TF_Inicio_Vigencia and COALESCE(PT.TF_Fin_Vigencia,GETDATE()))
			AND			(DGT.CantidadPropuesto=0 or DGT.CantidadPropuesto is null or DGT.TN_CodGrupoTrabajo in (SELECT TN_CodGrupoTrabajo
																				FROM   Catalogo.GrupoTrabajoPuesto GT where 
																				TC_CodPuestoTrabajo=@L_TC_CodPuestoTrabajo 
																				and TF_Inicio_Vigencia<=GETDATE()
																				and TC_CodContexto=COALESCE(@L_TC_CodContextoCrea,GT.TC_CodContexto)
			
			))
    UNION
				SELECT	
						A.TU_CodArchivo					AS Codigo,
						A.TC_Descripcion				AS Descripcion,
						A.TF_FechaCrea					AS FechaCrea,
						'Split'							AS	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							AS	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							AS	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,

						'Split'							AS	Split,
						A.TN_CodEstado					AS Estado,
						EX.TC_NumeroExpediente			As Expediente,
						AE.TC_NRD						AS NRD,
						DGT.CantidadPropuesto			AS Propuesto,
						AE.TN_CodGrupoTrabajo			AS CodigoGrupoTrabajo,

						'Split'							AS	Split,
						G.TC_CodPuestoTrabajo			AS  Codigo

			FROM		Archivo.Archivo					A WITH(NOLOCK)
			INNER JOIN	DefensaPublica.ArchivoCarpeta   AE WITH(NOLOCK)
			ON			A.TU_CodArchivo					= AE.TU_CodArchivo and AE.TN_CodGrupoTrabajo in (
																										SELECT TN_CodGrupoTrabajo
																									    FROM   Catalogo.GrupoTrabajoPuesto GT where 
																										       TC_CodPuestoTrabajo=@L_TC_CodPuestoTrabajo 
																										       and TF_Inicio_Vigencia<=GETDATE()
																										       and TC_CodContexto=COALESCE(@L_TC_CodContextoCrea,GT.TC_CodContexto)
																										)
			AND			AE.TC_NRD						= @L_TC_NRD	
			LEFT JOIN	DefensaPublica.Carpeta			AS	EX WITH(NOLOCK)
			ON			EX.TC_NumeroExpediente			=	ISNULL(@L_TC_NumeroExpediente ,EX.TC_NumeroExpediente) and
						Ex.TC_NRD						=   AE.TC_NRD

			OUTER APPLY	(	
							SELECT		C.TN_CodGrupoTrabajo,IIF(COUNT(*)>0,1,0) CantidadPropuesto
							FROM		DefensaPublica.PropuestaDocumento	B WITH(NOLOCK)
							INNER JOIN	Catalogo.GrupoTrabajoPuesto			C WITH(NOLOCK)
							ON			C.TC_CodPuestoTrabajo				= B.TC_CodPuestoTrabajo
							WHERE		B.TU_CodArchivo						= AE.TU_CodArchivo
							GROUP BY	TN_CodGrupoTrabajo
						) DGT		
			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			A.TC_CodContextoCrea			= D.TC_CodContexto
			INNER JOIN	Catalogo.FormatoArchivo			E WITH(NOLOCK)
			ON			A.TN_CodFormatoArchivo			= E.TN_CodFormatoArchivo
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			A.TC_UsuarioCrea				= F.TC_UsuarioRed
			INNER JOIN	Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK)
			ON			A.TC_UsuarioCrea				= G.TC_UsuarioRed
			INNER JOIN  Catalogo.GrupoTrabajoPuesto     H WITH(NOLOCK)
			ON          G.TC_CodPuestoTrabajo			= H.TC_CodPuestoTrabajo			
			WHERE		A.TU_CodArchivo					= COALESCE(@L_TU_CodArchivo, A.TU_CodArchivo)
			AND			A.TC_CodContextoCrea			= COALESCE(@L_TC_CodContextoCrea, A.TC_CodContextoCrea)
			AND			A.TN_CodEstado					IN (2) --2 = borrador, 3 = borrador público, 4 = terminado
			AND			AE.TC_NRD						=COALESCE(@L_TC_NRD, AE.TC_NRD)
			AND			H.TC_CodContexto				=COALESCE(@L_TC_CodContextoCrea,A.TC_CodContextoCrea)
			AND			H.TC_CodPuestoTrabajo    in (select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario PT where A.TF_FechaCrea between PT.TF_Inicio_Vigencia and COALESCE(PT.TF_Fin_Vigencia,GETDATE()))
			AND			(DGT.CantidadPropuesto=0 or DGT.CantidadPropuesto is null or  DGT.TN_CodGrupoTrabajo in (SELECT TN_CodGrupoTrabajo
																				FROM   Catalogo.GrupoTrabajoPuesto GT where 
																				TC_CodPuestoTrabajo=@L_TC_CodPuestoTrabajo 
																				and TF_Inicio_Vigencia<=GETDATE()
																				and TC_CodContexto=COALESCE(@L_TC_CodContextoCrea,GT.TC_CodContexto)
			
			))

	UNION
				SELECT	
						AA.TU_CodArchivo					AS Codigo,
						AA.TC_Descripcion				AS Descripcion,
						AA.TF_FechaCrea					AS FechaCrea,
						'Split'							AS	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							AS	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							AS	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,

						'Split'							AS	Split,
						AA.TN_CodEstado					AS Estado,
						EX.TC_NumeroExpediente			As Expediente,
						AE.TC_NRD						AS NRD,
						IIF((SELECT COUNT(*) 
							   FROM DefensaPublica.PropuestaDocumento L WITH(NOLOCK)
							   JOIN DefensaPublica.ArchivoCarpeta A
							   ON   A.TU_CodArchivo= L.TU_CodArchivo)>0,1,0) AS Propuesto,
						NULL							AS CodigoGrupoTrabajo,

						'Split'							AS	Split,
						G.TC_CodPuestoTrabajo			AS  Codigo

			FROM		Archivo.Archivo				    AA WITH(NOLOCK)
			INNER JOIN	DefensaPublica.ArchivoCarpeta   AE WITH(NOLOCK)
			ON			AA.TU_CodArchivo				= AE.TU_CodArchivo 
			LEFT JOIN	DefensaPublica.Carpeta		AS	EX WITH(NOLOCK)
			ON			EX.TC_NumeroExpediente		=	ISNULL(@L_TC_NumeroExpediente ,EX.TC_NumeroExpediente) and
						Ex.TC_NRD					=   AE.TC_NRD
			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			AA.TC_CodContextoCrea			= D.TC_CodContexto
			INNER JOIN	Catalogo.FormatoArchivo			E WITH(NOLOCK)
			ON			AA.TN_CodFormatoArchivo			= E.TN_CodFormatoArchivo
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			AA.TC_UsuarioCrea				= F.TC_UsuarioRed
			INNER JOIN	Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK)
			ON			AA.TC_UsuarioCrea				= G.TC_UsuarioRed
			INNER JOIN  Catalogo.GrupoTrabajoPuesto		H WITH(NOLOCK)
			ON          G.TC_CodPuestoTrabajo			= H.TC_CodPuestoTrabajo			
			WHERE		AA.TU_CodArchivo				= COALESCE(@L_TU_CodArchivo, AA.TU_CodArchivo)
			AND			AA.TC_CodContextoCrea			= COALESCE(@L_TC_CodContextoCrea, AA.TC_CodContextoCrea)
			AND			AA.TC_UsuarioCrea				LIKE '%' + COALESCE(@L_TC_UsuarioCrea ,AA.TC_UsuarioCrea) + '%'
			AND			AA.TN_CodEstado					= 1 --Privado
			AND			AE.TC_NRD						=COALESCE(@L_TC_NRD, AE.TC_NRD)
			AND			H.TC_CodContexto				=COALESCE(@L_TC_CodContextoCrea,AA.TC_CodContextoCrea)
			AND			H.TC_CodPuestoTrabajo    in (select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario PT where AA.TF_FechaCrea between PT.TF_Inicio_Vigencia and COALESCE(PT.TF_Fin_Vigencia,GETDATE()))
UNION

				SELECT	AA.TU_CodArchivo				AS Codigo,
						AA.TC_Descripcion				AS Descripcion,
						AA.TF_FechaCrea					AS FechaCrea,
						'Split'							AS	Split,

						D.TC_CodContexto				AS Codigo,
						D.TC_Descripcion				AS Descripcion,
						D.TF_Inicio_Vigencia			AS FechaActivacion,
						D.TF_Fin_Vigencia				AS FechaDesactivacion,
						D.TC_Telefono					AS Telefono,
						D.TC_Fax						AS Fax,
						D.TC_Email						AS Email,
						'Split'							AS	Split,

						E.TN_CodFormatoArchivo			AS Codigo,
						E.TC_Descripcion				AS Descripcion,
						E.TF_Inicio_Vigencia			AS FechaActivacion,
						E.TF_Fin_Vigencia				AS FechaDesactivacion,
						'Split'							AS	Split,

						F.TC_UsuarioRed					AS UsuarioRed,
						F.TC_Nombre						AS Nombre,
						F.TC_PrimerApellido				AS PrimerApellido,
						F.TC_SegundoApellido			AS SegundoApellido,
						F.TC_CodPlaza					AS CodigoPlaza,
						F.TF_Inicio_Vigencia			AS FechaActivacion,
						F.TF_Fin_Vigencia				AS FechaDesactivacion,

						'Split'							AS	Split,
						AA.TN_CodEstado					AS Estado,
						EX.TC_NumeroExpediente			As Expediente,
						AE.TC_NRD						AS NRD,
						1								AS Propuesto,
						NULL							AS CodigoGrupoTrabajo,

						'Split'							AS	Split,
						G.TC_CodPuestoTrabajo			AS  Codigo
			FROM		Archivo.Archivo				    AA WITH(NOLOCK)
			INNER JOIN	DefensaPublica.ArchivoCarpeta   AE WITH(NOLOCK)
			ON			AA.TU_CodArchivo				= AE.TU_CodArchivo 
			LEFT JOIN	DefensaPublica.Carpeta		AS	EX WITH(NOLOCK)
			ON			EX.TC_NumeroExpediente		=	ISNULL(@L_TC_NumeroExpediente ,EX.TC_NumeroExpediente) and
						Ex.TC_NRD					=   AE.TC_NRD
			INNER JOIN	Catalogo.Contexto				D WITH(NOLOCK)
			ON			AA.TC_CodContextoCrea			= D.TC_CodContexto
			INNER JOIN	Catalogo.FormatoArchivo			E WITH(NOLOCK)
			ON			AA.TN_CodFormatoArchivo			= E.TN_CodFormatoArchivo
			INNER JOIN	Catalogo.Funcionario			F WITH(NOLOCK)
			ON			AA.TC_UsuarioCrea				= F.TC_UsuarioRed
			INNER JOIN	Catalogo.PuestoTrabajoFuncionario G WITH(NOLOCK)
			ON			AA.TC_UsuarioCrea				= G.TC_UsuarioRed
			INNER JOIN  Catalogo.GrupoTrabajoPuesto      H WITH(NOLOCK)
			ON          G.TC_CodPuestoTrabajo			= H.TC_CodPuestoTrabajo
			INNER JOIN  DefensaPublica.PropuestaDocumento B
			ON			B.TU_CodArchivo					= AE.TU_CodArchivo			
			WHERE		AA.TU_CodArchivo				= COALESCE(@L_TU_CodArchivo, AA.TU_CodArchivo)
			AND			AA.TC_CodContextoCrea			= COALESCE(@L_TC_CodContextoCrea, AA.TC_CodContextoCrea)
			AND			(AA.TC_UsuarioCrea				LIKE '%' + COALESCE(@L_TC_UsuarioCrea ,AA.TC_UsuarioCrea) + '%' 
														or AE.TN_CodGrupoTrabajo in( SELECT TN_CodGrupoTrabajo
																					FROM   Catalogo.GrupoTrabajoPuesto GT where 
																					       TC_CodPuestoTrabajo=@L_TC_CodPuestoTrabajo 
																					       and TF_Inicio_Vigencia<=GETDATE()
																					       and TC_CodContexto=COALESCE(@L_TC_CodContextoCrea,GT.TC_CodContexto))
						)
			AND			AE.TC_NRD						=COALESCE(@L_TC_NRD, AE.TC_NRD)
			AND			H.TC_CodContexto				=COALESCE(@L_TC_CodContextoCrea,AA.TC_CodContextoCrea)
			AND			H.TC_CodPuestoTrabajo    in (select TC_CodPuestoTrabajo from Catalogo.PuestoTrabajoFuncionario PT where AA.TF_FechaCrea between PT.TF_Inicio_Vigencia and COALESCE(PT.TF_Fin_Vigencia,GETDATE()))
			AND			B.TC_EstadoPropuesta			='P'

--Código del estado del archivo (1 = privado, 2 = borrador, 3 = borrador público, 4 = terminado).
--Valor que indica el estado del documento propuesto a la o las representaciones (P = Pendiente, A = Aceptado, R = Rechazado)
END
GO
