SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[Consecutivo] (
		[TC_CodConsecutivo]     [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]        [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Periodo]            [smallint] NOT NULL,
		[TN_Consecutivo]        [int] NOT NULL,
		[TC_Descripcion]        [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Desactivacion]      [datetime2](7) NULL,
		[TF_Actualizacion]      [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Consecutivo]
		PRIMARY KEY
		CLUSTERED
		([TC_CodConsecutivo], [TC_CodContexto], [TN_Periodo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Configuracion].[Consecutivo]
	ADD
	CONSTRAINT [DF_Consecutivo_TF_UltimaActualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Configuracion].[Consecutivo]
	WITH CHECK
	ADD CONSTRAINT [FK_Consecutivo_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Configuracion].[Consecutivo]
	CHECK CONSTRAINT [FK_Consecutivo_Contextos]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los diferentes consecutivos de los diferentes módulos de la aplicación.', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del consecutivo establecido por el administrador.', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TC_CodConsecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Año de cuatro digitos que representa el periodo.', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TN_Periodo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de consecutivo de asignación de NUE. ', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TN_Consecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del consecutivo', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se desactivo el registro.', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TF_Desactivacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la última actualización del registro.', 'SCHEMA', N'Configuracion', 'TABLE', N'Consecutivo', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Configuracion].[Consecutivo] SET (LOCK_ESCALATION = TABLE)
GO
