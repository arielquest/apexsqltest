SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[LaborFacilitadorJudicial] (
		[TN_CodLaborFacilitador]     [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_InicioVigencia]          [datetime2](7) NOT NULL,
		[TF_FinVigencia]             [datetime2](7) NULL,
		[TB_ContabilizaGenero]       [bit] NOT NULL,
		CONSTRAINT [PK_LaborFacilitadorJudicial]
		PRIMARY KEY
		CLUSTERED
		([TN_CodLaborFacilitador])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[LaborFacilitadorJudicial]
	ADD
	CONSTRAINT [DF_LaborFacilitadoJudicial_TN_CodFacilitador]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaLaborFacilitadorJudidicial]) FOR [TN_CodLaborFacilitador]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registrar las labores de los facilitadores judiciales', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborFacilitadorJudicial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la labor del facilitador judicial', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborFacilitadorJudicial', 'COLUMN', N'TN_CodLaborFacilitador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción para la labor del facilitador judicial', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborFacilitadorJudicial', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborFacilitadorJudicial', 'COLUMN', N'TF_InicioVigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborFacilitadorJudicial', 'COLUMN', N'TF_FinVigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la labor se contabiliza por hombre y mujeres', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborFacilitadorJudicial', 'COLUMN', N'TB_ContabilizaGenero'
GO
ALTER TABLE [Catalogo].[LaborFacilitadorJudicial] SET (LOCK_ESCALATION = TABLE)
GO
