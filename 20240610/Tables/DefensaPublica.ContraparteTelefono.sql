SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[ContraparteTelefono] (
		[TU_CodTelefono]         [uniqueidentifier] NOT NULL,
		[TN_CodTipoTelefono]     [smallint] NOT NULL,
		[TU_CodContraparte]      [uniqueidentifier] NOT NULL,
		[TC_CodArea]             [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Numero]              [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Extension]           [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_SMS]                 [bit] NOT NULL,
		[TF_Actualizacion]       [datetime2](7) NULL,
		[TF_Particion]           [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DefensaPublica_ContraparteTelefono]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodTelefono])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	ADD
	CONSTRAINT [DF__DefensaPublica_ContraparteTelefono__TB_SMS__564C2B32]
	DEFAULT ((0)) FOR [TB_SMS]
GO
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	ADD
	CONSTRAINT [DF_DefensaPublica_ContraparteTelefono_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	ADD
	CONSTRAINT [DF__Contrapar__TF_Pa__0F04BA4A]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteTelefono_Contraparte]
	FOREIGN KEY ([TU_CodContraparte]) REFERENCES [DefensaPublica].[Contraparte] ([TU_CodContraparte])
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteTelefono_Contraparte]

GO
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteTelefono_TipoTelefono]
	FOREIGN KEY ([TN_CodTipoTelefono]) REFERENCES [Catalogo].[TipoTelefono] ([TN_CodTipoTelefono])
ALTER TABLE [DefensaPublica].[ContraparteTelefono]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteTelefono_TipoTelefono]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_ContraparteTelefono_TF_Particion]
	ON [DefensaPublica].[ContraparteTelefono] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los teléfonos asociados a las contrapartes de la defensa', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico del teléfono.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TU_CodTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico que indica el tipo de teléfono', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TN_CodTipoTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la contraparte', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TU_CodContraparte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código área del teléfono', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TC_CodArea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de teléfono.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TC_Numero'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de extensión.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TC_Extension'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se debe enviar SMS.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TB_SMS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteTelefono', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[ContraparteTelefono] SET (LOCK_ESCALATION = TABLE)
GO
