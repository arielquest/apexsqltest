SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================  
-- Versión:				<1.0>  
-- Creado por:			<Isaac Dobles Mata>  
-- Fecha de creación:	<13/16/2019>  
-- Descripción :		<Permite consultar los domicilios/medios de comunicacion de un interviniente dentro de un legajo.>   
-- =================================================================================================================================================  
-- Modificación:		<Isaac Dobles Mata><17/09/2019><Se agrega parÿmetro PerteneceExpediente>  
-- Modificación:		<Karol Jim'nez S.><10/03/2021><Se agregan par'ntesis en condición PerteneceExpediente, para evitar resultados incorrectos en la consulta, se tabula SP>
-- Modificación:		<Karol Jim'nez S.><07/06/2021><Se corrije consulta de medios de comunicación de un interviniente en un legajo espec­fico, 
--						dado que estaba tomando medios de comunicación de otro legajo que no era el de consulta, se cambia left por inner join>
-- Modificación:		<Isaac Dobles Mata><30/08/2021> <Cuando se consulta por interviniente y legajo se ignora PerteneceExpediente>  
-- Modificación:		<Luis Alonso Leiva Tames><23/09/2021><Se corregi duplicidad al mostrar medios de comunicacion si se envian los parametros interviniente, legajo>
-- Modificación:		<Luis Alonso Leiva Tames><22/02/2023><Se corregi duplicidad al mostrar medios de comunicacion -por  Datos Migración>
-- Modificación:		<Gabriel Arnaez H.> < PBI Se agrega condiciones al Left Join de Barrio para corregir duplicidad en medio de comunicacion>
-- =================================================================================================================================================  
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteLegajoMedioComunicacion]  
	 @CodigoInterviniente	uniqueidentifier = Null,  
	 @CodigoLegajo			uniqueidentifier = Null  
AS  
BEGIN  
 
	 DECLARE @TempCodigo AS TABLE  
	 (  
	  Codigo UNIQUEIDENTIFIER NOT NULL  
	 );  
  
	 If (@CodigoInterviniente Is Not Null And @CodigoLegajo Is Null)  
	 Begin  
		  Insert Into	@TempCodigo  
		  Select		A.TU_CodMedioComunicacion  
		  From			Expediente.IntervencionMedioComunicacion		As	A With(NoLock)  
		  Inner Join	Expediente.Intervencion							As	B With(NoLock)  
		  On			B.TU_CodInterviniente							=	A.TU_CodInterviniente  
		  Inner Join	Expediente.LegajoIntervencion					As	C With(NoLock)  
		  On			C.TU_CodInterviniente							=	A.TU_CodInterviniente  
		  Inner Join	Expediente.IntervencionMedioComunicacionLegajo	As	D With(NoLock)  
		  On			D.TU_CodMedioComunicacion						=	A.TU_CodMedioComunicacion  
		  And			D.TU_CodLegajo									=	C.TU_CodLegajo  
		  Where			A.TU_CodInterviniente							=	@CodigoInterviniente  
		  AND			(A.TB_PerteneceExpediente						=	0  
			OR			A.TB_PerteneceExpediente						IS	NULL);  
	 End  
	 Else If (@CodigoInterviniente Is Null And @CodigoLegajo Is Not Null)  
	 Begin  
		  Insert Into	@TempCodigo  
		  Select		A.TU_CodMedioComunicacion  
		  From			Expediente.IntervencionMedioComunicacion		As	A With(NoLock)  
		  Inner Join	Expediente.Intervencion							As	B With(NoLock)  
		  On			B.TU_CodInterviniente							=	A.TU_CodInterviniente  
		  Inner Join	Expediente.LegajoIntervencion					As	C With(NoLock)  
		  On			C.TU_CodInterviniente							=	A.TU_CodInterviniente  
		  Left Join		Expediente.IntervencionMedioComunicacionLegajo	As	D With(NoLock)  
		  On			D.TU_CodMedioComunicacion						=	A.TU_CodMedioComunicacion  
		  And			D.TU_CodLegajo									=	C.TU_CodLegajo  
		  Where			C.TU_CodLegajo									=	@CodigoLegajo  
		  AND			(A.TB_PerteneceExpediente						=	0  
			OR			A.TB_PerteneceExpediente						IS	NULL);  
	 End  
	 Else  
	 Begin  
		  Insert Into	@TempCodigo  
		  Select		A.TU_CodMedioComunicacion  
		  From			Expediente.IntervencionMedioComunicacion		As	A With(NoLock)  
		  Inner Join	Expediente.Intervencion							As	B With(NoLock)  
		  On			B.TU_CodInterviniente							=	A.TU_CodInterviniente  
		  Inner Join	Expediente.LegajoIntervencion					As	C With(NoLock)  
		  On			C.TU_CodInterviniente							=	A.TU_CodInterviniente  
		  Inner Join	Expediente.IntervencionMedioComunicacionLegajo	As	D With(NoLock)  
		  On			D.TU_CodMedioComunicacion						=	A.TU_CodMedioComunicacion  
		  And			D.TU_CodLegajo									=	C.TU_CodLegajo  
		  Where			C.TU_CodLegajo									=	@CodigoLegajo  
		  And			A.TU_CodInterviniente							=	@CodigoInterviniente;  
	 End  
  
	 Select		A.TU_CodMedioComunicacion								As CodigoMedio,   
				A.TC_Valor												As Valor,        
				A.TC_Rotulado											As Rotulado,  
				A.TU_CodInterviniente									As CodigoInterviniente,  
				A.TB_PerteneceExpediente								As PerteneceExpediente,  
				'Split'													As Split,  
				H.TN_CodBarrio											As Codigo,      
				H.TC_Descripcion										As Descripcion,  
				'Split'													As Split,  
				B.TN_CodDistrito										As Codigo,     
				B.TC_Descripcion										As Descripcion,  
				'Split'													As Split,  
				C.TN_CodCanton											As Codigo,      
				C.TC_Descripcion										As Descripcion,  
				'Split'													As Split,  
				D.TN_CodProvincia										As Codigo,    
				D.TC_Descripcion										As Descripcion,  
				'Split'													As Split,  
				E.TN_CodMedio											As Codigo,   
				E.TC_Descripcion										As Descripcion,  
				'Split'													As Split,  
				isnull(IM.TN_PrioridadLegajo,A.TN_PrioridadExpediente)  As PrioridadLegajo,  
				E.TC_TipoMedio											As TipoMedio,  
				F.TN_CodHorario											As CodigoHorario,   
				F.TC_Descripcion										As DescripcionHorario,  
				A.TG_UbicacionPunto.Lat									As Latitud,  
				A.TG_UbicacionPunto.Long								As Longitud    
	From		Expediente.IntervencionMedioComunicacion				As	A With(NoLock)  
	Left Join	Expediente.IntervencionMedioComunicacionLegajo			As	IM With(NoLock)  
	On			A.TU_CodMedioComunicacion								=	IM.TU_CodMedioComunicacion  
	Left Join	Catalogo.Distrito										As	B With(NoLock)  
	On			A.TN_CodDistrito										=	B.TN_CodDistrito   
	And			A.TN_CodCanton											=	B.TN_CodCanton  
	And			A.TN_CodProvincia										=	B.TN_CodProvincia  
	Left Join	Catalogo.Canton											As	C With(NoLock)   
	On			A.TN_CodCanton											=	C.TN_CodCanton  
	And			A.TN_CodProvincia										=	C.TN_CodProvincia  
	Left Join	Catalogo.Provincia										As	D With(NoLock)   
	On			A.TN_CodProvincia										=	D.TN_CodProvincia  
	Left Join	Catalogo.Barrio											As	H With(NoLock)   
	On			A.TN_CodBarrio											=	H.TN_CodBarrio 
	And			A.TN_CodProvincia										=	H.TN_CodProvincia
	And			A.TN_CodCanton											=	H.TN_CodCanton
	And			A.TN_CodDistrito										=	H.TN_CodDistrito
	Inner Join	Catalogo.TipoMedioComunicacion							As	E With(NoLock)   
	On			A.TN_CodMedio											=	E.TN_CodMedio  
	Left Join	Catalogo.HorarioMedioComunicacion						As	F With(NoLock)   
	On			A.TN_CodHorario											=	F.TN_CodHorario  
	Inner Join	@TempCodigo												As	G  
	On			G.Codigo												=	A.TU_CodMedioComunicacion  
	where IM.TU_CodLegajo = @CodigoLegajo
END  
GO
