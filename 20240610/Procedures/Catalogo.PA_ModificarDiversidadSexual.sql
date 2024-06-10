SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Roger Lara>
-- Fecha Creación: <31/08/2015>
-- Descripcion:	<Modificar una diversidad sexual>
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <04/01/2016>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarDiversidadSexual] 
	@CodDiversidadSexual smallint, 
	@Descripcion varchar(255),
	@FechaVencimiento datetime2
AS
BEGIN
			UPDATE Catalogo.DiversidadSexual
			SET TC_Descripcion=@Descripcion,
				TF_Fin_Vigencia=@FechaVencimiento
			WHERE 
				TN_CodDiversidadSexual=@CodDiversidadSexual
END
GO
