CREATE PARTITION SCHEME [ComunicacionPS]
	AS PARTITION [pfComunicacion]
	TO ([FG_Comunic2020], [FG_Comunic2021], [FG_Comunic2022], [FG_Comunic2023], [FG_Comunic2024], [FG_Comunic2025], [FG_Comunic2026], [FG_Comunic2027], [FG_Comunic2028], [FG_Comunic2029], [FG_Comunic2030])
GO
