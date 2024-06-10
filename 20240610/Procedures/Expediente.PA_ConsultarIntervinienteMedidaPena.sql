SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<25/09/2015>
-- Descripción :			<Permite Consultar las medidas penas de un interviniente imputado 
-- =================================================================================================================================================
-- Modificado:				<01/04/2016> <Gerardo Lopez> <Modificar porque se eliminaron campos numvoto y oficina>
-- Modificado:				<13/04/2016> <Johan Acosta> <Modificar porque ya no existe el alias CodigoMedidaPena se separaron en 2 alias>
-- Modificado:				<25/06/2016> <Gerardo Lopez> <Se agrega nuevo campo para identificar resultado de resolucion por interviniente>
-- Modificado:				<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificado:		        <02/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de TipoMedidaCautelar a TipoMedida>
-- =================================================================================================================================================  
CREATE   PROCEDURE [Expediente].[PA_ConsultarIntervinienteMedidaPena]
 @CodigoInterviniente uniqueidentifier,
 @CodigoMedidaPenaImputado char(1)
    As
 Begin
	SELECT	a.TU_CodMedidaPena			As	CodigoPena,
			a.TU_CodMedidaPena			As	CodigoMedida,
			a.TF_FechaImposicion		As	FechaImposicion,		
			a.TF_Vencimiento			As	FechaVencimiento,
			a.TF_Revocatoria			As	FechaRevocatoria,
			a.TF_Revision				As	FechaRevision,
			a.TB_ControlFirma			As	ControlFirma,			
			a.TF_SituacionLibertad		As	FechaSituacionLibertad,			
			a.TC_Observaciones			As	Observaciones,		
			'SplitSL' AS SplitSL,
			a.TN_CodSituacionLibertad	As	Codigo,
			f.TC_Descripcion			As	Descripcion,							
			'SplitDE' AS SplitDE,
			a.TN_CodDelito				As	Codigo,   
			b.TC_Descripcion			As	Descripcion,		
			'SplitTP' AS SplitTP,
		    a.TN_CodTipoPena			As	CodigoTipoPena,
			c.TC_Descripcion			As	DescripcionTipoPena,
			i.TU_CodResultadoResolucionInterviniente  as 	CodigoResultadoResolucion,
		    i.TU_CodResolucion          as CodigoResolucion, 
			(Select  TC_NumeroResolucion  from Expediente .Resolucion  where TU_CodResolucion = i.TU_CodResolucion) as NumeroResolucion ,
			r.TN_CodResultadoResolucion as CodigoResultado, 
			r.TC_Descripcion             AS DescripcionResultado,	
			'SplitMC' AS SplitMC,
			a.TN_CodTipoMedida			As	Codigo,
			d.TC_Descripcion			As	Descripcion	 		  
  FROM		Expediente.MedidaPena as a WITH (Nolock)
  join				Catalogo.Delito				as b on a.TN_CodDelito=b.TN_CodDelito
  join    Expediente.ResultadoResolucionInterviniente  i on a.TU_CodResultadoResolucionInterviniente = i.TU_CodResultadoResolucionInterviniente  
  JOIN      Catalogo.ResultadoResolucion    As r With(NoLock) on i.TN_CodResultadoResolucion  = r.TN_CodResultadoResolucion 
  left outer join	Catalogo.TipoPena			as c on a.TN_CodTipoPena=c.TN_CodTipoPena
  left outer join   Catalogo.TipoMedida as d on a.TN_CodTipoMedida=d.TN_CodTipoMedida  
  left outer join   Catalogo.SituacionLibertad	as f on a.TN_CodSituacionLibertad	=	f.TN_CodSituacionLibertad
  where a.TU_CodInterviniente=@CodigoInterviniente 
    and a.TC_CodMedidaPena= @CodigoMedidaPenaImputado
End



GO
