SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Fabian Sequeira Gamboa>
-- Fecha de creación:		<18/05/2021>
-- Descripción:				<Obtiene las comunicaciones temporales para una comunicacion automatica.> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarComunicacionTemporal]
AS
DECLARE @Top AS INT; 
SET @Top = 1000; 
BEGIN
SELECT (@TOP) TU_CodComunicacionAut				
      ,TU_CodAsignacionFirmado					AS CodigoAsignacionFirmado 
      ,TC_CodContextoOCJ						AS ContextoOCJ
      ,TC_CodMedio								AS TipoMedioComunicacion
      ,TC_Valor									AS Valor
      ,TN_CodProvincia							AS Provincia
      ,TN_CodCanton								AS Canton
      ,TN_CodDistrito							AS Distrito
      ,TN_CodBarrio								AS Barrio
      ,TN_CodSector								AS Sector
      ,TC_Rotulado								AS Rotulado
      ,TB_TienePrioridad						AS TienePrioridad
      ,TN_PrioridadMedio						AS PrioridadMedio
      ,TF_FechaResolucion						AS FechaResolucion
      ,TN_CodHorarioMedio						AS HorarioMedioComunicacion
      ,TB_RequiereCopias						AS RequiereCopias
      ,TC_Observaciones							AS Observaciones
      ,TU_CodPuestoFuncionarioRegistro			AS PuestoTrabajoFuncionario
      ,TF_FechaPreRegistro						AS FechaPreRegistro
      ,TC_TipoComunicacion						AS TipoComunicacion
      ,TC_EstadoEnvio							AS EstadoEnvioComunicacion
      ,TF_Particion								AS Particion 
  FROM Comunicacion.ComunicacionRegistroAutomatico
  where TC_EstadoEnvio = 'P'
END


GO
