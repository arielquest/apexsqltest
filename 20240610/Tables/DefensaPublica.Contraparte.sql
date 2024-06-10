SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[Contraparte] (
		[TU_CodContraparte]     [uniqueidentifier] NOT NULL,
		[TC_NRD]                [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodPersona]         [uniqueidentifier] NOT NULL,
		[TF_Creacion]           [datetime2](7) NOT NULL,
		[TF_Particion]          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Contraparte]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodContraparte])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[Contraparte]
	ADD
	CONSTRAINT [DF__Contrapar__TF_Pa__6BBB7E0D]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[Contraparte]
	WITH CHECK
	ADD CONSTRAINT [FK_Contraparte_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [DefensaPublica].[Contraparte]
	CHECK CONSTRAINT [FK_Contraparte_Persona]

GO
ALTER TABLE [DefensaPublica].[Contraparte]
	WITH CHECK
	ADD CONSTRAINT [FK_Contraparte_Carpeta]
	FOREIGN KEY ([TC_NRD]) REFERENCES [DefensaPublica].[Carpeta] ([TC_NRD])
ALTER TABLE [DefensaPublica].[Contraparte]
	CHECK CONSTRAINT [FK_Contraparte_Carpeta]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_Contraparte_TF_Particion]
	ON [DefensaPublica].[Contraparte] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la contraparte', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Contraparte', 'COLUMN', N'TU_CodContraparte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la carpeta', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Contraparte', 'COLUMN', N'TC_NRD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la persona', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Contraparte', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creacion de la contraparte', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Contraparte', 'COLUMN', N'TF_Creacion'
GO
ALTER TABLE [DefensaPublica].[Contraparte] SET (LOCK_ESCALATION = TABLE)
GO
