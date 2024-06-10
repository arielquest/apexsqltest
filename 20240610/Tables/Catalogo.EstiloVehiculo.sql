SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstiloVehiculo] (
		[TN_CodEstiloVehiculo]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime] NOT NULL,
		[TF_Fin_Vigencia]          [datetime] NULL,
		CONSTRAINT [PK__EstiloVe__3C6C6620869BDEB9]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstiloVehiculo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstiloVehiculo]
	ADD
	CONSTRAINT [DF_EstiloVehiculo_TN_CodEstiloVehiculo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstiloVehiculo]) FOR [TN_CodEstiloVehiculo]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que va a contener los estilos de vehiculo que se van a utlizar en el manejo de objetos, para relacionar los objetos que sean de estilo vehiculo', 'SCHEMA', N'Catalogo', 'TABLE', N'EstiloVehiculo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el codigo, este codigo se va a generar por secuencia, se va a utilizar como llave primaria', 'SCHEMA', N'Catalogo', 'TABLE', N'EstiloVehiculo', 'COLUMN', N'TN_CodEstiloVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener la descripción del estilo de vehiculo', 'SCHEMA', N'Catalogo', 'TABLE', N'EstiloVehiculo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado', 'SCHEMA', N'Catalogo', 'TABLE', N'EstiloVehiculo', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la fecha en la cual estara disponible el item', 'SCHEMA', N'Catalogo', 'TABLE', N'EstiloVehiculo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la fecha fin, la cual tiene como finalidad definir el limite que el item estará habilitado', 'SCHEMA', N'Catalogo', 'TABLE', N'EstiloVehiculo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstiloVehiculo] SET (LOCK_ESCALATION = TABLE)
GO
