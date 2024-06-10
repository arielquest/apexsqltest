SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--===============================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<02/12/2020>
-- Descripción:				<Consulta los sectores para la sincronización en la aplicación móvil> 
--===============================================================================================================================================================
-- Modificación:			<15/06/2021> <Cristian Cerdas Camacho> <Modificado para recibir por parámetro el tipo de funcionario>
-- Modificación:			<03/08/2021> <Cristian Cerdas Camacho> <Se modifica para buscar por catalogo los tipos de trabajo supervisor y notificador>
-- Modificación:			<09/08/2021> <Cristian Cerdas C.> <Se modifica el where para obtener solo los notificadores que utilizan app móvil>
-- Modificación:			<07/10/2021> <Isaac Dobles Mata> <Se agregar parámetros de valores de configuración>
-- ===============================================================================================================================================================
CREATE   PROCEDURE [Biztalk].[PA_ConsultarNotificadores]
	@CodigoJornadaNocturna				Varchar(255),
	@CodigoPuestoTrabajoSup			Varchar(255)
AS
BEGIN
	DECLARE @ConfigPuestoNotificaEnMovil VARCHAR(30) =  'C_TipoPuestoNotificaEnMovil'

	SELECT
	F.TC_UsuarioRed															AS CodNotificador,
	CONVERT(nvarchar(70), p.TU_CodPuestoFuncionario)						AS CodReferencia,
	F.TC_Nombre + ' ' + F.TC_PrimerApellido + ' ' + F.TC_SegundoApellido	AS NombreCompleto,
	1 AS 'activo',
	IIF(T.TN_CodJornadaLaboral <> @CodigoJornadaNocturna, 0,1)				AS 'rolNocturno',
	IIF(T.TN_CodTipoPuestoTrabajo <> @CodigoPuestoTrabajoSup, 0,1)			AS 'supervisor',
	1,
	'split'																	split,
	C.TC_CodContexto														AS Codigo,
	C.TC_Descripcion														AS Descripcion	
	
	FROM Catalogo.Funcionario							F WITH(NOLOCK)
	INNER JOIN CATALOGO.PuestoTrabajoFuncionario		P WITH(NOLOCK)
	ON P.TC_UsuarioRed									=	F.TC_UsuarioRed
	INNER JOIN Catalogo.PuestoTrabajo					T WITH(NOLOCK)
	ON T.TC_CodPuestoTrabajo							= P.TC_CodPuestoTrabajo
	INNER JOIN Catalogo.Contexto						C WITH(NOLOCK)
	ON C.TC_CodOficina									= T.TC_CodOficina
	WHERE T.TN_CodTipoPuestoTrabajo IN (SELECT TC_Valor 
										FROM	Configuracion.ConfiguracionValor V WITH(NOLOCK)
										WHERE	V.TC_CodConfiguracion = @ConfigPuestoNotificaEnMovil)
	AND	F.TF_Inicio_Vigencia		<=	GETDATE ()
	AND	(F.TF_Fin_Vigencia IS NULL OR F.TF_Fin_Vigencia  >= GETDATE ()) 
	AND T.TB_UtilizaAppMovil = 1
END

GO
