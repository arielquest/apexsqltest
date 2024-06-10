SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Bodega] (
		[TN_CodBodega]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime] NOT NULL,
		[TF_Fin_Vigencia]        [datetime] NULL,
		CONSTRAINT [PK__Bodega__49375C1B52D18D33]
		PRIMARY KEY
		CLUSTERED
		([TN_CodBodega])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Bodega]
	ADD
	CONSTRAINT [DF_Bodega_TN_CodBodega]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaBodega]) FOR [TN_CodBodega]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que va a contener los registros de Bodega que se van a utlizar en el manejo de objetos, para relacionar los objetos que sean de Bodega', 'SCHEMA', N'Catalogo', 'TABLE', N'Bodega', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el codigo, este codigo se va a generar por secuencia, se va a utilizar como llave primaria', 'SCHEMA', N'Catalogo', 'TABLE', N'Bodega', 'COLUMN', N'TN_CodBodega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener la descripción del registro de Bodega', 'SCHEMA', N'Catalogo', 'TABLE', N'Bodega', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado', 'SCHEMA', N'Catalogo', 'TABLE', N'Bodega', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la fecha en la cual estara disponible el item', 'SCHEMA', N'Catalogo', 'TABLE', N'Bodega', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la fecha fin, la cual tiene como finalidad definir el limite que el item estará habilitado', 'SCHEMA', N'Catalogo', 'TABLE', N'Bodega', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Bodega] SET (LOCK_ESCALATION = TABLE)
GO
