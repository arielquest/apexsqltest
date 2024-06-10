SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[Sistema] (
		[TN_CodSistema]          [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Siglas]              [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](2) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](2) NULL,
		CONSTRAINT [PK_Sistema]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSistema])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Configuracion].[Sistema]
	ADD
	CONSTRAINT [DF_Sistema_TN_CodSistema]
	DEFAULT (NEXT VALUE FOR [Configuracion].[SecuenciaSistema]) FOR [TN_CodSistema]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los sistemas.', 'SCHEMA', N'Configuracion', 'TABLE', N'Sistema', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código asoignado al Sistema.', 'SCHEMA', N'Configuracion', 'TABLE', N'Sistema', 'COLUMN', N'TN_CodSistema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del Sistema.', 'SCHEMA', N'Configuracion', 'TABLE', N'Sistema', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Siglas identificadoras del Sistema.', 'SCHEMA', N'Configuracion', 'TABLE', N'Sistema', 'COLUMN', N'TC_Siglas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Configuracion', 'TABLE', N'Sistema', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Configuracion', 'TABLE', N'Sistema', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Configuracion].[Sistema] SET (LOCK_ESCALATION = TABLE)
GO
