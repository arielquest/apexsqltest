SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Arma] (
		[TU_CodObjeto]       [uniqueidentifier] NOT NULL,
		[TN_CodTipoArma]     [smallint] NOT NULL,
		[TC_Calibre]         [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Dif]             [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]       [datetime2](7) NOT NULL,
		CONSTRAINT [UQ__Arma__9E0B2123ACCEC9AB]
		UNIQUE
		NONCLUSTERED
		([TU_CodObjeto])
		ON [PRIMARY],
		CONSTRAINT [PK_Arma]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodObjeto])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Arma]
	ADD
	CONSTRAINT [DF__Arma__TF_Partici__7AFDC19D]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Arma]
	WITH CHECK
	ADD CONSTRAINT [FK_Arma_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Arma]
	CHECK CONSTRAINT [FK_Arma_Objeto]

GO
ALTER TABLE [Objeto].[Arma]
	WITH CHECK
	ADD CONSTRAINT [FK_Arma_TipoArma]
	FOREIGN KEY ([TN_CodTipoArma]) REFERENCES [Catalogo].[TipoArma] ([TN_CodTipoArma])
ALTER TABLE [Objeto].[Arma]
	CHECK CONSTRAINT [FK_Arma_TipoArma]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Arma_TF_Particion]
	ON [Objeto].[Arma] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el código del objeto que hace referencia a la tabla de Arma', 'SCHEMA', N'Objeto', 'TABLE', N'Arma', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el código de tipo de arma asociado,', 'SCHEMA', N'Objeto', 'TABLE', N'Arma', 'COLUMN', N'TN_CodTipoArma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el calibre del arma,', 'SCHEMA', N'Objeto', 'TABLE', N'Arma', 'COLUMN', N'TC_Calibre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a definir el valor Dif asociado al arma', 'SCHEMA', N'Objeto', 'TABLE', N'Arma', 'COLUMN', N'TC_Dif'
GO
ALTER TABLE [Objeto].[Arma] SET (LOCK_ESCALATION = TABLE)
GO
