SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Tarea] (
		[TN_CodTarea]            [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[CODTAREA]               [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [KTAREA$TAREA_PK]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodTarea])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[Tarea]
	ADD
	CONSTRAINT [DF_Tarea_TN_CodTarea]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTarea]) FOR [TN_CodTarea]
GO
CREATE NONCLUSTERED INDEX [_dta_index_Tarea_5_1206412213__K1_K2]
	ON [Catalogo].[Tarea] ([TN_CodTarea], [TC_Descripcion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que almacena las tareas.', 'SCHEMA', N'Catalogo', 'TABLE', N'Tarea', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la tarea.', 'SCHEMA', N'Catalogo', 'TABLE', N'Tarea', 'COLUMN', N'TN_CodTarea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la tarea.', 'SCHEMA', N'Catalogo', 'TABLE', N'Tarea', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Tarea', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Tarea', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Tarea] SET (LOCK_ESCALATION = TABLE)
GO
