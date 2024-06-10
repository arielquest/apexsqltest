SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Johan Acosta>
-- Fecha Creación: <11/07/2016>
-- Descripcion:	<Modificar un puesto de trabajo>
-- Modificación: <05/12/2016> <Pablo Alvarez> <Se corrige TN_CodPerfilpuesto y TN_CodTipoFuncionario por estandar.>
-- Modificación: <06/02/2017> <Pablo Alvarez> <Se agrega la columna código jornada laboral.>
-- =============================================
-- Modificado por: <23/06/2020> <Jose Gabriel Cordero Soto> <Se agrega campo codTipoPuestoTrabajo en modificar puesto de trabajo>
-- Modificado por: <16/07/2021> <Cristian Cerdas Camacho> <Se agrega el parámetro de entrada UtilizaAppMovil>
-- Modificado por: <10/08/2021> <Cristian Cerdas Camacho> <Se modifica el parámetro de entrada UtilizaAppMovil para que reciba valores NULL>
-- =============================================
CREATE   PROCEDURE [Catalogo].[PA_ModificarPuestoTrabajo] 
	 @CodigoPuestoTrabajo	varchar(14),
	 @CodigoOficina			varchar(4),
	 @Descripcion			varchar(75),
	 @FechaVencimiento		datetime2(3),
	 @CodJornadaLaboral     smallint,
	 @CodTipoPuestoTrabajo  smallint,
	 @UtilizaAppMovil		bit = NULL
AS
BEGIN

	DECLARE @L_CodigoPuestoTrabajo      varchar(14)  = @CodigoPuestoTrabajo
	DECLARE @L_CodigoOficina	        varchar(4)   = @CodigoOficina
	DECLARE @L_Descripcion			    varchar(75)  = @Descripcion	
	DECLARE @L_FechaVencimiento         datetime2(3) = @FechaVencimiento
	DECLARE @L_CodJornadaLaboral        smallint     = @CodJornadaLaboral
	DECLARE @L_CodTipoPuestoTrabajo     smallint     = @CodTipoPuestoTrabajo
	DECLARE @L_UtilizaAppMovil			bit	

	IF (@UtilizaAppMovil IS NOT NULL)
		BEGIN
			SET @L_UtilizaAppMovil = @UtilizaAppMovil
		END
	ELSE
		BEGIN
			SET @L_UtilizaAppMovil = 0
		END

	UPDATE	Catalogo.PuestoTrabajo
	SET		TC_CodOficina				=	@L_CodigoOficina,
			TC_Descripcion				=	@L_Descripcion,
			TF_Fin_Vigencia				=	@L_FechaVencimiento,
			TN_CodJornadaLaboral        =   @L_CodJornadaLaboral,
			TN_CodTipoPuestoTrabajo     =   @L_CodTipoPuestoTrabajo,
			TB_UtilizaAppMovil			=	@L_UtilizaAppMovil

	WHERE	TC_CodPuestoTrabajo			=	@L_CodigoPuestoTrabajo
END


GO
