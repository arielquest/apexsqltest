SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Sistema].[CierreEstadistico] (
		[TC_CodOficina]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Mes]              [smallint] NOT NULL,
		[TN_Anno]             [smallint] NOT NULL,
		[TF_Fecha_Cierre]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CierreEstadistico]
		PRIMARY KEY
		CLUSTERED
		([TC_CodOficina], [TN_Mes], [TN_Anno])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Sistema].[CierreEstadistico]
	WITH CHECK
	ADD CONSTRAINT [FK_CierreEstadistico_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Sistema].[CierreEstadistico]
	CHECK CONSTRAINT [FK_CierreEstadistico_Oficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los cierres estadísticos por mes de las oficinas.', 'SCHEMA', N'Sistema', 'TABLE', N'CierreEstadistico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de oficina.', 'SCHEMA', N'Sistema', 'TABLE', N'CierreEstadistico', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del mes.', 'SCHEMA', N'Sistema', 'TABLE', N'CierreEstadistico', 'COLUMN', N'TN_Mes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del año.', 'SCHEMA', N'Sistema', 'TABLE', N'CierreEstadistico', 'COLUMN', N'TN_Anno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del cierre estadístico.', 'SCHEMA', N'Sistema', 'TABLE', N'CierreEstadistico', 'COLUMN', N'TF_Fecha_Cierre'
GO
ALTER TABLE [Sistema].[CierreEstadistico] SET (LOCK_ESCALATION = TABLE)
GO
