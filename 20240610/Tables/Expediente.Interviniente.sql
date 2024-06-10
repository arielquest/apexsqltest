SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Interviniente] (
		[TU_CodInterviniente]        [uniqueidentifier] NOT NULL,
		[TN_CodTipoIntervencion]     [smallint] NOT NULL,
		[TC_CodPais]                 [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodProfesion]            [smallint] NULL,
		[TN_CodEscolaridad]          [smallint] NULL,
		[TF_ComisionDelito]          [datetime2](7) NULL,
		[TC_Caracteristicas]         [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodSituacionLaboral]     [smallint] NULL,
		[TC_Alias]                   [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_Droga]                   [bit] NULL,
		[TF_Actualizacion]           [datetime2](7) NOT NULL,
		[TB_Rebeldia]                [bit] NULL,
		[TU_CodParentesco]           [smallint] NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		[TB_Turista]                 [bit] NULL,
		[TC_LugarTrabajo]            [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Interviniente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Interviniente]
	ADD
	CONSTRAINT [DF_Interviniente_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Interviniente]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__76390C80]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Interviniente]
	ADD
	CONSTRAINT [DF__Intervini__TB_Tu__263D255D]
	DEFAULT ((0)) FOR [TB_Turista]
GO
ALTER TABLE [Expediente].[Interviniente]
	WITH CHECK
	ADD CONSTRAINT [FK_Interviniente_Parentesco]
	FOREIGN KEY ([TU_CodParentesco]) REFERENCES [Catalogo].[Parentesco] ([TC_CodParentesco])
ALTER TABLE [Expediente].[Interviniente]
	CHECK CONSTRAINT [FK_Interviniente_Parentesco]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Interviniente_TF_Particion]
	ON [Expediente].[Interviniente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los intervinientes de los expedientes.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de intervencion por materia.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TN_CodTipoIntervencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la nacionalidad.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TC_CodPais'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de profesión.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TN_CodProfesion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de escolaridad.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TN_CodEscolaridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la comisión del delito.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TF_ComisionDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Características del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TC_Caracteristicas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la situacion laboral.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TN_CodSituacionLaboral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Alias del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TC_Alias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si esta ebrio o drogado al momento de la captura.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TB_Droga'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el interviniente se encuentra rebelde', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TB_Rebeldia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el interviniente tiene un parentresco con el agresor', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TU_CodParentesco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que se utiliza para almacenar el nombre del lugar de trabajo del interviniente', 'SCHEMA', N'Expediente', 'TABLE', N'Interviniente', 'COLUMN', N'TC_LugarTrabajo'
GO
ALTER TABLE [Expediente].[Interviniente] SET (LOCK_ESCALATION = TABLE)
GO
