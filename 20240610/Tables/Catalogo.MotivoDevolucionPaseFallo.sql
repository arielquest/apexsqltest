SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoDevolucionPaseFallo] (
		[TN_CodMotivoDevolucion]     [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoMotivo]              [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		CONSTRAINT [PK_MotivoDevolucionPaseFallo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoDevolucion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFallo]
	ADD
	CONSTRAINT [CK_MotivoDevolucionPaseFallo_TipoMotivo]
	CHECK
	([TC_TipoMotivo]='C' OR [TC_TipoMotivo]='S' OR [TC_TipoMotivo]='P')
GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFallo]
CHECK CONSTRAINT [CK_MotivoDevolucionPaseFallo_TipoMotivo]
GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFallo]
	ADD
	CONSTRAINT [DF_MotivoDevolucionPaseFallo_TN_CodMotivoDevolucion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoDevolucionPaseFallo]) FOR [TN_CodMotivoDevolucion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los motivos de devolucion de un pase a fallo.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFallo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de devolución del pase a fallo.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFallo', 'COLUMN', N'TN_CodMotivoDevolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de devolución del pase a fallo.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFallo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo del motivo de pase a fallo asociado al emunerador E_TipoMotivoPaseFallo admite los valores S = Sin sentencia, C = Con sentencia y P = Suspende Plazo.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFallo', 'COLUMN', N'TC_TipoMotivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFallo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFallo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFallo] SET (LOCK_ESCALATION = TABLE)
GO
