SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite consultar cierres estadisticos para una oficina.> 
-- =================================================================================================================================================
-- Modificacion				<Jonathan Aguilar Navarro> <14/05/2019> <Se cambia el parametro CodOficina por CodContexto> 
CREATE PROCEDURE [Sistema].[PA_ConsultarCierreEstadistico]
	@CodContexto Varchar(4),
	@Mes smallint=0,
	@Anno smallint= 0
 
 As
 Begin
	
		--Todos los cierres  existentes
	If	  	@CodContexto Is null And @Mes = 0 And @Anno = 0
	Begin	
			Select		A.TN_Mes	As	Mes,				A.TN_Anno		As	Annio, 
						'Split'		as Split,				A.TC_CodOficina	As Codigo,	
						B.TC_Nombre As	Nombre
			From		Sistema.CierreEstadistico	A
			Inner Join	Catalogo.Oficina			B
				On		A.TC_CodOficina				= B.TC_CodOficina 

	End

	--Todos los cierres de una oficina
	If	  	@CodContexto Is Not null And @Mes = 0 And @Anno = 0
	Begin	
			Select		A.TN_Mes	As	Mes,A.TF_Fecha_Cierre as FechaCierre, A.TN_Anno		As	Annio, 
						'Split'		as Split,				A.TC_CodOficina	As Codigo,	
						B.TC_Nombre As	Nombre
			From		Sistema.CierreEstadistico	A
			Inner Join	Catalogo.Oficina			B
				On		A.TC_CodOficina				= B.TC_CodOficina
			Where   A.TC_CodOficina = @CodContexto 

	End
	
	--Todos los cierres de una oficina en una periodo.
	Else IF	@CodContexto Is Not Null And @Anno > 0 And @Mes = 0 
	Begin
			Select		A.TN_Mes	As	Mes,A.TF_Fecha_Cierre as FechaCierre,A.TN_Anno		As	Annio, 
						'Split'		as Split,				A.TC_CodOficina	As Codigo,	
						B.TC_Nombre As	Nombre	
			From		Sistema.CierreEstadistico	A
			Inner Join	Catalogo.Oficina			B
				On		A.TC_CodOficina				= B.TC_CodOficina
			Where		A.TC_CodOficina         	=	@CodContexto 
			 and        A.TN_Anno                   = @Anno 
	End	
	
	--Cierre de una oficina en mes y periodo
	Else If @CodContexto Is Not Null  And @Anno > 0 And @Mes > 0
	Begin
			Select		A.TN_Mes	As	Mes,A.TF_Fecha_Cierre as FechaCierre,A.TN_Anno		As	Annio, 
						'Split'		as Split,				A.TC_CodOficina	As Codigo,	
						B.TC_Nombre As	Nombre	
			From		Sistema.CierreEstadistico	A
			Inner Join	Catalogo.Oficina			B
				On		A.TC_CodOficina				=	B.TC_CodOficina
			Where		A.TC_CodOficina				=	@CodContexto
			And			A.TN_Mes					=	@Mes
			  and       A.TN_Anno                   =   @Anno 
	End
 End

GO
