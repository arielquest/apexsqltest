SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ControlRondasReparto] (
		[TU_CodRonda]               [uniqueidentifier] NOT NULL,
		[TU_CodCriterioReparto]     [uniqueidentifier] NOT NULL,
		[TU_CodEquipo]              [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Prioridad]              [smallint] NOT NULL,
		[TF_Fecha]                  [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		[TN_NumeroRonda]            [int] NOT NULL,
		CONSTRAINT [PK_ControlRondasReparto]
		PRIMARY KEY
		CLUSTERED
		([TU_CodRonda])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[ControlRondasReparto]
	ADD
	CONSTRAINT [DF_ControlRondasReparto_TN_NumeroRonda]
	DEFAULT ((0)) FOR [TN_NumeroRonda]
GO
ALTER TABLE [Catalogo].[ControlRondasReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_ControlRondasReparto_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[ControlRondasReparto]
	CHECK CONSTRAINT [FK_ControlRondasReparto_PuestoTrabajo]

GO
ALTER TABLE [Catalogo].[ControlRondasReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Ronda_Criterio]
	FOREIGN KEY ([TU_CodCriterioReparto]) REFERENCES [Catalogo].[CriteriosReparto] ([TU_CodCriterio])
ALTER TABLE [Catalogo].[ControlRondasReparto]
	CHECK CONSTRAINT [FK_Ronda_Criterio]

GO
ALTER TABLE [Catalogo].[ControlRondasReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Ronda_Equipo]
	FOREIGN KEY ([TU_CodEquipo]) REFERENCES [Catalogo].[EquiposReparto] ([TU_CodEquipo])
ALTER TABLE [Catalogo].[ControlRondasReparto]
	CHECK CONSTRAINT [FK_Ronda_Equipo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Lleva el control de las rondas de reparto,la prioridad de los miembros que cambia en las rondas.', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TU_CodRonda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Llave del criterio de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TU_CodCriterioReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Llave del equipo de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TU_CodEquipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puesto de trábajo secundario', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden de asignación de demandas', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TN_Prioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del cambio de ronda', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha para particionamiento', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cuenta las rondas que se ha reiniciado', 'SCHEMA', N'Catalogo', 'TABLE', N'ControlRondasReparto', 'COLUMN', N'TN_NumeroRonda'
GO
ALTER TABLE [Catalogo].[ControlRondasReparto] SET (LOCK_ESCALATION = TABLE)
GO
