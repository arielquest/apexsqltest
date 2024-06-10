SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<23/03/2018>
-- Descripción :			<Permite asociar contexto a un puesto de trabajo>
-- =================================================================================================================================================
-- Modificación:			<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia'.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarContextoPuestoTrabajo]
   @CodContexto			varchar(4),
   @CodPuestoTrabajo	varchar(14),
   @Inicio_Vigencia		datetime2(7)
AS 
BEGIN          
	INSERT INTO Catalogo.ContextoPuestoTrabajo
	(
		TC_CodContexto,TC_CodPuestoTrabajo, TF_Inicio_Vigencia
	)
		VALUES
	(
		@CodContexto,	@CodPuestoTrabajo, @Inicio_Vigencia 
	)
END
GO
