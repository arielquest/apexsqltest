SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Migracion].[Bitacora] (
		[TN_CodBitacora]          [bigint] NOT NULL,
		[TC_CodAccion]            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Esquema]              [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Tabla]                [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Mensaje]              [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Valores]              [varchar](max) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha_Registro]       [datetime2](7) NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_EsPreCargaACarga]     [bit] NOT NULL,
		CONSTRAINT [PK_Migracion_Bitacora]
		PRIMARY KEY
		CLUSTERED
		([TN_CodBitacora])
	ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Migracion].[Bitacora]
	ADD
	CONSTRAINT [CK_Migracion_Bitacora_CodAccion]
	CHECK
	([TC_CodAccion]='A' OR [TC_CodAccion]='I')
GO
ALTER TABLE [Migracion].[Bitacora]
CHECK CONSTRAINT [CK_Migracion_Bitacora_CodAccion]
GO
ALTER TABLE [Migracion].[Bitacora]
	ADD
	CONSTRAINT [DF_Migracion_Bitacora_TN_CodBitacora]
	DEFAULT (NEXT VALUE FOR [Migracion].[SecuenciaBitacora]) FOR [TN_CodBitacora]
GO
ALTER TABLE [Migracion].[Bitacora]
	ADD
	CONSTRAINT [DF__Bitacora__TF_Fec__00C7174C]
	DEFAULT (getdate()) FOR [TF_Fecha_Registro]
GO
ALTER TABLE [Migracion].[Bitacora]
	ADD
	CONSTRAINT [DF__Bitacora__TB_EsP__392E6792]
	DEFAULT ((0)) FOR [TB_EsPreCargaACarga]
GO
CREATE NONCLUSTERED INDEX [IX_Migracion_Bitacora_TC_CodContexto_TB_EsPreCargaACarga]
	ON [Migracion].[Bitacora] ([TC_CodContexto], [TB_EsPreCargaACarga])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registro de eventos de la herramienta de migración de datos.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de registro de bitácora.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TN_CodBitacora'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de acción efectuada por la herramienta de migración A = registro agregado, I = registro no agregado.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TC_CodAccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del esquema al cual pretenece la tabla para la cual se inserta el registro.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TC_Esquema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la tabla para la cual se inserta el registro.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TC_Tabla'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mensaje informativo del evento ocurrido con el registro', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TC_Mensaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valores que formaban parte del trasiego de información.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TC_Valores'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del registro.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TF_Fecha_Registro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto al que pertenece la bitácora.', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se registra un 1 si es una bitácora del proceso de migración de Precarga a Carga, caso contrario un 0 (si es del proceso de migración de los orígenes a Precarga)', 'SCHEMA', N'Migracion', 'TABLE', N'Bitacora', 'COLUMN', N'TB_EsPreCargaACarga'
GO
ALTER TABLE [Migracion].[Bitacora] SET (LOCK_ESCALATION = TABLE)
GO
