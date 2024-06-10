SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Fabian Sequeira>
-- Fecha de creación:	<23/11/2020>
-- Descripción:			<Permite consultar la ultima ubicacion de un legajo en la tabla: LegajoUbicacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_ConsultarUltimaUbicacionLegajo]
		@NumeroExpediente			VARCHAR(14),
		@TU_CodLegajo				uniqueidentifier,
	    @CodContexto				VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_NumeroExpediente		VARCHAR(14)			= @NumeroExpediente
	DECLARE	@L_TU_CodLegajo			uniqueidentifier	= @TU_CodLegajo
    DECLARE	@L_CodContexto	        VARCHAR(4)			= @CodContexto

	--Lógica
	SELECT top 1	A.TU_CodLegajoUbicacion CodigoHistorico,
					A.TC_NumeroExpediente		NumeroExpediente,
					A.TF_FechaUbicacion		    FechaUbicacion,
					A.TC_Descripcion            Descripcion,
					'Split'                     Split,
					A.TU_CodLegajo				CodigoLegajo,
	    			B.TN_CodUbicacion			CodigoUbicacion,
					B.TC_Descripcion            DescripcionUbicacion,
					C.TC_UsuarioRed             UsuarioRed,
					C.TC_Nombre                 Nombre,
					C.TC_PrimerApellido         PrimerApellido,
					C.TC_SegundoApellido        SegundoApelido
	FROM	Historico.LegajoUbicacion		A WITH (NOLOCK)
	Inner Join		Catalogo.Ubicacion	   As	B With(Nolock)
	ON				A.TN_CodUbicacion    =	B.TN_CodUbicacion
	Inner Join		Catalogo.Funcionario   As	C With(Nolock)
	ON				A.TC_UsuarioRed      =	c.TC_UsuarioRed
	WHERE	        TC_NumeroExpediente  = @L_NumeroExpediente and
					TU_CodLegajo		 = @L_TU_CodLegajo and 	
	                TC_CodContexto       = @L_CodContexto
	ORDER BY		a.TF_FechaUbicacion	 DESC
END
GO
