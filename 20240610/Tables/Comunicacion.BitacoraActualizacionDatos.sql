SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[BitacoraActualizacionDatos] (
		[TF_Fecha_Registro]     [datetime2](7) NULL,
		[TC_CodAccion]          [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Esquema]            [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Tabla]              [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Mensaje]            [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Valores]            [varchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]        [varchar](4) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Comunicacion].[BitacoraActualizacionDatos]
	ADD
	CONSTRAINT [CK_Comunicacion_BitacoraActualizacionDatos_CodAccion]
	CHECK
	([TC_CodAccion]='A' OR [TC_CodAccion]='I')
GO
ALTER TABLE [Comunicacion].[BitacoraActualizacionDatos]
CHECK CONSTRAINT [CK_Comunicacion_BitacoraActualizacionDatos_CodAccion]
GO
ALTER TABLE [Comunicacion].[BitacoraActualizacionDatos]
	ADD
	CONSTRAINT [DF__Bitacora__TF_Fec__00C7174C]
	DEFAULT (getdate()) FOR [TF_Fecha_Registro]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del registro.', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TF_Fecha_Registro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de acción efectuada por la herramienta de migración A = registro agregado, I = registro no agregado.', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TC_CodAccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del esquema al cual pretenece la tabla para la cual se inserta el registro.', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TC_Esquema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la tabla para la cual se inserta el registro.', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TC_Tabla'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mensaje informativo del evento ocurrido con el registro', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TC_Mensaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valores que formaban parte del trasiego de información.', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TC_Valores'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto al que pertenece la bitácora.', 'SCHEMA', N'Comunicacion', 'TABLE', N'BitacoraActualizacionDatos', 'COLUMN', N'TC_CodContexto'
GO
ALTER TABLE [Comunicacion].[BitacoraActualizacionDatos] SET (LOCK_ESCALATION = TABLE)
GO
