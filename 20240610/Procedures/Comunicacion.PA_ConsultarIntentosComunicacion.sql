SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Wilbert Gamboa Araya>
-- Fecha de creación:		<29/03/2017>
-- Descripción :			<Permite consultar registros de Comunicacion.IntentoComunicacion> 

-- Modificado:				<1/12/2017> <Ailyn López> <Se agregó los inner join para obtener los 
--                          datos de funcionario y el código de puesto de trabajo, para completar 
--                          los datos del usuario que registra el intento>
-- =================================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero Soto>	<10/05/2021> <Se realiza ajuste en consulta incorporando filtrado por Puesto de trabajo> 
-- Modificado por:			<Isaac Dobles Mata>	<10/05/2021> <Se coloca como optativo el filtro de puesto de trabajo> 
-- Modificado por:			<Isaac Dobles Mata>	<07/12/2021> <Se corrige consulta para mostrar los intentos de un único puesto de trabajo> 
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarIntentosComunicacion]
	@CodigoComunicacion		UNIQUEIDENTIFIER,
	@CodigoPuestoTrabajo	VARCHAR(14) = null
As
Begin
	
	--Locales
	DECLARE		@L_CodComunicacion						UNIQUEIDENTIFIER =	@CodigoComunicacion,
				@L_CodPuestoTrabajo						VARCHAR(14)		 =  @CodigoPuestoTrabajo 


	SELECT 
				A.[TU_CodIntento]						As Codigo,
				A.[TC_Observaciones]					As Observaciones,
				A.[TF_FechaIntento]						As FechaIntento,
				A.[TC_UsuarioRed]						As UsuarioRed,
				A.[TB_Positivo]							As Positivo,
				A.[TC_NombreRecibe]						As NombreRecibe,
				A.[TC_NombreTestigo]					As NombreTestigo,
				'Split'									As Split,
				A.[TU_CodComunicacion]					As CodigoComunicacion,
				'Split'									As Split,
				A.[TG_UbicacionPuntoVisita].Lat			As Latitud,
				A.[TG_UbicacionPuntoVisita].Long		As Longitud,
				'Split'									As Split,
				B.[TC_Nombre]							As Nombre, 
				B.[TC_PrimerApellido]					As PrimerApellido,
				B.[TC_SegundoApellido]					As SegundoApellido,
				'Split'									As Split,
				C.[TC_CodPuestoTrabajo]					AS Codigo

	FROM		[Comunicacion].[IntentoComunicacion]	AS A With(NoLock)
	INNER JOIN	[Comunicacion].[Comunicacion]			AS D With(NoLock)
	ON			A.TU_CodComunicacion					=  D.TU_CodComunicacion
	INNER JOIN  [Catalogo].[Funcionario] 				AS B With(NoLock)
	ON			B.TC_UsuarioRed							=  A.TC_UsuarioRed
	INNER JOIN  [Catalogo].[PuestoTrabajoFuncionario]	AS C With(NoLock)
	ON			C.TC_UsuarioRed							=  A.TC_UsuarioRed
	INNER JOIN  [Catalogo].[ContextoPuestoTrabajo]		AS E With(NoLock)
	ON			E.TC_CodPuestoTrabajo					=  C.TC_CodPuestoTrabajo
	AND         E.TC_CodContexto						=  D.TC_CodContextoOCJ
	AND			C.TC_CodPuestoTrabajo					=  COALESCE(@L_CodPuestoTrabajo, C.TC_CodPuestoTrabajo)
	AND         ((C.TF_Fin_Vigencia						>= GETDATE() 
	OR			  C.TF_Fin_Vigencia						IS NULL) 
	AND			  C.TF_Inicio_Vigencia					<= GETDATE())
	WHERE		A.[TU_CodComunicacion]					= @L_CodComunicacion	
End
GO
