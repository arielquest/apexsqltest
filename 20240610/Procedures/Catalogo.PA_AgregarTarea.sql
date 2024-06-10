SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Pablo Alvarez Espinoza>
-- Fecha Creación: <10/09/2015>
-- Descripcion:	<Crear un nuevo Tarea>
--Modificacion: 15/12/2015  Pablo Alvarez <Generar llave por sequence> 
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTarea] 
	@Descripcion varchar(255),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.Tarea 
	(
			TC_Descripcion,	TF_Inicio_Vigencia,	TF_Fin_Vigencia
	)
	VALUES
	(
			@Descripcion,	@FechaActivacion	,@FechaVencimiento
	)
END
GO
