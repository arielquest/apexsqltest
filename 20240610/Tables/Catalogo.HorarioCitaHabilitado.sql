SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[HorarioCitaHabilitado] (
		[TU_CodHorario]           [uniqueidentifier] NOT NULL,
		[TU_CodConfiguracion]     [uniqueidentifier] NOT NULL,
		[TF_HoraInicio]           [time](7) NOT NULL,
		[TB_Lunes]                [bit] NOT NULL,
		[TB_Martes]               [bit] NOT NULL,
		[TB_Miercoles]            [bit] NOT NULL,
		[TB_Jueves]               [bit] NOT NULL,
		[TB_Viernes]              [bit] NOT NULL,
		[TB_Sabado]               [bit] NOT NULL,
		[TB_Domingo]              [bit] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Catalogo_HorarioCitaHabilitado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodHorario])
	ON [FG_SIAGPJ]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[HorarioCitaHabilitado]
	WITH CHECK
	ADD CONSTRAINT [FK_HorarioCitaHabilitado_ConfiguracionCita]
	FOREIGN KEY ([TU_CodConfiguracion]) REFERENCES [Catalogo].[ConfiguracionCita] ([TU_CodConfiguracion])
ALTER TABLE [Catalogo].[HorarioCitaHabilitado]
	CHECK CONSTRAINT [FK_HorarioCitaHabilitado_ConfiguracionCita]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Indentificador de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TU_CodHorario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Referencia al código de configuración de la tabla Catalogo.configuracionCita', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TU_CodConfiguracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora que se deshabilita para la atención de citas', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TF_HoraInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día lunes se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Lunes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día martes se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Martes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día miercoles se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Miercoles'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día jueves se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Jueves'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día viernes se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Viernes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día sabado se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Sabado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica sí para el día domingo se habilita el horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TB_Domingo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la fecha de registro para particionar', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioCitaHabilitado', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Catalogo].[HorarioCitaHabilitado] SET (LOCK_ESCALATION = TABLE)
GO
