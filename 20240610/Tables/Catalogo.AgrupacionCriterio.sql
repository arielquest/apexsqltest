SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[AgrupacionCriterio] (
		[TU_CodAgrupacion]                [uniqueidentifier] NOT NULL,
		[TU_CodCriterio]                  [uniqueidentifier] NOT NULL,
		[TN_CodClase]                     [int] NULL,
		[TN_CodProceso]                   [smallint] NULL,
		[TN_CodFase]                      [smallint] NULL,
		[TU_CodConfiguracionReparto]      [uniqueidentifier] NOT NULL,
		[TN_CodClaseAsunto]               [int] NULL,
		[TC_Nombre]                       [varchar](250) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodCriterioRepartoManual]     [int] NULL,
		CONSTRAINT [PK_AgrupacionCriterio]
		PRIMARY KEY
		CLUSTERED
		([TU_CodAgrupacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_Agrupacion_Clase]
	FOREIGN KEY ([TN_CodClase]) REFERENCES [Catalogo].[Clase] ([TN_CodClase])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_Agrupacion_Clase]

GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_Agrupacion_Criterio]
	FOREIGN KEY ([TU_CodCriterio]) REFERENCES [Catalogo].[CriteriosReparto] ([TU_CodCriterio])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_Agrupacion_Criterio]

GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_Agrupacion_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_Agrupacion_Fase]

GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_Agrupacion_Proceso]
	FOREIGN KEY ([TN_CodProceso]) REFERENCES [Catalogo].[Proceso] ([TN_CodProceso])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_Agrupacion_Proceso]

GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_AgrupacionCriterio_ClaseAsunto]
	FOREIGN KEY ([TN_CodClaseAsunto]) REFERENCES [Catalogo].[ClaseAsunto] ([TN_CodClaseAsunto])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_AgrupacionCriterio_ClaseAsunto]

GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_AgrupacionCriterio_CriterioRepartoManual]
	FOREIGN KEY ([TN_CodCriterioRepartoManual]) REFERENCES [Catalogo].[CriterioRepartoManual] ([TN_CodCriterioRepartoManual])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_AgrupacionCriterio_CriterioRepartoManual]

GO
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionGeneralReparto_AgrupacionCriterio]
	FOREIGN KEY ([TU_CodConfiguracionReparto]) REFERENCES [Catalogo].[ConfiguracionGeneralReparto] ([TU_CodConfiguracionReparto])
ALTER TABLE [Catalogo].[AgrupacionCriterio]
	CHECK CONSTRAINT [FK_ConfiguracionGeneralReparto_AgrupacionCriterio]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TU_CodAgrupacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del criterio que contiene la agrupación', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TU_CodCriterio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la clase', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del proceso', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase de asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del criterio de reparto agrupado', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de criterio de reparto manual', 'SCHEMA', N'Catalogo', 'TABLE', N'AgrupacionCriterio', 'COLUMN', N'TN_CodCriterioRepartoManual'
GO
ALTER TABLE [Catalogo].[AgrupacionCriterio] SET (LOCK_ESCALATION = TABLE)
GO
