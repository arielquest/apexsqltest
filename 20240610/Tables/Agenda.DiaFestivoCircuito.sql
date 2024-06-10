SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Agenda].[DiaFestivoCircuito] (
		[TF_FechaFestivo]        [datetime2](7) NOT NULL,
		[TN_CodCircuito]         [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DiaFestivoCircuito]
		PRIMARY KEY
		CLUSTERED
		([TF_FechaFestivo], [TN_CodCircuito])
	ON [FG_Agenda]
) ON [FG_Agenda]
GO
ALTER TABLE [Agenda].[DiaFestivoCircuito]
	ADD
	CONSTRAINT [DF_DiaFestivoCircuito_TF_Inicio_Vigencia]
	DEFAULT (getdate()) FOR [TF_Inicio_Vigencia]
GO
ALTER TABLE [Agenda].[DiaFestivoCircuito]
	WITH CHECK
	ADD CONSTRAINT [FK_DiaFestivoCircuito_Circuito]
	FOREIGN KEY ([TN_CodCircuito]) REFERENCES [Catalogo].[Circuito] ([TN_CodCircuito])
ALTER TABLE [Agenda].[DiaFestivoCircuito]
	CHECK CONSTRAINT [FK_DiaFestivoCircuito_Circuito]

GO
ALTER TABLE [Agenda].[DiaFestivoCircuito]
	WITH CHECK
	ADD CONSTRAINT [FK_DiaFestivoCircuito_DiaFestivo]
	FOREIGN KEY ([TF_FechaFestivo]) REFERENCES [Agenda].[DiaFestivo] ([TF_FechaFestivo])
ALTER TABLE [Agenda].[DiaFestivoCircuito]
	CHECK CONSTRAINT [FK_DiaFestivoCircuito_DiaFestivo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla Intermedia para relacionar los días festivos con los distintos circuitos', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivoCircuito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se celebra el día festivo.', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivoCircuito', 'COLUMN', N'TF_FechaFestivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del circuito.', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivoCircuito', 'COLUMN', N'TN_CodCircuito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivoCircuito', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Agenda].[DiaFestivoCircuito] SET (LOCK_ESCALATION = TABLE)
GO
