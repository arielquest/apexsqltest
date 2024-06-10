SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Donald Vargas>
-- Fecha Creación:		<02/05/2016>
-- Descripcion:			<Crear nuevo formato jurídico>
-- Modificado por:		<Jeffry Hernández>
-- Fecha Modificación:	<02/05/2016>
-- =========================================================================================================================================
-- Descripcion:			<Se reestructura toda la cláusula>
-- Modificacion:		<03/10/2018><Isaac Dobles><Se agrega nuevo parámetro @AplicaParaExpediente.>
-- Modificacion:		<17/02/2021><Wagner Vargas><se amplia campo TC_Nombre  a255.
-- Modificacion:		<17/03/2021><Jose Gabriel Cordero Soto> <Se agrega en inserción el campo indicador de generardor de voto automatico>
-- Modificacion:		<13/07/2021><Daniel Ruiz Hernández> <Se agrega el parametro PaseFallo para indicar si el formato juridico utiliza esta funcionalidad>
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarFormatoJuridico] 
	@Categorizacion			 Char(1),
	@Descripcion			 Varchar(255),
	@InicioVigencia			 Datetime2,
	@FinVigencia			 Datetime2,
	@CodGrupoFormatoJuridico Smallint,
	@IDArchivoFSActual		 Uniqueidentifier,
	@IDArchivoFSVersionado	 Uniqueidentifier,
	@Nombre					 Varchar(255),
	@UsuarioRed				 Varchar(30),
	@EjecucionMasiva         Bit,
	@Notifica				 Bit,
	@Ordenamiento			 Smallint,
	@AplicaParaExpediente	 Bit = 0,
	@GeneraVotoAutomatico	 BIT = 0,
	@PaseFallo				 BIT = 0
AS
BEGIN

	--Variables locales
	DECLARE @L_Categorizacion			Char(1)				= @Categorizacion,
			@L_Descripcion				Varchar(255)		= @Descripcion,
			@L_InicioVigencia			Datetime2			= @InicioVigencia,
			@L_FinVigencia				Datetime2			= @FinVigencia,
			@L_IDArchivoFSActual		Uniqueidentifier	= @IDArchivoFSActual,
			@L_IDArchivoFSVersionado	Uniqueidentifier	= @IDArchivoFSVersionado,
			@L_Nombre					Varchar(255)		= @Nombre,
			@L_UsuarioRed				Varchar(30)			= @UsuarioRed,
			@L_EjecucionMasiva          Bit					= @EjecucionMasiva,
			@L_Notifica				    Bit					= @Notifica,
			@L_Ordenamiento			    Smallint			= @Ordenamiento,
			@L_CodGrupoFormatoJuridico  Smallint			= @CodGrupoFormatoJuridico,
			@L_AplicaParaExpediente	    Bit					= @AplicaParaExpediente,
			@L_GeneraVotoAutomatico	    BIT					= @GeneraVotoAutomatico,
			@L_PaseFallo				BIT					= @PaseFallo



	--Aplicación de inserción
	INSERT INTO Catalogo.FormatoJuridico
	(
		 [TC_Categorizacion]            ,[TC_Descripcion]			,[TF_Inicio_Vigencia]           ,[TF_Fin_Vigencia] 
		,[TN_CodGrupoFormatoJuridico]   ,[TU_IDArchivoFSActual]		,[TU_IDArchivoFSVersionado]		,[TC_Nombre]		
		,[TC_UsuarioRed]				,[TB_EjecucionMasiva]		,[TB_Notifica]					,[TN_Ordenamiento]
		,[TB_DocumentoSinExpediente]	,[TB_GenerarVotoAutomatico]	,[TB_PaseFallo]			
	)
	VALUES
	(
		 @L_Categorizacion				,@L_Descripcion				,@L_InicioVigencia				,@L_FinVigencia
		,@L_CodGrupoFormatoJuridico		,@L_IDArchivoFSActual		,@L_IDArchivoFSVersionado		,@L_Nombre
		,@L_UsuarioRed					,@L_EjecucionMasiva			,@L_Notifica					,@L_Ordenamiento
		,@L_AplicaParaExpediente		,@L_GeneraVotoAutomatico	,@L_PaseFallo	
	)

END

GO
