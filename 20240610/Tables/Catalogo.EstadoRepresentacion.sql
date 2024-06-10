SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoRepresentacion] (
		[TN_CodEstadoRepresentacion]     [smallint] NOT NULL,
		[TC_Descripcion]                 [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Circulante]                  [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Pasivo]                      [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Inicio_Vigencia]             [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                [datetime2](7) NULL,
		CONSTRAINT [PK_EstadoRepresentacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoRepresentacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoRepresentacion]
	ADD
	CONSTRAINT [CK_EstadoRepresentacion_Circulante]
	CHECK
	([TC_Circulante]='F' OR [TC_Circulante]='P' OR [TC_Circulante]='A')
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'CONSTRAINT', N'CK_EstadoRepresentacion_Circulante'
GO
ALTER TABLE [Catalogo].[EstadoRepresentacion]
CHECK CONSTRAINT [CK_EstadoRepresentacion_Circulante]
GO
ALTER TABLE [Catalogo].[EstadoRepresentacion]
	ADD
	CONSTRAINT [CK_EstadoRepresentacion_Pasivo]
	CHECK
	([TC_Pasivo]='I' OR [TC_Pasivo]='S')
GO
ALTER TABLE [Catalogo].[EstadoRepresentacion]
CHECK CONSTRAINT [CK_EstadoRepresentacion_Pasivo]
GO
ALTER TABLE [Catalogo].[EstadoRepresentacion]
	ADD
	CONSTRAINT [DF_EstadoRepresentacion_TN_CodEstadoRepresentacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoRepresentacion]) FOR [TN_CodEstadoRepresentacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del estado de representacion', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'COLUMN', N'TN_CodEstadoRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion del estado de representacion', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala la condición en el circulante en que está en el expediente o legajo de acuerdo a su estado. A: Activo, P: Pasivo, F: Finalizado.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'COLUMN', N'TC_Circulante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite señalar si el expediente o legajo está suspendido (S) o inactivo (I).', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'COLUMN', N'TC_Pasivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoRepresentacion] SET (LOCK_ESCALATION = TABLE)
GO
