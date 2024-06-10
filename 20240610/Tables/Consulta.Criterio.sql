SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Consulta].[Criterio] (
		[TN_CodCriterio]         [smallint] NOT NULL,
		[TC_Nombre]              [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Criterio]            [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodModulo]           [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Criterio]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCriterio])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Consulta].[Criterio]
	ADD
	CONSTRAINT [DF_Criterio_TN_CodCriterio]
	DEFAULT (NEXT VALUE FOR [Consulta].[SecuenciaCriterio]) FOR [TN_CodCriterio]
GO
ALTER TABLE [Consulta].[Criterio]
	WITH CHECK
	ADD CONSTRAINT [FK_Criterio_Modulo]
	FOREIGN KEY ([TN_CodModulo]) REFERENCES [Consulta].[Modulo] ([TN_CodModulo])
ALTER TABLE [Consulta].[Criterio]
	CHECK CONSTRAINT [FK_Criterio_Modulo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Relación entre el criterio de búsqueda y su módulo.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'CONSTRAINT', N'FK_Criterio_Modulo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los criterios de búsqueda.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de criterio de búsqueda.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'COLUMN', N'TN_CodCriterio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del criterio de búsqueda.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Criterio de búsqueda.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'COLUMN', N'TC_Criterio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del módulo asociado.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'COLUMN', N'TN_CodModulo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Criterio', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Consulta].[Criterio] SET (LOCK_ESCALATION = TABLE)
GO
