SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Migracion].[Expediente] (
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodAccion]            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_Expediente_1]
		PRIMARY KEY
		CLUSTERED
		([TC_NumeroExpediente], [TC_CodAccion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Migracion].[Expediente]
	ADD
	CONSTRAINT [CK_Migracion_Expediente_CodAccion]
	CHECK
	([TC_CodAccion]='A' OR [TC_CodAccion]='E' OR [TC_CodAccion]='N')
GO
ALTER TABLE [Migracion].[Expediente]
CHECK CONSTRAINT [CK_Migracion_Expediente_CodAccion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los datos de los expedientes a actualizar o insertar desde la precarga y hacia la carga', 'SCHEMA', N'Migracion', 'TABLE', N'Expediente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de acción evaluada por la herramienta de migración N = Nuevo en producción, A = Actualiza un cascarón o uno más antiguo, E = Existe en producción. ', 'SCHEMA', N'Migracion', 'TABLE', N'Expediente', 'COLUMN', N'TC_CodAccion'
GO
ALTER TABLE [Migracion].[Expediente] SET (LOCK_ESCALATION = TABLE)
GO
