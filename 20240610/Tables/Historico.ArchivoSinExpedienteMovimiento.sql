SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ArchivoSinExpedienteMovimiento] (
		[TU_CodArchivo]                [uniqueidentifier] NOT NULL,
		[TF_Movimiento]                [datetime2](7) NOT NULL,
		[TC_Movimiento]                [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]               [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_JustificacionTraslado]     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoSinExpedienteMovimiento]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TF_Movimiento])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	ADD
	CONSTRAINT [CK_ArchivoSinExpedienteMovimiento_Movimiento]
	CHECK
	([TC_Movimiento]='C' OR [TC_Movimiento]='I' OR [TC_Movimiento]='T' OR [TC_Movimiento]='R')
GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
CHECK CONSTRAINT [CK_ArchivoSinExpedienteMovimiento_Movimiento]
GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	ADD
	CONSTRAINT [DF__ArchivoSi__TF_Pa__0FF8DE83]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSinExpedienteMovimiento_ArchivoSinExpediente]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [ArchivoSinExpediente].[ArchivoSinExpediente] ([TU_CodArchivo])
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	CHECK CONSTRAINT [FK_ArchivoSinExpedienteMovimiento_ArchivoSinExpediente]

GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSinExpedienteMovimiento_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	CHECK CONSTRAINT [FK_ArchivoSinExpedienteMovimiento_Contextos]

GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSinExpedienteMovimiento_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento]
	CHECK CONSTRAINT [FK_ArchivoSinExpedienteMovimiento_Funcionario]

GO
CREATE CLUSTERED INDEX [IX_Historico_ArchivoSinExpedienteMovimiento_TF_Particion]
	ON [Historico].[ArchivoSinExpedienteMovimiento] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los movimientos que tiene un documento sin expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', 'COLUMN', N'TF_Movimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala el movimiento que tiene el documento sin expediente. Valor ‘C’: Creado, valor ‘I’: Incorporado a expediente, valor ‘T’: Trasladado, valor ‘R’: Recibido.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', 'COLUMN', N'TC_Movimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto en el que se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red del funcionario que realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Justificación señalada en caso que se traslade un documento sin expediente a otro despacho judicial.', 'SCHEMA', N'Historico', 'TABLE', N'ArchivoSinExpedienteMovimiento', 'COLUMN', N'TC_JustificacionTraslado'
GO
ALTER TABLE [Historico].[ArchivoSinExpedienteMovimiento] SET (LOCK_ESCALATION = TABLE)
GO
