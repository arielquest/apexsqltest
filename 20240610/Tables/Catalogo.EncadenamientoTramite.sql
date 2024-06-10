SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EncadenamientoTramite] (
		[TU_CodEncadenamientoTramite]          [uniqueidentifier] NOT NULL,
		[TU_CodGrupoEncadenamientoTramite]     [uniqueidentifier] NOT NULL,
		[TC_Nombre]                            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]                       [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]                   [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                      [datetime2](7) NULL,
		[TF_Actualizacion]                     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EncadenamientoTramite]
		PRIMARY KEY
		CLUSTERED
		([TU_CodEncadenamientoTramite])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramite]
	ADD
	CONSTRAINT [DF_EncadenamientoTramite_TN_CodEncadenamientoTramite]
	DEFAULT (newid()) FOR [TU_CodEncadenamientoTramite]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramite]
	ADD
	CONSTRAINT [DF_EncadenamientoTramite_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramite]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramite_GrupoEncadenamientoTramite]
	FOREIGN KEY ([TU_CodGrupoEncadenamientoTramite]) REFERENCES [Catalogo].[GrupoEncadenamientoTramite] ([TU_CodGrupoEncadenamientoTramite])
ALTER TABLE [Catalogo].[EncadenamientoTramite]
	CHECK CONSTRAINT [FK_EncadenamientoTramite_GrupoEncadenamientoTramite]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que relaciona pasos con su respectiva operación.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del trámite del encadenamiento (autogenerado).', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TU_CodEncadenamientoTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trámite del encadenamiento al que pertenece el encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TU_CodGrupoEncadenamientoTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del trámite del encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del trámite del encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramite', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[EncadenamientoTramite] SET (LOCK_ESCALATION = TABLE)
GO
