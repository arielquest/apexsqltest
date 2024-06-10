SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[DestinoEvidencia] (
		[TU_CodObjeto]       [uniqueidentifier] NOT NULL,
		[TC_Fiscal]          [varchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Disposicion]     [datetime2](7) NOT NULL,
		[TC_Disposicion]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_OrdenDe]         [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Destino]         [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Entrega]         [datetime2](7) NOT NULL,
		[TC_UsuarioRed]      [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]           [datetime2](7) NOT NULL,
		[TF_Particion]       [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DestinoEvidencia]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodObjeto])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [CK_DestinoEvidencia_Destino]
	CHECK
	([TC_Destino]='D' OR [TC_Destino]='A' OR [TC_Destino]='P' OR [TC_Destino]='B')
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
CHECK CONSTRAINT [CK_DestinoEvidencia_Destino]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [CK_DestinoEvidencia_Disposicion]
	CHECK
	([TC_Disposicion]='C' OR [TC_Disposicion]='O' OR [TC_Disposicion]='D' OR [TC_Disposicion]='E')
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
CHECK CONSTRAINT [CK_DestinoEvidencia_Disposicion]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [CK_DestinoEvidencia_OrdenDe]
	CHECK
	([TC_OrdenDe]='F' OR [TC_OrdenDe]='J' OR [TC_OrdenDe]='T')
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
CHECK CONSTRAINT [CK_DestinoEvidencia_OrdenDe]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [DF__DestinoEv__TF_Di__56620522]
	DEFAULT (getdate()) FOR [TF_Disposicion]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [DF__DestinoEv__TF_En__5756295B]
	DEFAULT (getdate()) FOR [TF_Entrega]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [DF__DestinoEv__TF_Fe__584A4D94]
	DEFAULT (getdate()) FOR [TF_Fecha]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	ADD
	CONSTRAINT [DF__DestinoEv__TF_Pa__50136398]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[DestinoEvidencia]
	WITH CHECK
	ADD CONSTRAINT [FK_DestinoEvidencia_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[DestinoEvidencia]
	CHECK CONSTRAINT [FK_DestinoEvidencia_Objeto]

GO
CREATE CLUSTERED INDEX [IX_Objeto_DestinoEvidencia_TF_Particion]
	ON [Objeto].[DestinoEvidencia] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo único obligatorio que va a contener el id del código del objeto que hace referencia a la tabla de Objeto', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el nombre del fiscal que dispone de la evidencia', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TC_Fiscal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de disposición de la evidencia', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TF_Disposicion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a indicar el tipo de disposición (Custodia = [C], Comiso = [O], Destrucción = [D] o Devolución = [E])', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TC_Disposicion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a indicar el tipo de a la orden de (Fiscalía = [F], Juzgado = [J] o Tribunal = [T])', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TC_OrdenDe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a indicar el destino de la evidencia (Depósito de Objetos = [D], Arsenal Nacional = [A], Pericias Físicas = [P] o Botadero = [B])', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TC_Destino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha de entrega al destino de la evidencia', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TF_Entrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a indicar el usuario de red que realiza el registro, del destino de la evidencia', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora del registro del destino de la evidencia', 'SCHEMA', N'Objeto', 'TABLE', N'DestinoEvidencia', 'COLUMN', N'TF_Fecha'
GO
ALTER TABLE [Objeto].[DestinoEvidencia] SET (LOCK_ESCALATION = TABLE)
GO
