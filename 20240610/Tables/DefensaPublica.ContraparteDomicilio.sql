SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[ContraparteDomicilio] (
		[TU_CodDomicilio]         [uniqueidentifier] NOT NULL,
		[TU_CodContraparte]       [uniqueidentifier] NOT NULL,
		[TN_CodTipoDomicilio]     [smallint] NOT NULL,
		[TC_CodPais]              [varchar](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodProvincia]         [smallint] NULL,
		[TN_CodCanton]            [smallint] NULL,
		[TN_CodDistrito]          [smallint] NULL,
		[TN_CodBarrio]            [smallint] NULL,
		[TC_Direccion]            [varchar](500) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Activo]               [bit] NOT NULL,
		[TF_Actualizacion]        [datetime2](7) NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DefensaPublica_ContraparteDomicilio]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodDomicilio])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	ADD
	CONSTRAINT [DF_DefensaPublica_ContraparteDomicilio_TB_Activo]
	DEFAULT ((1)) FOR [TB_Activo]
GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	ADD
	CONSTRAINT [DF_DefensaPublica_ContraparteDomicilio_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	ADD
	CONSTRAINT [DF__Contrapar__TF_Pa__15B1B7D9]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Barrio]

GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Contraparte]
	FOREIGN KEY ([TU_CodContraparte]) REFERENCES [DefensaPublica].[Contraparte] ([TU_CodContraparte])
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Contraparte]

GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Distrito]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito]) REFERENCES [Catalogo].[Distrito] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Distrito]

GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Domicilio]
	FOREIGN KEY ([TU_CodDomicilio]) REFERENCES [DefensaPublica].[ContraparteDomicilio] ([TU_CodDomicilio])
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Domicilio]

GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Pais]
	FOREIGN KEY ([TC_CodPais]) REFERENCES [Catalogo].[Pais] ([TC_CodPais])
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_Pais]

GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_TipoDomicilio]
	FOREIGN KEY ([TN_CodTipoDomicilio]) REFERENCES [Catalogo].[TipoDomicilio] ([TN_CodTipoDomicilio])
ALTER TABLE [DefensaPublica].[ContraparteDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_ContraparteDomicilio_TipoDomicilio]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_ContraparteDomicilio_TF_Particion]
	ON [DefensaPublica].[ContraparteDomicilio] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los domicilios asociados a las contrapartes de la defensa', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico del domicilio', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TU_CodDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico de la contraparte', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TU_CodContraparte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de domicilio', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TN_CodTipoDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del país.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TC_CodPais'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la dirección exacta.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TC_Direccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el domicilio se encuentra activo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TB_Activo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ContraparteDomicilio', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[ContraparteDomicilio] SET (LOCK_ESCALATION = TABLE)
GO
