SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Kirvin Bennett Mathurin>
-- Fecha de creación:		<17/12/2020>
-- Descripción:				<Obtiene la información sobre eventos asignados a participante externo> 
-- =========================================================================================================

CREATE PROCEDURE [Agenda].[PA_ConsultarEventosParticipanteExterno] 
  @UsuarioExterno		Varchar(30),
  @TipoEvento			smallint,
  @CodigoContexto		Varchar(4)
As
Begin
	DECLARE	  @L_UsuarioExterno Varchar(30) = @UsuarioExterno,   
			  @L_TipoEvento		smallint	= @TipoEvento,  
			  @L_CodigoContexto Varchar(4)	= @CodigoContexto

	SELECT		E.TU_CodEvento			AS	Codigo,
				E.TC_Descripcion		AS	Descripcion,
				'Split'					AS	Split,
				F.TF_FechaInicio		AS	FechaInicio,
				'Split'					AS	Split,
				E.TC_CodContexto		AS	Codigo,
				C.TC_Descripcion		AS	Descripcion,
				'Split'					AS	Split,
				PE.UsuarioExterno		AS	UsuarioExterno,
				PE.NumeroBoleta			AS	NumeroBoleta,
				PE.PlacaVehiculo		AS	PlacaVehiculo,
				PE.AportaFotografias	AS	AportaFotografias	

	FROM		Agenda.Evento				AS	E 
	INNER JOIN	Agenda.FechaEvento			AS	F
	ON			F.TU_CodEvento		=	E.TU_CodEvento
	INNER JOIN	Agenda.ParticipanteExterno	AS	PE
	ON			PE.TU_CodEvento		=	E.TU_CodEvento
	INNER JOIN	Catalogo.Contexto			AS	C
	ON			C.TC_CodContexto	=	E.TC_CodContexto

	WHERE		PE.UsuarioExterno	=	@L_UsuarioExterno
	AND			E.TC_CodContexto	=	COALESCE(@L_CodigoContexto, E.TC_CodContexto)
	AND			E.TN_CodTipoEvento	=	COALESCE(@L_TipoEvento, E.TN_CodTipoEvento)

	ORDER BY	F.TF_FechaInicio	DESC
	
End
GO
