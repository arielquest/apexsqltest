CREATE TYPE [Comunicacion].[SectorBarriosType]
AS TABLE (
		[Provincia]     [smallint] NOT NULL,
		[Canton]        [smallint] NOT NULL,
		[Distrito]      [smallint] NOT NULL,
		[Barrio]        [smallint] NOT NULL
)
GO
