SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[PropuestaDocumento] (
		[TU_CodPropuesta]           [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]             [uniqueidentifier] NOT NULL,
		[TU_CodRepresentacion]      [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_EstadoPropuesta]        [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaPropuesta]         [datetime2](3) NOT NULL,
		[TF_FechaActualizacion]     [datetime2](3) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DefensaPublica_PropuestaDocumento]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPropuesta])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	ADD
	CONSTRAINT [CK_DefensaPublica_PropuestaDocumento_EstadoPropuesta]
	CHECK
	([TC_EstadoPropuesta]='P' OR [TC_EstadoPropuesta]='A' OR [TC_EstadoPropuesta]='R')
GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
CHECK CONSTRAINT [CK_DefensaPublica_PropuestaDocumento_EstadoPropuesta]
GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	ADD
	CONSTRAINT [DF_DefensaPublica_PropuestaDocumento_TF_FechaActualizacion]
	DEFAULT (sysdatetime()) FOR [TF_FechaActualizacion]
GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	ADD
	CONSTRAINT [DF_DefensaPublica_PropuestaDocumento_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_PropuestaDocumento_TC_CodPuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	CHECK CONSTRAINT [FK_DefensaPublica_PropuestaDocumento_TC_CodPuestoTrabajo]

GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_PropuestaDocumento_TU_CodArchivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	CHECK CONSTRAINT [FK_DefensaPublica_PropuestaDocumento_TU_CodArchivo]

GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_PropuestaDocumento_TU_CodRepresentacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[PropuestaDocumento]
	CHECK CONSTRAINT [FK_DefensaPublica_PropuestaDocumento_TU_CodRepresentacion]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_PropuestaDocumento_TF_Particion]
	ON [DefensaPublica].[PropuestaDocumento] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para determinar vinculación de documento propuesto a representacion(es)', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico de la tabla propuesta documento', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TU_CodPropuesta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico que vincula al registro del documento registrado', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico del registro de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico del registro del puesto de trabajo', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor que indica el estado del documento propuesto a la o las representaciones (P = Pendiente, A = Aceptado, R = Rechazado)', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TC_EstadoPropuesta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de cuando se registro la propuesta del documento a la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TF_FechaPropuesta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TF_FechaActualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de partición del registro', 'SCHEMA', N'DefensaPublica', 'TABLE', N'PropuestaDocumento', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [DefensaPublica].[PropuestaDocumento] SET (LOCK_ESCALATION = TABLE)
GO
