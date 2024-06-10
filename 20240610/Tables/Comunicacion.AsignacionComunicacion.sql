SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[AsignacionComunicacion] (
		[TU_CodAsignacion]                [uniqueidentifier] NOT NULL,
		[TU_CodComunicacion]              [uniqueidentifier] NOT NULL,
		[TC_UsuarioAsigna]                [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaAsignacion]              [datetime2](7) NOT NULL,
		[TC_CodPuestoTrabajoAsignado]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                    [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ComunicacionOfcialComunicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodAsignacion])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[AsignacionComunicacion]
	ADD
	CONSTRAINT [DF__Asignacio__TF_Pa__10ED02BC]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[AsignacionComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionComunicacion_PuestoTrabajoAsignado]
	FOREIGN KEY ([TC_CodPuestoTrabajoAsignado]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Comunicacion].[AsignacionComunicacion]
	CHECK CONSTRAINT [FK_AsignacionComunicacion_PuestoTrabajoAsignado]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_AsignacionComunicacion_TF_Particion]
	ON [Comunicacion].[AsignacionComunicacion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Asocia las comunicaciones a los distintos funcionarios de la OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'AsignacionComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la asignacion', 'SCHEMA', N'Comunicacion', 'TABLE', N'AsignacionComunicacion', 'COLUMN', N'TU_CodAsignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'AsignacionComunicacion', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del usuario que realiza la asignación', 'SCHEMA', N'Comunicacion', 'TABLE', N'AsignacionComunicacion', 'COLUMN', N'TC_UsuarioAsigna'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se asigna la comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'AsignacionComunicacion', 'COLUMN', N'TF_FechaAsignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo del oficial al que se le asigna la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'AsignacionComunicacion', 'COLUMN', N'TC_CodPuestoTrabajoAsignado'
GO
ALTER TABLE [Comunicacion].[AsignacionComunicacion] SET (LOCK_ESCALATION = TABLE)
GO
