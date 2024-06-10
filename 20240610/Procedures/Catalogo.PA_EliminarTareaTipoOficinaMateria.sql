SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<23/10/2020>
-- Descripción :			<Permite desasociar un estado a un tipo de oficina y materia>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarTareaTipoOficinaMateria]
	@CodTipoOficina			smallint,
	@CodTarea				smallint,
	@CodMateria				varchar(5)
AS 
BEGIN

	DECLARE	
	@L_TN_CodTipoOficina	smallint				=	@CodTipoOficina,
	@L_TN_CodTarea			smallint				=	@CodTarea,
	@L_TC_CodMateria		varchar(5)				=	@CodMateria


	DELETE 
	FROM	Catalogo.TareaTipoOficinaMateria
	WHERE	TN_CodTipoOficina						=	@L_TN_CodTipoOficina
	AND		TN_CodTarea								=	@L_TN_CodTarea
	AND		TC_CodMateria							=	@L_TC_CodMateria
	
END

GO
