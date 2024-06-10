SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<04/09/2015>
-- Descripción :			<Permite Consultar el ultimo estado de un expediente en una oficina 
-- Modificación:			<Johan Acosta>
-- Fecha Modificación:		<18/09/2015>
-- Descripcion:				<Indentación compelta del SP>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

  
CREATE PROCEDURE [Historico].[PA_ConsultarUltimoEstado]
	@CodLegajo		Uniqueidentifier,
	@CodOficina		Varchar(4)
 As
 Begin

	SELECT      TOP (1) Catalogo.Estado.TN_CodEstado   AS Codigo,           Catalogo.Estado.TC_Descripcion          AS Descripcion, 
	            Catalogo.Estado.TF_Inicio_Vigencia     AS FechaActivacion,  Catalogo.Estado.TF_Fin_Vigencia         AS FechaDesactivacion, 
				'Split'                                AS Split,            Catalogo.TipoEstado.TN_CodTipoEstado    AS Codigo, 
				Catalogo.TipoEstado.TC_Descripcion     AS Descripcion,      Catalogo.TipoEstado.TF_Inicio_Vigencia  AS FechaActivacion, 
				Catalogo.TipoEstado.TF_Fin_Vigencia    AS FechaDesactivacion
    FROM        Historico.ExpedienteEstado             AS A WITH (Nolock) INNER JOIN
                Catalogo.Estado                        ON A.TN_CodEstado = Catalogo.Estado.TN_CodEstado INNER JOIN
                Catalogo.TipoEstado                    ON Catalogo.Estado.TN_CodTipoEstado = Catalogo.TipoEstado.TN_CodTipoEstado
	WHERE       (A.TU_CodLegajo = @CodLegajo)          AND (A.TC_CodOficina = @CodOficina)
	ORDER BY A.TF_Sistema DESC
 
 End





GO
