SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CriteriosReparto] (
		[TU_CodCriterio]                  [uniqueidentifier] NOT NULL,
		[TN_CodClase]                     [int] NULL,
		[TN_CodProceso]                   [smallint] NULL,
		[TN_CodFase]                      [smallint] NULL,
		[TU_CodConfiguracionReparto]      [uniqueidentifier] NOT NULL,
		[TC_Nombre]                       [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_Herencia]                     [bit] NOT NULL,
		[TB_Agrupacion]                   [bit] NOT NULL,
		[TF_FechaParticion]               [datetime2](7) NOT NULL,
		[TN_CodClaseAsunto]               [int] NULL,
		[TN_CodCriterioRepartoManual]     [int] NULL,
		CONSTRAINT [PK_criterios]
		PRIMARY KEY
		CLUSTERED
		([TU_CodCriterio])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	ADD
	CONSTRAINT [DF_criterios_TB_Herencia]
	DEFAULT ((0)) FOR [TB_Herencia]
GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	ADD
	CONSTRAINT [DF_criterios_TB_Agrupacion]
	DEFAULT ((0)) FOR [TB_Agrupacion]
GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionGeneralReparto_Criterio]
	FOREIGN KEY ([TU_CodConfiguracionReparto]) REFERENCES [Catalogo].[ConfiguracionGeneralReparto] ([TU_CodConfiguracionReparto])
ALTER TABLE [Catalogo].[CriteriosReparto]
	CHECK CONSTRAINT [FK_ConfiguracionGeneralReparto_Criterio]

GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Criterio_Clase]
	FOREIGN KEY ([TN_CodClase]) REFERENCES [Catalogo].[Clase] ([TN_CodClase])
ALTER TABLE [Catalogo].[CriteriosReparto]
	CHECK CONSTRAINT [FK_Criterio_Clase]

GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Criterio_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Catalogo].[CriteriosReparto]
	CHECK CONSTRAINT [FK_Criterio_Fase]

GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Criterio_Proceso]
	FOREIGN KEY ([TN_CodProceso]) REFERENCES [Catalogo].[Proceso] ([TN_CodProceso])
ALTER TABLE [Catalogo].[CriteriosReparto]
	CHECK CONSTRAINT [FK_Criterio_Proceso]

GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_CriterioRepartoManual_Criterio]
	FOREIGN KEY ([TN_CodCriterioRepartoManual]) REFERENCES [Catalogo].[CriterioRepartoManual] ([TN_CodCriterioRepartoManual])
ALTER TABLE [Catalogo].[CriteriosReparto]
	CHECK CONSTRAINT [FK_CriterioRepartoManual_Criterio]

GO
ALTER TABLE [Catalogo].[CriteriosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_CriteriosReparto_ClaseAsunto]
	FOREIGN KEY ([TN_CodClaseAsunto]) REFERENCES [Catalogo].[ClaseAsunto] ([TN_CodClaseAsunto])
ALTER TABLE [Catalogo].[CriteriosReparto]
	CHECK CONSTRAINT [FK_CriteriosReparto_ClaseAsunto]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los criterios de reparto para un despacho. Sí por ejemplo se reparte por clases, sería la lista de clases.', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TU_CodCriterio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase, Catalogo.Clase', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del proceso, Catalogo.Proceso', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase, Catalogo.Fase', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la configuración a la que pertenece el criterio', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TU_CodConfiguracionReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del criterio de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de sí permite la herencia de resposables', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TB_Herencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador sí el criterio está agrupado, es decir, está formado por varios criterios', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TB_Agrupacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha para la partición de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TF_FechaParticion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clase de asuntos de legajos', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo de criterio de reparto manual', 'SCHEMA', N'Catalogo', 'TABLE', N'CriteriosReparto', 'COLUMN', N'TN_CodCriterioRepartoManual'
GO
ALTER TABLE [Catalogo].[CriteriosReparto] SET (LOCK_ESCALATION = TABLE)
GO
