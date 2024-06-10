SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoMedida] (
		[TN_CodEstado]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[TF_Actualizacion]       [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EstadoMedida]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstado])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoMedida]
	ADD
	CONSTRAINT [DF_EstadoMedida_TN_CodEstado]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoMedida]) FOR [TN_CodEstado]
GO
ALTER TABLE [Catalogo].[EstadoMedida]
	ADD
	CONSTRAINT [DF_EstadoMedida_TF_Actualizacion]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados de medida cautelar.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedida', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de la medida.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedida', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de la medida.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedida', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedida', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedida', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha actualización del registro de estado de medida.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoMedida', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[EstadoMedida] SET (LOCK_ESCALATION = TABLE)
GO
