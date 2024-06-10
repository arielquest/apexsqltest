CREATE PARTITION SCHEME [HistoricoPS]
	AS PARTITION [pfHistorico]
	TO ([FG_Histo2020], [FG_Histo2021], [FG_Histo2022], [FG_Histo2023], [FG_Histo2024], [FG_Histo2025], [FG_Histo2026], [FG_Histo2027], [FG_Histo2028], [FG_Histo2029], [FG_Histo2030])
GO
