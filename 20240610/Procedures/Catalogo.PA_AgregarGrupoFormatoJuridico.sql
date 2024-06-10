SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<04/05/2016>
-- Descripcion:		<Crear un nuevo registro de grupo de formato jurídico.>
-- Modificacion:	<10/07/2018><Jefry Hernández><Se agrega nuevo parámetro @Ordenamiento.>
-- Modificacion:	<17/02/2021><Wagner Vargas><Se amplia campo TC_nombre>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarGrupoFormatoJuridico] 
	@CodigoPadre						smallint = null,
	@Descripcion						varchar(150),
	@Nombre							    varchar(255),
	@FechaActivacion					datetime2,
	@FechaVencimiento					datetime2,
	@Ordenamiento						Smallint
AS
BEGIN
	INSERT INTO Catalogo.GrupoFormatoJuridico 
	(
		TN_CodGrupoFormatoJuridicoPadre,	TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia,
		TC_Nombre,							TN_Ordenamiento
	)
	VALUES
	(
		@CodigoPadre,						@Descripcion,		@FechaActivacion,		@FechaVencimiento,
		@Nombre,							@Ordenamiento
	)
END


GO
