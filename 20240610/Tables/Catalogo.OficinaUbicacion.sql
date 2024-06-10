SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[OficinaUbicacion] (
		[TC_CodOficina]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodUbicacion]        [int] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[CODUBI]                 [varchar](11) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_OficinaUbicacion]
		PRIMARY KEY
		CLUSTERED
		([TC_CodOficina], [TN_CodUbicacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[OficinaUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_FuncionarioUbicacion_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Catalogo].[OficinaUbicacion]
	CHECK CONSTRAINT [FK_FuncionarioUbicacion_Oficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia a la oficina a las ubicaciones.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaUbicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaUbicacion', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la ubicación.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaUbicacion', 'COLUMN', N'TN_CodUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaUbicacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[OficinaUbicacion] SET (LOCK_ESCALATION = TABLE)
GO
