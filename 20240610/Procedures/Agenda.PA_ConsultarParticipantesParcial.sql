SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana flores>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Obtiene fechas parciales por participante> 
-- Modificación:			<Cambio del nombre del SP>
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarParticipantesParcial] 

@CodigoEvento Uniqueidentifier

As
Begin

	Select		
		P.[TU_CodParticipacion]		AS Codigo, 
		'SplitTipoFuncionario'		As SplitTipoFuncionario, 
		TF.TN_CodTipoFunciOnario	AS Codigo,
		' SplitOficina'             As SplitOficina,
		Oficina.TC_CodOficina		As Codigo,
		'SplitPuestoTrabajo'        As SplitPuestoTrabajo,
		PT.TC_CodPuestoTrabajo		As Codigo,
		'SplitOtros'				AS SplitOTros,
		G.TN_CodTipoPuestoTrabajo			AS CodigoTipoPuesto,
		G.TC_Descripcion					AS DescripcionTipoPuesto		
	From			[AgEnda].[ParticipanteEvento]			As	P   With(Nolock)
	Inner Join      [Catalogo].[PuestoTrabajo]				As  PT  With(Nolock)
	On              PT.TC_CodPuestoTrabajo					=   p.TC_CodPuestoTrabajo 

	Inner Join      [Catalogo].[Oficina]					As  Oficina With(Nolock)
	On              Oficina.[TC_CodOficina]					=   PT.[TC_CodOficina] 
	inner join      Catalogo.EstadoParticipacionEvento		As  E With(Nolock)
	on              P.TN_CodEstadoParticipacion				=   E.TN_CodEstadoParticipacion
	inner join     [Agenda].[FechaParticipanteParcial]		As pp With(Nolock)
	on				P.TU_CodParticipacion					= pp.TU_CodParticipacion
	Inner join		Catalogo.TipoPuestoTrabajo				AS G With(Nolock)
	on				G.TN_CodTipoPuestoTrabajo				= PT.TN_CodTipoPuestoTrabajo
	Inner Join      [Catalogo].[TipoFunciOnario]			As  TF  With(Nolock)
	On              TF.TN_CodTipoFunciOnario				=   G.TN_CodTipoFunciOnario 

	Where	      (P.TU_CodEvento                       = @CodigoEvento)  

End


GO
