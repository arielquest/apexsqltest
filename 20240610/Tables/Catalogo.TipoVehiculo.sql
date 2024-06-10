SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoVehiculo] (
		[TN_CodTipoVehiculo]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime] NOT NULL,
		[TF_Fin_Vigencia]        [datetime] NULL,
		CONSTRAINT [PK__TipoVehi__C383529EE806E665]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoVehiculo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoVehiculo]
	ADD
	CONSTRAINT [DF_TipoVehiculo_TN_CodTipoVehiculo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoVehiculo]) FOR [TN_CodTipoVehiculo]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que va a contener los Tipos de vehiculo que se van a utlizar en el manejo de objetos, para relacionar los objetos que sean de tipo vehiculo', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVehiculo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el codigo, este codigo se va a generar por secuencia, se va a utilizar como llave primaria', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVehiculo', 'COLUMN', N'TN_CodTipoVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el nombre del tipo de vehiculo', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVehiculo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVehiculo', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la fecha en la cual estara disponible el item', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVehiculo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la fecha fin, la cual tiene como finalidad definir el limite que el item estará habilitado', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVehiculo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoVehiculo] SET (LOCK_ESCALATION = TABLE)
GO
