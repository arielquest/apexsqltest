SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[ConsecutivoReutilizar] (
		[TU_CodPreasignado]     [uniqueidentifier] NOT NULL,
		[TF_Fecha]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ConsecutivoReutilizar]
		PRIMARY KEY
		CLUSTERED
		([TU_CodPreasignado])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[ConsecutivoReutilizar]
	ADD
	CONSTRAINT [DF_ConsecutivoReutilizar_TF_Fecha]
	DEFAULT (sysdatetime()) FOR [TF_Fecha]
GO
ALTER TABLE [Expediente].[ConsecutivoReutilizar]
	WITH CHECK
	ADD CONSTRAINT [FK_ConsecutivoReutilizar_ExpedientePreasignado]
	FOREIGN KEY ([TU_CodPreasignado]) REFERENCES [Expediente].[ExpedientePreasignado] ([TU_CodPreasignado])
ALTER TABLE [Expediente].[ConsecutivoReutilizar]
	CHECK CONSTRAINT [FK_ConsecutivoReutilizar_ExpedientePreasignado]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene consecutivos que pueden ser reutilizados por sistemas externos', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoReutilizar', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del expediente preasignado que estará disponible para reutilizarse.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoReutilizar', 'COLUMN', N'TU_CodPreasignado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se ingresó el registro del consecutivo generado.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoReutilizar', 'COLUMN', N'TF_Fecha'
GO
ALTER TABLE [Expediente].[ConsecutivoReutilizar] SET (LOCK_ESCALATION = TABLE)
GO
