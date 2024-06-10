SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Donald Vargas>
-- Fecha Creación:		<03/05/2016>
-- Descripcion:			<Modificar formato jurídico>
-- Modificado por:		<Jeffry Hernández>
-- Fecha Modificación:	<03/08/2016>
-- =========================================================================================================================================
-- Descripcion:			<Se reestructura toda la cláusula>
-- Modificacion:		<10/07/2018><Jefry Hernández><Se agrega nuevo parámetro @CodGrupoFormatoJuridico.>
-- Modificacion:		<03/10/2018><Isaac Dobles><Se agrega nuevo parámetro @AplicaParaExpediente.>
-- Modificacion:		<17/02/2021><Wagner Vargas><Seamplia campo TC_Nombre>
-- Modificacion:		<17/03/2021><Jose Gabriel Cordero Soto> <Se agrega en actualización el campo indicador de generardor de voto automatico>
-- Modificacion:		<13/07/2021><Daniel Ruiz Hernández> <Se agrega el parametro PaseFallo para indicar si el formato juridico utiliza esta funcionalidad>
-- =========================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarFormatoJuridico] 
    @Codigo					 Varchar(8),
	@Categorizacion			 Char(1),
	@Descripcion			 Varchar(255),
	@InicioVigencia			 Datetime2,
	@FinVigencia			 Datetime2,
	@IDArchivoFSActual		 Uniqueidentifier,
	@IDArchivoFSVersionado	 Uniqueidentifier,
	@Nombre					 Varchar(255),
	@EjecucionMasiva         Bit,
	@Notifica				 Bit,
	@Ordenamiento			 Smallint,
	@CodGrupoFormatoJuridico Smallint,
	@AplicaParaExpediente	 Bit,
	@GeneraVotoAutomatico	 BIT = 0,
	@PaseFallo				 BIT = 0
AS
BEGIN
	
	--Variables locales
	DECLARE @L_Codigo					Varchar(8)			= @Codigo,
			@L_Categorizacion			Char(1)				= @Categorizacion,
			@L_Descripcion				Varchar(255)		= @Descripcion,
			@L_InicioVigencia			Datetime2			= @InicioVigencia,
			@L_FinVigencia				Datetime2			= @FinVigencia,
			@L_IDArchivoFSActual		Uniqueidentifier	= @IDArchivoFSActual,
			@L_IDArchivoFSVersionado	Uniqueidentifier	= @IDArchivoFSVersionado,
			@L_Nombre					Varchar(255)		= @Nombre,
			@L_EjecucionMasiva          Bit					= @EjecucionMasiva,
			@L_Notifica				    Bit					= @Notifica,
			@L_Ordenamiento			    Smallint			= @Ordenamiento,
			@L_CodGrupoFormatoJuridico  Smallint			= @CodGrupoFormatoJuridico,
			@L_AplicaParaExpediente	    Bit					= @AplicaParaExpediente,
			@L_GeneraVotoAutomatico	    BIT					= @GeneraVotoAutomatico,
			@L_PaseFallo				BIT					= @PaseFallo


    --Aplicación de modificación
	UPDATE Catalogo.FormatoJuridico
	SET 
		TC_Categorizacion			=	@L_Categorizacion,
		TC_Descripcion				=	@L_Descripcion,
		TF_Inicio_Vigencia			=	@L_InicioVigencia,
		TF_Fin_Vigencia				=	@L_FinVigencia,
		TN_CodGrupoFormatoJuridico  =   @L_CodGrupoFormatoJuridico,
		[TU_IDArchivoFSActual]		=	@L_IDArchivoFSActual,
		[TU_IDArchivoFSVersionado]	=	@L_IDArchivoFSVersionado,
		[TC_Nombre]					=	@L_Nombre,
		[TB_EjecucionMasiva]		=	@L_EjecucionMasiva,
		[TB_Notifica]				=	@L_Notifica,
		[TN_Ordenamiento]			=	@L_Ordenamiento,
		[TF_Actualizacion]			=	Getdate(),
		[TB_DocumentoSinExpediente] =	@L_AplicaParaExpediente,
		[TB_GenerarVotoAutomatico]  =   @L_GeneraVotoAutomatico,
		[TB_PaseFallo]				=	@L_PaseFallo

	WHERE TC_CodFormatoJuridico		=	@L_Codigo

END
GO
