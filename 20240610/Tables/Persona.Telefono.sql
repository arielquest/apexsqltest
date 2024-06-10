SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Persona].[Telefono] (
		[TU_CodTelefono]         [uniqueidentifier] NOT NULL,
		[TU_CodPersona]          [uniqueidentifier] NOT NULL,
		[TN_CodTipoTelefono]     [smallint] NOT NULL,
		[TC_CodArea]             [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Numero]              [varchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Extension]           [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]       [datetime2](7) NULL,
		[TB_SMS]                 [bit] NOT NULL,
		CONSTRAINT [PK_Persona.Telefono]
		PRIMARY KEY
		CLUSTERED
		([TU_CodTelefono])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Persona].[Telefono]
	ADD
	CONSTRAINT [DF_PersonaTelefono_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[Telefono]
	ADD
	CONSTRAINT [DF__Telefono__TB_SMS__3FFCF760]
	DEFAULT ((0)) FOR [TB_SMS]
GO
ALTER TABLE [Persona].[Telefono]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaTelefono_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [Persona].[Telefono]
	CHECK CONSTRAINT [FK_PersonaTelefono_Persona]

GO
ALTER TABLE [Persona].[Telefono]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaTelefono_TipoTelefono]
	FOREIGN KEY ([TN_CodTipoTelefono]) REFERENCES [Catalogo].[TipoTelefono] ([TN_CodTipoTelefono])
ALTER TABLE [Persona].[Telefono]
	CHECK CONSTRAINT [FK_PersonaTelefono_TipoTelefono]

GO
CREATE NONCLUSTERED INDEX [IX_Persona_Telefono_Migracion]
	ON [Persona].[Telefono] ([TU_CodPersona], [TN_CodTipoTelefono], [TC_Numero])
	ON [FG_Persona]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los números de teléfono de los Personas.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de teléfono del Persona.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TU_CodTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Persona.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de teléfono.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TN_CodTipoTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de área del número telefónico.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TC_CodArea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de teléfono.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TC_Numero'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de extensión.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TC_Extension'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para Sigma.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si este teléfono permite envío de SMS para la personas usuaria.', 'SCHEMA', N'Persona', 'TABLE', N'Telefono', 'COLUMN', N'TB_SMS'
GO
ALTER TABLE [Persona].[Telefono] SET (LOCK_ESCALATION = TABLE)
GO
