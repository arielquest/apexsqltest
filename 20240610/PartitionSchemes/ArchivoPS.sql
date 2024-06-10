CREATE PARTITION SCHEME [ArchivoPS]
	AS PARTITION [pfArchivo]
	TO ([FG_Archivo2020], [FG_Archivo2021], [FG_Archivo2022], [FG_Archivo2023], [FG_Archivo2024], [FG_Archivo2025], [FG_Archivo2026], [FG_Archivo2027], [FG_Archivo2028], [FG_Archivo2029], [FG_Archivo2030])
GO
