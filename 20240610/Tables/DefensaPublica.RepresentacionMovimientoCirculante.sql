SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[RepresentacionMovimientoCirculante] (
		[TU_CodMovimiento]               [uniqueidentifier] NOT NULL,
		[TF_Movimiento]                  [datetime2](7) NOT NULL,
		[TU_CodRepresentacion]           [uniqueidentifier] NOT NULL,
		[TC_CodContexto]                 [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodPuestoFuncionario]        [uniqueidentifier] NOT NULL,
		[TN_CodEstadoRepresentacion]     [smallint] NOT NULL,
		[TC_Movimiento]                  [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		CONSTRAINT [PK_RepresentacionMovimientoCirculante]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodMovimiento])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	ADD
	CONSTRAINT [CK_RepresentacionMovimientoCirculante_Movimiento]
	CHECK
	([TC_Movimiento]='E' OR [TC_Movimiento]='F' OR [TC_Movimiento]='L' OR [TC_Movimiento]='R' OR [TC_Movimiento]='S')
GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
CHECK CONSTRAINT [CK_RepresentacionMovimientoCirculante_Movimiento]
GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__3DF4B35D]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionMovimientoCirculante_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	CHECK CONSTRAINT [FK_RepresentacionMovimientoCirculante_Contexto]

GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionMovimientoCirculante_EstadoRepresentacion]
	FOREIGN KEY ([TN_CodEstadoRepresentacion]) REFERENCES [Catalogo].[EstadoRepresentacion] ([TN_CodEstadoRepresentacion])
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	CHECK CONSTRAINT [FK_RepresentacionMovimientoCirculante_EstadoRepresentacion]

GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionMovimientoCirculante_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_CodPuestoFuncionario]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	CHECK CONSTRAINT [FK_RepresentacionMovimientoCirculante_PuestoTrabajoFuncionario]

GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_RepresentacionMovimientoCirculante_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante]
	CHECK CONSTRAINT [FK_RepresentacionMovimientoCirculante_Representacion]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_RepresentacionMovimientoCirculante_TF_Particion]
	ON [DefensaPublica].[RepresentacionMovimientoCirculante] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico del movimiento', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TU_CodMovimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de movimiento de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TF_Movimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se realiza el movimiento.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de pusto de trabajo del funcionario', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TU_CodPuestoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del estado de representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TN_CodEstadoRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entrado = ''E'', Finalizado = ''F'', LevantarSuspension = ''L'', Reentrado = ''R'', Suspendido = ''S''', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RepresentacionMovimientoCirculante', 'COLUMN', N'TC_Movimiento'
GO
ALTER TABLE [DefensaPublica].[RepresentacionMovimientoCirculante] SET (LOCK_ESCALATION = TABLE)
GO
