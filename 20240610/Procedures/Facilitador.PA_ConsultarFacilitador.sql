SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Facilitador].[PA_ConsultarFacilitador]
	@CodTipoIdentificacion	VARCHAR(21) ,
	@Identificacion	        VARCHAR(21) ,
	@CodContexto            VARCHAR(4),
	@Activo			        BIT,
	@DomicilioHabitual      BIT
AS
BEGIN
--Variables
	DECLARE	@L_TN_CodTipoIdentificacion VARCHAR(21) = @CodTipoIdentificacion
	DECLARE	@L_TC_Identificacion        VARCHAR(21) = @Identificacion
	DECLARE	@L_TC_CodContexto           VARCHAR(21) = @CodContexto
	DECLARE	@L_TB_Activo                BIT         = @Activo
	DECLARE	@L_TB_DomicilioHabitual     BIT         = @DomicilioHabitual
	
	Select P.TU_CodPersona				AS CodigoPersona,                 P.TC_Identificacion   AS Identificacion,              PF.TC_Nombre          AS Nombre,		        
		   PF.TC_PrimerApellido	        AS PrimerApellido,                PF.TC_SegundoApellido AS SegundoApellido,             PF.TF_FechaNacimiento AS FechaNacimiento,
		   F.TC_Observaciones			AS Observaciones,		          F.TC_Email			AS Correo,                      F.TC_CodContexto      AS CodigoContexto,
		   F.TN_CodFacilitador          As CodigoFacilitador,
	       'SplitTipoIdentificacion'	AS SplitTipoIdentificacion,		    						      					    
	       CTI.TN_CodTipoIdentificacion	AS Codigo,					      CTI.TC_Descripcion    AS Descripcion,	                CTI.TF_Inicio_Vigencia AS FechaActivacion,
	       CTI.TF_Fin_Vigencia			AS FechaDesactivacion,		      CTI.TB_Nacional	    AS  Nacional,		       	    
	       'SplitProvincia'             AS SplitProvincia,			      										       		    
	       CPR.TN_CodProvincia          AS Codigo,					      CPR.TC_Descripcion	AS Descripcion,                 CPR.TF_Inicio_Vigencia AS FechaActivacion,
	       CPR.TF_Fin_Vigencia          AS FechaDesactivacion,		      												           
	       'SplitCanton'				AS SplitCanton,				      												           
	       CC.TN_CodCanton              AS Codigo,					      CC.TC_Descripcion		AS Descripcion,                 CC.TF_Inicio_Vigencia  AS FechaActivacion,
	       CC.TF_Fin_Vigencia			AS FechaDesactivacion,		      												           
	       'SplitDistrito'				AS SplitDistrito,			      												           
	       CD.TN_CodDistrito            AS Codigo,					      CD.TC_Descripcion		AS Descripcion,                 CD.TF_Inicio_Vigencia  AS FechaActivacion,
	       CD.TF_Fin_Vigencia           AS FechaDesactivacion,		      													    
	       'SplitDatos'			        AS SplitDatos,				      													    
	       CE.TN_CodEscolaridad         AS CodigoEscolaridad,		      CE.TC_Descripcion		AS DescripcionEscolaridad,      CE.TF_Inicio_Vigencia  AS FechaActivacionEscolaridad, 
		   CE.TF_Fin_Vigencia			AS FechaDesactivacionEscolaridad, CP.TN_CodProfesion    AS CodigoProfesion  ,           CP.TC_Descripcion	   AS DescripcionProfesion,    
		   CP.TF_Inicio_Vigencia        AS FechaActivacionProfesion,      CP.TF_Fin_Vigencia    AS FechaDesactivacionProfesion, CS.TC_CodSexo		   AS CodigoSexo,
		   CS.TC_Descripcion		    AS  DescripcionSexo,              CS.TF_Inicio_Vigencia AS FechaActivacionSexo,         CS.TF_Fin_Vigencia     AS FechaDesactivacionSexo,
		   F.TB_Activo		            AS Estado,						  PD.TC_Direccion       AS Comunidad	
	FROM			Persona.Persona				         AS	 P   WITH(NOLOCK)
	INNER JOIN		Persona.PersonaFisica		         AS	 PF  WITH(NOLOCK) 
	ON				P.TU_CodPersona				         =	 PF.TU_CodPersona
	INNER JOIN		Facilitador.Facilitador				 AS	 F  WITH(NOLOCK) 
	ON				P.TU_CodPersona				         =	 F.TU_CodPersona
	INNER JOIN		Persona.Domicilio				     AS	 PD  WITH(NOLOCK) 
	ON				P.TU_CodPersona				         =	 PD.TU_CodPersona
	INNER JOIN		Catalogo.TipoIdentificacion			 AS	 CTI  WITH(NOLOCK) 
	ON				P.TN_CodTipoIdentificacion			 =	 CTI.TN_CodTipoIdentificacion
	INNER JOIN		Catalogo.Sexo						 AS	 CS  WITH(NOLOCK) 
	ON				PF.TC_CodSexo						 =	 CS.TC_CodSexo
	INNER JOIN		Catalogo.Escolaridad				 AS	 CE  WITH(NOLOCK) 
	ON				F.TN_CodEscolaridad					 =	 CE.TN_CodEscolaridad
	INNER JOIN		Catalogo.Profesion					 AS	 CP  WITH(NOLOCK) 
	ON				F.TN_CodProfesion					 =	 CP.TN_CodProfesion
	INNER JOIN		Catalogo.Provincia					 AS	 CPR  WITH(NOLOCK) 
	ON				PD.TN_CodProvincia					 =	 CPR.TN_CodProvincia	
	INNER JOIN		Catalogo.Canton						 AS	 CC  WITH(NOLOCK) 
	ON				PD.TN_CodCanton						 =	 CC.TN_CodCanton
	INNER JOIN		Catalogo.Distrito					 AS	 CD  WITH(NOLOCK) 
	ON				PD.TN_CodDistrito					 =	 CD.TN_CodDistrito
	where			P.TC_Identificacion					 =	 COALESCE(@L_TC_Identificacion,P.TC_Identificacion)
	and				F.TB_Activo							 =	 COALESCE(@L_TB_Activo,F.TB_Activo)
	and				CTI.TN_CodTipoIdentificacion     	 =	 COALESCE(@CodTipoIdentificacion,CTI.TN_CodTipoIdentificacion)
	and				F.TC_CodContexto					 =	 @L_TC_CodContexto
	and             PD.TB_DomicilioHabitual              =   @L_TB_DomicilioHabitual
	ORDER BY		F.TB_Activo							 ASC,
				    PF.TC_Nombre						 ASC
	END
GO
