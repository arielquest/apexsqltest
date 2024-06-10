SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MiembrosPorConjuntoReparto] (
		[TU_CodMiembroReparto]     [uniqueidentifier] NOT NULL,
		[TU_CodConjutoReparto]     [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]      [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Prioridad]             [smallint] NOT NULL,
		[TN_Limite]                [smallint] NOT NULL,
		[TN_CodUbicacion]          [int] NOT NULL,
		[TF_FechaCreacion]         [datetime2](7) NOT NULL,
		[TF_FechaParticion]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_miembro]
		PRIMARY KEY
		CLUSTERED
		([TU_CodMiembroReparto])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_miembro_conjunto]
	FOREIGN KEY ([TU_CodConjutoReparto]) REFERENCES [Catalogo].[ConjuntosReparto] ([TU_CodConjutoReparto])
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto]
	CHECK CONSTRAINT [FK_miembro_conjunto]

GO
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_miembro_puesto]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto]
	CHECK CONSTRAINT [FK_miembro_puesto]

GO
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_miembro_ubicacion]
	FOREIGN KEY ([TN_CodUbicacion]) REFERENCES [Catalogo].[Ubicacion] ([TN_CodUbicacion])
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto]
	CHECK CONSTRAINT [FK_miembro_ubicacion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los miembros por conjuno de reparto para un despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del miembro del conjunto de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TU_CodMiembroReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del conjunto de reparto al que pertenece el miembro', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TU_CodConjutoReparto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo para el miembro del conjunto de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad de reparto del miembro', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TN_Prioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Límite de expedientes a asignar en una ronda al miembro', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TN_Limite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ubicación  a asignar al expediente cuando se le asigna el miembro por reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TN_CodUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del miembro', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha para la partición de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'MiembrosPorConjuntoReparto', 'COLUMN', N'TF_FechaParticion'
GO
ALTER TABLE [Catalogo].[MiembrosPorConjuntoReparto] SET (LOCK_ESCALATION = TABLE)
GO
