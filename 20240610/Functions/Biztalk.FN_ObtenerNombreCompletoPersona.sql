SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Alejandro Villalta>
-- Fecha de creación:		<12/09/2017>
-- Descripción :			<Obtiene el nombre completo de una persona física o juridica.Segun el tipo de persona y validando si los datos son nullos> 
-- =================================================================================================================================================
CREATE FUNCTION [Biztalk].[FN_ObtenerNombreCompletoPersona]
(
	@TipoPersona			char(1),
	@Nombre					varchar(100),
	@PrimerApellido			varchar(50),
	@SegundoApellido		varchar(50),
	@NombreEntidad			varchar(100)
)
RETURNS varchar(200)
AS
BEGIN

	Declare @Apellido1 As varchar(50)=CASE WHEN @PrimerApellido IS NULL THEN '' ELSE ' ' + @PrimerApellido END
	Declare @Apellido2 As varchar(50)=CASE WHEN @SegundoApellido IS NULL THEN '' ELSE ' ' + @SegundoApellido END

	Declare	@NombreCompleto As varchar(200) = IIF(@TipoPersona='F',@Nombre + @Apellido1 + @Apellido2 ,@NombreEntidad);
		  
	Return @NombreCompleto ;
END
GO
