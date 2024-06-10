SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[JornadaComunicacion] (
		[TU_CodJornadaComunicacion]     [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]           [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Apertura]                   [datetime2](7) NOT NULL,
		[TF_Cierre]                     [datetime2](7) NULL,
		[TC_Observaciones]              [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		[IdNC]                          [int] NULL,
		CONSTRAINT [PK_JornadaComunicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodJornadaComunicacion])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[JornadaComunicacion]
	ADD
	CONSTRAINT [DF__JornadaCo__TF_Pa__5C793A7D]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[JornadaComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_JornadaComunicacion_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Comunicacion].[JornadaComunicacion]
	CHECK CONSTRAINT [FK_JornadaComunicacion_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_JornadaComunicacion_TF_Particion]
	ON [Comunicacion].[JornadaComunicacion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para almacenar las comunicaciones que un oficial de comunicacion realiza en una jornada de trabajo. Solo puede haber una jornada abierta por puesto de trabajo', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador unico del registro de la cominicacion ', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacion', 'COLUMN', N'TU_CodJornadaComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo del oficial de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacion', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora de apertura de la jornada', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacion', 'COLUMN', N'TF_Apertura'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora del cierre de la jornada', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacion', 'COLUMN', N'TF_Cierre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observacioes o justificación de la jornada', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacion', 'COLUMN', N'TC_Observaciones'
GO
ALTER TABLE [Comunicacion].[JornadaComunicacion] SET (LOCK_ESCALATION = TABLE)
GO
