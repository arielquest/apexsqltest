SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Sigma].[Sp_CREA_DSIGMA]
@FechaInicio datetime,
@FechaFinal datetime,
@ContextoCargaActual VARCHAR(MAX)
as
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
         Declare @SQLTEXT varchar (8000), @FInicio varchar (10),@FFinal varchar (10),@Contexto varchar(MAX)

         TRUNCATE TABLE Sigma.DSIGMA
         TRUNCATE TABLE Sigma.DSIGMA_LISTADO
         TRUNCATE TABLE Sigma.DSIGMA_CARGA
         TRUNCATE TABLE Sigma.DSIGMA_CF_ANTERIOR
        
        PRINT('>> Print 1')
        SET @FInicio = /*@FechaInicio*/ CONVERT(VARCHAR(10),@FechaInicio,102)
        SET @FFinal  = /*@FechaFinal*/ CONVERT(VARCHAR(10),@FechaFinal,102)
        SET @Contexto = @ContextoCargaActual
        PRINT('>> ' + @FInicio)
        PRINT('>> ' + @FFinal)
        PRINT('>> Print 2')

--SET @Contexto = '0318'--?
--SET @FInicio  = '2023/12/01'--?
--SET  @FFinal = '2024/01/01'--?

/*Circulantes*/

Insert into Sigma.Dsigma
/*EXTRAE EL CIRCULANTE DE LOS EXPEDIENTES*/

SELECT DISTINCT
HistExp.IDFEP,
HistExp.CARPETA,
HistExp.NUE,
HistExp.CODDEJ,
HistExp.CODASU,
HistExp.CODCLAS,  
HistExp.CODJURIS,
HistExp.CODTIDEJ,
HistExp.FECHA,
HistExp.FINEST,
HistExp.CODESTASU_TER,
CODESTASU_ACT,
HistExp.FECININUE,
HistExp.FECENT,
HistExp.FECTER,
HistExp.FECREENT,
HistExp.BALANCE_CF,
HistExp.BALANCE_CI,
HistExp.CODJUTRA,
HistExp.CODJUDEC,
HistExp.SUBEST,
HistExp.CODFAS,
CODESTASU_ACT.TF_Fecha as CODESTASU_ACT_FECHA
FROM
(
SELECT DISTINCT 
   	HistExp.TN_CodExpedienteMovimientoCirculante				AS IDFEP,
   	Convert(Varchar(36),Expe.TC_NumeroExpediente)				AS CARPETA,
	HistExp.TC_NumeroExpediente									AS NUE,
	HistExp.TC_CodContexto										AS CODDEJ,
	CONVERT (VARCHAR (3),'PRI')									AS CODASU,
	CONVERT (VARCHAR (9),ISNULL(ExpeDetall.TN_CodClASe,'-1'))	AS CODCLAS,  
	CONVERT (VARCHAR (2),CatCont.TC_CodMateria)					AS CODJURIS,
	CONVERT (VARCHAR (2),CatOfi.TN_CodTipoOficina)				AS CODTIDEJ,
	HistExp.TF_Fecha											AS FECHA,
	HistExp.TC_Movimiento										AS FINEST,
	NULL														AS CODESTASU_TER,
--	HistExp.TN_CodEstado										AS CODESTASU_ACT,

	Expe.TF_Inicio												AS FECININUE,
	CASe HistExp.TC_Movimiento 
	When 'E' Then HistExp.TF_Fecha 
	END															AS FECENT,
	CONVERT(DATETIME,NULL,103)									AS FECTER,
	CONVERT(DATETIME,NULL,103)									AS FECREENT,
	'CF'														AS BALANCE_CF,
	CONVERT (VARCHAR (2),NULL)									AS BALANCE_CI,
	CASE 
	WHEN 
	CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 														AS CODJUTRA,
	CASE 
	WHEN 
	CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 														AS CODJUDEC,
	NULL														AS SUBEST,
	CONVERT (VARCHAR (6),ExpeDetall.TN_CodFASe)					AS CODFAS,
	HistExp.TF_Fecha											AS CODESTASU_ACT_FECHA
From Expediente.Expediente Expe WITH(NOLOCK)
	
	INNER JOIN Historico.ExpedienteMovimientoCirculante HistExp  WITH(NOLOCK) ON (HistExp.TC_NumeroExpediente = Expe.TC_NumeroExpediente 
					 AND HistExp.TC_Movimiento <>'F'
					 AND HistExp.TN_CodExpedienteMovimientoCirculante=
					 			(SELECT MAX(HistExp1.TN_CodExpedienteMovimientoCirculante) FROM Historico.ExpedienteMovimientoCirculante HistExp1 WITH(NOLOCK)
					 					WHERE HistExp1.TC_NumeroExpediente=HistExp.TC_NumeroExpediente 
					 					AND HistExp1.TC_CodContexto=HistExp.TC_CodContexto
					 					AND HistExp1.TC_Movimiento IS NOT NULL
					 					AND HistExp1.TF_FECHA =
										(SELECT MAX (HistExp2.TF_Fecha) 
												FROM Historico.ExpedienteMovimientoCirculante HistExp2  WITH(NOLOCK) 
												WHERE HistExp2.TC_NumeroExpediente		=	HistExp1.TC_NumeroExpediente
												AND HistExp2.TC_CodContexto				=	HistExp1.TC_CodContexto
												AND HistExp2.TC_Movimiento 				IS NOT NULL
												AND HistExp2.TF_Fecha 					< 	Convert(DateTime,@FFinal,102)
												--AND HistExp2.TF_Fecha < @FechaFinal
												
										)
								))		
								
   	INNER JOIN Expediente.ExpedienteDetalle 	ExpeDetall  WITH(NOLOCK) ON (ExpeDetall.TC_NumeroExpediente 	= 	HistExp.TC_NumeroExpediente)
   	   																			AND ExpeDetall.TC_CodContexto	=	HistExp.TC_CodContexto
	INNER JOIN Catalogo.ClASeASunto 			CatClASASu  WITH(NOLOCK) ON (CatClASASu.TN_CodClASeASunto 		= 	ExpeDetall.TN_CodClASe)
	INNER JOIN Catalogo.Contexto 				CatCont  	WITH(NOLOCK) ON (CatCont.TC_CodContexto 			= 	HistExp.TC_CodContexto)
	LEFT JOIN Catalogo.Oficina 					CatOfi  	WITH(NOLOCK) ON (CatOfi.TC_CodOficina 				= 	CatCont.TC_CodOficina)
	LEFT Join Catalogo.PuestoTrabajoFuncionario CatPTFunc   WITH(NOLOCK) ON CatPTFunc.TU_CodPuestoFuncionario 	= 	HistExp.TU_CodPuestoFuncionario
	LEFT Join Catalogo.PuestoTrabajo 			CatPT 		WITH(NOLOCK) ON CatPT.TC_CodPuestoTrabajo 			= 	CatPTFunc.TC_CodPuestoTrabajo
	LEFT JOIN Catalogo.TipoPuestoTrabajo 		CatPT_JD 	WITH(NOLOCK) ON CatPT_JD.TN_CodTipoPuestoTrabajo	=	CatPT.TN_CodTipoPuestoTrabajo 
																AND CatPT_JD.TN_CodTipoFuncionario				=	CatPT.TN_CodTipoFuncionario 
																AND CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	LEFT JOIN Catalogo.TipoPuestoTrabajo 		CatPT_JT 	WITH(NOLOCK) ON CatPT_JT.TN_CodTipoPuestoTrabajo	=	CatPT.TN_CodTipoPuestoTrabajo 
																AND CatPT_JT.TN_CodTipoFuncionario				=	CatPT.TN_CodTipoFuncionario 
																AND CatPT_JT.TC_Descripcion LIKE '%Tramitador%'	
Where  --HistExp.TC_NumeroExpediente= '230047560494TR' and
(HistExp.Tc_CodContexto IN (SELECT * from string_split(@contexto ,CHAR(44))) OR @Contexto = '-1') AND
	   HistExp.Tc_CodContexto <> '0000'
)AS HistExp
CROSS APPLY
	(
		SELECT	TOP 1 HistExp1.TN_CodEstado	AS CODESTASU_ACT, TF_Fecha
		FROM Historico.ExpedienteMovimientoCirculante HistExp1  WITH (NOLOCK) 
		WHERE 
		HistExp1.TC_NumeroExpediente = HistExp.CARPETA
		AND HistExp1.TC_CodContexto = HistExp.CODDEJ 
		AND HistExp1.TF_Fecha < Convert(DateTime,@FFinal,102)
		--AND HistExp1.TC_Movimiento <>'F'
		--AND HistExp1.TN_CodEstado IS NOT NULL
		ORDER BY HistExp1.TF_Fecha DESC			         	
	) AS CODESTASU_ACT


UNION

/*EXTRAE EL CIRCULANTE DE LOS LEGAJOS*/
SELECT DISTINCT
HistLeg.IDFEP,
HistLeg.CARPETA,
HistLeg.NUE,
HistLeg.CODDEJ,
HistLeg.CODASU,
HistLeg.CODCLAS,  
HistLeg.CODJURIS,
HistLeg.CODTIDEJ,
HistLeg.FECHA,
HistLeg.FINEST,
HistLeg.CODESTASU_TER,
CODESTASU_ACT,
HistLeg.FECININUE,
HistLeg.FECENT,
HistLeg.FECTER,
HistLeg.FECREENT,
HistLeg.BALANCE_CF,
HistLeg.BALANCE_CI,
HistLeg.CODJUTRA,
HistLeg.CODJUDEC,
HistLeg.SUBEST,
HistLeg.CODFAS,
CODESTASU_ACT.TF_Fecha as CODESTASU_ACT_FECHA
FROM
(
SELECT DISTINCT
	HistLeg.TN_CodLegajoMovimientoCirculante						AS IDFEP,
	Convert(Varchar(36),Leg.TU_CodLegajo)							AS CARPETA,
	HistLeg.TC_NumeroExpediente										AS NUE,
	HistLeg.TC_CodContexto											AS CODDEJ,
	CONVERT (VARCHAR (3),ISNULL(LegDetall.TN_CodASunto,'-1'))		AS CODASU,
	CONVERT (VARCHAR (9),ISNULL(LegDetall.TN_CodClASeASunto,'-1'))	AS CODCLAS, 
	CONVERT (VARCHAR (2),CatCont.TC_CodMateria)						AS CODJURIS,
	CONVERT (VARCHAR (2),CatOfi.TN_CodTipoOficina)					AS CODTIDEJ,
	HistLeg.TF_Fecha												AS FECHA,
	HistLeg.TC_Movimiento											AS FINEST,
	NULL															AS CODESTASU_TER,
--	HistLeg.TN_CodEstado											AS CODESTASU_ACT,
	Leg.TF_Inicio													AS FECININUE,
	CASe HistLeg.TC_Movimiento 
	When 'E' Then HistLeg.TF_Fecha 
	END																AS FECENT,
	NULL 															AS FECTER,
	NULL															AS FECREENT,
	'CF'															AS BALANCE_CF,
	CONVERT (VARCHAR (2),NULL)										AS BALANCE_CI,
	CASE 
	WHEN 
	CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 															AS CODJUTRA,
	CASE 
	WHEN 
	CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 															AS CODJUDEC,
	Null															AS SUBEST,
	CONVERT (VARCHAR (6),NULL)										AS CODFAS,
	HistLeg.TF_Fecha												AS CODESTASU_ACT_FECHA
FROM 
Historico.LegajoMovimientoCirculante 	HistLeg WITH(NOLOCK)

	INNER JOIN Expediente.Legajo 		Leg  	WITH(NOLOCK) ON (HistLeg.TC_NumeroExpediente = Leg.TC_NumeroExpediente 
					AND HistLeg.TU_CodLegajo	=	Leg.TU_CodLegajo
					 AND HistLeg.TC_Movimiento 	<>	'F'
					 AND HistLeg.TN_CodLegajoMovimientoCirculante=
					 			(SELECT MAX(HistLeg1.TN_CodLegajoMovimientoCirculante) FROM Historico.LegajoMovimientoCirculante HistLeg1 WITH(NOLOCK)
					 					WHERE HistLeg1.TC_NumeroExpediente	=	HistLeg.TC_NumeroExpediente 
					 					AND HistLeg1.TU_CodLegajo			=	HistLeg.TU_CodLegajo
					 					AND HistLeg1.TC_CodContexto			=	HistLeg.TC_CodContexto
					 					AND HistLeg1.TC_Movimiento IS NOT NULL
					 					AND HistLeg1.TF_FECHA =
										(SELECT MAX (HistLeg2.TF_Fecha) 
												FROM Historico.LegajoMovimientoCirculante HistLeg2  WITH(NOLOCK) 
												WHERE HistLeg2.TC_NumeroExpediente	=	HistLeg1.TC_NumeroExpediente
												AND HistLeg2.TU_CodLegajo			=	HistLeg1.TU_CodLegajo
												AND HistLeg2.TC_CodContexto			=	HistLeg1.TC_CodContexto
												AND HistLeg2.TC_Movimiento 			IS NOT NULL
												AND HistLeg2.TF_Fecha 				< 	Convert(DateTime,@FFinal,102)--mm/dd/aaaa
												--AND HistLeg2.TF_Fecha < @FechaFinal
												
										)
								))	


	INNER JOIN Expediente.LegajoDetalle 		LegDetall 	WITH(NOLOCK) ON (LegDetall.TU_CodLegajo 			= Leg.TU_CodLegajo)
	   																			AND LegDetall.TC_CodContexto	= HistLeg.TC_CodContexto
	LEFT JOIN Catalogo.Contexto 				CatCont 	WITH(NOLOCK) ON (CatCont.TC_CodContexto 			= Leg.TC_CodContexto)
	LEFT JOIN Catalogo.Oficina 					CatOfi 		WITH(NOLOCK) ON (CatOfi.TC_CodOficina 				= CatCont.TC_CodOficina)	
	LEFT Join Catalogo.PuestoTrabajoFuncionario CatPTFunc 	WITH(NOLOCK) ON CatPTFunc.TU_CodPuestoFuncionario 	= HistLeg.TU_CodPuestoFuncionario
	LEFT Join Catalogo.PuestoTrabajo 			CatPT 		WITH(NOLOCK) ON CatPT.TC_CodPuestoTrabajo 			= CatPTFunc.TC_CodPuestoTrabajo
	LEFT JOIN Catalogo.TipoPuestoTrabajo 		CatPT_JD 	WITH(NOLOCK) ON CatPT_JD.TN_CodTipoPuestoTrabajo	= CatPT.TN_CodTipoPuestoTrabajo 
																AND CatPT_JD.TN_CodTipoFuncionario				= CatPT.TN_CodTipoFuncionario 
																AND CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	LEFT JOIN Catalogo.TipoPuestoTrabajo 		CatPT_JT 	WITH(NOLOCK) ON CatPT_JT.TN_CodTipoPuestoTrabajo	= CatPT.TN_CodTipoPuestoTrabajo 
																AND CatPT_JT.TN_CodTipoFuncionario				= CatPT.TN_CodTipoFuncionario 
																AND CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
Where  --HistLeg.TC_NumeroExpediente= '230047560494TR' and
(HistLeg.Tc_CodContexto IN (SELECT distinct * from string_split(@contexto ,CHAR(44))) OR @Contexto = '-1') AND
	   HistLeg.Tc_CodContexto <> '0000'
)AS HistLeg
CROSS APPLY
	(
		SELECT	TOP 1 HistLeg1.TN_CodEstado	AS CODESTASU_ACT,  TF_Fecha
		FROM Historico.LegajoMovimientoCirculante 	HistLeg1  WITH (NOLOCK) 
		WHERE 
		HistLeg1.TC_NumeroExpediente = HistLeg.NUE
		AND HistLeg1.TC_CodContexto = HistLeg.CODDEJ 
		AND HistLeg1.TF_Fecha < Convert(DateTime,@FFinal,102)
		--AND HistLeg1.TC_Movimiento <>'F'
		--AND HistLeg1.TN_CodEstado IS NOT NULL
		ORDER BY HistLeg1.TF_Fecha DESC			         	
	) AS CODESTASU_ACT
-----------------------------------------------------------------------------------------Inserta en DWSIGMA----------------------------------------------------------------------------------
------------------------------------------------------Copia el CF ANTERIOR para comparar con el ACTUAL (inconcistencias entre circulantes)---------------------------------------------------
PRINT('>> Print 3')

Insert Into Sigma.DSIGMA_CF_ANTERIOR

--EXPEDIENTES
	SELECT DISTINCT
		 Convert(VARCHAR(36),Expe.TC_NumeroExpediente)		AS CARPETA,
		 HistExp.TC_NumeroExpediente						AS NUE,
		 HistExp.TC_CodContexto								AS CODDEJ,
	CONVERT (VARCHAR (3),'PRI')								AS CODASU,
	CONVERT (VARCHAR (9),ISNULL(ExpeDet.TN_CodClASe,'-1'))	AS CODCLAS,  
	CONVERT (VARCHAR (2),CatCont.TC_CodMateria)				AS CODJURIS,
	CONVERT (VARCHAR (2),CatOfi.TN_CodTipoOficina)			AS CODTIDEJ,
		 HistExp.TF_Fecha									AS FECHA,
		 HistExp.TC_Movimiento								AS FINEST
     FROM Historico.ExpedienteMovimientoCirculante HistExp
     INNER JOIN Expediente.Expediente Expe  WITH(NOLOCK) ON (HistExp.TC_NumeroExpediente = Expe.TC_NumeroExpediente 
					 AND HistExp.TC_Movimiento <>'F'
					 AND HistExp.TN_CodExpedienteMovimientoCirculante=
					 			(SELECT MAX(HistExp1.TN_CodExpedienteMovimientoCirculante) FROM Historico.ExpedienteMovimientoCirculante HistExp1 WITH(NOLOCK)
					 					WHERE HistExp1.TC_NumeroExpediente	=	HistExp.TC_NumeroExpediente 
					 					AND HistExp1.TC_CodContexto			=	HistExp.TC_CodContexto
					 					AND HistExp1.TC_Movimiento IS NOT NULL
					 					AND HistExp1.TF_FECHA =
										(SELECT MAX (HistExp2.TF_Fecha) 
												FROM Historico.ExpedienteMovimientoCirculante HistExp2  WITH(NOLOCK) 
												WHERE HistExp2.TC_NumeroExpediente	=	HistExp1.TC_NumeroExpediente
												AND HistExp2.TC_CodContexto			=	HistExp1.TC_CodContexto
												AND HistExp2.TC_Movimiento 			IS NOT NULL
												AND HistExp2.TF_Fecha 				< 	DATEADD(MM,-1,CONVERT(DATETIME,@FFinal,102)--mm/dd/aaaa
												--AND HistExp2.TF_Fecha < DATEADD(MM,-1,@FechaFinal--mm/dd/aaaa
												
										)
								)))
		 INNER JOIN Expediente.ExpedienteDetalle 	ExpeDet 	WITH(NOLOCK) ON  ExpeDet.TC_NumeroExpediente 	= Expe.TC_NumeroExpediente
		 																		AND ExpeDet.TC_CodContexto		= HistExp.TC_CodContexto
		 INNER JOIN Catalogo.Contexto 				CatCont 	WITH(NOLOCK) ON  CatCont.TC_CodContexto 		= Expe.TC_CodContexto
		 INNER JOIN Catalogo.ClASeASunto 			CatClASASu 	WITH(NOLOCK) ON  CatClASASu.TN_CodClASeASunto 	= ExpeDet.TN_CodClASe
		 LEFT JOIN Catalogo.Oficina 				CatOfi 		WITH(NOLOCK) ON  CatOfi.TC_CodOficina 			= CatCont.TC_CodOficina
		 

	WHERE --HistExp.TC_NumeroExpediente= '230047560494TR' and
	(HistExp.Tc_CodContexto IN (SELECT * from string_split(@contexto,CHAR(44))) OR @Contexto = '-1') AND
	        HistExp.TC_CodContexto <> '0000'
	
	UNION
	
--LEGAJOS
	SELECT DISTINCT
	    Convert(Varchar(36),Leg.TU_CodLegajo)						AS CARPETA,
		Leg.TC_NumeroExpediente										AS NUE,
		Leg.TC_CodContexto											AS CODDEJ,
	CONVERT (VARCHAR (3),ISNULL(LegDet.TN_CodASunto,'-1'))			AS CODASU,
	CONVERT (VARCHAR (9),ISNULL(LegDet.TN_CodClASeASunto,'-1'))		AS CODCLAS, 
	CONVERT (VARCHAR (2),CatCont.TC_CodMateria)						AS CODJURIS,
	CONVERT (VARCHAR (2),CatOfi.TN_CodTipoOficina)					AS CODTIDEJ,
		HistLeg.TF_Fecha											AS FECHA,
		HistLeg.TC_Movimiento										AS FINEST

	From Historico.LegajoMovimientoCirculante 	HistLeg WITH(NOLOCK)
		INNER JOIN Expediente.Legajo 			Leg 	WITH(NOLOCK) ON (HistLeg.TC_NumeroExpediente = Leg.TC_NumeroExpediente 
						AND Leg.TU_CodLegajo		=	HistLeg.TU_CodLegajo
					 	AND HistLeg.TC_Movimiento 	<>	'F'
					 	AND HistLeg.TN_CodLegajoMovimientoCirculante=
					 			(SELECT MAX(HistLeg1.TN_CodLegajoMovimientoCirculante) FROM Historico.LegajoMovimientoCirculante HistLeg1 WITH(NOLOCK)
					 					WHERE HistLeg1.TC_NumeroExpediente	=	HistLeg.TC_NumeroExpediente
					 					AND HistLeg1.TU_CodLegajo			=	HistLeg.TU_CodLegajo
					 					AND HistLeg1.TC_CodContexto			=	HistLeg.TC_CodContexto
					 					AND HistLeg1.TC_Movimiento IS NOT NULL
					 					AND HistLeg1.TF_FECHA =
										(SELECT MAX (HistLeg2.TF_Fecha) 
												FROM Historico.LegajoMovimientoCirculante HistLeg2  WITH(NOLOCK) 
												WHERE HistLeg2.TC_NumeroExpediente	=	HistLeg1.TC_NumeroExpediente
												AND HistLeg2.TU_CodLegajo			=	HistLeg1.TU_CodLegajo
												AND HistLeg2.TC_CodContexto			=	HistLeg1.TC_CodContexto
												AND HistLeg2.TC_Movimiento 			IS NOT NULL
												AND HistLeg2.TF_Fecha 				< 	DATEADD(MM,-1,CONVERT(DATETIME,@FFinal,102)--mm/dd/aaaa
												--AND HistLeg2.TF_Fecha < DATEADD(MM,-1,@FechaFinal--mm/dd/aaaa
												
										)
								)))
		INNER JOIN Expediente.LegajoDetalle LegDet 			WITH(NOLOCK) ON LegDet.TU_CodLegajo 	= Leg.TU_CodLegajo
																		 AND LegDet.TC_CodContexto	= HistLeg.TC_CodContexto
		INNER JOIN Catalogo.Contexto CatCont 				WITH(NOLOCK) ON CatCont.TC_CodContexto 	= Leg.TC_CodContexto
		LEFT JOIN Catalogo.Oficina CatOfi 					WITH(NOLOCK) ON CatOfi.TC_CodOficina 	= CatCont.TC_CodOficina
	

	Where   --HistLeg.TC_NumeroExpediente= '230047560494TR' and
	(HistLeg.Tc_CodContexto IN (SELECT * from string_split(@contexto,CHAR(44))) OR @Contexto = '-1') AND
	       HistLeg.TC_CodContexto <> '0000'


-------------------------------------------Ligar DWHSIGMA_DESPACHOS_CARGA_ACTUAL----------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
PRINT('>> Print 4')

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------Inserta lo demas que no esta en tramite-------------------------------------------------------------------------


Insert into Sigma.Dsigma

--ESTADOS EXPEDIENTES
SELECT DISTINCT
	HistExp.TN_CodExpedienteMovimientoCirculante				AS IDFEP,
	Convert(Varchar(36),Expe.TC_NumeroExpediente)				AS CARPETA,
	HistExp.TC_NumeroExpediente									AS NUE,
	HistExp.TC_CodContexto										AS CODDEJ,
	CONVERT (VARCHAR (3),'PRI')									AS CODASU,
	CONVERT (VARCHAR (9),ISNULL(ExpeDetall.TN_CodClASe,'-1'))	AS CODCLAS,  
	CONVERT (VARCHAR (2),CatCont.TC_CodMateria)					AS CODJURIS,
	CONVERT (VARCHAR (2),CatOfi.TN_CodTipoOficina)				AS CODTIDEJ,
	HistExp.TF_Fecha											AS FECHA,
	HistExp.TC_Movimiento										AS FINEST,
	HistExp.TN_CodEstado										AS CODESTASU_HIST,
	HistExp.TN_CodEstado										AS CODESTASU_ACT,
	Expe.TF_Inicio												AS FECININUE,
	CASe HistExp.TC_Movimiento 
	When 'E' Then HistExp.TF_Fecha 
	END															AS FECENT,

	CASe HistExp.TC_Movimiento 
	When 'F' Then HistExp.TF_Fecha 
	End															AS FECTER,

	CASe HistExp.TC_Movimiento 
	When 'R' 
	Then HistExp.TF_Fecha 
	End															AS FECREENT,

	''    														AS BALANCE_CF,
	''															AS BALANCE_CI,
	CASE 
	WHEN 
	CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 														AS CODJUTRA,
	CASE 
	WHEN 
	CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 														AS CODJUDEC,
	Null														AS SUBEST,
	CONVERT (VARCHAR (6),ExpeDetall.TN_CodFASe)					AS CODFAS,
	HistExp.TF_Fecha											AS CODESTASU_ACT_FECHA
FROM 
Historico.ExpedienteMovimientoCirculante 				HistExp 	WITH(NOLOCK)
	INNER JOIN Expediente.Expediente 					Expe 		WITH(NOLOCK) ON HistExp.TC_NumeroExpediente			= Expe.TC_NumeroExpediente 
	INNER JOIN Expediente.ExpedienteDetalle 			ExpeDetall 	WITH(NOLOCK) ON (ExpeDetall.TC_NumeroExpediente 	= Expe.TC_NumeroExpediente)
	   																			AND ExpeDetall.TC_CodContexto			= HistExp.TC_CodContexto
	INNER JOIN Catalogo.ClASeASunto 					CatClASASu 	WITH(NOLOCK) ON (CatClASASu.TN_CodClASeASunto 		= ExpeDetall.TN_CodClASe)
	INNER JOIN Catalogo.Contexto 						CatCont 	WITH(NOLOCK) ON (CatCont.TC_CodContexto 			= Expe.TC_CodContexto)
	LEFT JOIN Catalogo.Oficina 							CatOfi 		WITH(NOLOCK) ON (CatOfi.TC_CodOficina 				= CatCont.TC_CodOficina)
	LEFT Join Catalogo.PuestoTrabajoFuncionario 		CatPTFunc 	WITH(NOLOCK) ON CatPTFunc.TU_CodPuestoFuncionario 	= HistExp.TU_CodPuestoFuncionario
	LEFT Join Catalogo.PuestoTrabajo 					CatPT 		WITH(NOLOCK) ON CatPT.TC_CodPuestoTrabajo 			= CatPTFunc.TC_CodPuestoTrabajo
	LEFT JOIN Catalogo.TipoPuestoTrabajo 				CatPT_JD 	WITH(NOLOCK) ON CatPT_JD.TN_CodTipoPuestoTrabajo	= CatPT.TN_CodTipoPuestoTrabajo 
																AND CatPT_JD.TN_CodTipoFuncionario						= CatPT.TN_CodTipoFuncionario 
																AND CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	LEFT JOIN Catalogo.TipoPuestoTrabajo 				CatPT_JT 	WITH(NOLOCK) ON CatPT_JT.TN_CodTipoPuestoTrabajo	= CatPT.TN_CodTipoPuestoTrabajo 
																AND CatPT_JT.TN_CodTipoFuncionario						= CatPT.TN_CodTipoFuncionario 
																AND CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
Where --HistExp.TC_NumeroExpediente= '230047560494TR' and
(HistExp.Tc_CodContexto IN (SELECT distinct * from string_split(@contexto,CHAR(44))) OR @Contexto = '-1') 
	   AND HistExp.TC_CodContexto 	 <> '0000'
       AND HistExp.TF_Fecha >= Convert(DateTime,@FInicio,102) 	--Convert(DateTime,'06/01/2021',102)
	   AND HistExp.TF_Fecha < Convert(DateTime,@FFinal,102)		--Convert(DateTime,'07/01/2021',102)
	   AND HistExp.TC_Movimiento in ('F') --,'R','E')
   
UNION 
--ESTADOS LEGAJOS
SELECT DISTINCT
	HistLeg.TN_CodLegajoMovimientoCirculante 						AS IDFEP,
	Convert(Varchar(36),HistLeg.TU_CodLegajo)						AS CARPETA,
	HistLeg.TC_NumeroExpediente										AS NUE,
	HistLeg.TC_CodContexto		  									AS CODDEJ,
	CONVERT (VARCHAR (3),ISNULL(LegDetall.TN_CodASunto,'-1'))		AS CODASU,
	CONVERT (VARCHAR (9),ISNULL(LegDetall.TN_CodClASeASunto,'-1'))	AS CODCLAS, 
	CONVERT (VARCHAR (2),CatCont.TC_CodMateria)						AS CODJURIS,
	CONVERT (VARCHAR (2),CatOfi.TN_CodTipoOficina)					AS CODTIDEJ,
	HistLeg.TF_Fecha												AS FECHA,
	HistLeg.TC_Movimiento											AS FINEST,
	HistLeg.TN_CodEstado  											AS CODESTASU_HIST,
	''																AS CODESTASU_ACT,
	Leg.TF_Inicio													AS FECININUE,
	CASe HistLeg.TC_Movimiento 
	When 'E' Then HistLeg.TF_Fecha 
	End																AS FECENT,

	CASe HistLeg.TC_Movimiento 
	When 'F' Then HistLeg.TF_Fecha 
	End																AS FECTER,

	CASe HistLeg.TC_Movimiento 
	When 'R' 
	Then HistLeg.TF_Fecha 
	End																AS FECREENT,

	''																AS BALANCE_CF,
	''																AS BALANCE_CI,
	CASE 
	WHEN 
	CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 															AS CODJUTRA,
	CASE 
	WHEN 
	CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	THEN CatPTFunc.TC_CodPuestoTrabajo	
	END 															AS CODJUDEC,
	Null															AS SUBEST,
	CONVERT (VARCHAR (6),NULL)										AS CODFAS,
	HistLeg.TF_Fecha												AS CODESTASU_ACT_FECHA
FROM 
Historico.LegajoMovimientoCirculante 				HistLeg 	WITH(NOLOCK)
	INNER JOIN Expediente.Legajo 					Leg 		WITH(NOLOCK) ON	Leg.TC_NumeroExpediente				=	HistLeg.TC_NumeroExpediente
																				AND Leg.TU_CodLegajo				=	HistLeg.TU_CodLegajo
 	INNER JOIN Expediente.LegajoDetalle 			LegDetall 	WITH(NOLOCK) ON (LegDetall.TU_CodLegajo 			=	HistLeg.TU_CodLegajo)
   		   																		AND LegDetall.TC_CodContexto		=	HistLeg.TC_CodContexto
	INNER JOIN Catalogo.Contexto 					CatCont 	WITH(NOLOCK) ON (CatCont.TC_CodContexto 			=	HistLeg.TC_CodContexto)
	LEFT JOIN Catalogo.Oficina 						CatOfi 		WITH(NOLOCK) ON (CatOfi.TC_CodOficina 				=	CatCont.TC_CodOficina)
	LEFT JOIN Catalogo.PuestoTrabajoFuncionario 	CatPTFunc 	WITH(NOLOCK) ON CatPTFunc.TU_CodPuestoFuncionario 	=	HistLeg.TU_CodPuestoFuncionario
	LEFT JOIN Catalogo.PuestoTrabajo 				CatPT 		WITH(NOLOCK) ON CatPT.TC_CodPuestoTrabajo 			=	CatPTFunc.TC_CodPuestoTrabajo
	LEFT JOIN Catalogo.TipoPuestoTrabajo 			CatPT_JD 	WITH(NOLOCK) ON CatPT_JD.TN_CodTipoPuestoTrabajo	=	CatPT.TN_CodTipoPuestoTrabajo 
																	AND CatPT_JD.TN_CodTipoFuncionario				=	CatPT.TN_CodTipoFuncionario 
																	AND CatPT_JD.TC_Descripcion LIKE '%Decisor%'
	LEFT JOIN Catalogo.TipoPuestoTrabajo 			CatPT_JT 	WITH(NOLOCK) ON CatPT_JT.TN_CodTipoPuestoTrabajo	=	CatPT.TN_CodTipoPuestoTrabajo 
																	AND CatPT_JT.TN_CodTipoFuncionario				=	CatPT.TN_CodTipoFuncionario 
																	AND CatPT_JT.TC_Descripcion LIKE '%Tramitador%'
WHERE --HistLeg.TC_NumeroExpediente= '067003150318PA' and
(HistLeg.Tc_CodContexto IN (SELECT distinct * from string_split(@contexto,CHAR(44))) OR @Contexto = '-1') 
AND HistLeg.TC_CodContexto 	<> '0000'
AND HistLeg.TF_Fecha 	>= 	Convert(DateTime,@FInicio,102) 	--Convert(DateTime,'01/12/2020',102)
AND HistLeg.TF_Fecha 	< 	Convert(DateTime,@FFinal,102)	--Convert(DateTime,'01/01/2021',102)
AND HistLeg.TC_Movimiento in ('F') --,'R','E')


PRINT('>> Print 5')
--Update Datos FECTER, FECREENT

Update Sigma.Dsigma
Set Dsigma.FecTer = Dsigma.Fecha
Where Dsigma.Finest = 'F'

Update Sigma.Dsigma
Set Dsigma.FecReent = Dsigma.Fecha
Where Dsigma.Finest = 'R'

Update Sigma.Dsigma
Set Dsigma.FecTer = Dsigma.Fecha
Where Dsigma.Finest = 'F'

--Update Datos SubEstado (NO EXISTE)

--Update Datos Fase
Update Sigma.Dsigma
Set Dsigma.CodFas = Dsigma.Codfas
Where Dsigma.Carpeta = Dsigma.Carpeta and Dsigma.Coddej = Dsigma.coddej and Dsigma.Codfas is null and Dsigma.codfas is not null

-- INSERTA DATOS EN DSIGMA_LISTADO
Insert into Sigma.DSIGMA_LISTADO
  Select Distinct 
         Carpeta, 
		 Nue,
		 CodDej,
		 CodAsu,
		 CodClas,
		 CodJuris,
		 CodtiDej,
		 FeInNue,
		 Convert(datetime,null)  as FecEnt,
		 Convert(datetime,null)  as FecTer,
		 0 as Motivo_TER,
		 0 as Estado_ACT,
		 Convert(datetime,null)  as FecReent,
		 Convert(varchar,null)   as Balance_CF,
		 Balance_CI,
		 CodJuTra,
		 CodJuDec,
		 CodSubEst,
		 CodFas,
		 CodEstasu_Act_Fecha
  From Sigma.Dsigma 


-- INSERTA EN DSIGMA_CARGA
Insert into Sigma.DSIGMA_CARGA
  Select Distinct 
         Carpeta,
		 Nue,
		 CodDej
  From Sigma.Dsigma

-- ACTUALIZA DATOS DSIGMA_LISTADO
Update Sigma.DSigma_Listado
 Set Balance_CF = Dsigma.Balance_CF
 From Sigma.Dsigma
 Where DSigma.Carpeta = Dsigma_Listado.Carpeta and Dsigma.CodDej = DSigma_Listado.CodDej
 And DSigma.Balance_CF is not null

Update Sigma.DSigma_Listado
 Set Estado_Act = Dsigma.CodEstasu_Act
 From Sigma.Dsigma
 Where DSigma.Carpeta = Dsigma_Listado.Carpeta and Dsigma.CodDej = DSigma_Listado.CodDej
 And DSigma.CodEstasu_Act is not null

Update Sigma.DSigma_Listado
 Set FecEnt = Dsigma.FecEnt
 From Sigma.Dsigma
 Where DSigma.Carpeta = Dsigma_Listado.Carpeta and Dsigma.CodDej = DSigma_Listado.CodDej
 And DSigma.FecEnt is not null

Update Sigma.DSigma_Listado
 Set FecTer = Dsigma.FecTer
 From Sigma.Dsigma
 Where DSigma.Carpeta = Dsigma_Listado.Carpeta and Dsigma.CodDej = DSigma_Listado.CodDej
 And DSigma.FecTer is not null

Update Sigma.DSigma_Listado
 Set FecReent = Dsigma.FecReent
 From Sigma.Dsigma
 Where DSigma.Carpeta = Dsigma_Listado.Carpeta and Dsigma.CodDej = DSigma_Listado.CodDej
 And DSigma.FecReent is not null

Update Sigma.DSigma_Listado
 Set Motivo_Ter = Dsigma.CodEstasu_Ter
 From Sigma.Dsigma
 Where DSigma.Carpeta = Dsigma_Listado.Carpeta and Dsigma.CodDej = DSigma_Listado.CodDej
 And DSigma.Finest = 'F'

/*ACTUALIZA FECHA ENTRADA*/
Update DS
SET DS.FECENT=HistExp.TF_FECHA
FROM Sigma.DSigma_Listado DS
INNER JOIN Historico.ExpedienteMovimientoCirculante HistExp ON HistExp.TC_NumeroExpediente = DS.Nue AND HistExp.TC_MOVIMIENTO ='E'
WHERE  DS.FecEnt IS NULL
 
 
PRINT('>> Print 6')
/*Actualiza el circulante al iniciar*/

--ESTADOS EXPEDIENTES
Update Sigma.DSigma_Listado
        Set Balance_CI = 'CI'
  --Expediente.Expediente ExpExpe WITH(NOLOCK)
From	 Historico.ExpedienteMovimientoCirculante HistExp  	WITH(NOLOCK) --ON (HistExp.TC_NumeroExpediente = ExpExpe.TC_NumeroExpediente 
	INNER JOIN Sigma.DSigma_Listado DSList WITH(NOLOCK) ON DSList.Carpeta = HistExp.TC_NumeroExpediente and DSList.CodDej = HistExp.TC_CodContexto
	WHERE	  --HistExp.TC_NumeroExpediente= '067003150318PA' and
	HistExp.TC_Movimiento <>'F'
					 AND HistExp.TN_CodExpedienteMovimientoCirculante=
					 			(SELECT MAX(HistExp1.TN_CodExpedienteMovimientoCirculante) FROM Historico.ExpedienteMovimientoCirculante HistExp1 WITH(NOLOCK)
					 					WHERE HistExp1.TC_NumeroExpediente	=	HistExp.TC_NumeroExpediente 
					 					AND HistExp1.TC_CodContexto			=	HistExp.TC_CodContexto
					 					AND HistExp1.TC_Movimiento IS NOT NULL
					 					AND HistExp1.TF_FECHA =
										(SELECT MAX (HistExp2.TF_Fecha) 
												FROM Historico.ExpedienteMovimientoCirculante HistExp2  WITH(NOLOCK) 
												WHERE HistExp2.TC_NumeroExpediente	=	HistExp1.TC_NumeroExpediente
												AND HistExp2.TC_CodContexto			=	HistExp1.TC_CodContexto
												AND HistExp2.TC_Movimiento IS NOT NULL
												AND HistExp2.TF_Fecha < Convert(DateTime,@FInicio,102)
												--AND HistExp2.TF_Fecha < @FechaInicio
										)
								)
	

Update Sigma.DSigma_Listado
        Set Balance_CI = 'CI'
 --Expediente.Legajo Leg
From	 Historico.LegajoMovimientoCirculante HistLeg  WITH(NOLOCK) --ON (HistLeg.TC_NumeroExpediente = Leg.TC_NumeroExpediente 
		INNER JOIN Sigma.DSigma_Listado	DSList	WITH(NOLOCK) ON DSList.Carpeta = CONVERT(varchar(36),HistLeg.TU_CodLegajo) and DSList.CodDej = HistLeg.TC_CodContexto

			WHERE   --HistLeg.TC_NumeroExpediente= '067003150318PA' and
			HistLeg.TC_Movimiento <>'F'
					 AND HistLeg.TN_CodLegajoMovimientoCirculante=
					 			(SELECT MAX(HistLeg1.TN_CodLegajoMovimientoCirculante) FROM Historico.LegajoMovimientoCirculante HistLeg1 WITH(NOLOCK)
					 					WHERE HistLeg1.TC_NumeroExpediente	=	HistLeg.TC_NumeroExpediente
					 					AND HistLeg1.TU_CodLegajo			=	HistLeg.TU_CodLegajo
					 					AND HistLeg1.TC_CodContexto			=	HistLeg.TC_CodContexto
					 					AND HistLeg1.TC_Movimiento			IS NOT NULL
					 					AND HistLeg1.TF_FECHA =
										(SELECT MAX (HistLeg2.TF_Fecha) 
												FROM Historico.LegajoMovimientoCirculante HistLeg2  WITH(NOLOCK) 
												WHERE HistLeg2.TC_NumeroExpediente	=	HistLeg1.TC_NumeroExpediente
												AND HistLeg2.TU_CodLegajo			=	HistLeg1.TU_CodLegajo
												AND HistLeg2.TC_CodContexto			=	HistLeg1.TC_CodContexto
												AND HistLeg2.TC_Movimiento			IS NOT NULL
												AND HistLeg2.TF_Fecha < Convert(DateTime,@FInicio ,102)
												--AND HistLeg2.TF_Fecha < @FechaInicio
										)
								)

END




GO
