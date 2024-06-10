SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoMedidaMateria] (
		[TN_CodTipoMedida]        [smallint] NOT NULL,
		[TC_CodMateria]           [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha_Asociacion]     [datetime2](3) NOT NULL,
		CONSTRAINT [PK_TipoMedidaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoMedida], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoMedidaMateria]
	ADD
	CONSTRAINT [DF_TipoMedidaCautelarMateria_TF_Fecha_Asociacion]
	DEFAULT (getdate()) FOR [TF_Fecha_Asociacion]
GO
ALTER TABLE [Catalogo].[TipoMedidaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoMedidaMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[TipoMedidaMateria]
	CHECK CONSTRAINT [FK_TipoMedidaMateria_Materia]

GO
ALTER TABLE [Catalogo].[TipoMedidaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoMedidaMateria_TipoMedidaCautelar]
	FOREIGN KEY ([TN_CodTipoMedida]) REFERENCES [Catalogo].[TipoMedida] ([TN_CodTipoMedida])
ALTER TABLE [Catalogo].[TipoMedidaMateria]
	CHECK CONSTRAINT [FK_TipoMedidaMateria_TipoMedidaCautelar]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla inermedia medida cautelar materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedidaMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de medida.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedidaMateria', 'COLUMN', N'TN_CodTipoMedida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedidaMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro de asociación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedidaMateria', 'COLUMN', N'TF_Fecha_Asociacion'
GO
ALTER TABLE [Catalogo].[TipoMedidaMateria] SET (LOCK_ESCALATION = TABLE)
GO
