SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<Obtiene participantes por evento> 
-- Modificacion:            <Se agrega el Funcionario>
-- Fecha de modificación:   <30/06/2016>
-- Modificacion:            <Se corrige segundo apellido>
-- ===========================================================================================
CREATE Procedure [Agenda].[PA_ConsultarParticipantesEvento] 

@CodEvento Uniqueidentifier

As
Begin

	Select			P.[TU_CodParticipaciOn]             As Codigo,						
					'SplitTipoFunciOnario'				As SplitTipoFunciOnario,	
					TF.TN_CodTipoFunciOnario		    As Codigo,	
					TF.[TC_Descripcion]					As Descripcion,
					'SplitOficina'                      As SplitOficina,
					Oficina.[TC_CodOficina]             As Codigo,
					Oficina.[TC_Nombre]					As Descripcion,
					'SplitPuestoTrabajo'                As SplitPuestoTrabajo,
					PT.[TC_CodPuestoTrabajo]            As  Codigo,	
					PT.[TC_Descripcion]					As Descripcion,
					'SplitEstadoParticipacion'          As SplitEstadoParticipacion,
					E.TN_CodEstadoParticipacion         As Codigo,
					E.TF_Inicio_Vigencia				As FechaActivacion,
					E.TF_Fin_Vigencia				    As FechaDesactivacion,
					E.TC_Descripcion                    As Descripcion,                
					'SlplitFuncionario'                 As SlplitFuncionario,
					F.CodigoPlaza                       As CodigoPlaza,
					F.FechaActivacion                   As FechaActivacion,
					F.FechaDesactivacion                As FechaDesactivacion,
					F.Nombre                            As Nombre,
					F.PrimerApellido                    As PrimerApellido, 
					F.SegundoApellido                   As SegundoApellido,
					F.UsuarioRed                        As UsuarioRed,
					'SplitOtros'						As SplitOTros,
					G.TN_CodTipoPuestoTrabajo			AS CodigoTipoPuesto,
					G.TC_Descripcion					AS DescripcionTipoPuesto
										
	From			[AgEnda].[ParticipanteEvento]	    As	P  With(Nolock)
	Inner Join      [Catalogo].[PuestoTrabajo]          As PT  With(Nolock)
	On              PT.TC_CodPuestoTrabajo              =  p.TC_CodPuestoTrabajo 
	Inner Join      [Catalogo].[Oficina]                As Oficina With(Nolock)
	On              Oficina.[TC_CodOficina]             =   PT.[TC_CodOficina] 
	inner join      Catalogo.EstadoParticipacionEvento  as  E With(Nolock)
	on              P.TN_CodEstadoParticipacion         =  E.TN_CodEstadoParticipacion
	Inner join		Catalogo.TipoPuestoTrabajo			AS G With(Nolock)
	on				G.TN_CodTipoPuestoTrabajo			= PT.TN_CodTipoPuestoTrabajo
	inner join		Catalogo.TipoFuncionario			AS TF
	on				TF.TN_CodTipoFuncionario			= G.TN_CodTipoFuncionario
	OUTER APPLY     Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(P.TC_CodPuestoTrabajo) F	
	Where			(p.TU_CodEvento                = @CodEvento)
	
End
GO
