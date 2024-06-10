SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Permite agregar un registro a [AgEnda].[Evento].>
-- ===========================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <30/05/2018> <Se cambian los campos Oficina por Contexto> 
-- =========================================================================================================
-- Modificado por:		<Ronny Ramírez Rojas>
-- Fecha:				<13/08/2019>
-- Descripción:			<Se modifica para cambiar parámetro código de legajo por número de expediente>
-- =========================================================================================================
-- Modificado por:		<Daniel Ruiz Hernández>
-- Fecha:				<28/08/2020>
-- Descripción:			<Se agrega al insert la fecha de actualizacion>
-- =========================================================================================================
-- Modificado por:		<Aarón Ríos Retana>
-- Fecha:				<11/11/2021>
-- Descripción:			<Se agrega al insert el código del legajo y se agregan las variables para almacenar los parametros>
-- =========================================================================================================

CREATE PROCEDURE [Agenda].[PA_AgregarEvento]
	 @CodigoEvento Uniqueidentifier,
	 @CodigoContexto Varchar(4),
	 @NumeroExpediente char(14),
	 @Titulo Varchar(80),
	 @Descripcion Varchar(300),
	 @CodigoTipoEvento Smallint,
	 @CodigoEstadoEvento Smallint,
	 @CodigoMotivoEvento Smallint,
	 @CodigoPrioridadEvento Smallint,
	 @UsuarioCrea Varchar(30),
	 @RequiereSala Bit,
	 @FechaCreacion Datetime2(7),
	 @CodigoLegajo uniqueidentifier

As
Begin
	--Declaración de variables 
	Declare @L_CodigoEvento Uniqueidentifier = @CodigoEvento;
	Declare @L_CodigoContexto Varchar(4) = @CodigoContexto;
	Declare @L_NumeroExpediente char(14) = @NumeroExpediente;
	Declare @L_Titulo Varchar(80) = @Titulo;
	Declare @L_Descripcion Varchar(300) = @Descripcion;
	Declare @L_CodigoTipoEvento Smallint = @CodigoTipoEvento;
	Declare @L_CodigoEstadoEvento Smallint = @CodigoEstadoEvento;
	Declare @L_CodigoMotivoEvento Smallint = @CodigoMotivoEvento;
	Declare @L_CodigoPrioridadEvento Smallint = @CodigoPrioridadEvento;
	Declare @L_UsuarioCrea Varchar(30) = @UsuarioCrea;
	Declare @L_RequiereSala Bit = @RequiereSala;
	Declare @L_FechaCreacion Datetime2(7) = @FechaCreacion;
	Declare @L_CodigoLegajo uniqueidentifier = @CodigoLegajo;
	-- Se realizar el insert del evento
	Insert Into [AgEnda].[Evento]
	(
		TU_CodEvento, 
		TC_CodContexto, 
		TC_NumeroExpediente, 
		TC_Titulo, 
		TC_Descripcion, 
		TN_CodTipoEvento, 
		TN_CodEstadoEvento, 
		TN_CodMotivoEstado, 
		TN_CodPrioridadEvento, 
		TC_UsuarioCrea, 
		TB_RequiereSala, 
		TF_FechaCreacion,
		TF_Actualizacion,
		TU_CodLegajo
	)
	Values
	(
		 @L_CodigoEvento,
		 @L_CodigoContexto,
		 @L_NumeroExpediente,
		 @L_Titulo,
		 @L_Descripcion,
		 @L_CodigoTipoEvento,
		 @L_CodigoEstadoEvento,
		 @L_CodigoMotivoEvento,
		 @L_CodigoPrioridadEvento,
		 @L_UsuarioCrea,
		 @L_RequiereSala,
		 @L_FechaCreacion,
		 getdate(),
		 @L_CodigoLegajo
    )

End


GO
