SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<06/11/2015>
-- Descripción :			<Permite Agregar un ResultadoResolucion a un tipo de oficina>
-- =================================================================================================================================================
-- Modificación:			<16/12/2015> <Johan Acosta> <Cambio tipo smallint TC_CodResultadoResolucion>
-- Modificación:			<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificación:			<15/06/2018> <Jonathan Aguilar Navarrro> <Se agrega la materia>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarTipoOficinaResultadoResolucion]
	@CodTipoOficina			smallint,
	@CodResultadoResolucion smallint,
	@CodMateria				varchar(5),
	@Inicio_Vigencia        datetime2
AS 
    BEGIN
          
		INSERT INTO Catalogo.TipoOficinaResultadoResolucion
		(
			TN_CodTipoOficina,	TN_CodResultadoResolucion,	TF_Inicio_Vigencia, TC_CodMateria
		)
		VALUES
		(
			@CodTipoOficina,	@CodResultadoResolucion,	@Inicio_Vigencia, @CodMateria
		)
    END
 





GO
