SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PrioridadEvento] (
		[TN_CodPrioridadEvento]     [smallint] NOT NULL,
		[TC_Descripcion]            [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[intIDPrioridad]            [int] NULL,
		CONSTRAINT [PK_PrioridadEvento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPrioridadEvento])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PrioridadEvento]
	ADD
	CONSTRAINT [DF_PrioridadEvento_TN_CodPrioridadEvento]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaPrioridadEvento]) FOR [TN_CodPrioridadEvento]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de prioridad de los eventos de la agenda.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prioridad del evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEvento', 'COLUMN', N'TN_CodPrioridadEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la prioridad del evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEvento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEvento', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEvento', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[PrioridadEvento] SET (LOCK_ESCALATION = TABLE)
GO
