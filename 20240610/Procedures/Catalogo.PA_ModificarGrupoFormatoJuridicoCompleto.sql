SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta Ibañez>
-- Fecha Creación: <16/05/2016>
-- Descripcion:	<Modifica un de grupo de formato jurídico y todos sus subniveles y formatos.>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarGrupoFormatoJuridicoCompleto] 
	@Codigo							smallint, 
	@FechaVencimiento				datetime2
AS
BEGIN
		DECLARE @Tabla_Grupo TABLE
		(
			Id smallint,
			Padre_Id smallint
		)

		DECLARE @Id smallint;


		WITH Grupos(Id, Padre)
		AS
		(
			SELECT TOP 1 D.TN_CodGrupoFormatoJuridico, D.TN_CodGrupoFormatoJuridicoPadre 
			FROM Catalogo.GrupoFormatoJuridico	AS D WITH(NOLOCK)
			WHERE D.TN_CodGrupoFormatoJuridico = @Codigo
			UNION ALL
			SELECT A.TN_CodGrupoFormatoJuridico, A.TN_CodGrupoFormatoJuridicoPadre 
			FROM Catalogo.GrupoFormatoJuridico	AS A WITH(NOLOCK)
			INNER JOIN  Grupos					AS B
			ON A.TN_CodGrupoFormatoJuridicoPadre	=	B.ID
			WHERE A.TN_CodGrupoFormatoJuridico		<>	@Codigo
		)

		Insert Into @Tabla_Grupo (Id, Padre_Id)
		Select Id, Padre From Grupos


		UPDATE	Catalogo.GrupoFormatoJuridico 
		SET		TF_Fin_Vigencia					=	@FechaVencimiento
		WHERE	TN_CodGrupoFormatoJuridico		IN	(Select Id From @Tabla_Grupo)

		UPDATE	Catalogo.FormatoJuridico
		SET		TF_Fin_Vigencia					=	@FechaVencimiento
		WHERE	TN_CodGrupoFormatoJuridico		IN	(Select Id From @Tabla_Grupo)

END






GO
