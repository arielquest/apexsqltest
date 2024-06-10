SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ConjuntosReparto] (
		[TU_CodConjutoReparto]          [uniqueidentifier] NOT NULL,
		[TU_CodEquipo]                  [uniqueidentifier] NOT NULL,
		[TC_Nombre]                     [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Prioridad]                  [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_UbicaExpedientesNuevos]     [bit] NOT NULL,
		[TF_FechaCreacion]              [datetime2](7) NOT NULL,
		[TF_FechaParticion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_conjunto]
		PRIMARY KEY
		CLUSTERED
		([TU_CodConjutoReparto])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[ConjuntosReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_conjunto_equipo]
	FOREIGN KEY ([TU_CodEquipo]) REFERENCES [Catalogo].[EquiposReparto] ([TU_CodEquipo])
ALTER TABLE [Catalogo].[ConjuntosReparto]
	CHECK CONSTRAINT [FK_conjunto_equipo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almancena los conjuntos (principal, secundario y adicional) de reparto para un equipo dado.', 'SCHEMA', N'Catalogo', 'TABLE', N'ConjuntosReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del conjunto de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'ConjuntosReparto', 'COLUMN', N'TU_CodConjutoReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del equipo al que pertenece el conjunto', 'SCHEMA', N'Catalogo', 'TABLE', N'ConjuntosReparto', 'COLUMN', N'TU_CodEquipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del conjunto de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'ConjuntosReparto', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del conjunto. Valores: Principal, Secundario y Adicional', 'SCHEMA', N'Catalogo', 'TABLE', N'ConjuntosReparto', 'COLUMN', N'TC_Prioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí en este conjunto se ubican los expedientes nuevos que se reparten', 'SCHEMA', N'Catalogo', 'TABLE', N'ConjuntosReparto', 'COLUMN', N'TB_UbicaExpedientesNuevos'
GO
ALTER TABLE [Catalogo].[ConjuntosReparto] SET (LOCK_ESCALATION = TABLE)
GO
