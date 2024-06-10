SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================  
-- Versión:     <1.0>  
-- Creado por:    <Xinia Soto Valerio>  
-- Fecha de creación:  <07/12/2020>  
-- Descripción:    <Permite agregar un registro a [Agenda].[ParticipanteExterno].>  
-- ===========================================================================================  

  
CREATE PROCEDURE [Agenda].[PA_AgregarParticipanteExterno]  
  @CodigoEvento Uniqueidentifier,   
  @NumeroBoleta Varchar(20),  
  @PlacaVehiculo Varchar(10),  
  @AportaFotografias bit,  
  @UsuarioExterno Varchar(30)
As  
Begin  

Declare   @L_CodigoEvento Uniqueidentifier = @CodigoEvento,   
  @L_NumeroBoleta Varchar(20) = @NumeroBoleta,  
  @L_PlacaVehiculo Varchar(10) = @PlacaVehiculo,  
  @L_AportaFotografias bit = @AportaFotografias,  
  @L_UsuarioExterno Varchar(30) = @UsuarioExterno
  
 Insert Into [Agenda].[ParticipanteExterno]  
 (  
  TU_CodEvento,   
  NumeroBoleta,
  PlacaVehiculo,
  AportaFotografias,
  UsuarioExterno,
  TF_Particion,
  TU_CodParticipacion
 )  
 Values  
 (  
  @L_CodigoEvento,
  @L_NumeroBoleta,
  @L_PlacaVehiculo,
  @L_AportaFotografias,
  @L_UsuarioExterno,
  GETDATE(),
  NEWID()
    )  
  
End  
  
  
GO
