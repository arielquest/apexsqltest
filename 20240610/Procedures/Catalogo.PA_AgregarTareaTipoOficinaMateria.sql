SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<22/10/2020>
-- Descripción :			<Permite asociar un estado a un tipo de oficina y materia>
-- =================================================================================================================================================
-- Modificación:			<07/07/2021> <Daniel Ruiz Hernández> <Se agrega el parametro pase a fallo.>
-- Modificación:			<28/09/2021> <Isaac Santiago Méndez Castillo> <Se cambia el tipo de dato de la cantidad de horas (@CantidadHoras y 
--																		   @L_TN_CantidadHoras de smallint a int.>
-- =================================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_AgregarTareaTipoOficinaMateria]
	@CodTipoOficina			smallint,
	@CodTarea				smallint,
	@CodMateria				varchar(5),
	@FechaAsociacion		datetime2(7),
	@CantidadHoras			int,
	@PaseFallo				char(1)
AS 
BEGIN

	DECLARE	
	@L_TN_CodTipoOficina	smallint		=	@CodTipoOficina,
	@L_TN_CodTarea			smallint		=	@CodTarea,
	@L_TC_CodMateria		varchar(5)		=	@CodMateria,
	@L_TF_Inicio_Vigencia	datetime2(7)	=	@FechaAsociacion,
	@L_TN_CantidadHoras		int				=	@CantidadHoras,
	@L_TC_PaseFallo			char(1)			=	@PaseFallo


	INSERT INTO Catalogo.TareaTipoOficinaMateria
	(	
		TN_CodTipoOficina,		
		TN_CodTarea,	
		TC_CodMateria,	
		TF_Inicio_Vigencia,
		TN_CantidadHoras,
		TC_PaseFallo
	)
	VALUES
	(	
		@L_TN_CodTipoOficina,	
		@L_TN_CodTarea,		
		@L_TC_CodMateria,		
		@L_TF_Inicio_Vigencia,
		@L_TN_CantidadHoras,
		@L_TC_PaseFallo
	)
END

GO
