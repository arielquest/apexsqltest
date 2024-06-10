SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<04/05/2016>
-- Descripcion:		<Modifica un registro de grupo de formato jurídico.>
-- Descripcion:		<19/07/2016><Modifica un registro de grupo de formato jurídico.>
-- Modificacion:	<10/07/2018><Jefry Hernández><Se agrega nuevo parámetro @Ordenamiento.>
-- Modificacion:	<17/02/2021><Wagner Vargas><Se amplica campo TC_Nombre.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarGrupoFormatoJuridico] 
	@Codigo							smallint, 
	@CodigoPadre					smallint = null,
	@Nombre                         varchar(255),
	@Descripcion					varchar(150),
	@FechaVencimiento				datetime2,
	@FechaInicio					datetime2,
	@Ordenamiento					Smallint
AS
BEGIN
	UPDATE	Catalogo.GrupoFormatoJuridico 
	SET		TN_CodGrupoFormatoJuridicoPadre	=	@CodigoPadre,
			TC_Nombre						=	@Nombre,
			TC_Descripcion					=	@Descripcion,
			TF_Fin_Vigencia					=	@FechaVencimiento,
			TF_Inicio_Vigencia				=	@FechaInicio,
			TN_Ordenamiento					=	@Ordenamiento
	WHERE	TN_CodGrupoFormatoJuridico		=	@Codigo
END

GO
