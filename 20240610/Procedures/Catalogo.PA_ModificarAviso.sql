SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<28/01/2020>
-- Descripción :			<Permite modificar un aviso> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarAviso]
	@CodAviso	 bigint, 
	@Descripcion varchar(255),
	@Sistema	 varchar(1),
	@FecInicio   datetime2,
	@FecFin      datetime2
AS
BEGIN

--Variables.
Declare @L_TC_Descripcion VarChar(255) = @Descripcion,
		@L_TC_Sistema	  Varchar(1)   = @Sistema,
		@L_TF_FecInicio	  DateTime2	   = @FecInicio,
		@L_TF_FecFin	  DateTime2	   = @FecFin,
		@L_TN_CodAviso	  bigint       = @CodAviso

--Lógica.
	UPDATE [Catalogo].[Aviso]
	   SET [TC_Descripcion] = @L_TC_Descripcion
		  ,[TC_Sistema]     = @L_TC_Sistema
		  ,[TF_FecInicio]   = @L_TF_FecInicio
		  ,[TF_FecFin]      = @L_TF_FecFin
	 WHERE TN_CodAviso      = @L_TN_CodAviso

END

GO
