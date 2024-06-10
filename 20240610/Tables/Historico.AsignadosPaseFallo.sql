SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[AsignadosPaseFallo] (
		[TU_CodPaseFallo]         [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_AsignadosPaseFallo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPaseFallo], [TC_CodPuestoTrabajo])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[AsignadosPaseFallo]
	ADD
	CONSTRAINT [DF_AsignadosPaseFallo_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[AsignadosPaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignadosPaseFallo_PaseFallo]
	FOREIGN KEY ([TU_CodPaseFallo]) REFERENCES [Historico].[PaseFallo] ([TU_CodPaseFallo])
ALTER TABLE [Historico].[AsignadosPaseFallo]
	CHECK CONSTRAINT [FK_AsignadosPaseFallo_PaseFallo]

GO
ALTER TABLE [Historico].[AsignadosPaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignadosPaseFallo_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Historico].[AsignadosPaseFallo]
	CHECK CONSTRAINT [FK_AsignadosPaseFallo_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Historico_AsignadosPaseFallo_TF_Particion]
	ON [Historico].[AsignadosPaseFallo] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico para cada pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'AsignadosPaseFallo', 'COLUMN', N'TU_CodPaseFallo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo a quien se asigna el pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'AsignadosPaseFallo', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
ALTER TABLE [Historico].[AsignadosPaseFallo] SET (LOCK_ESCALATION = TABLE)
GO
