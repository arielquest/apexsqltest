SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PuestoTrabajo] (
		[TC_CodPuestoTrabajo]         [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina]               [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoFuncionario]       [smallint] NULL,
		[TC_Descripcion]              [varchar](75) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[TN_CodJornadaLaboral]        [smallint] NOT NULL,
		[TN_CodTipoPuestoTrabajo]     [smallint] NULL,
		[TB_UtilizaAppMovil]          [bit] NOT NULL,
		CONSTRAINT [PK_PuestoTrabajo]
		PRIMARY KEY
		CLUSTERED
		([TC_CodPuestoTrabajo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PuestoTrabajo]
	ADD
	CONSTRAINT [DF__PuestoTra__TB_Ut__65AC084E]
	DEFAULT ((0)) FOR [TB_UtilizaAppMovil]
GO
ALTER TABLE [Catalogo].[PuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_Catalogo_PuestoTrabajo_TipoPuestoTrabajo]
	FOREIGN KEY ([TN_CodTipoPuestoTrabajo]) REFERENCES [Catalogo].[TipoPuestoTrabajo] ([TN_CodTipoPuestoTrabajo])
ALTER TABLE [Catalogo].[PuestoTrabajo]
	CHECK CONSTRAINT [FK_Catalogo_PuestoTrabajo_TipoPuestoTrabajo]

GO
ALTER TABLE [Catalogo].[PuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajo_JornadaLaboral]
	FOREIGN KEY ([TN_CodJornadaLaboral]) REFERENCES [Catalogo].[JornadaLaboral] ([TN_CodJornadaLaboral])
ALTER TABLE [Catalogo].[PuestoTrabajo]
	CHECK CONSTRAINT [FK_PuestoTrabajo_JornadaLaboral]

GO
ALTER TABLE [Catalogo].[PuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajo_TipoFuncionario]
	FOREIGN KEY ([TN_CodTipoFuncionario]) REFERENCES [Catalogo].[TipoFuncionario] ([TN_CodTipoFuncionario])
ALTER TABLE [Catalogo].[PuestoTrabajo]
	CHECK CONSTRAINT [FK_PuestoTrabajo_TipoFuncionario]

GO
CREATE NONCLUSTERED INDEX [_dta_index_PuestoTrabajo_5_651162111__K1_K4]
	ON [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo], [TC_Descripcion])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PuestoTrabajo_ConsultarPuestoTrabajo]
	ON [Catalogo].[PuestoTrabajo] ([TC_Descripcion], [TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	INCLUDE ([TC_CodPuestoTrabajo], [TC_CodOficina], [TN_CodTipoFuncionario], [TN_CodJornadaLaboral])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Catalogo.PA_ConsultarPuestoTrabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'INDEX', N'IX_PuestoTrabajo_ConsultarPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de puestos de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo definido para un número  de oficina, cuatro letras y consecutivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TN_CodTipoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la jornada laboral', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TN_CodJornadaLaboral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del tipo de puesto de trabajo que referencia a la tabla tipo puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajo', 'COLUMN', N'TN_CodTipoPuestoTrabajo'
GO
ALTER TABLE [Catalogo].[PuestoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO
