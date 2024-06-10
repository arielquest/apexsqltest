SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Expediente] (
		[TC_NumeroExpediente]        [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio]                  [datetime2](7) NOT NULL,
		[TN_CodDelito]               [int] NULL,
		[TB_Confidencial]            [bit] NOT NULL,
		[TC_CodContexto]             [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoCreacion]     [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_CasoRelevante]           [bit] NOT NULL,
		[TN_CodPrioridad]            [smallint] NULL,
		[TN_CodTipoCuantia]          [tinyint] NULL,
		[TN_CodMoneda]               [smallint] NULL,
		[TN_MontoCuantia]            [decimal](18, 2) NULL,
		[TN_CodTipoViabilidad]       [smallint] NULL,
		[TN_CodProvincia]            [smallint] NULL,
		[TN_CodCanton]               [smallint] NULL,
		[TN_CodDistrito]             [smallint] NULL,
		[TN_CodBarrio]               [smallint] NULL,
		[TC_Señas]                   [varchar](500) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Hechos]                  [datetime2](7) NULL,
		[TF_Actualizacion]           [datetime2](7) NOT NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		[CARPETA]                    [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_DescripcionHechos]       [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_MontoMensual]            [decimal](18, 2) NULL,
		[TN_MontoAguinaldo]          [decimal](18, 2) NULL,
		[TN_MontoSalarioEscolar]     [decimal](18, 2) NULL,
		[TN_MontoEmbargo]            [decimal](18, 2) NULL,
		[TB_EmbargosFisicos]         [bit] NOT NULL,
		CONSTRAINT [PK_Expediente]
		PRIMARY KEY
		NONCLUSTERED
		([TC_NumeroExpediente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Expediente]
	ADD
	CONSTRAINT [DF_Expediente_TB_Confidencial]
	DEFAULT ((0)) FOR [TB_Confidencial]
GO
ALTER TABLE [Expediente].[Expediente]
	ADD
	CONSTRAINT [DF__Expedient__TB_Ca__5ED6843B]
	DEFAULT ((0)) FOR [TB_CasoRelevante]
GO
ALTER TABLE [Expediente].[Expediente]
	ADD
	CONSTRAINT [DF__Expedient__TF_Ac__676BCA3C]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Expediente]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__0E109611]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Expediente]
	ADD
	CONSTRAINT [DF__Expedient__TB_Em__1CC7330E]
	DEFAULT ((0)) FOR [TB_EmbargosFisicos]
GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Barrio]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Canton]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton]) REFERENCES [Catalogo].[Canton] ([TN_CodProvincia], [TN_CodCanton])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Canton]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Contexto]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ContextoCreacion]
	FOREIGN KEY ([TC_CodContextoCreacion]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_ContextoCreacion]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Delito]
	FOREIGN KEY ([TN_CodDelito]) REFERENCES [Catalogo].[Delito] ([TN_CodDelito])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Delito]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Distrito]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito]) REFERENCES [Catalogo].[Distrito] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Distrito]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Moneda]
	FOREIGN KEY ([TN_CodMoneda]) REFERENCES [Catalogo].[Moneda] ([TN_CodMoneda])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Moneda]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Prioridad]
	FOREIGN KEY ([TN_CodPrioridad]) REFERENCES [Catalogo].[Prioridad] ([TN_CodPrioridad])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Prioridad]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_Provincia]
	FOREIGN KEY ([TN_CodProvincia]) REFERENCES [Catalogo].[Provincia] ([TN_CodProvincia])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_Provincia]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_TipoCuantia]
	FOREIGN KEY ([TN_CodTipoCuantia]) REFERENCES [Catalogo].[TipoCuantia] ([TN_CodTipoCuantia])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_TipoCuantia]

GO
ALTER TABLE [Expediente].[Expediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_TipoViabilidad]
	FOREIGN KEY ([TN_CodTipoViabilidad]) REFERENCES [Catalogo].[TipoViabilidad] ([TN_CodTipoViabilidad])
ALTER TABLE [Expediente].[Expediente]
	CHECK CONSTRAINT [FK_Expediente_TipoViabilidad]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Expediente_TF_Particion]
	ON [Expediente].[Expediente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [_dta_index_Expediente_5_1991690889__K1_K21_K3]
	ON [Expediente].[Expediente] ([TC_NumeroExpediente], [TN_CodDelito], [TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_TC_CodContexto]
	ON [Expediente].[Expediente] ([TC_CodContexto])
	INCLUDE ([TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información general del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único a lo largo de la vida del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha que el expediente ingreso al Poder Judicial por primera vez, que no necesariamente es la misma que la fecha de entrada a la oficina.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TF_Inicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Delito al cual pertene el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si el expediente es confidencial o no lo es.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TB_Confidencial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se encuentra el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se creó el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TC_CodContextoCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador, para determinar que un expediente es de interés para la prensa o no.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TB_CasoRelevante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodPrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de cuantía.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodTipoCuantia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de moneda de la cuantía.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto de la cuantía.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_MontoCuantia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de viabilidad del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodTipoViabilidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de provincia', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del canton', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Otras señas del lugar de los hechos.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TC_Señas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de los hechos.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TF_Hechos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de carpeta que identifica al expediente en Gestión, se registra para facilitar las itineraciones entre SIAGPJ y Gestión', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'CARPETA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de los hechos asociados al lugar de los hechos', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TC_DescripcionHechos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto mensual de la pensión', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_MontoMensual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto de aguinaldo', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_MontoAguinaldo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto de salario escolar', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_MontoSalarioEscolar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto del embargo', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TN_MontoEmbargo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para determinar si el expediente posee embargos que fueron registrados de forma física o no.', 'SCHEMA', N'Expediente', 'TABLE', N'Expediente', 'COLUMN', N'TB_EmbargosFisicos'
GO
ALTER TABLE [Expediente].[Expediente] SET (LOCK_ESCALATION = TABLE)
GO
