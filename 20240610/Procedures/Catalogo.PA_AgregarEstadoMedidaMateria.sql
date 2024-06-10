SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Gabriel Cordero Soto>
-- Fecha de creación:		<06-10-2022>
-- Descripción :			<Realizar nuevo registro sobre EstadoMedidaMateria>
-- =============================================================================================================================================================================
-- Modificación:			<18/11/2022><Karol Jiménez Sánchez> <Se agrega parámetro para recibir la Fecha Inicio Vigencia de la materia asociada al estado de la medida>
-- =============================================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_AgregarEstadoMedidaMateria]
	@CodEstado			SMALLINT,
	@CodMateria			VARCHAR(5),
	@FechaAsociacion	DATETIME2(3)
AS
BEGIN	
	DECLARE @L_CodEstado			SMALLINT		= @CodEstado,
			@L_CodMateria			VARCHAR(5)		= @CodMateria,
			@L_TF_Fecha_Asociacion	DATETIME2(3)	= @FechaAsociacion;

	INSERT INTO [Catalogo].[EstadoMedidaMateria] WITH(ROWLOCK)
           ([TN_CodEstado], [TC_CodMateria],	TF_Fecha_Asociacion)
     VALUES
           (@L_CodEstado,	@L_CodMateria,		@L_TF_Fecha_Asociacion )
END
GO
