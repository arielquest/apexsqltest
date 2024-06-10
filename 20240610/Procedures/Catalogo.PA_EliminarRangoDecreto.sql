SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<04/07/2019>
-- Descripción:				<Permite eliminar un rango de un decreto> 
-- Modificado:				<Adrián Arias>
-- Fecha de modificación:	<05/11/2019>
-- Descripción:				<Se corrgije para que se tome en cuenta toda la llave compuesta de la tabla, se agrega a la validación
--                           los campos MontoInicial y MontoFinal>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarRangoDecreto]
	@CodDecreto				varchar(15),
	@CodTipoOficina			smallint,
	@CodClase				int,
	@CodMateria				varchar(5),
	@MontoInicial			decimal(12,0),
	@MontoFinal				decimal(12,0)
AS  
BEGIN  
	DELETE FROM Catalogo.ClaseAsuntoDecreto 
	WHERE	TC_CodigoDecreto		=	@CodDecreto
	AND		TN_CodTipoOficina		=	@CodTipoOficina
	AND		TN_CodClase				=	@CodClase
	AND		TC_CodMateria			=	@CodMateria
	AND		TN_MontoInicial			=	@MontoInicial
	AND		TN_MontoFinal			=	@MontoFinal
END	
GO
