SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[SectorLocalizacion] (
		[TN_CodSector]          [smallint] NOT NULL,
		[TN_OrdenPunto]         [smallint] NOT NULL,
		[TG_UbicacionPunto]     [geography] NOT NULL,
		CONSTRAINT [PK_SectorLocalizacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSector], [TN_OrdenPunto])
	ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Comunicacion].[SectorLocalizacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SectorLocalizacion_Sector]
	FOREIGN KEY ([TN_CodSector]) REFERENCES [Comunicacion].[Sector] ([TN_CodSector])
ALTER TABLE [Comunicacion].[SectorLocalizacion]
	CHECK CONSTRAINT [FK_SectorLocalizacion_Sector]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Detalla la ubicación de un sector.', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorLocalizacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sector', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorLocalizacion', 'COLUMN', N'TN_CodSector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden en que se debe mostrar el punto en la interfaz gráfica', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorLocalizacion', 'COLUMN', N'TN_OrdenPunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ubicación geográfica del punto, contiene la latitud y longitud', 'SCHEMA', N'Comunicacion', 'TABLE', N'SectorLocalizacion', 'COLUMN', N'TG_UbicacionPunto'
GO
ALTER TABLE [Comunicacion].[SectorLocalizacion] SET (LOCK_ESCALATION = TABLE)
GO
