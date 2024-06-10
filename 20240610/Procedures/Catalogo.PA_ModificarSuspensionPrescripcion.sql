SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:			<Pablo Alvarez>
-- Fecha Creación:	<26/08/2015>
-- Descripcion:		<Modificar datos de una suspensión de prescripción
-- Modificado por:	<Sigifredo Leitón Luna>
-- Fecha:			<08/01/2016>
-- Descripción :	<Se modifica para la autogeneración del código de suspensión prescripción - item 5606>
-- Modificado:	    <05/12/2016> <Pablo Alvarez<Se corrige TN_CodSuspensionPrescripcion por estandar >
-- ==========================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarSuspensionPrescripcion] 
	@CodSuspensionPrescripcion	varchar(2), 
	@Descripcion				varchar(100),
	@FechaVencimiento			datetime2
AS
BEGIN
	UPDATE	Catalogo.SuspensionPrescripcion
	SET		TC_Descripcion					=	@Descripcion,
			TF_Fin_Vigencia					=	@FechaVencimiento
	WHERE	TN_CodSuspensionPrescripcion	=	@CodSuspensionPrescripcion
END
GO
