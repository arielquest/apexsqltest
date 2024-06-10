SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico] (
		[TU_CodComunicacionAut]     [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]       [uniqueidentifier] NOT NULL,
		[TB_EsPrincipal]            [bit] NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ComunicacionIntervencionRegistroAutomatico]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodComunicacionAut], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [FG_Comunicacion]
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico]
	ADD
	CONSTRAINT [DF_FK_ComunicacionIntervencionRegistroAutomatico_TB_EsPrincipal]
	DEFAULT ((0)) FOR [TB_EsPrincipal]
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico]
	ADD
	CONSTRAINT [DF_ComunicacionIntervencionRegistroAutomatico_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionIntervencionRegistroAutomatico_ComunicacionRegistroAutomatico]
	FOREIGN KEY ([TU_CodComunicacionAut]) REFERENCES [Comunicacion].[ComunicacionRegistroAutomatico] ([TU_CodComunicacionAut])
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionIntervencionRegistroAutomatico_ComunicacionRegistroAutomatico]

GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionIntervencionRegistroAutomatico_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionIntervencionRegistroAutomatico_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_ComunicacionIntervencionRegistroAutomatico_TF_Particion]
	ON [Comunicacion].[ComunicacionIntervencionRegistroAutomatico] ([TF_Particion])
	ON [FG_Comunicacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla liga los preregistros de las comunicaciones judiciales con los intervinientes', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencionRegistroAutomatico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador único del pre registro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencionRegistroAutomatico', 'COLUMN', N'TU_CodComunicacionAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del registro del interviniente', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencionRegistroAutomatico', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de si la comunicación es al medio principal', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionIntervencionRegistroAutomatico', 'COLUMN', N'TB_EsPrincipal'
GO
ALTER TABLE [Comunicacion].[ComunicacionIntervencionRegistroAutomatico] SET (LOCK_ESCALATION = TABLE)
GO
