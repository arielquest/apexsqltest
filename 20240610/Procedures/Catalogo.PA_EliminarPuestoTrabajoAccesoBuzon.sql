SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================
-- Autor:		   <Luis Alonso Leiva Tames>
-- Fecha Creación: <27/10/2018>
-- Descripcion:    <Eliminar un permiso especifico de un puesto de trabajo
-- ==========================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarPuestoTrabajoAccesoBuzon]
	 @Codigo  			int
 As
 Begin


	 Declare @L_Codigo			int  = @Codigo

	Delete 
	from 
			[Catalogo].[PuestoTrabajoAccesoBuzon]
	where 
			TN_CodPuestosTrabajoAccesoBuzon = @L_Codigo
 
 End 



GO
