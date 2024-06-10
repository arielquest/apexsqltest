SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<21/06/2018>
-- Descripción :			<Permite Agregar un TipoResolucion a un tipo de oficina y materia>

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoOficinaTipoResolucion]
	@CodTipoOficina			smallint,
	@CodTipoResolucion		smallint,
	@CodMateria				varchar(5),
	@Inicio_Vigencia        datetime2
AS 
    BEGIN
          
		INSERT INTO Catalogo.TipoOficinaTipoResolucion
		(
			TN_CodTipoOficina,	TN_CodTipoResolucion,	TF_Inicio_Vigencia, TC_CodMateria
		)
		VALUES
		(
			@CodTipoOficina,	@CodTipoResolucion,		@Inicio_Vigencia,	@CodMateria
		)
    END
 





GO
