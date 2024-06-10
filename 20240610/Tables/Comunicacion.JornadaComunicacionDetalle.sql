SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[JornadaComunicacionDetalle] (
		[TU_CodJornadaComunicacion]     [uniqueidentifier] NOT NULL,
		[TU_CodComunicacion]            [uniqueidentifier] NOT NULL,
		[TB_Realizada]                  [bit] NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		CONSTRAINT [PK_JornadaComunicacionDetalle]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodJornadaComunicacion], [TU_CodComunicacion])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[JornadaComunicacionDetalle]
	ADD
	CONSTRAINT [DF_JornadaComunicacionDetalle_TB_Realizada]
	DEFAULT ((0)) FOR [TB_Realizada]
GO
ALTER TABLE [Comunicacion].[JornadaComunicacionDetalle]
	ADD
	CONSTRAINT [DF__JornadaCo__TF_Pa__6AC759D4]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[JornadaComunicacionDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_JornadaComunicacionDetalle_JornadaComunicacion]
	FOREIGN KEY ([TU_CodJornadaComunicacion]) REFERENCES [Comunicacion].[JornadaComunicacion] ([TU_CodJornadaComunicacion])
ALTER TABLE [Comunicacion].[JornadaComunicacionDetalle]
	CHECK CONSTRAINT [FK_JornadaComunicacionDetalle_JornadaComunicacion]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_JornadaComunicacionDetalle_TF_Participacion]
	ON [Comunicacion].[JornadaComunicacionDetalle] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detalle de las comunicaciones que un oficial de comunicación debe tramitar', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacionDetalle', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador de la jornada de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacionDetalle', 'COLUMN', N'TU_CodJornadaComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador unico del registro de la cominicacion ', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacionDetalle', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la comunicación fue realizada o tramitada, si no se tramitó se debe escribir una observación o justificación en la jornada de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'JornadaComunicacionDetalle', 'COLUMN', N'TB_Realizada'
GO
ALTER TABLE [Comunicacion].[JornadaComunicacionDetalle] SET (LOCK_ESCALATION = TABLE)
GO
