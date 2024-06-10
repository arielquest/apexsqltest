SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================
-- Autor:		   <Johan Acosta>
-- Fecha Creación: <08/07/2016>
-- Descripcion:    <Agregar un puesto de trabajo>
-- Modifica        <06/02/2017><palvareze>Se agrega el campo Jornada laboral 
-- ==========================================================================
-- Modificado por: <Jose Gabriel Cordero Soto><23/06/2020><Se agrega campo CodTipoPuestoTrabajo a la sentencia de agregar>
-- Modificdo por <Cristian Cerdas Camacho><16/07/2021><Se agrega el parametro de entrada UtilizaAppMovil>
-- Modificado por: <10/08/2021> <Cristian Cerdas Camacho> <Se modifica el parámetro de entrada UtilizaAppMovil para que reciba valores NULL>
-- ==========================================================================
CREATE   PROCEDURE [Catalogo].[PA_AgregarPuestoTrabajo]
	 @CodigoPuestoTrabajo	varchar(14),
	 @CodigoOficina			varchar(4),
	 @Descripcion			varchar(75),
	 @FechaActivacion		datetime2(3),
	 @FechaVencimiento		datetime2(3),
	 @CodJornadaLaboral     smallint,
	 @CodTipoPuestoTrabajo  smallint,
	 @UtilizaAppMovil		bit
 As
 Begin
	
	DECLARE @L_CodigoPuestoTrabajo      varchar(14)  = @CodigoPuestoTrabajo
	DECLARE @L_CodigoOficina	        varchar(4)   = @CodigoOficina
	DECLARE @L_Descripcion			    varchar(75)  = @Descripcion	
	DECLARE @L_FechaActivacion          datetime2(3) = @FechaActivacion
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

    Insert into [Catalogo].[PuestoTrabajo]  (TC_CodPuestoTrabajo,
										 	 TC_CodOficina,
											 TN_CodTipoFuncionario,
											 TC_Descripcion,
											 TF_Inicio_Vigencia,
											 TF_Fin_Vigencia,
											 TN_CodJornadaLaboral,
											 TN_CodTipoPuestoTrabajo,
											 TB_UtilizaAppMovil)
                                   Values (	 @L_CodigoPuestoTrabajo
											,@L_CodigoOficina
											,null
											,@L_Descripcion
											,@L_FechaActivacion
											,@L_FechaVencimiento
										    ,@L_CodJornadaLaboral
											,@L_CodTipoPuestoTrabajo,
											@L_UtilizaAppMovil)
 
 End 



GO
