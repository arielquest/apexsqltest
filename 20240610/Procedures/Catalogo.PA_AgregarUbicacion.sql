SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez Espinoza>
-- Fecha Creación: <10/09/2015>
-- Descripcion:	<Crear un nuevo Ubicacion>
-- =============================================
--   Modificacion: 15/12/2015  Gerardo Lopez <Generar llave por sequence> 
-- =============================================
--   Modificacion: 16/11/2020 Roger Lara <Se agrega campo Ofcina> 


CREATE PROCEDURE [Catalogo].[PA_AgregarUbicacion]  
	@Descripcion varchar(150),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2,
	@Oficina varchar(4)
AS
BEGIN

    DECLARE @L_TC_Descripcion			VARCHAR(150)	= @Descripcion,
		    @L_TF_Inicio_Vigencia		DATETIME2(3)	= @FechaActivacion,
		    @L_TF_Fin_Vigencia			DATETIME2(3)	= @FechaVencimiento,
			@L_TC_Oficina               VARCHAR(4)      = @Oficina


	INSERT INTO Catalogo.Ubicacion WITH(ROWLOCK)
	(
			TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia,TC_CodOficina
	)
	VALUES
	(
			@L_TC_Descripcion,	@L_TF_Inicio_Vigencia	, @L_TF_Fin_Vigencia, @L_TC_Oficina
	)
END
GO
