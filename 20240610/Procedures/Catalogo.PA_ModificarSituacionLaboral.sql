SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Johan Acosta Ibañez>
-- Fecha Creación:		<24/08/2015>
-- Descripcion:			<Modificar una Situación Laboral>
-- Modificado por:		<Alejandro Villalta>
-- Fecha de creación:	<10/12/2015>
-- Descripción :		<Autogenerar el codigo del catalogo situación laboral.> 
-- Modificado:	            <05/12/2016> <Pablo Alvarez<Se corrige TN_CodSituacionLaboral por estandar >
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarSituacionLaboral] 
	@Codigo smallint, 
	@Descripcion varchar(100),
	@FechaVencimiento datetime2=null
AS
BEGIN
	UPDATE	Catalogo.SituacionLaboral
	SET		TC_Descripcion			=	@Descripcion,
			TF_Fin_Vigencia			=	@FechaVencimiento
	WHERE TN_CodSituacionLaboral			=	@Codigo
END




GO
