SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[RelacionParentesco] (
		[TC_CodParentescoA]     [smallint] NOT NULL,
		[TC_CodParentescoB]     [smallint] NOT NULL,
		CONSTRAINT [PK_RelacionParentesco]
		PRIMARY KEY
		NONCLUSTERED
		([TC_CodParentescoA])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[RelacionParentesco]
	WITH CHECK
	ADD CONSTRAINT [FK_RelacionParentesco_ParentescoA]
	FOREIGN KEY ([TC_CodParentescoA]) REFERENCES [Catalogo].[Parentesco] ([TC_CodParentesco])
ALTER TABLE [Catalogo].[RelacionParentesco]
	CHECK CONSTRAINT [FK_RelacionParentesco_ParentescoA]

GO
ALTER TABLE [Catalogo].[RelacionParentesco]
	WITH CHECK
	ADD CONSTRAINT [FK_RelacionParentesco_ParentescoB]
	FOREIGN KEY ([TC_CodParentescoB]) REFERENCES [Catalogo].[Parentesco] ([TC_CodParentesco])
ALTER TABLE [Catalogo].[RelacionParentesco]
	CHECK CONSTRAINT [FK_RelacionParentesco_ParentescoB]

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ParentescoB]
	ON [Catalogo].[RelacionParentesco] ([TC_CodParentescoB])
	WITH ( FILLFACTOR = 80)
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo para asociar los parentescos.', 'SCHEMA', N'Catalogo', 'TABLE', N'RelacionParentesco', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de parentesco A.', 'SCHEMA', N'Catalogo', 'TABLE', N'RelacionParentesco', 'COLUMN', N'TC_CodParentescoA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de parentesco B.', 'SCHEMA', N'Catalogo', 'TABLE', N'RelacionParentesco', 'COLUMN', N'TC_CodParentescoB'
GO
ALTER TABLE [Catalogo].[RelacionParentesco] SET (LOCK_ESCALATION = TABLE)
GO
