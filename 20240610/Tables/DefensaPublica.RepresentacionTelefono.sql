SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[RepresentacionTelefono] (
		[TU_CodTelefono]           [uniqueidentifier] NOT NULL,
		[TN_CodTipoTelefono]       [smallint] NOT NULL,
		[TU_CodRepresentacion]     [uniqueidentifier] NOT NULL,
		[TC_CodArea]               [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Numero]                [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Extension]             [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_SMS]                   [bit] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DefensaPublica_RepresentacionTelefono]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodTelefono])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	ADD
	CONSTRAINT [DF__DefensaPublica_RepresentacionTelefono__TB_SMS__564C2B32]
	DEFAULT ((0)) FOR [TB_SMS]
GO
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	ADD
	CONSTRAINT [DF_DefensaPublica_RepresentacionTelefono_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__352A6332]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionTelefono_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionTelefono_Representacion]

GO
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionTelefono_TipoTelefono]
	FOREIGN KEY ([TN_CodTipoTelefono]) REFERENCES [Catalogo].[TipoTelefono] ([TN_CodTipoTelefono])
ALTER TABLE [DefensaPublica].[RepresentacionTelefono]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionTelefono_TipoTelefono]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_RepresentacionTelefono_TF_Particion]
	ON [DefensaPublica].[RepresentacionTelefono] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los teléfonos asociados a las representaciones de la defensa', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico del teléfono.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TU_CodTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico que indica el tipo de teléfono', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TN_CodTipoTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código área del teléfono', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TC_CodArea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de teléfono.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TC_Numero'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de extensión.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TC_Extension'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se debe enviar SMS.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TB_SMS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionTelefono', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[RepresentacionTelefono] SET (LOCK_ESCALATION = TABLE)
GO
