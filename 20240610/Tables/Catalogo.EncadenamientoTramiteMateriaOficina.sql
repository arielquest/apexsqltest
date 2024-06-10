SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina] (
		[TU_CodEncadenamientoTramite]     [uniqueidentifier] NOT NULL,
		[TC_CodMateria]                   [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoOficina]               [smallint] NOT NULL,
		[TF_Actualizacion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EncadenamientoTramiteMateriaOficina]
		PRIMARY KEY
		CLUSTERED
		([TU_CodEncadenamientoTramite], [TC_CodMateria], [TN_CodTipoOficina])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	ADD
	CONSTRAINT [DF_EncadenamientoTramiteMateriaOficina_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramiteMateriaOficina_EncadenamientoTramite]
	FOREIGN KEY ([TU_CodEncadenamientoTramite]) REFERENCES [Catalogo].[EncadenamientoTramite] ([TU_CodEncadenamientoTramite])
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	CHECK CONSTRAINT [FK_EncadenamientoTramiteMateriaOficina_EncadenamientoTramite]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramiteMateriaOficina_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	CHECK CONSTRAINT [FK_EncadenamientoTramiteMateriaOficina_Materia]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramiteMateriaOficina_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina]
	CHECK CONSTRAINT [FK_EncadenamientoTramiteMateriaOficina_TipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los tipo Materia y oficina relacionados con un trámite encadenado.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramiteMateriaOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del trámite del encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramiteMateriaOficina', 'COLUMN', N'TU_CodEncadenamientoTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de materia al cual pertenece el trámite de encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramiteMateriaOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina al cual pertenece el trámite de encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramiteMateriaOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramiteMateriaOficina', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[EncadenamientoTramiteMateriaOficina] SET (LOCK_ESCALATION = TABLE)
GO
