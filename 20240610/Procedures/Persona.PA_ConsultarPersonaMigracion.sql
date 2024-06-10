SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Adrián Arias Abarca>
-- Fecha de creación:		<08/09/2023>
-- Descripción:				<Procedimiento almacenado creado para optimizar los tiempos de consultas de los ETLs de migración de precarga a carga con los siguientes pasos:
--							1.- Se optimiza la consulta pasando de un esquema de sub consultas que realiza el SSIS por defecto a common table expression
--							2.- Se toman por factor comun los filtros que pueden ser aplicados en la primera consulta a efectos de no traer todos los datos de las tablas donde 
--								se guarda la información de las personas para posteriormente filtrar, sino traer la menor cantidad de información posible desde el inicio.
--							3.- Se separan las consultas de personas físicas y juridicas, ya que la consulta era general, trayendo información de los tipos de personas, para al final
--								de la consulta hacer la distinción>
--							4.- Se convierte la consulta en un procedimiento almacenado (SP) para aprovechar los beneficios de los planes de ejecución que el motor de base de datos guarda 
--								despues de la primera ejecución de un SP, además de la estadística que se pueda generar y que pueda ayudar en futuras mejoras.>
-- =========================================================================================================
-- Fecha de modificación:	<06/12/2023> 	
-- Modificado por:		    <Adrián Arias Abarca>
-- Descripción:             <Se modifica la forma en como se optienen el nombre de la persona en la CTE PersonaPreseleccionadas para personas físicas, ya que por error se pasaba un apóstrofe 
--							si el segundo apellido era null. Tambien se corrije la comparación de nombres en la consulta de personas jurídicas, para que pueda realizar validaciones en caso de
--							que el nombre venga nulo>
-- =========================================================================================================
CREATE PROCEDURE [Persona].[PA_ConsultarPersonaMigracion] 
--Variables de entrada(imput)
			@I_IDINT				int,
			@I_Identificacion		VarChar(21),
			@I_Nombre				VarChar(200),
			@I_TipoPersona			VarChar(1)
AS
BEGIN
	--VARIABLES LOCALES
	DECLARE		@IDINT				int				= @I_IDINT,
				@Identificacion		VarChar(21)		= @I_Identificacion,
				@Nombre				VarChar(200)	= @I_Nombre,
				@TipoPersona		VarChar(1)		= @I_TipoPersona;
	--LÓGICA
	If	@TipoPersona = 'F'
	Begin
		With	PersonasPreselecionadas As 
		(
			SELECT		P.TU_CodPersona,
						P.TC_CodTipoPersona,
						P.TN_CodTipoIdentificacion,
						P.TC_Identificacion,
						P.IDINT,
						TRIM(PF.TC_Nombre) + TRIM(PF.TC_PrimerApellido) + ISNULL(TRIM(PF.TC_SegundoApellido), '') TC_Nombre		
			FROM		Persona.Persona			P	WITH(NOLOCK)
			LEFT JOIN	Persona.PersonaFisica	PF	WITH(NOLOCK)
			ON			PF.TU_CodPersona		=	P.TU_CodPersona
			Where		(P.IDINT				is null
			Or			P.IDINT					= @IDINT)
			And			(P.TC_Identificacion		is null
			Or			P.TC_Identificacion		= @Identificacion)
			And			P.TC_CodTipoPersona		= @TipoPersona
		) 
		Select	* 
		From	PersonasPreselecionadas P
		Where	(	
					(P.[IDINT] IS NOT NULL /*Si el registro tiene IDINT En Carga*/
					AND	(	P.[IDINT] = @IDINT
							AND (
									P.[TC_Identificacion]	= @Identificacion 
									OR (/*Si la identificación es nula, pero el nombre si coincide*/
											(P.[TC_Identificacion] IS NULL OR @Identificacion /*TC_Identificacion*/ IS NULL)
											AND P.TC_Nombre	= @Nombre
										)
								)
								OR (
										([TC_Identificacion] IS NULL OR @Identificacion /*TC_Identificacion*/ IS NULL) 
										And P.TC_Nombre = @Nombre
								)
						) 
					)
					OR 
					([IDINT] IS NULL /*Si el registro no tiene IDINT en Carga*/
						AND [TC_Identificacion]	= @Identificacion /*Pero tiene número de identificación*/
						AND P.TC_Nombre	= @Nombre /*Pero validamos que sea la misma persona*/
					)
					OR (
						P.TU_CodPersona IS NULL /*VALOR ERRÓNEO PARA QUE NO RETORNE NADA SI NO ENCONTRÓ DATOS CON LOS FILTROS ANTERIORES*/
					)
				)
	End
	
	Else 
	Begin 
		With		PersonasPreselecionadas As 
		(
			SELECT		P.TU_CodPersona,
						P.TC_CodTipoPersona,
						P.TN_CodTipoIdentificacion,
						P.TC_Identificacion,
						P.IDINT,
						PJ.TC_NombreComercial TC_Nombre		
			FROM		Persona.Persona			P	WITH(NOLOCK)
			LEFT JOIN	Persona.PersonaJuridica	PJ	WITH(NOLOCK)
			ON			PJ.TU_CodPersona		=	P.TU_CodPersona
			Where		(P.IDINT				is null
			Or			P.IDINT					= @IDINT)
			And			(P.TC_Identificacion		is null
			Or			P.TC_Identificacion		= @Identificacion)
			And			P.TC_CodTipoPersona		= @TipoPersona
		) 
		Select	* 
		From	PersonasPreselecionadas P
		Where	(	
					(P.[IDINT] IS NOT NULL /*Si el registro tiene IDINT En Carga*/
					AND	(	P.[IDINT] = @IDINT
							AND (
									P.[TC_Identificacion]	= @Identificacion 
									OR (/*Si la identificación es nula, pero el nombre si coincide*/
											(P.[TC_Identificacion] IS NULL OR @Identificacion /*TC_Identificacion*/ IS NULL)
											AND COALESCE(P.TC_Nombre, '')	= COALESCE(@Nombre, '')
										)
								)
								OR (
										([TC_Identificacion] IS NULL OR @Identificacion /*TC_Identificacion*/ IS NULL) 
										And COALESCE(P.TC_Nombre, '') = COALESCE(@Nombre, '')
								)
						) 
					)
					OR 
					([IDINT] IS NULL /*Si el registro no tiene IDINT en Carga*/
						AND [TC_Identificacion]	= @Identificacion /*Pero tiene número de identificación*/
						AND P.TC_Nombre	= @Nombre /*Pero validamos que sea la misma persona*/
					)
					OR (
						P.TU_CodPersona IS NULL /*VALOR ERRÓNEO PARA QUE NO RETORNE NADA SI NO ENCONTRÓ DATOS CON LOS FILTROS ANTERIORES*/
					)
				)
	End	
      
END



GO
