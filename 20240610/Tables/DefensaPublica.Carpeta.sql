SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[Carpeta] (
		[TC_NRD]                  [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Creacion]             [datetime2](7) NOT NULL,
		[TN_CodTipoCaso]          [smallint] NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]        [datetime2](7) NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		[TC_Observaciones]        [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Carpeta]
		PRIMARY KEY
		NONCLUSTERED
		([TC_NRD])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[Carpeta]
	ADD
	CONSTRAINT [DF__Carpeta__TF_Actu__47E69B3D]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[Carpeta]
	ADD
	CONSTRAINT [DF__Carpeta__TF_Part__7544E847]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[Carpeta]
	WITH CHECK
	ADD CONSTRAINT [FK_Carpeta_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [DefensaPublica].[Carpeta]
	CHECK CONSTRAINT [FK_Carpeta_Contexto]

GO
ALTER TABLE [DefensaPublica].[Carpeta]
	WITH CHECK
	ADD CONSTRAINT [FK_Carpeta_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [DefensaPublica].[Carpeta]
	CHECK CONSTRAINT [FK_Carpeta_Expediente]

GO
ALTER TABLE [DefensaPublica].[Carpeta]
	WITH CHECK
	ADD CONSTRAINT [FK_Carpeta_TipoCaso]
	FOREIGN KEY ([TN_CodTipoCaso]) REFERENCES [Catalogo].[TipoCaso] ([TN_CodTipoCaso])
ALTER TABLE [DefensaPublica].[Carpeta]
	CHECK CONSTRAINT [FK_Carpeta_TipoCaso]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_Carpeta_TF_Particion]
	ON [DefensaPublica].[Carpeta] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de referencia de la defensa', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Carpeta', 'COLUMN', N'TC_NRD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Carpeta', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creacion de la carpeta', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Carpeta', 'COLUMN', N'TF_Creacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del tipo de caso de la carpeta', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Carpeta', 'COLUMN', N'TN_CodTipoCaso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Carpeta', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Carpeta', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[Carpeta] SET (LOCK_ESCALATION = TABLE)
GO
