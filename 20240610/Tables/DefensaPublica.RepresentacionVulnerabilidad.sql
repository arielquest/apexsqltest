SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [DefensaPublica].[RepresentacionVulnerabilidad] (
		[TU_CodRepresentacion]     [uniqueidentifier] NOT NULL,
		[TN_CodVulnerabilidad]     [smallint] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_RepresentacionVulnerabilidad]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodRepresentacion], [TN_CodVulnerabilidad])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad]
	ADD
	CONSTRAINT [DF__Represent__TF_Ac__5ECA0095]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__49666609]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionVulnerabilidad_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad]
	CHECK CONSTRAINT [FK_RepresentacionVulnerabilidad_Representacion]

GO
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionVulnerabilidad_Vulnerabilidad]
	FOREIGN KEY ([TN_CodVulnerabilidad]) REFERENCES [Catalogo].[Vulnerabilidad] ([TN_CodVulnerabilidad])
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad]
	CHECK CONSTRAINT [FK_RepresentacionVulnerabilidad_Vulnerabilidad]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_RepresentacionVulnerabilidad_TF_Particion]
	ON [DefensaPublica].[RepresentacionVulnerabilidad] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionVulnerabilidad', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la vulnerabilidad', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionVulnerabilidad', 'COLUMN', N'TN_CodVulnerabilidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualizacion para sigma', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionVulnerabilidad', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[RepresentacionVulnerabilidad] SET (LOCK_ESCALATION = TABLE)
GO
