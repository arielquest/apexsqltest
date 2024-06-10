SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Persona].[Domicilio] (
		[TU_CodDomicilio]          [uniqueidentifier] NOT NULL,
		[TU_CodPersona]            [uniqueidentifier] NOT NULL,
		[TN_CodTipoDomicilio]      [smallint] NOT NULL,
		[TC_CodPais]               [varchar](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodProvincia]          [smallint] NULL,
		[TN_CodCanton]             [smallint] NULL,
		[TN_CodDistrito]           [smallint] NULL,
		[TN_CodBarrio]             [smallint] NULL,
		[TC_Direccion]             [varchar](500) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_DomicilioHabitual]     [bit] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Domicilio]
		PRIMARY KEY
		CLUSTERED
		([TU_CodDomicilio])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Persona].[Domicilio]
	ADD
	CONSTRAINT [DF_Domicilio_TB_Activo]
	DEFAULT ((1)) FOR [TB_DomicilioHabitual]
GO
ALTER TABLE [Persona].[Domicilio]
	ADD
	CONSTRAINT [DF_Domicilio_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[Domicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_Domicilio_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [Persona].[Domicilio]
	CHECK CONSTRAINT [FK_Domicilio_Barrio]

GO
ALTER TABLE [Persona].[Domicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_Domicilio_Distrito]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito]) REFERENCES [Catalogo].[Distrito] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
ALTER TABLE [Persona].[Domicilio]
	CHECK CONSTRAINT [FK_Domicilio_Distrito]

GO
ALTER TABLE [Persona].[Domicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_Domicilio_Pais]
	FOREIGN KEY ([TC_CodPais]) REFERENCES [Catalogo].[Pais] ([TC_CodPais])
ALTER TABLE [Persona].[Domicilio]
	CHECK CONSTRAINT [FK_Domicilio_Pais]

GO
ALTER TABLE [Persona].[Domicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_Domicilio_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [Persona].[Domicilio]
	CHECK CONSTRAINT [FK_Domicilio_Persona]

GO
ALTER TABLE [Persona].[Domicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_Domicilio_TipoDomicilio]
	FOREIGN KEY ([TN_CodTipoDomicilio]) REFERENCES [Catalogo].[TipoDomicilio] ([TN_CodTipoDomicilio])
ALTER TABLE [Persona].[Domicilio]
	CHECK CONSTRAINT [FK_Domicilio_TipoDomicilio]

GO
CREATE NONCLUSTERED INDEX [IX_Persona_Domicilio_Migracion]
	ON [Persona].[Domicilio] ([TU_CodPersona], [TN_CodTipoDomicilio], [TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio], [TC_Direccion])
	ON [FG_Persona]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Domicilio]
	ON [Persona].[Domicilio] ([TU_CodDomicilio])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los domicilios asociados a las personas.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de domicilio.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TU_CodDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de domicilio.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TN_CodTipoDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del país.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TC_CodPais'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la dirección exacta.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TC_Direccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el domicilio se encuentra activo.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TB_DomicilioHabitual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'Persona', 'TABLE', N'Domicilio', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Persona].[Domicilio] SET (LOCK_ESCALATION = TABLE)
GO
