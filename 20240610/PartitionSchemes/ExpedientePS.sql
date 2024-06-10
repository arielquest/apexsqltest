CREATE PARTITION SCHEME [ExpedientePS]
	AS PARTITION [pfExpediente]
	TO ([FG_Exped2020], [FG_Exped2021], [FG_Exped2022], [FG_Exped2023], [FG_Exped2024], [FG_Exped2025], [FG_Exped2026], [FG_Exped2027], [FG_Exped2028], [FG_Exped2029], [FG_Exped2030])
GO
