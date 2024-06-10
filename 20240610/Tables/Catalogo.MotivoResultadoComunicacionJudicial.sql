SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoResultadoComunicacionJudicial] (
		[TN_CodMotivoResultado]            [smallint] NOT NULL,
		[TC_Resultado]                     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]                   [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]               [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                  [datetime2](7) NULL,
		[TC_CodMotivoResultadoBiztalk]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[id_rechazo]                       [int] NULL,
		CONSTRAINT [PK_MotivoResultadoComunicacionJudicial]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoResultado])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial]
	ADD
	CONSTRAINT [CHK_CodMotivoResultadoBiztalk]
	CHECK
	([TC_CodMotivoResultadoBiztalk]='A' OR [TC_CodMotivoResultadoBiztalk]='B' OR [TC_CodMotivoResultadoBiztalk]='C' OR [TC_CodMotivoResultadoBiztalk]='D' OR [TC_CodMotivoResultadoBiztalk]='E' OR [TC_CodMotivoResultadoBiztalk]='F' OR [TC_CodMotivoResultadoBiztalk]='G' OR [TC_CodMotivoResultadoBiztalk]='H' OR [TC_CodMotivoResultadoBiztalk]='I' OR [TC_CodMotivoResultadoBiztalk]='J' OR [TC_CodMotivoResultadoBiztalk]='K')
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial]
CHECK CONSTRAINT [CHK_CodMotivoResultadoBiztalk]
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial]
	ADD
	CONSTRAINT [CK_ResultadoComunicacionJudicial]
	CHECK
	([TC_Resultado]='P' OR [TC_Resultado]='N' OR [TC_Resultado]='E')
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial]
CHECK CONSTRAINT [CK_ResultadoComunicacionJudicial]
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial]
	ADD
	CONSTRAINT [DF_MotivoResultadoComunicacionJudicial_TN_CodMotivoResultado]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoResultadoComunicacionJudicial]) FOR [TN_CodMotivoResultado]
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial]
	ADD
	CONSTRAINT [DF_MotivoResultadoComunicacionJudicial_TC_CodMotivoResultadoBiztalk]
	DEFAULT ('A') FOR [TC_CodMotivoResultadoBiztalk]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo para los motivos de resultado de las comunicaciones judiciales', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identidicador del motivo del resultado', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', 'COLUMN', N'TN_CodMotivoResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el resultado de la diligencia de la comunicación judicial, WITH CHECK ADD CONSTRAINT para que solo acepte los siguientes valores Positivo = ''P'', Negativo = ''N'', Error = ''E''
 ', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', 'COLUMN', N'TC_Resultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo del resultado', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inicio de vigencia de la jornada', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fin de vigencia de la jornada
 ', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de resultado que será utilizado como referencia por las orquestaciones de Biztalk Check Constraint para A = Otros, B = Entregada, C = FormatoDireccionCorreoNoValido, D = ComunicacionSinDocumento, E = DocumentoExcedeTamannioMaximo, F = EntidadJuridicaNoRegistrada, G = NumeroFaxNoValido, H = DocumentoExcedeHojasMaximo, I = ComunicacionFallaEntodosIntentosdeLey, J = UsuarioNoSubscritoAlMedioMovil, K = MaximoIntentosRealizados', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoResultadoComunicacionJudicial', 'COLUMN', N'TC_CodMotivoResultadoBiztalk'
GO
ALTER TABLE [Catalogo].[MotivoResultadoComunicacionJudicial] SET (LOCK_ESCALATION = TABLE)
GO
