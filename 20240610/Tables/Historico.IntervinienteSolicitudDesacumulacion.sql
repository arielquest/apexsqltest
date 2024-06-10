SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[IntervinienteSolicitudDesacumulacion] (
		[TU_CodSolicitud]         [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TC_ModoSeleccion]        [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteSolicitudDesacumulacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitud], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
	ADD
	CONSTRAINT [CK_IntervinienteSolicitudDesacumulacion]
	CHECK
	([TC_ModoSeleccion]='M' OR [TC_ModoSeleccion]='C')
GO
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
CHECK CONSTRAINT [CK_IntervinienteSolicitudDesacumulacion]
GO
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__7FC276BA]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteSolicitudDesacumulacion_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_IntervinienteSolicitudDesacumulacion_Intervencion]

GO
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteSolicitudDesacumulacion_SolicitudDesacumulacion]
	FOREIGN KEY ([TU_CodSolicitud]) REFERENCES [Historico].[SolicitudDesacumulacion] ([TU_CodSolicitud])
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_IntervinienteSolicitudDesacumulacion_SolicitudDesacumulacion]

GO
CREATE CLUSTERED INDEX [IX_Historico_IntervinienteSolicitudDesacumulacion_TF_Particion]
	ON [Historico].[IntervinienteSolicitudDesacumulacion] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de solicitud', 'SCHEMA', N'Historico', 'TABLE', N'IntervinienteSolicitudDesacumulacion', 'COLUMN', N'TU_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de interviniente', 'SCHEMA', N'Historico', 'TABLE', N'IntervinienteSolicitudDesacumulacion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Modo de selección', 'SCHEMA', N'Historico', 'TABLE', N'IntervinienteSolicitudDesacumulacion', 'COLUMN', N'TC_ModoSeleccion'
GO
ALTER TABLE [Historico].[IntervinienteSolicitudDesacumulacion] SET (LOCK_ESCALATION = TABLE)
GO
