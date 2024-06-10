SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ConfiguracionGeneralReparto] (
		[TU_CodConfiguracionReparto]       [uniqueidentifier] NOT NULL,
		[TC_CodContexto]                   [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Habilitado]                    [bit] NOT NULL,
		[TB_RecordarAsignaciones]          [bit] NOT NULL,
		[TB_LimiteTiempoHabilitado]        [bit] NOT NULL,
		[TN_DiasHabiles]                   [int] NULL,
		[TC_CriterioReparto]               [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodUbicacionError]             [int] NOT NULL,
		[TC_CodPuestoTrabajoError]         [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTareaError]                 [smallint] NOT NULL,
		[TN_CodTareaExpedientesNuevos]     [smallint] NOT NULL,
		[TF_Particion]                     [datetime2](7) NOT NULL,
		[TF_FechaCreacion]                 [datetime2](7) NOT NULL,
		[TB_AsignacionReparto]             [bit] NOT NULL,
		[TB_AsignacionManual]              [bit] NOT NULL,
		[TB_AsignacionHerencia]            [bit] NOT NULL,
		CONSTRAINT [PK_ConfiguracionGeneralReparto]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodConfiguracionReparto])
	ON [FG_SIAGPJ]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	ADD
	CONSTRAINT [DF_ConfiguracionGeneralReparto_TB_AsignacionManual]
	DEFAULT ((0)) FOR [TB_AsignacionManual]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	ADD
	CONSTRAINT [DF_ConfiguracionGeneralReparto_TB_AsignacionHerencia]
	DEFAULT ((0)) FOR [TB_AsignacionHerencia]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	ADD
	CONSTRAINT [DF_Catalogo.ConfiguracionGeneralReparto_TB_Habilitado]
	DEFAULT ((0)) FOR [TB_Habilitado]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	ADD
	CONSTRAINT [DF_Catalogo.ConfiguracionGeneralReparto_TB_RecordarAsignaciones]
	DEFAULT ((0)) FOR [TB_RecordarAsignaciones]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	ADD
	CONSTRAINT [DF_Catalogo.ConfiguracionGeneralReparto_TB_LimiteTiempoHabilitado]
	DEFAULT ((0)) FOR [TB_LimiteTiempoHabilitado]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	ADD
	CONSTRAINT [DF_ConfiguracionGeneralReparto_TB_AsignacionReparto]
	DEFAULT ((0)) FOR [TB_AsignacionReparto]
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionGeneralReparto_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajoError]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	CHECK CONSTRAINT [FK_ConfiguracionGeneralReparto_PuestoTrabajo]

GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionGeneralReparto_TareaError]
	FOREIGN KEY ([TN_CodTareaError]) REFERENCES [Catalogo].[Tarea] ([TN_CodTarea])
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	CHECK CONSTRAINT [FK_ConfiguracionGeneralReparto_TareaError]

GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionGeneralReparto_TareaNuevos]
	FOREIGN KEY ([TN_CodTareaExpedientesNuevos]) REFERENCES [Catalogo].[Tarea] ([TN_CodTarea])
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	CHECK CONSTRAINT [FK_ConfiguracionGeneralReparto_TareaNuevos]

GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionGeneralReparto_Ubicacion]
	FOREIGN KEY ([TN_CodUbicacionError]) REFERENCES [Catalogo].[Ubicacion] ([TN_CodUbicacion])
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto]
	CHECK CONSTRAINT [FK_ConfiguracionGeneralReparto_Ubicacion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la configuración del reparto para un despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TU_CodConfiguracionReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto para el que se configura el reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí el reparto está habilitado para el despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TB_Habilitado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el despacho se recuerdan las asignaciones en el reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TB_RecordarAsignaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí el despacho configuró un limite de días habiles para que se ejecute el reparto luego de la fecha de ingreso del expediente', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TB_LimiteTiempoHabilitado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Días habiles en los que se ejecuta el reparto, luego de la fecha de ingreso del expediente', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TN_DiasHabiles'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del tipo de reparto para el despacho, Valores: Clase, procedimiento, fase, manual', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TC_CriterioReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ubicación a asignar el expediente en caso de que el reparto falle', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TN_CodUbicacionError'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puesto de trabajo a asignar el expediente en caso de que el reparto falle', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TC_CodPuestoTrabajoError'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tarea a asignar al expediente en caso de que el reparto falle', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TN_CodTareaError'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tarea a asignar el expediente nuevo que se reparte', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TN_CodTareaExpedientesNuevos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha para partición de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se crea la configuración para el despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que determina si la asignación de responsables se realiza por reparto.', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TB_AsignacionReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que determina si la asignación de responsables se realiza de manera manual.', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TB_AsignacionManual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que determina si la asignación de responsables se realiza por herencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionGeneralReparto', 'COLUMN', N'TB_AsignacionHerencia'
GO
ALTER TABLE [Catalogo].[ConfiguracionGeneralReparto] SET (LOCK_ESCALATION = TABLE)
GO
