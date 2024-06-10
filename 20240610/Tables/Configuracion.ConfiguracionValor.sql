SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[ConfiguracionValor] (
		[TU_Codigo]               [uniqueidentifier] NOT NULL,
		[TC_CodConfiguracion]     [varchar](27) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaCreacion]        [datetime2](7) NOT NULL,
		[TF_FechaActivacion]      [datetime2](7) NOT NULL,
		[TF_FechaCaducidad]       [datetime2](7) NULL,
		[TC_Valor]                [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_ConfiguracionValor]
		PRIMARY KEY
		CLUSTERED
		([TU_Codigo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Configuracion].[ConfiguracionValor]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionValor_ConfiguracionValor]
	FOREIGN KEY ([TC_CodConfiguracion]) REFERENCES [Configuracion].[Configuracion] ([TC_CodConfiguracion])
ALTER TABLE [Configuracion].[ConfiguracionValor]
	CHECK CONSTRAINT [FK_ConfiguracionValor_ConfiguracionValor]

GO
ALTER TABLE [Configuracion].[ConfiguracionValor]
	WITH CHECK
	ADD CONSTRAINT [FK_ConfiguracionValor_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Configuracion].[ConfiguracionValor]
	CHECK CONSTRAINT [FK_ConfiguracionValor_Contexto]

GO
CREATE NONCLUSTERED INDEX [IX_ConfiguracionValor_ConsultarConfiguracionValorOficinaGeneral]
	ON [Configuracion].[ConfiguracionValor] ([TC_CodContexto], [TF_FechaActivacion], [TF_FechaCaducidad])
	INCLUDE ([TU_Codigo], [TC_CodConfiguracion], [TF_FechaCreacion], [TC_Valor])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Configuracion.PA_ConsultarConfiguracionValorOficinaGeneral', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'INDEX', N'IX_ConfiguracionValor_ConsultarConfiguracionValorOficinaGeneral'
GO
CREATE NONCLUSTERED INDEX [IX_ConfiguracionValor_Fechas]
	ON [Configuracion].[ConfiguracionValor] ([TC_CodConfiguracion], [TF_FechaActivacion], [TF_FechaCaducidad])
	INCLUDE ([TC_Valor])
	ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla donde se definen los valores de las configuraciones.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del valor de configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TU_Codigo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la configuración a la que corresponde el valor.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TC_CodConfiguracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el valor.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del valor de configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del valor de configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TF_FechaActivacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del valor de configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TF_FechaCaducidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor de configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'ConfiguracionValor', 'COLUMN', N'TC_Valor'
GO
ALTER TABLE [Configuracion].[ConfiguracionValor] SET (LOCK_ESCALATION = TABLE)
GO
