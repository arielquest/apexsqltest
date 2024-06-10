SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[IntervinienteVictima] (
		[TU_CodVictima]               [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]         [uniqueidentifier] NOT NULL,
		[TB_EsViolacion]              [bit] NOT NULL,
		[TN_CodPeriodoAntirretro]     [smallint] NULL,
		[TN_CodPuebloIndigena]        [smallint] NULL,
		[TB_EsPrivadoLibertad]        [bit] NOT NULL,
		[TN_CodDiversidadSexual]      [smallint] NULL,
		[TN_CodLugarAtencion]         [smallint] NULL,
		[TN_CodLugarDenuncia]         [smallint] NULL,
		[TC_Observaciones]            [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]            [datetime2](7) NOT NULL,
		[TB_DepSolApliRetro]          [bit] NULL,
		[TB_ERRVS]                    [bit] NULL,
		[TB_ApoyoPsicoSocial]         [bit] NULL,
		[TB_EsIndigena]               [bit] NULL,
		[TB_TrabSocial]               [bit] NULL,
		[TB_PerMedHosp]               [bit] NULL,
		[TB_MedForense]               [bit] NULL,
		[TB_Fiscal]                   [bit] NULL,
		[TB_OfOIJ]                    [bit] NULL,
		[TB_OfFuerzaPub]              [bit] NULL,
		[TB_RepPani]                  [bit] NULL,
		[TB_Otros]                    [bit] NULL,
		[TC_Otros]                    [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_CamGessel]                [bit] NULL,
		[TN_CodIdioma]                [smallint] NULL,
		[TC_ProfAtiende]              [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_HoraInicio]               [time](7) NULL,
		[TC_HoraFinal]                [time](7) NULL,
		[TC_PersAtendio]              [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		[TB_ExamenMedForense]         [bit] NULL,
		[TC_CodContexto]              [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_IntervinienteVictima]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodVictima])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF_IntervinienteVictima_TB_EsViolacion]
	DEFAULT ((0)) FOR [TB_EsViolacion]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF_IntervinienteVictima_TB_EsPrivadoLibertad]
	DEFAULT ((0)) FOR [TB_EsPrivadoLibertad]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF_IntervinienteVictima_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_De__20844C07]
	DEFAULT ((0)) FOR [TB_DepSolApliRetro]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_ER__21787040]
	DEFAULT ((0)) FOR [TB_ERRVS]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Ap__226C9479]
	DEFAULT ((0)) FOR [TB_ApoyoPsicoSocial]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Es__2360B8B2]
	DEFAULT ((0)) FOR [TB_EsIndigena]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Tr__2454DCEB]
	DEFAULT ((0)) FOR [TB_TrabSocial]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Pe__25490124]
	DEFAULT ((0)) FOR [TB_PerMedHosp]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Me__263D255D]
	DEFAULT ((0)) FOR [TB_MedForense]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Fi__27314996]
	DEFAULT ((0)) FOR [TB_Fiscal]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Of__28256DCF]
	DEFAULT ((0)) FOR [TB_OfOIJ]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Of__29199208]
	DEFAULT ((0)) FOR [TB_OfFuerzaPub]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Re__2A0DB641]
	DEFAULT ((0)) FOR [TB_RepPani]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Ot__2B01DA7A]
	DEFAULT ((0)) FOR [TB_Otros]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TB_Ca__2BF5FEB3]
	DEFAULT ((0)) FOR [TB_CamGessel]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__33421AC0]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVictima_DiversidadSexual]
	FOREIGN KEY ([TN_CodDiversidadSexual]) REFERENCES [Catalogo].[DiversidadSexual] ([TN_CodDiversidadSexual])
ALTER TABLE [Expediente].[IntervinienteVictima]
	CHECK CONSTRAINT [FK_IntervinienteVictima_DiversidadSexual]

GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVictima_Idioma]
	FOREIGN KEY ([TN_CodIdioma]) REFERENCES [Catalogo].[Idioma] ([TN_CodIdioma])
ALTER TABLE [Expediente].[IntervinienteVictima]
	CHECK CONSTRAINT [FK_IntervinienteVictima_Idioma]

GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVictima_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteVictima]
	CHECK CONSTRAINT [FK_IntervinienteVictima_Intervencion]

GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVictima_LugarAtencion]
	FOREIGN KEY ([TN_CodLugarAtencion]) REFERENCES [Catalogo].[LugarAtencion] ([TN_CodLugarAtencion])
ALTER TABLE [Expediente].[IntervinienteVictima]
	CHECK CONSTRAINT [FK_IntervinienteVictima_LugarAtencion]

GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVictima_PeriodoAntirretroviral]
	FOREIGN KEY ([TN_CodPeriodoAntirretro]) REFERENCES [Catalogo].[PeriodoAntirretroviral] ([TN_CodPeriodoAntirretro])
ALTER TABLE [Expediente].[IntervinienteVictima]
	CHECK CONSTRAINT [FK_IntervinienteVictima_PeriodoAntirretroviral]

GO
ALTER TABLE [Expediente].[IntervinienteVictima]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVictima_PuebloIndigena]
	FOREIGN KEY ([TN_CodPuebloIndigena]) REFERENCES [Catalogo].[PuebloIndigena] ([TN_CodPuebloIndigena])
ALTER TABLE [Expediente].[IntervinienteVictima]
	CHECK CONSTRAINT [FK_IntervinienteVictima_PuebloIndigena]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteVictima_TF_Particiion]
	ON [Expediente].[IntervinienteVictima] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_IntervinienteVictima_Migracion]
	ON [Expediente].[IntervinienteVictima] ([TU_CodInterviniente])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los datos de victimización del interviniente en los casos de violación.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para la victimización del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TU_CodVictima'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para identificar un interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para determinar si es victima de violación.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_EsViolacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para indicar el periodo antirretroviral aplicado a la victima.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TN_CodPeriodoAntirretro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para indicar el pueblo indigena al que pertenece la victima.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TN_CodPuebloIndigena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para saber si se encuentra privado de libertad.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_EsPrivadoLibertad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para indicar la diversidad sexual del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TN_CodDiversidadSexual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para indicar el lugar donde recibió atención el interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TN_CodLugarAtencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único para indicar el lugar donde se tomó la denuncia el interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TN_CodLugarDenuncia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se indican las observaciones acerca del interviniente que el usuario considere necesarias.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si el departamento solicito aplicacion de  antirretrovirales', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_DepSolApliRetro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de ERRVS', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_ERRVS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la victima recibio apoyo Psicosocial', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_ApoyoPsicoSocial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la victima es indigena', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_EsIndigena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si  la persona que lo atendio es es trabajadora social', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_TrabSocial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es personal medico del Hospital', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_PerMedHosp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es personal medico forense', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_MedForense'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es personal medico es fiscal', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_Fiscal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es oficial del OIJ', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_OfOIJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es Oficial de Fuerza Publica', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_OfFuerzaPub'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es Representante del PANI', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_RepPani'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si la persona que lo atendio es otra persona no indicada', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_Otros'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la persona que atendio la persona', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TC_Otros'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se utilizo camara gessel', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TB_CamGessel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del idoma que habla la victima', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TN_CodIdioma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion del profesional que atiende a la victima', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TC_ProfAtiende'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la hora en que inicio la atencion del profesional a la victima', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TC_HoraInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la hora en que finalizo la atencion del profesional a la victima', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TC_HoraFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la persona que atendio a la victima.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVictima', 'COLUMN', N'TC_PersAtendio'
GO
ALTER TABLE [Expediente].[IntervinienteVictima] SET (LOCK_ESCALATION = TABLE)
GO
