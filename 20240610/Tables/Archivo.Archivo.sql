SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Archivo].[Archivo] (
		[TU_CodArchivo]                [uniqueidentifier] NOT NULL,
		[TC_Descripcion]               [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoCrea]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodFormatoArchivo]         [int] NOT NULL,
		[TC_UsuarioCrea]               [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCrea]                 [datetime2](7) NOT NULL,
		[TN_CodEstado]                 [tinyint] NULL,
		[TF_Actualizacion]             [datetime2](7) NOT NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		[TC_CodFormatoJuridico]        [varchar](8) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_GenerarVotoAutomatico]     [bit] NULL,
		[IDACO]                        [int] NULL,
		[TB_Multimedia]                [bit] NOT NULL,
		CONSTRAINT [PK_ExpedienteArchivo_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo])
	ON [PRIMARY]
) ON [ArchivoPS] ([TF_Particion])
GO
ALTER TABLE [Archivo].[Archivo]
	ADD
	CONSTRAINT [CK_Archivo_CodEstado]
	CHECK
	([TN_CodEstado]=(4) OR [TN_CodEstado]=(3) OR [TN_CodEstado]=(2) OR [TN_CodEstado]=(1))
GO
ALTER TABLE [Archivo].[Archivo]
CHECK CONSTRAINT [CK_Archivo_CodEstado]
GO
ALTER TABLE [Archivo].[Archivo]
	ADD
	CONSTRAINT [DF_LegajoArchivo_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Archivo].[Archivo]
	ADD
	CONSTRAINT [DF__Archivo__TF_Part__27D06814]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Archivo].[Archivo]
	ADD
	CONSTRAINT [DF__Archivo__TB_Mult__6304A5CD]
	DEFAULT ((0)) FOR [TB_Multimedia]
GO
ALTER TABLE [Archivo].[Archivo]
	WITH CHECK
	ADD CONSTRAINT [FK_Archivo_Contexto]
	FOREIGN KEY ([TC_CodContextoCrea]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Archivo].[Archivo]
	CHECK CONSTRAINT [FK_Archivo_Contexto]

GO
ALTER TABLE [Archivo].[Archivo]
	WITH CHECK
	ADD CONSTRAINT [FK_Archivo_FormatoJuridico]
	FOREIGN KEY ([TC_CodFormatoJuridico]) REFERENCES [Catalogo].[FormatoJuridico] ([TC_CodFormatoJuridico])
ALTER TABLE [Archivo].[Archivo]
	CHECK CONSTRAINT [FK_Archivo_FormatoJuridico]

GO
ALTER TABLE [Archivo].[Archivo]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoArchivo_FormatoArchivo]
	FOREIGN KEY ([TN_CodFormatoArchivo]) REFERENCES [Catalogo].[FormatoArchivo] ([TN_CodFormatoArchivo])
ALTER TABLE [Archivo].[Archivo]
	CHECK CONSTRAINT [FK_LegajoArchivo_FormatoArchivo]

GO
CREATE CLUSTERED INDEX [IX_Archivo_Archivo_TF_Particion]
	ON [Archivo].[Archivo] ([TF_Particion])
	ON [ArchivoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los archivos asociados al expediente.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del archivo. Mismo identificador que tiene el archivo en la base de datos FileStream.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del archivo.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina que agregó el archivo.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TC_CodContextoCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del formato del archivo.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TN_CodFormatoArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que agregó el archivo.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TC_UsuarioCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del archivo.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TF_FechaCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado del archivo (1 = privado, 2 = borrador, 3 = borrador público, 4 = terminado).', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de formato jurídico utilizado para generar el archivo del documento', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para determinar si el voto se genera automatico o no. Entonces 1 es generado automatico y 0 no lo hace', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TB_GenerarVotoAutomatico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifica si el archivo es de tipo multimedia o no.', 'SCHEMA', N'Archivo', 'TABLE', N'Archivo', 'COLUMN', N'TB_Multimedia'
GO
ALTER TABLE [Archivo].[Archivo] SET (LOCK_ESCALATION = TABLE)
GO
