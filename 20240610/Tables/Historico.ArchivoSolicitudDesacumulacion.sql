SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ArchivoSolicitudDesacumulacion] (
		[TU_CodSolicitud]      [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]        [uniqueidentifier] NOT NULL,
		[TC_ModoSeleccion]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoSolicitudDesacumulacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitud], [TU_CodArchivo])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ArchivoSolicitudDesacumulacion]
	ADD
	CONSTRAINT [DF__ArchivoSo__TF_Pa__57B48560]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ArchivoSolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSolicitudDesacumulacion_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Historico].[ArchivoSolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_ArchivoSolicitudDesacumulacion_Archivo]

GO
ALTER TABLE [Historico].[ArchivoSolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSolicitudDesacumulacion_SolicitudDesacumulacion]
	FOREIGN KEY ([TU_CodSolicitud]) REFERENCES [Historico].[SolicitudDesacumulacion] ([TU_CodSolicitud])
ALTER TABLE [Historico].[ArchivoSolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_ArchivoSolicitudDesacumulacion_SolicitudDesacumulacion]

GO
CREATE CLUSTERED INDEX [IX_Historico_ArchivoSolicitudDesacumulacion_TF_Particiom]
	ON [Historico].[ArchivoSolicitudDesacumulacion] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de solicitud', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSolicitudDesacumulacion', 'COLUMN', N'TU_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de archivo', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSolicitudDesacumulacion', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Modo de selección', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSolicitudDesacumulacion', 'COLUMN', N'TC_ModoSeleccion'
GO
ALTER TABLE [Historico].[ArchivoSolicitudDesacumulacion] SET (LOCK_ESCALATION = TABLE)
GO
