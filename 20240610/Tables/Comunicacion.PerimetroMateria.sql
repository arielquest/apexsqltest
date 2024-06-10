SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[PerimetroMateria] (
		[TN_CodPerimetro]        [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NULL,
		[TF_Particion]           [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PerimetroMateria]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodPerimetro], [TC_CodMateria])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[PerimetroMateria]
	ADD
	CONSTRAINT [DF__Perimetro__TF_Pa__2C951D31]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[PerimetroMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_PerimetroMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Comunicacion].[PerimetroMateria]
	CHECK CONSTRAINT [FK_PerimetroMateria_Materia]

GO
ALTER TABLE [Comunicacion].[PerimetroMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_PerimetroMateria_Perimetro]
	FOREIGN KEY ([TN_CodPerimetro]) REFERENCES [Comunicacion].[Perimetro] ([TN_CodPerimetro])
ALTER TABLE [Comunicacion].[PerimetroMateria]
	CHECK CONSTRAINT [FK_PerimetroMateria_Perimetro]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_PerimetroMateria_TF_Particion]
	ON [Comunicacion].[PerimetroMateria] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del perímetro', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroMateria', 'COLUMN', N'TN_CodPerimetro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que inicia la vigencia de la asociación', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Comunicacion].[PerimetroMateria] SET (LOCK_ESCALATION = TABLE)
GO
