SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[ComunicacionIntervencion] (
		[TU_CodComunicacion]      [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TB_Principal]            [bit] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		[TB_Leido]                [bit] NOT NULL,
		[TF_FechaLeido]           [datetime2](3) NULL,
		CONSTRAINT [PK_ComunicacionIntervencion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodComunicacion], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	ADD
	CONSTRAINT [DF__Comunicac__TB_Pr__423A458D]
	DEFAULT ((0)) FOR [TB_Principal]
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	ADD
	CONSTRAINT [DF__Comunicac__TF_Pa__6326380C]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	ADD
	CONSTRAINT [DF_ComunicacionIntervencion_TB_Leido]
	DEFAULT ((0)) FOR [TB_Leido]
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	CHECK CONSTRAINT [FK_Comunicacion_Intervencion]

GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionIntervencion_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Comunicacion].[ComunicacionIntervencion]
	CHECK CONSTRAINT [FK_ComunicacionIntervencion_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_ComunicacionIntervencion_TF_Particion]
	ON [Comunicacion].[ComunicacionIntervencion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Comunicacion_ComunicacionIntervencion_TU_CodInterviniente]
	ON [Comunicacion].[ComunicacionIntervencion] ([TU_CodInterviniente])
	WITH ( FILLFACTOR = 100)
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_ComunicacionIntervencion_Migracion]
	ON [Comunicacion].[ComunicacionIntervencion] ([TU_CodComunicacion], [TU_CodInterviniente])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencion', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del interviniente', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de si la comunicación es al medio principal', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencion', 'COLUMN', N'TB_Principal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de si la comunicación ha sido leída', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencion', 'COLUMN', N'TB_Leido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de la fecha en que la notificación fue leída', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencion', 'COLUMN', N'TF_FechaLeido'
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencion] SET (LOCK_ESCALATION = TABLE)
GO
