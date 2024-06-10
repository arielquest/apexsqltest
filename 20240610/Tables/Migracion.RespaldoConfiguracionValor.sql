SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Migracion].[RespaldoConfiguracionValor] (
		[TU_Codigo]               [uniqueidentifier] NOT NULL,
		[TC_CodConfiguracion]     [varchar](27) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaCreacion]        [datetime2](7) NOT NULL,
		[TF_FechaActivacion]      [datetime2](7) NOT NULL,
		[TF_FechaCaducidad]       [datetime2](7) NULL,
		[TC_Valor]                [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Migracion].[RespaldoConfiguracionValor] SET (LOCK_ESCALATION = TABLE)
GO
