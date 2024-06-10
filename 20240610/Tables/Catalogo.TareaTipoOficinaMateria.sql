SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TareaTipoOficinaMateria] (
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TN_CodTarea]            [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NULL,
		[TN_CantidadHoras]       [int] NOT NULL,
		[TC_PaseFallo]           [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_TareaTipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TN_CodTarea], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
	ADD
	CONSTRAINT [CK_TareaTipoOficinaMateria_PaseFallo]
	CHECK
	([TC_PaseFallo]='N' OR [TC_PaseFallo]='I' OR [TC_PaseFallo]='D')
GO
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
CHECK CONSTRAINT [CK_TareaTipoOficinaMateria_PaseFallo]
GO
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
	ADD
	CONSTRAINT [DF_TareaTipoOficinaMateria_TC_PaseFallo]
	DEFAULT ('N') FOR [TC_PaseFallo]
GO
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaTipoOficinaMateria_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
	CHECK CONSTRAINT [FK_TareaTipoOficinaMateria_TipoOficinaMateria]

GO
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTarea_TN_CodTarea]
	FOREIGN KEY ([TN_CodTarea]) REFERENCES [Catalogo].[Tarea] ([TN_CodTarea])
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria]
	CHECK CONSTRAINT [FK_TipoOficinaTarea_TN_CodTarea]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaTipoOficinaMateria', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la Tarea', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaTipoOficinaMateria', 'COLUMN', N'TN_CodTarea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaTipoOficinaMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaTipoOficinaMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de horas establecidas como límite para la tarea', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaTipoOficinaMateria', 'COLUMN', N'TN_CantidadHoras'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se registra el enum para indicar la accion de pase a fallo que realiza la tarea, admite los valores {N,I,D} N= No, I = Inclusión y D = Devolución', 'SCHEMA', N'Catalogo', 'TABLE', N'TareaTipoOficinaMateria', 'COLUMN', N'TC_PaseFallo'
GO
ALTER TABLE [Catalogo].[TareaTipoOficinaMateria] SET (LOCK_ESCALATION = TABLE)
GO
