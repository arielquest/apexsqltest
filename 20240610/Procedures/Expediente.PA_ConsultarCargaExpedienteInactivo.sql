SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Olger Gamboa Castillo
-- Create date: 31/08/2020
-- Description:	Procedimiento para consultas las solicitudes de carga de expedientes inactivos por estado, usuario o contexto
-- =============================================
-- Fecha Modificación:29/09/2020
-- Descripcion: Se agrega el campo codigo a la consulta.
-- Fecha Modificación:29/09/2020
-- Descripcion: Se agrega el codigo del contexto en el resultado
-- =============================================
-- Fecha Modificación:20/04/2021
-- Descripcion: Se modifica nombre del campo TN_CodSolictud por TN_CodSolicitud
CREATE PROCEDURE [Expediente].[PA_ConsultarCargaExpedienteInactivo]
	@CodContexto varchar(4),
	@UsuarioRed varchar(30)=null,
	@Estado char(1)	

AS
BEGIN
	--Variables
	DECLARE		@TC_CodContexto varchar(4)	=	@CodContexto, 	
				@TC_UsuarioRed varchar(30)	=	@UsuarioRed,
				@TC_Estado char(1)			=	@Estado

SELECT	esc.TB_ValidarSREM AS SREM,				esc.TB_ValidarDocumento AS DocumentosAsociados ,	
		esc.TB_ValidarEscrito AS Escritos,		esc.TF_Corte AS FechaCorte,
		esc.TF_Solicitud as FechaSolicitud,		esc.TC_CodContexto,						
		esc.TN_CodSolicitud AS Codigo,			'SplitEstado' as SplitEstado,			
		esc.TC_Estado AS Estado,				'SplitUsuario' as SplitUsuario,			
		esc.TC_UsuarioRed AS UsuarioRed,		cf.TC_Nombre AS Nombre,
		cf.TC_PrimerApellido AS PrimerApellido,	cf.TC_SegundoApellido AS SegundoApellido,
		'SplitContexto' as SplitContexto,		esc.TC_CodContexto AS CodigoContexto
FROM	Expediente.SolicitudCargaInactivo esc WITH (NOLOCK)
		LEFT join Catalogo.Funcionario cf WITH (NOLOCK) ON esc.TC_UsuarioRed = cf.TC_UsuarioRed
WHERE	esc.TC_CodContexto=COALESCE(@TC_CodContexto,esc.TC_CodContexto)
		AND esc.TC_Estado=COALESCE(@TC_Estado,esc.TC_Estado)
		AND esc.TC_UsuarioRed=COALESCE(@TC_UsuarioRed,esc.TC_UsuarioRed)	
ORDER BY	esc.TF_Solicitud desc

END	
GO
