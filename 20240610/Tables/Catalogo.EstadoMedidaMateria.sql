SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoMedidaMateria] (
		[TN_CodEstado]            [smallint] NOT NULL,
		[TC_CodMateria]           [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha_Asociacion]     [datetime2](3) NOT NULL,
		CONSTRAINT [PK_EstadoMedidaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstado], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoMedidaMateria]
	ADD
	CONSTRAINT [DF_EstadoMedidaMateria_TF_Fecha_Asociacion]
	DEFAULT (getdate()) FOR [TF_Fecha_Asociacion]
GO
ALTER TABLE [Catalogo].[EstadoMedidaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_EstadoMedidaMateria_EstadoMedida]
	FOREIGN KEY ([TN_CodEstado]) REFERENCES [Catalogo].[EstadoMedida] ([TN_CodEstado])
ALTER TABLE [Catalogo].[EstadoMedidaMateria]
	CHECK CONSTRAINT [FK_EstadoMedidaMateria_EstadoMedida]

GO
ALTER TABLE [Catalogo].[EstadoMedidaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_EstadoMedidaMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[EstadoMedidaMateria]
	CHECK CONSTRAINT [FK_EstadoMedidaMateria_Materia]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla inermedia estados medida cautelar materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedidaMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de la medida.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedidaMateria', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedidaMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro de asociación.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedidaMateria', 'COLUMN', N'TF_Fecha_Asociacion'
GO
ALTER TABLE [Catalogo].[EstadoMedidaMateria] SET (LOCK_ESCALATION = TABLE)
GO
