SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LaborRealizadaPersonalJudicial] (
		[TU_CodLabor]                     [uniqueidentifier] NOT NULL,
		[TN_Anno]                         [smallint] NOT NULL,
		[TN_Mes]                          [smallint] NOT NULL,
		[TC_UsuarioRed]                   [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                  [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodLaborPersonalJudicial]     [smallint] NOT NULL,
		[TN_HorasOficina]                 [smallint] NOT NULL,
		[TN_HorasFueraOficina]            [smallint] NOT NULL,
		[TF_FechaRegistro]                [datetime2](7) NOT NULL,
		[TF_Actualizacion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CodLabor]
		PRIMARY KEY
		CLUSTERED
		([TU_CodLabor])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[LaborRealizadaPersonalJudicial]
	WITH CHECK
	ADD CONSTRAINT [FK_LaborRealizadaPersonalJudicial_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LaborRealizadaPersonalJudicial]
	CHECK CONSTRAINT [FK_LaborRealizadaPersonalJudicial_Contexto]

GO
ALTER TABLE [Historico].[LaborRealizadaPersonalJudicial]
	WITH CHECK
	ADD CONSTRAINT [FK_LaborRealizadaPersonalJudicial_LaborPersonalJudicial]
	FOREIGN KEY ([TN_CodLaborPersonalJudicial]) REFERENCES [Catalogo].[LaborPersonalJudicial] ([TN_CodLaborPersonalJudicial])
ALTER TABLE [Historico].[LaborRealizadaPersonalJudicial]
	CHECK CONSTRAINT [FK_LaborRealizadaPersonalJudicial_LaborPersonalJudicial]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registrar el historico de labores realizadas por el personal judicial', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del historico de la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TU_CodLabor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el año cuando se realizo la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TN_Anno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el mes cuando se realizo la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TN_Mes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el usuario de red asociado al historico de la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el contexto asociado al historico de la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica a cual labor de personal judicial esta asociado al historico', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TN_CodLaborPersonalJudicial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica un total de horas para labores realizadas en oficina', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TN_HorasOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica un total de horas para labores realizadas fuera de oficina', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TN_HorasFueraOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se realizo el registro del historico de la labor', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TF_FechaRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica cuando se hizo la actualizacion de algun registro', 'SCHEMA', N'Historico', 'TABLE', N'LaborRealizadaPersonalJudicial', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Historico].[LaborRealizadaPersonalJudicial] SET (LOCK_ESCALATION = TABLE)
GO
