SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Alejandro Villalta Ruiz>
-- Fecha Creación: <07/08/2015>
-- Descripcion:	<Crear una nueva fase>
-- Modificado por:	<Alejandro Villalta><07/01/2016><Autogenerar el codigo de fase.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarFase] 
	@Descripcion varchar(255),
	@FechaActivacion datetime2,
	@FechaVencimiento datetime2
AS
BEGIN
	INSERT INTO Catalogo.Fase(
								TC_Descripcion,TF_Inicio_Vigencia,TF_Fin_Vigencia
							  ) 
						VALUES(
								@Descripcion,@FechaActivacion,@FechaVencimiento
							  )
END
GO
