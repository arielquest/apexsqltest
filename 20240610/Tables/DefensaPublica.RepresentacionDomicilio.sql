SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[RepresentacionDomicilio] (
		[TU_CodDomicilio]          [uniqueidentifier] NOT NULL,
		[TU_CodRepresentacion]     [uniqueidentifier] NOT NULL,
		[TN_CodTipoDomicilio]      [smallint] NOT NULL,
		[TC_CodPais]               [varchar](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodProvincia]          [smallint] NULL,
		[TN_CodCanton]             [smallint] NULL,
		[TN_CodDistrito]           [smallint] NULL,
		[TN_CodBarrio]             [smallint] NULL,
		[TC_Direccion]             [varchar](500) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Activo]                [bit] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DefensaPublica_RepresentacionDomicilio]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodDomicilio])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	ADD
	CONSTRAINT [DF_DefensaPublica_RepresentacionDomicilio_TB_Activo]
	DEFAULT ((1)) FOR [TB_Activo]
GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	ADD
	CONSTRAINT [DF_DefensaPublica_RepresentacionDomicilio_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__1D52D9A1]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Barrio]

GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Distrito]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito]) REFERENCES [Catalogo].[Distrito] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Distrito]

GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Domicilio]
	FOREIGN KEY ([TU_CodDomicilio]) REFERENCES [DefensaPublica].[RepresentacionDomicilio] ([TU_CodDomicilio])
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Domicilio]

GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Pais]
	FOREIGN KEY ([TC_CodPais]) REFERENCES [Catalogo].[Pais] ([TC_CodPais])
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Pais]

GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_Representacion]

GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_TipoDomicilio]
	FOREIGN KEY ([TN_CodTipoDomicilio]) REFERENCES [Catalogo].[TipoDomicilio] ([TN_CodTipoDomicilio])
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio]
	CHECK CONSTRAINT [FK_DefensaPublica_RepresentacionDomicilio_TipoDomicilio]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_RepresentacionDomicilio_TF_Particion]
	ON [DefensaPublica].[RepresentacionDomicilio] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los domicilios asociados a las representaciones de la defensa', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico del domicilio', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TU_CodDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico de la representación', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de domicilio', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TN_CodTipoDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del país.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TC_CodPais'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la dirección exacta.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TC_Direccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el domicilio se encuentra activo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TB_Activo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionDomicilio', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[RepresentacionDomicilio] SET (LOCK_ESCALATION = TABLE)
GO
