SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Legajo] (
		[TU_CodLegajo]               [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]        [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio]                  [datetime2](7) NOT NULL,
		[TC_CodContextoCreacion]     [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]             [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodPrioridad]            [smallint] NULL,
		[TF_Actualizacion]           [datetime2](7) NOT NULL,
		[CARPETA]                    [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		[TB_EmbargosFisicos]         [bit] NOT NULL,
		CONSTRAINT [PK_Legajo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Legajo]
	ADD
	CONSTRAINT [DF__Legajo__TF_Actua__7896563E]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Legajo]
	ADD
	CONSTRAINT [DF__Legajo__TF_Parti__6CAFA246]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Legajo]
	ADD
	CONSTRAINT [DF__Legajo__TB_Embar__522F1F86]
	DEFAULT ((0)) FOR [TB_EmbargosFisicos]
GO
ALTER TABLE [Expediente].[Legajo]
	WITH CHECK
	ADD CONSTRAINT [FK_Legajo_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Legajo]
	CHECK CONSTRAINT [FK_Legajo_Contexto]

GO
ALTER TABLE [Expediente].[Legajo]
	WITH CHECK
	ADD CONSTRAINT [FK_Legajo_ContextoCreacion]
	FOREIGN KEY ([TC_CodContextoCreacion]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Legajo]
	CHECK CONSTRAINT [FK_Legajo_ContextoCreacion]

GO
ALTER TABLE [Expediente].[Legajo]
	WITH CHECK
	ADD CONSTRAINT [FK_Legajo_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[Legajo]
	CHECK CONSTRAINT [FK_Legajo_Expediente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Legajo_TF_Particion]
	ON [Expediente].[Legajo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_Legajo_TC_Contexto_INCLUDE]
	ON [Expediente].[Legajo] ([TC_CodContexto])
	INCLUDE ([TU_CodLegajo], [TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_Legajo_TC_Contexto_TU_CodLegajo]
	ON [Expediente].[Legajo] ([TC_CodContexto])
	INCLUDE ([TU_CodLegajo], [TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Legajo_TC_NumeroExpediente]
	ON [Expediente].[Legajo] ([TC_NumeroExpediente])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Codigo]
	ON [Expediente].[Legajo] ([TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que lleva el control de legajos de un expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número único del expediente donde esta asociado el legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se crea el legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TF_Inicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se creó el legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TC_CodContextoCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se encuentra el legajo en la fecha actual.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TN_CodPrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de carpeta que identifica al legajo en Gestión, se registra para facilitar las itineraciones entre SIAGPJ y Gestión', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'CARPETA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para determinar si el legajo posee embargos que fueron registrados de forma física o no.', 'SCHEMA', N'Expediente', 'TABLE', N'Legajo', 'COLUMN', N'TB_EmbargosFisicos'
GO
ALTER TABLE [Expediente].[Legajo] SET (LOCK_ESCALATION = TABLE)
GO
