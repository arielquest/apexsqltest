SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Estado] (
		[TN_CodEstado]            [int] NOT NULL,
		[TC_Descripcion]          [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]         [datetime2](7) NULL,
		[TC_ExpedienteLegajo]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Circulante]           [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Pasivo]               [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[CODESTASU]               [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		[CODTIDEJ]                [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Estado]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstado])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Estado]
	ADD
	CONSTRAINT [CK_Estado_Circulante]
	CHECK
	([TC_Circulante]='F' OR [TC_Circulante]='P' OR [TC_Circulante]='A')
GO
ALTER TABLE [Catalogo].[Estado]
CHECK CONSTRAINT [CK_Estado_Circulante]
GO
ALTER TABLE [Catalogo].[Estado]
	ADD
	CONSTRAINT [CK_Estado_ExpedienteLegajo]
	CHECK
	([TC_ExpedienteLegajo]='L' OR [TC_ExpedienteLegajo]='E' OR [TC_ExpedienteLegajo]='A')
GO
ALTER TABLE [Catalogo].[Estado]
CHECK CONSTRAINT [CK_Estado_ExpedienteLegajo]
GO
ALTER TABLE [Catalogo].[Estado]
	ADD
	CONSTRAINT [CK_Estado_Pasivo]
	CHECK
	([TC_Pasivo]='I' OR [TC_Pasivo]='S')
GO
ALTER TABLE [Catalogo].[Estado]
CHECK CONSTRAINT [CK_Estado_Pasivo]
GO
ALTER TABLE [Catalogo].[Estado]
	ADD
	CONSTRAINT [DF_Estado_TN_CodEstado]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstado]) FOR [TN_CodEstado]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados del expediente y del legajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado del expediente y del legajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado del expediente y del legajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala si el estado corresponde a expediente (E), legajo (L) o Ambos (A).', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TC_ExpedienteLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala la condición en el circulante en que está en el expediente o legajo de acuerdo a su estado. A: Activo, P: Pasivo, F: Finalizado.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TC_Circulante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite señalar si el expediente o legajo está suspendido (S) o inactivo (I).', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'TC_Pasivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'CODESTASU'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estado', 'COLUMN', N'CODTIDEJ'
GO
ALTER TABLE [Catalogo].[Estado] SET (LOCK_ESCALATION = TABLE)
GO
