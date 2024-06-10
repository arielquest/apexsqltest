SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[AsuntosReparto] (
		[TN_CodAsunto]                   [int] NOT NULL,
		[TU_CodConfiguracionReparto]     [uniqueidentifier] NOT NULL,
		CONSTRAINT [PK_AsuntosReparto]
		PRIMARY KEY
		CLUSTERED
		([TN_CodAsunto], [TU_CodConfiguracionReparto])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[AsuntosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_asunto_asunto]
	FOREIGN KEY ([TN_CodAsunto]) REFERENCES [Catalogo].[Asunto] ([TN_CodAsunto])
ALTER TABLE [Catalogo].[AsuntosReparto]
	CHECK CONSTRAINT [FK_asunto_asunto]

GO
ALTER TABLE [Catalogo].[AsuntosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_asunto_configuracion]
	FOREIGN KEY ([TU_CodConfiguracionReparto]) REFERENCES [Catalogo].[ConfiguracionGeneralReparto] ([TU_CodConfiguracionReparto])
ALTER TABLE [Catalogo].[AsuntosReparto]
	CHECK CONSTRAINT [FK_asunto_configuracion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Alnacena los asuntos de legajos que se reparten para un contexto dado', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntosReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de asunto para legajo que se repartirá', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntosReparto', 'COLUMN', N'TN_CodAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la configuración de reparto para el despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntosReparto', 'COLUMN', N'TU_CodConfiguracionReparto'
GO
ALTER TABLE [Catalogo].[AsuntosReparto] SET (LOCK_ESCALATION = TABLE)
GO
