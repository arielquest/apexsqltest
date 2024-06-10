SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [ArchivoSinExpediente].[ArchivoSinExpediente] (
		[TU_CodArchivo]         [uniqueidentifier] NOT NULL,
		[TC_Condicion]          [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_BoletaCitacion]     [varchar](29) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_PlacaVehiculo]      [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Colision]           [datetime2](7) NULL,
		[TF_Particion]          [datetime2](7) NOT NULL,
		[DOCSINNUE]             [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ArchivoSinExpediente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo])
	ON [PRIMARY]
) ON [ArchivoPS] ([TF_Particion])
GO
ALTER TABLE [ArchivoSinExpediente].[ArchivoSinExpediente]
	ADD
	CONSTRAINT [CK_ArchivoSinExpediente_Condicion]
	CHECK
	([TC_Condicion]='P' OR [TC_Condicion]='I' OR [TC_Condicion]='T')
GO
ALTER TABLE [ArchivoSinExpediente].[ArchivoSinExpediente]
CHECK CONSTRAINT [CK_ArchivoSinExpediente_Condicion]
GO
ALTER TABLE [ArchivoSinExpediente].[ArchivoSinExpediente]
	ADD
	CONSTRAINT [DF__ArchivoSi__TF_Pa__55CC3CEE]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [ArchivoSinExpediente].[ArchivoSinExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSinExpediente_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [ArchivoSinExpediente].[ArchivoSinExpediente]
	CHECK CONSTRAINT [FK_ArchivoSinExpediente_Archivo]

GO
CREATE CLUSTERED INDEX [IX_ArchivoSinExpediente_ArchivoSinExpediente_TF_Particion]
	ON [ArchivoSinExpediente].[ArchivoSinExpediente] ([TF_Particion])
	ON [ArchivoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena información general de los archivos sin expediente.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'ArchivoSinExpediente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'ArchivoSinExpediente', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establece la condición en que en que se encuentra el archivo. Valor ‘P’: Pendiente de incorporar, valor ‘I’: Incorporado en expediente, valor ‘T’: Trasladado.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'ArchivoSinExpediente', 'COLUMN', N'TC_Condicion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de boleta de citación de tránsito.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'ArchivoSinExpediente', 'COLUMN', N'TC_BoletaCitacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de placa del vehículo. Aplica para Tránsito.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'ArchivoSinExpediente', 'COLUMN', N'TC_PlacaVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de colisión. Aplica para Tránsito.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'ArchivoSinExpediente', 'COLUMN', N'TF_Colision'
GO
ALTER TABLE [ArchivoSinExpediente].[ArchivoSinExpediente] SET (LOCK_ESCALATION = TABLE)
GO
