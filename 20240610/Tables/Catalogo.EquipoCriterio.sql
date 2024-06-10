SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[EquipoCriterio] (
		[TU_CodEquipo]       [uniqueidentifier] NOT NULL,
		[TU_CodCriterio]     [uniqueidentifier] NOT NULL,
		CONSTRAINT [PK_EquipoCriterio]
		PRIMARY KEY
		CLUSTERED
		([TU_CodEquipo], [TU_CodCriterio])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EquipoCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_EquipoCriterio_Criterio]
	FOREIGN KEY ([TU_CodCriterio]) REFERENCES [Catalogo].[CriteriosReparto] ([TU_CodCriterio])
ALTER TABLE [Catalogo].[EquipoCriterio]
	CHECK CONSTRAINT [FK_EquipoCriterio_Criterio]

GO
ALTER TABLE [Catalogo].[EquipoCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_EquipoCriterio_Equipo]
	FOREIGN KEY ([TU_CodEquipo]) REFERENCES [Catalogo].[EquiposReparto] ([TU_CodEquipo])
ALTER TABLE [Catalogo].[EquipoCriterio]
	CHECK CONSTRAINT [FK_EquipoCriterio_Equipo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica que equipo de trabajo atiende el citerio de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'EquipoCriterio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del equipo de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'EquipoCriterio', 'COLUMN', N'TU_CodEquipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del criterio al que se asocia el equipo de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'EquipoCriterio', 'COLUMN', N'TU_CodCriterio'
GO
ALTER TABLE [Catalogo].[EquipoCriterio] SET (LOCK_ESCALATION = TABLE)
GO
