SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto V.>
-- Fecha de creación:		<24/01/2020>
-- Descripción:				<Permite agregar un registro de aviso>
-- ===========================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarAviso]
	@Descripcion varchar(255),
	@Sistema	 varchar(1),
	@FecInicio   datetime2,
	@FecFin      datetime2
AS  
BEGIN  

--Variables.
Declare @L_TC_Descripcion		VarChar(255)= @Descripcion,
		@L_TC_Sistema			Varchar(1)  = @Sistema,
		@L_TF_FecInicio			DateTime2	= @FecInicio,
		@L_TF_FecFin			DateTime2	= @FecFin

--Lógica.
INSERT INTO [Catalogo].[Aviso]
           ([TC_Descripcion]
           ,[TC_Sistema]
           ,[TF_FecInicio]
           ,[TF_FecFin])
     VALUES
           (@L_TC_Descripcion
           ,@L_TC_Sistema
           ,@L_TF_FecInicio
           ,@L_TF_FecFin)

END		 
GO
