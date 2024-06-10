SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================  
-- Autor:		   <Jonathan Aguilar Navarro  
-- Fecha Creación: <20/03/2018>  
-- Descripcion:    <Permite agregar un nuevo registro de contexto>  
-- Modificación    <23/05/2018> <Jonathan Aguilar Navarro> <Se agrega el campo Tc_CodigoContextoOCJ>   
-- Modificación    <Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>  
-- Modificación    <Johan Acosta Ibañez> <27/03/2020> <Se agregan los campos que corresponden a PBI - 80629 HU 02 Env¡o de Escritos GL- 
--					Funcionalidad Agregar servicios externos a una oficina judicial en SIAGPJ>  
-- Modificación    <Xinia Soto V> <13/10/2020> <Se agrega par metro para indicar si solicita citas por medio de GL o app móvil >  
-- Modificación    <Karol Jim‚nez S nchez> <08/12/2020> <Se agrega par metro para indicar si el contexto utiliza o no SIAGPJ y se tabula el SP>  
-- Modificación    <Xinia Soto V> <09/12/2020> <Se agrega par metro para indicar si el contexto solicita ordenes de apremio por GL>    
-- Modificación    <Ronny Ram¡rez R.> <09/03/2021> <Se agrega par metro para agregar nuevo campo de TC_PaginaWeb> 
-- Modificación    <Ronny Ram¡rez R.> <10/03/2021> <Se agregan par metros para agregar nuevos campos de TN_CodProvincia, TN_CodCanton, 
--					TN_CodDistrito y TN_CodBarrio, para almacenar la ubicación de un contexto> 
-- Modificación    <Fabian Sequeira G.> <24/09/2021> <Se agrega campo TB_ValidacionDocumento_GL_AM para validar documentos de Gestion en Linea y App> 
-- Modificación    <Ricardo Gutiérrez Peña> <16/02/2023> <Se agregan parámetros para agregar nuevo campo de TC_CodContextoSuperior>
-- Modificación    <Ricardo Gutiérrez Peña> <11/08/2023> <Se agrega campo TB_EnvioInformesFacilitador_GL_AM para indicar si se reciben informes de facilitadores de Gestión en Línea y App>
-- =================================================================================================================================================  
  
CREATE PROCEDURE [Catalogo].[PA_AgregarContexto]  
	 @CodOficina					VARCHAR(4),  
	 @CodContexto					VARCHAR(4),  
	 @CodContextoOCJ				VARCHAR(4)  = NULL,  
	 @CodMateria					VARCHAR(5),  
	 @Descripcion					VARCHAR(255),  
	 @Telefono						VARCHAR(50)  = NULL,  
	 @Fax							VARCHAR(50)  = NULL,  
	 @Email							VARCHAR(255) = NULL,  
	 @Inicio_Vigencia				DATETIME2(7),  
	 @Fin_Vigencia					DATETIME2(7) = NULL,  
	 @EnvioEscrito_GL_AM			BIT,  
	 @EnvioDemandaDenuncia_GL_AM	BIT,  
	 @ConsultaPublicaCiudadano		BIT,  
	 @ConsultaPrivadaCiudadano		BIT ,
	 @SolicitudCitas_GL_AM			BIT = 0,
	 @UtilizaSiagpj					BIT,
     @SolicitudApremios_GL_AM       BIT = 0,
	 @PaginaWeb						VARCHAR(255) = NULL,
	 @CodProvincia					SMALLINT = NULL,
	 @CodCanton						SMALLINT = NULL,
	 @CodDistrito					SMALLINT = NULL,
	 @CodBarrio						SMALLINT = NULL, 
	 @ValidacionDocumento_GL_AM		BIT ,
	 @CodContextoSuperior			VARCHAR(4)  = NULL,
	 @EnvioInformesFacilitador_GL_AM BIT = 0
AS  
BEGIN  

	 --Variables  
	 DECLARE @L_TC_CodOficina				VARCHAR(4)		= @CodOficina,  
	   @L_TC_CodContexto					VARCHAR(4)		= @CodContexto,  
	   @L_TC_CodContextoOCJ					VARCHAR(4)		= @CodContextoOCJ,  
	   @L_TC_CodMateria						VARCHAR(5)		= @CodMateria,  
	   @L_TC_Descripcion					VARCHAR(255)	= @Descripcion,  
	   @L_TC_Telefono						VARCHAR(50)		= @Telefono,  
	   @L_TC_Fax							VARCHAR(50)		= @Fax,  
	   @L_TC_Email							VARCHAR(255)	= @Email,  
	   @L_TF_Inicio_Vigencia				DATETIME2(7)	= @Inicio_Vigencia,  
	   @L_TF_Fin_Vigencia					DATETIME2(7)	= @Fin_Vigencia,  
	   @L_TB_EnvioEscrito_GL_AM				BIT				= @EnvioEscrito_GL_AM,  
	   @L_TB_EnvioDemandaDenuncia_GL_AM		BIT				= @EnvioDemandaDenuncia_GL_AM,  
	   @L_TB_ConsultaPublicaCiudadano		BIT				= @ConsultaPublicaCiudadano,  
	   @L_TB_ConsultaPrivadaCiudadano		BIT				= @ConsultaPrivadaCiudadano,  
	   @L_TB_SolicitudCitas_GL_AM			BIT				= @SolicitudCitas_GL_AM, 
	   @L_TB_UtilizaSiagpj					BIT				= @UtilizaSiagpj,
	   @L_TB_SolicitudApremios_GL_AM		BIT				= @SolicitudApremios_GL_AM,
	   @L_TC_PaginaWeb						VARCHAR(255)	= @PaginaWeb,
	   @L_TN_CodProvincia					SMALLINT		= @CodProvincia,
	   @L_TN_CodCanton						SMALLINT		= @CodCanton,
	   @L_TN_CodDistrito					SMALLINT		= @CodDistrito,
	   @L_TN_CodBarrio						SMALLINT		= @CodBarrio,
	   @L_TB_ValidacionDocumento_GL_AM		BIT				= @ValidacionDocumento_GL_AM,
	   @L_TC_CodContextoSuperior			VARCHAR(4)		= @CodContextoSuperior,
	   @L_TB_EnvioInformesFacilitador_GL_AM BIT				= @EnvioInformesFacilitador_GL_AM

	 --Cuerpo  
	 INSERT INTO Catalogo.Contexto WITH (ROWLOCK)  
	 (  
	  TC_CodOficina,					TC_CodContexto,					TC_CodContextoOCJ,				TC_CodMateria,     
	  TC_Descripcion,					TC_Telefono,					TC_Fax,							TC_Email,      
	  TF_Inicio_Vigencia,				TF_Fin_Vigencia,				TB_EnvioEscrito_GL_AM,			TB_EnvioDemandaDenuncia_GL_AM,     
	  TB_ConsultaPublicaCiudadano,		TB_ConsultaPrivadaCiudadano,	TB_SolicitudCitas_GL_AM,		TB_UtilizaSiagpj,
	  TB_SolicitudApremios_GL_AM,		TC_PaginaWeb,					TN_CodProvincia,				TN_CodCanton,
	  TN_CodDistrito,					TN_CodBarrio,					TB_ValidacionDocumento_GL_AM,	TC_CodContextoSuperior,
	  TB_EnvioInformesFacilitador_GL_AM
	 )  
	 VALUES  
	 (  
	  @L_TC_CodOficina,					@L_TC_CodContexto,				@L_TC_CodContextoOCJ,				@L_TC_CodMateria,     
	  @L_TC_Descripcion,				@L_TC_Telefono,					@L_TC_Fax,							@L_TC_Email,      
	  @L_TF_Inicio_Vigencia,			@L_TF_Fin_Vigencia,				@L_TB_EnvioEscrito_GL_AM,			@L_TB_EnvioDemandaDenuncia_GL_AM,     
	  @L_TB_ConsultaPublicaCiudadano,	@L_TB_ConsultaPrivadaCiudadano, @L_TB_SolicitudCitas_GL_AM,			@L_TB_UtilizaSiagpj,
	  @L_TB_SolicitudApremios_GL_AM,	@L_TC_PaginaWeb,				@L_TN_CodProvincia,					@L_TN_CodCanton,
	  @L_TN_CodDistrito,				@L_TN_CodBarrio,				@L_TB_ValidacionDocumento_GL_AM,	@L_TC_CodContextoSuperior,
	  @L_TB_EnvioInformesFacilitador_GL_AM
	 )  
END
GO
