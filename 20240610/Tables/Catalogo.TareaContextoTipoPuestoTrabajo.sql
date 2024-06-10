SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo] (
		[TC_CodContexto]              [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoPuestoTrabajo]     [smallint] NOT NULL,
		[TN_CodTarea]                 [smallint] NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	ADD
	CONSTRAINT [DF_TareaContextoTipoPuestoTrabajo_TF_Inicio_Vigencia]
	DEFAULT (getdate()) FOR [TF_Inicio_Vigencia]
GO
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaContexto_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	CHECK CONSTRAINT [FK_TareaContexto_Contexto]

GO
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaContexto_Tarea]
	FOREIGN KEY ([TN_CodTarea]) REFERENCES [Catalogo].[Tarea] ([TN_CodTarea])
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	CHECK CONSTRAINT [FK_TareaContexto_Tarea]

GO
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaContexto_TipoPuestoTrabajo]
	FOREIGN KEY ([TN_CodTipoPuestoTrabajo]) REFERENCES [Catalogo].[TipoPuestoTrabajo] ([TN_CodTipoPuestoTrabajo])
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo]
	CHECK CONSTRAINT [FK_TareaContexto_TipoPuestoTrabajo]

GO
CREATE NONCLUSTERED INDEX [Idx_TC_CodContexto_TN_CodTipoPuestoTrabajo_TN_CodTarea]
	ON [Catalogo].[TareaContextoTipoPuestoTrabajo] ([TC_CodContexto], [TN_CodTipoPuestoTrabajo], [TN_CodTarea])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene la configuración de tareas para un contexto sobre un tipo de puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaContextoTipoPuestoTrabajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaContextoTipoPuestoTrabajo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaContextoTipoPuestoTrabajo', 'COLUMN', N'TN_CodTipoPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tarea', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaContextoTipoPuestoTrabajo', 'COLUMN', N'TN_CodTarea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se vinculó el registro', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaContextoTipoPuestoTrabajo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TareaContextoTipoPuestoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO
