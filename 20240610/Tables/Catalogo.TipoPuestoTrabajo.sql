SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoPuestoTrabajo] (
		[TN_CodTipoPuestoTrabajo]     [smallint] NOT NULL,
		[TN_CodTipoFuncionario]       [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Inicio_Vigencia]          [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](3) NULL,
		[CODCARGO]                    [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Catalogo_TipoPuestoTrabajo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoPuestoTrabajo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoPuestoTrabajo]
	ADD
	CONSTRAINT [DF_Catalogo_TipoPuestoTrabajo_TN_CodTipoPuestoTrabajo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoPuestoTrabajo]) FOR [TN_CodTipoPuestoTrabajo]
GO
ALTER TABLE [Catalogo].[TipoPuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_Catalogo_TipoPuestoTrabajo_TipoFuncionario]
	FOREIGN KEY ([TN_CodTipoFuncionario]) REFERENCES [Catalogo].[TipoFuncionario] ([TN_CodTipoFuncionario])
ALTER TABLE [Catalogo].[TipoPuestoTrabajo]
	CHECK CONSTRAINT [FK_Catalogo_TipoPuestoTrabajo_TipoFuncionario]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "TipoPuestoTrabajo"', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPuestoTrabajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPuestoTrabajo', 'COLUMN', N'TN_CodTipoPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPuestoTrabajo', 'COLUMN', N'TN_CodTipoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPuestoTrabajo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPuestoTrabajo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPuestoTrabajo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoPuestoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO
