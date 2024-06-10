SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ClaseAsuntoDecreto] (
		[TC_CodigoDecreto]       [varchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TN_CodClase]            [int] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaAsociacion]     [datetime2](7) NOT NULL,
		[TN_MontoInicial]        [decimal](12, 0) NOT NULL,
		[TN_MontoFinal]          [decimal](12, 0) NOT NULL,
		[TN_Porcentaje]          [decimal](4, 2) NOT NULL,
		[TB_UltimoMonto]         [bit] NOT NULL,
		CONSTRAINT [PK_ClaseAsuntoDecreto]
		PRIMARY KEY
		CLUSTERED
		([TC_CodigoDecreto], [TN_CodTipoOficina], [TN_CodClase], [TC_CodMateria], [TN_MontoInicial], [TN_MontoFinal])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	ADD
	CONSTRAINT [DF_ClaseAsuntoDecreto_TN_MontoInicial]
	DEFAULT ((0)) FOR [TN_MontoInicial]
GO
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	ADD
	CONSTRAINT [DF_ClaseAsuntoDecreto_TN_MontoFinal]
	DEFAULT ((0)) FOR [TN_MontoFinal]
GO
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	ADD
	CONSTRAINT [DF_ClaseAsuntoDecreto_TN_Porcentaje]
	DEFAULT ((0)) FOR [TN_Porcentaje]
GO
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseAsuntoDecreto_Decreto]
	FOREIGN KEY ([TC_CodigoDecreto]) REFERENCES [Catalogo].[Decreto] ([TC_CodigoDecreto])
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	CHECK CONSTRAINT [FK_ClaseAsuntoDecreto_Decreto]

GO
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseAsuntoDecreto_TipoOficinaClaseAsunto]
	FOREIGN KEY ([TN_CodClase], [TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[ClaseTipoOficina] ([TN_CodClase], [TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto]
	CHECK CONSTRAINT [FK_ClaseAsuntoDecreto_TipoOficinaClaseAsunto]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla pivote para vincular la clase de asunto, el decreto y el tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TC_CodigoDecreto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de clase de asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de materia', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fechade asociación del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TF_FechaAsociacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto inicial del rango para el decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TN_MontoInicial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto final del rango para el decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TN_MontoFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Porcentaje de honorarios', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TN_Porcentaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si es el último monto del rango para el decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoDecreto', 'COLUMN', N'TB_UltimoMonto'
GO
ALTER TABLE [Catalogo].[ClaseAsuntoDecreto] SET (LOCK_ESCALATION = TABLE)
GO
