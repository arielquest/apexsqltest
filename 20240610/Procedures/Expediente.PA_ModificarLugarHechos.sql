SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================
-- Autor:		   <Jonathan Aguilar Navarro>
-- Fecha Creación: <26/03/2018>
-- Descripcion:	   <Modifica datos basicos de un  expediente.>
-- =============================================================================================================
-- Modificación    <Ronny Ramírez R.> <11/03/2021> <Se agrega nuevo campo de TC_DescripcionHechos al SP>
-- =============================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarLugarHechos]
	@NumeroExpediente	char(14), 
	@Canton				int,
	@Distrito			int,
	@Barrio				int,
	@Provincia			int,
	@Sennas				varchar(500),
	@DescripcionHechos	varchar(255) = NULL
AS
BEGIN
	--Variables        
	DECLARE	@L_TC_NumeroExpediente		CHAR(14)		=	@NumeroExpediente,
			@L_TN_CodCanton				INT				=	@Canton,
			@L_TN_CodDistrito			INT				=	@Distrito,
			@L_TN_CodBarrio				INT				=	@Barrio,
			@L_TN_CodProvincia			INT				=	@Provincia,
			@L_TC_Senas					varchar(500)	=	@Sennas,
			@L_TC_DescripcionHechos		VARCHAR(255)	=	@DescripcionHechos

	Update  Expediente.Expediente
	set		TN_CodCanton			=	@L_TN_CodCanton,	
			TN_CodDistrito			=	@L_TN_CodDistrito,
			TN_CodBarrio			=	@L_TN_CodBarrio,	
			TN_CodProvincia			=	@L_TN_CodProvincia,
			TC_Señas				=	@L_TC_Senas,	
			TC_DescripcionHechos	=	@L_TC_DescripcionHechos,
			TF_Actualizacion		=	GETDATE()
	Where TC_NumeroExpediente		=	@L_TC_NumeroExpediente

END
GO
