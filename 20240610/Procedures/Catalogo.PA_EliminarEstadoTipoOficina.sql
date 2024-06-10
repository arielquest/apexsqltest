SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite eliminar un estado asociado a un tipo de oficina> 
-- Modificado :				<Olger Gamboa Castillo, 17/12/2015, Se modifica el tipo de dato del codigo de estado a smallint.> 
-- Modificado:				<Pablo Alvarez Espinoza>
-- Fecha Modifica:          <06/01/2015>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- Modificado :				Jeffry Hernández, 30/08/2017, Se agrega parámetro @CodMateria.> 
-- Modificacion				<27/02/2019> <Isaac Dobles> <Se ajusta para tabla Catalogo.EstadoTipoOficina>
-- Modificación:			<04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarEstadoTipoOficina]
   @CodTipoOficina		smallint,
   @CodEstado			int,
   @CodMateria			Varchar(5)
 
AS 
	BEGIN
			DELETE		FROM					Catalogo.EstadoTipoOficina
			WHERE		TN_CodTipoOficina		= @CodTipoOficina
			AND			TN_CodEstado			= @CodEstado
			AND			TC_CodMateria			= @CodMateria
   END
GO
