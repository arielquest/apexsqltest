SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[JornadaLaboral] (
		[TN_CodJornadaLaboral]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_HoraInicio]            [time](7) NOT NULL,
		[TF_HoraFin]               [time](7) NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		CONSTRAINT [PK_JornadaLaboral]
		PRIMARY KEY
		CLUSTERED
		([TN_CodJornadaLaboral])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[JornadaLaboral]
	ADD
	CONSTRAINT [DF_JornadaLaboral_TN_CodJornadaLaboral]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaJornadaLaboral]) FOR [TN_CodJornadaLaboral]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo para la jornada Laboral', 'SCHEMA', N'Catalogo', 'TABLE', N'JornadaLaboral', 'COLUMN', N'TN_CodJornadaLaboral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la jornada', 'SCHEMA', N'Catalogo', 'TABLE', N'JornadaLaboral', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de inici de la jornada', 'SCHEMA', N'Catalogo', 'TABLE', N'JornadaLaboral', 'COLUMN', N'TF_HoraInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora finalizacion de la jornada', 'SCHEMA', N'Catalogo', 'TABLE', N'JornadaLaboral', 'COLUMN', N'TF_HoraFin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inicio Vigencia de la jornada', 'SCHEMA', N'Catalogo', 'TABLE', N'JornadaLaboral', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fin de vigencia de la jornada', 'SCHEMA', N'Catalogo', 'TABLE', N'JornadaLaboral', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[JornadaLaboral] SET (LOCK_ESCALATION = TABLE)
GO
