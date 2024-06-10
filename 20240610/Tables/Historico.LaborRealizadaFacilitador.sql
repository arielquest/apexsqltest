SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Historico].[LaborRealizadaFacilitador] (
		[TU_CodLaborRealizada]        [uniqueidentifier] NOT NULL,
		[TN_Anno]                     [smallint] NOT NULL,
		[TN_Mes]                      [smallint] NOT NULL,
		[TN_CodFacilitador]           [int] NOT NULL,
		[TN_CodLaborFacilitador]      [smallint] NOT NULL,
		[TN_TotalRealizado]           [smallint] NOT NULL,
		[TN_ParticipantesHombres]     [smallint] NULL,
		[TN_ParticipantesMujeres]     [smallint] NULL,
		[TF_FechaRegistro]            [datetime2](7) NOT NULL,
		[TF_Actualizacion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_LaborRealizadaFacilitador]
		PRIMARY KEY
		CLUSTERED
		([TU_CodLaborRealizada])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[LaborRealizadaFacilitador]
	WITH CHECK
	ADD CONSTRAINT [FK_HistoricoLabor_Facilitador]
	FOREIGN KEY ([TN_CodFacilitador]) REFERENCES [Facilitador].[Facilitador] ([TN_CodFacilitador])
ALTER TABLE [Historico].[LaborRealizadaFacilitador]
	CHECK CONSTRAINT [FK_HistoricoLabor_Facilitador]

GO
ALTER TABLE [Historico].[LaborRealizadaFacilitador]
	WITH CHECK
	ADD CONSTRAINT [FK_HistoricoLabor_LaborFacilitador]
	FOREIGN KEY ([TN_CodLaborFacilitador]) REFERENCES [Catalogo].[LaborFacilitadorJudicial] ([TN_CodLaborFacilitador])
ALTER TABLE [Historico].[LaborRealizadaFacilitador]
	CHECK CONSTRAINT [FK_HistoricoLabor_LaborFacilitador]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registrar el historico de labores realizadas por el facilitadores judiciales', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del historico de la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TU_CodLaborRealizada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el año cuando se realizo la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_Anno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el mes cuando se realizo la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_Mes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica a cual facilitador judicial esta asociado este resgistro historico', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_CodFacilitador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica a cual labor de facilitador esta asociado este resgistro historico', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_CodLaborFacilitador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el total de veces que el facilitador realizo esta labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_TotalRealizado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la cantidad de hombres a las que participaron en la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_ParticipantesHombres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la cantidad de mujeres a las que participaron en la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TN_ParticipantesMujeres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se realizo el registro del historico de la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TF_FechaRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica cuando se hizo la actualizacion de algun registro', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaFacilitador', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Historico].[LaborRealizadaFacilitador] SET (LOCK_ESCALATION = TABLE)
GO
