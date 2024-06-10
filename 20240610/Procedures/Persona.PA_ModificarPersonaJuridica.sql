SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<14/09/2015>
-- Descripción :			<Permite modificar una persona Juridica> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<06/10/2015>
-- Descripción :			<Se combina el sp ModificarPersona con este para hacer uno solo.> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Se incluye fecha de actualiacion del registro.> 
-- Modificado por:			<Johan Acosta, 15/12/2015, CodtipoEntidad smallint>
-- Modificado por:			<Alejandro Villalta><06/01/2016><Cambiar tipo de dato del codigo del catalogo tipo identificación> 
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:			<Isaac Dobles><14/01/2019><Se modifica para actualizar campo TC_Origen en tabla Persona.Persona> 
-- Modificado por:			<Karol Jiménez S.><24/03/2021><Se modifica para quitar transacción de BD, se pasa al backend. Se valida nulo TC_Origen>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ModificarPersonaJuridica] 	
	@CodPersona				uniqueidentifier,
	@CodTipoIdentificacion	smallint, 
	@Identificacion			varchar(21),
	@Nombre					varchar(100),
	@NombreComercial		varchar(200),
	@CodTipoEntidad			smallint,
	@Origen					char(1)	
AS
BEGIN
		Update	Persona.Persona
		Set		TN_CodTipoIdentificacion	=	@CodTipoIdentificacion, 
				TC_Identificacion			=	@Identificacion,
				TF_Actualizacion			=	GETDATE(),
				TC_Origen					=	ISNULL(@Origen, TC_Origen)
		Where	TU_CodPersona				=	@CodPersona;

		Update	Persona.PersonaJuridica
		Set		TC_Nombre				=	@Nombre,
				TC_NombreComercial		=	@NombreComercial,
				TN_CodTipoEntidad		=	@CodTipoEntidad,
				TF_Actualizacion		=	GETDATE()
		Where	TU_CodPersona			=	@CodPersona;
END
GO
