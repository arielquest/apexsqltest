SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoTipoOficina] (
		[TN_CodTipoOficina]        [smallint] NOT NULL,
		[TN_CodEstado]             [int] NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NULL,
		[TB_IniciaTramitacion]     [bit] NOT NULL,
		[TC_CodMateria]            [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_CierreAcumulacion]     [bit] NOT NULL,
		CONSTRAINT [PK_TipoOficinaEstado]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstado], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoTipoOficina]
	ADD
	CONSTRAINT [DF_TipoOficinaEstado_TB_PorDefecto]
	DEFAULT ((0)) FOR [TB_IniciaTramitacion]
GO
ALTER TABLE [Catalogo].[EstadoTipoOficina]
	ADD
	CONSTRAINT [DF__EstadoTip__TB_Ci__73678CCD]
	DEFAULT ((0)) FOR [TB_CierreAcumulacion]
GO
ALTER TABLE [Catalogo].[EstadoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaEstado_Estado]
	FOREIGN KEY ([TN_CodEstado]) REFERENCES [Catalogo].[Estado] ([TN_CodEstado])
ALTER TABLE [Catalogo].[EstadoTipoOficina]
	CHECK CONSTRAINT [FK_TipoOficinaEstado_Estado]

GO
ALTER TABLE [Catalogo].[EstadoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaEstado_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[EstadoTipoOficina]
	CHECK CONSTRAINT [FK_TipoOficinaEstado_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los tipos de oficina con sus estados de expediente.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado del expediente.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala si estado inicia la tramitación de expedientes y legajos en el tipo de oficina y materia donde está asociado.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', 'COLUMN', N'TB_IniciaTramitacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el estado corresponde a un cierre por acumulación de expediente.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTipoOficina', 'COLUMN', N'TB_CierreAcumulacion'
GO
ALTER TABLE [Catalogo].[EstadoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO
