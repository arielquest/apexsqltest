SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Roger Lara Hernandez>
-- Fecha de creación:	<20/11/2020>
-- Descripción:			<Permite consultar la ultima ubicacion de un expediente en la tabla: ExpedienteUbicacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Historico].[PA_ConsultarUltimaUbicacionExpediente]
		@NumeroExpediente			VARCHAR(14),
	    @CodContexto				VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_NumeroExpediente		VARCHAR(14)		= @NumeroExpediente
    DECLARE	@L_CodContexto	        VARCHAR(4)		= @CodContexto

	--Lógica
	SELECT top 1	A.TU_CodExpedienteUbicacion CodigoHistorico,
					A.TC_NumeroExpediente		NumeroExpediente,
					A.TF_FechaUbicacion		    FechaUbicacion,
					A.TC_Descripcion            Descripcion,
					'Split'                     Split,
	    			B.TN_CodUbicacion			CodigoUbicacion,
					B.TC_Descripcion            DescripcionUbicacion,
					C.TC_UsuarioRed             UsuarioRed,
					C.TC_Nombre                 Nombre,
					C.TC_PrimerApellido         PrimerApellido,
					C.TC_SegundoApellido        SegundoApelido
	FROM	Historico.ExpedienteUbicacion		A WITH (NOLOCK)
	Inner Join		Catalogo.Ubicacion	   As	B With(Nolock)
	ON				A.TN_CodUbicacion    =	B.TN_CodUbicacion
	Inner Join		Catalogo.Funcionario   As	C With(Nolock)
	ON				A.TC_UsuarioRed      =	c.TC_UsuarioRed
	WHERE	        TC_NumeroExpediente  = @L_NumeroExpediente and
	                TC_CodContexto       = @L_CodContexto
	ORDER BY		a.TF_FechaUbicacion	 DESC
END
GO
