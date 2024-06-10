CREATE PARTITION SCHEME [AgendaPS]
	AS PARTITION [pfAgenda]
	TO ([FG_Agenda2020], [FG_Agenda2021], [FG_Agenda2022], [FG_Agenda2023], [FG_Agenda2024], [FG_Agenda2025], [FG_Agenda2026], [FG_Agenda2027], [FG_Agenda2028], [FG_Agenda2029], [FG_Agenda2030])
GO
