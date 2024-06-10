SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Wagner Vargas Sanabria>
-- Fecha de creación:		<14/12/2020>
-- Descripción :			<Permite consultar las historico de fases del expediente> 
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_ConsultarHistoricoExpedienteFase]
@NumeroExpediente			varchar(14),
@CodContexto				varchar(4)
AS  
BEGIN 
 
	SELECT      A.TU_CodExpedienteFase              As CodigoExpedienteFase,
				A.TN_CodFase						As CodigoFase,
				A.TC_NumeroExpediente				As NumeroExpediente,
				A.TC_CodContexto					As CodigoContexto,
				A.TF_Fase							As FechaFase,
				A.TC_UsuarioRed						As Usuario,
				A.TF_Actualizacion					As FechaActualizacion,
				A.TF_Particion						As FechaParticion,	
				B.TC_Descripcion					As DescripcionFase,
				C.TC_Descripcion					As DescripcionContexto,
				E.TN_CodEstado						As CodigoDescripcion,
				E.TC_Descripcion					As DescripcionEstado

				
	            from Historico.ExpedienteFase								As A
				INNER JOIN	Catalogo.Fase								As	B With(NoLock)
				on		B.TN_CodFase					=	A.TN_CodFase
				INNER JOIN	Catalogo.Contexto							As	C With(Nolock)
				on		C.TC_CodContexto				=	A.TC_CodContexto
				INNER JOIN Historico.ExpedienteMovimientoCirculante		As	D With(Nolock)
				on		D.TC_NumeroExpediente			=	A.TC_NumeroExpediente
				AND				D.TF_Fecha									=	(SELECT MAX(TF_Fecha) 
																	 FROM	Historico.ExpedienteMovimientoCirculante
																	 WHERE	TC_NumeroExpediente =@NumeroExpediente
																	 AND	TC_CodContexto = @CodContexto)
				INNER JOIN		Catalogo.Estado								AS	E WITH(NOLOCK)
				ON		E.TN_CodEstado					=	D.TN_CodEstado	
				where A.TC_NumeroExpediente = @NumeroExpediente
				AND	  a.TC_CodContexto= @CodContexto
				order by A.TF_Fase desc

	
END
GO
