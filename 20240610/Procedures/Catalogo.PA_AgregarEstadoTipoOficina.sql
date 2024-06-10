SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite Agregar un estado a un tipo de oficina>
-- Modificado :				<Olger Gamboa Castillo, 17/12/2015, Se modifica el tipo de dato del codigo de estado a smallint.> 
-- Modificado:              <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <17/12/2015>
-- Descripcion:	            <Se cambia la llave a smallint squence>
-- Modificacion:			<26/02/2019> <Isaac Dobles> <Se ajusta a tabla EstadoTipoOficina>
-- Modificación:			<04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarEstadoTipoOficina]
	@CodTipoOficina			smallint,
	@CodEstado				int,
	@FechaActivacion		datetime2,
	@IniciaTramitacion		bit,
	@CierreAcumulacion		bit, 
	@CodMateria				Varchar(5)
AS 
BEGIN
          
	INSERT INTO Catalogo.EstadoTipoOficina
	(	
		TN_CodTipoOficina,	TN_CodEstado,	TF_Inicio_Vigencia,		TB_IniciaTramitacion,
		TC_CodMateria,		TB_CierreAcumulacion
	)
	VALUES
	(	
		@CodTipoOficina,	@CodEstado,		@FechaActivacion,		@IniciaTramitacion,
		@CodMateria,		@CierreAcumulacion	
	)
END
 

GO
