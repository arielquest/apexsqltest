SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[PerimetroLocalizacion] (
		[TN_CodPerimetro]       [smallint] NOT NULL,
		[TN_OrdenPunto]         [smallint] NOT NULL,
		[TG_UbicacionPunto]     [geography] NOT NULL,
		CONSTRAINT [PK_PerimetroLocalizacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPerimetro], [TN_OrdenPunto])
	ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Comunicacion].[PerimetroLocalizacion]
	WITH CHECK
	ADD CONSTRAINT [FK_PerimetroLocalizacion_Perimetro]
	FOREIGN KEY ([TN_CodPerimetro]) REFERENCES [Comunicacion].[Perimetro] ([TN_CodPerimetro])
ALTER TABLE [Comunicacion].[PerimetroLocalizacion]
	CHECK CONSTRAINT [FK_PerimetroLocalizacion_Perimetro]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Detalla la ubicación de un perímetro.', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroLocalizacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del perímetro', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroLocalizacion', 'COLUMN', N'TN_CodPerimetro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden en que se debe mostrar el punto en la interfaz gráfica', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroLocalizacion', 'COLUMN', N'TN_OrdenPunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ubicación geográfica del punto', 'SCHEMA', N'Comunicacion', 'TABLE', N'PerimetroLocalizacion', 'COLUMN', N'TG_UbicacionPunto'
GO
ALTER TABLE [Comunicacion].[PerimetroLocalizacion] SET (LOCK_ESCALATION = TABLE)
GO
