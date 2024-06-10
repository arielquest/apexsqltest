SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<21-04-2023>
-- Descripción :			<Permite consultar registros de Comunicacion.Sector que tienen barrio indicado en la consulta>  
-- Modificación:			<05/05/2023> <Glopezr> <HU - 311406: Se permite filtrar sin oficina de ocj  > 
-- ===============================================================================================================================================================================================================  

  CREATE     PROCEDURE [Comunicacion].[PA_ConsultarSectoresDeBarrio]  
    @CodOficinaOCJ  varchar(4)=null,
	@CodBarrio		smallint,
	@CodDistrito    smallint,
	@CodCanton		smallint,
	@CodProvincia	smallint
 As
 Begin
 
 
		Select		A.TN_CodSector			As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					A.TB_UtilizaAppMovil    AS UtilizaAppMovil,
					'Split'					As Split,
					B.TC_CodOficina			As Codigo,
					B.TC_Nombre				As Descripcion
		From		Comunicacion.Sector		A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		Inner Join  Comunicacion.SectorBarrio  As	C With(Nolock) 		
		On			C.TN_CodSector			= A.TN_CodSector		 
		And			C.TN_CodBarrio			=  @CodBarrio 
		And			C.TN_CodDistrito		=  @CodDistrito 
		And			C.TN_CodCanton			=  @CodCanton 
		And			C.TN_CodProvincia		=  @CodProvincia 
		Where		A.TF_Inicio_Vigencia	< GETDATE ()
		And			(A.TF_Fin_Vigencia		Is Null Or A.TF_Fin_Vigencia >= GETDATE())
		And			A.TC_CodOficinaOCJ		= Coalesce( @CodOficinaOCJ, A.TC_CodOficinaOCJ) 
	 
		Order By	A.TC_Descripcion;
  
			
 End
GO
