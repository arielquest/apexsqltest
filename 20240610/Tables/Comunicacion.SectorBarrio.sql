SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[SectorBarrio] (
		[TN_CodSector]        [smallint] NOT NULL,
		[TN_CodProvincia]     [smallint] NOT NULL,
		[TN_CodCanton]        [smallint] NOT NULL,
		[TN_CodDistrito]      [smallint] NOT NULL,
		[TN_CodBarrio]        [smallint] NOT NULL,
		CONSTRAINT [PK_SectorBarrio]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSector], [TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Comunicacion].[SectorBarrio]
	WITH CHECK
	ADD CONSTRAINT [FK_SectorBarrio_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [Comunicacion].[SectorBarrio]
	CHECK CONSTRAINT [FK_SectorBarrio_Barrio]

GO
ALTER TABLE [Comunicacion].[SectorBarrio]
	WITH CHECK
	ADD CONSTRAINT [FK_SectorBarrio_Sector]
	FOREIGN KEY ([TN_CodSector]) REFERENCES [Comunicacion].[Sector] ([TN_CodSector])
ALTER TABLE [Comunicacion].[SectorBarrio]
	CHECK CONSTRAINT [FK_SectorBarrio_Sector]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sector', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorBarrio', 'COLUMN', N'TN_CodSector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorBarrio', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón.', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorBarrio', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito.', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorBarrio', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio.', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorBarrio', 'COLUMN', N'TN_CodBarrio'
GO
ALTER TABLE [Comunicacion].[SectorBarrio] SET (LOCK_ESCALATION = TABLE)
GO
