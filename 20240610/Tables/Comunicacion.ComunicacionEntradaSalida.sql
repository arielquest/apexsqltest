SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[ComunicacionEntradaSalida] (
		[TU_CodComunicacionEntradaSalida]     [uniqueidentifier] NOT NULL,
		[TU_CodComunicacion]                  [uniqueidentifier] NOT NULL,
		[TC_CodContextoOCJOrigen]             [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoOCJDestino]            [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Entrada]                          [datetime2](7) NULL,
		[TF_Envio]                            [datetime2](7) NULL,
		[TC_UsuarioCrea]                      [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ComisionOCJ_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodComunicacionEntradaSalida])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[ComunicacionEntradaSalida]
	ADD
	CONSTRAINT [DF__Comunicac__TF_Pa__613DEF9A]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[ComunicacionEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionEntradaSalida_Contextos]
	FOREIGN KEY ([TC_CodContextoOCJOrigen]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Comunicacion].[ComunicacionEntradaSalida]
	CHECK CONSTRAINT [FK_ComunicacionEntradaSalida_Contextos]

GO
ALTER TABLE [Comunicacion].[ComunicacionEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionEntradaSalida_Contextos1]
	FOREIGN KEY ([TC_CodContextoOCJDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Comunicacion].[ComunicacionEntradaSalida]
	CHECK CONSTRAINT [FK_ComunicacionEntradaSalida_Contextos1]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_ComunicacionEntradaSalida_TF_Particion]
	ON [Comunicacion].[ComunicacionEntradaSalida] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que almacena las entradas y salidas de una comunicación entre las oficinas OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la entrada salida de la comunicación de una ocj', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TU_CodComunicacionEntradaSalida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador unico del registro de la cominicacion ', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto origen', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TC_CodContextoOCJOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto destino', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TC_CodContextoOCJDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se recibe la comunicación en la ocj', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TF_Entrada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se envía la comunicación a otra OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TF_Envio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que solicita la comisión de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionEntradaSalida', 'COLUMN', N'TC_UsuarioCrea'
GO
ALTER TABLE [Comunicacion].[ComunicacionEntradaSalida] SET (LOCK_ESCALATION = TABLE)
GO
