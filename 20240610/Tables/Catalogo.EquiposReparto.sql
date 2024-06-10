SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EquiposReparto] (
		[TU_CodEquipo]                   [uniqueidentifier] NOT NULL,
		[TU_CodConfiguracionReparto]     [uniqueidentifier] NOT NULL,
		[TC_NombreEquipo]                [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_UbicaExpedientesNuevos]      [bit] NOT NULL,
		[TF_FechaCreacion]               [datetime2](7) NOT NULL,
		[TF_FechaParticion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_equipos]
		PRIMARY KEY
		CLUSTERED
		([TU_CodEquipo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EquiposReparto]
	ADD
	CONSTRAINT [DF_equipos_TB_UbicaExpedientesNuevos]
	DEFAULT ((0)) FOR [TB_UbicaExpedientesNuevos]
GO
ALTER TABLE [Catalogo].[EquiposReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Equipo_ConfiguracionGeneralReparto]
	FOREIGN KEY ([TU_CodConfiguracionReparto]) REFERENCES [Catalogo].[ConfiguracionGeneralReparto] ([TU_CodConfiguracionReparto])
ALTER TABLE [Catalogo].[EquiposReparto]
	CHECK CONSTRAINT [FK_Equipo_ConfiguracionGeneralReparto]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almance los equipos de reparto para un despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'EquiposReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de los equipos de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'EquiposReparto', 'COLUMN', N'TU_CodEquipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del equipo de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'EquiposReparto', 'COLUMN', N'TC_NombreEquipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí en este equipo se ubican los expedientes nuevos que se reparte', 'SCHEMA', N'Catalogo', 'TABLE', N'EquiposReparto', 'COLUMN', N'TB_UbicaExpedientesNuevos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del equipo de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'EquiposReparto', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de particionamiento de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'EquiposReparto', 'COLUMN', N'TF_FechaParticion'
GO
ALTER TABLE [Catalogo].[EquiposReparto] SET (LOCK_ESCALATION = TABLE)
GO
