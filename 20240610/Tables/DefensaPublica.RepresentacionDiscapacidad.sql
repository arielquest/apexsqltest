SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [DefensaPublica].[RepresentacionDiscapacidad] (
		[TU_CodRepresentacion]     [uniqueidentifier] NOT NULL,
		[TN_CodDiscapacidad]       [smallint] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_RepresentacionDiscapacidad]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodRepresentacion], [TN_CodDiscapacidad])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad]
	ADD
	CONSTRAINT [DF__Represent__TF_Ac__5634BA94]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__1B6A912F]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionDiscapacidad_Discapacidad]
	FOREIGN KEY ([TN_CodDiscapacidad]) REFERENCES [Catalogo].[Discapacidad] ([TN_CodDiscapacidad])
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad]
	CHECK CONSTRAINT [FK_RepresentacionDiscapacidad_Discapacidad]

GO
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionDiscapacidad_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad]
	CHECK CONSTRAINT [FK_RepresentacionDiscapacidad_Representacion]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_RepresentacionDiscapacidad_TF_Particion]
	ON [DefensaPublica].[RepresentacionDiscapacidad] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDiscapacidad', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la discapacidad', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDiscapacidad', 'COLUMN', N'TN_CodDiscapacidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDiscapacidad', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[RepresentacionDiscapacidad] SET (LOCK_ESCALATION = TABLE)
GO
