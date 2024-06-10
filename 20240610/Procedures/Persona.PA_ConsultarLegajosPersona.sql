SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Sigifredo Leitón Luna>
-- Fecha de creación:		<23/09/2015>
-- Descripción :			<Consulta los legajos en los cuales la persona pertenece>
-- Modificación :			<Se cambia la linea If @CodPersona Is Null And @Identificacion Is Null por If @CodPersona Is NOT Null And @Identificacion Is NOT Null no tienen sentido evaluar los parametros si son nulos ambos valores 25/08/2016 Johan Acosta>
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodClaseAsunto a TN_CodClaseAsunto de acuerdo al tipo de dato.>
-- Modificación:			<24/09/2019> <Isaac Dobles Mata> <Se modifica ClaseAsunto a Clase.>
-- =================================================================================================================================================
CREATE PROCEDURE [Persona].[PA_ConsultarLegajosPersona]
	@CodPersona		uniqueidentifier = Null,
	@Identificacion Varchar(21) = Null 
As
BEGIN	
	If @CodPersona Is Not Null And @Identificacion Is Null
	Begin 	
		Select	C.TC_NumeroExpediente, C.TB_Confidencial, 'Split' AS Split,
				D.TN_CodClase, E.TC_Descripcion
		From	Expediente.Interviniente A
		Inner Join Expediente.Intervencion B
		On	A.TU_CodInterviniente = B.TU_CodInterviniente
		Inner Join Expediente.Expediente C
		On B.TC_NumeroExpediente = C.TC_NumeroExpediente
		Inner Join Expediente.ExpedienteDetalle D
		On  C.TC_NumeroExpediente = D.TC_NumeroExpediente
		Inner Join Catalogo.Clase E
		On	D.TN_CodClase= E.TN_CodClase
		Where	B.TU_CodPersona = @CodPersona	
	End
	If @CodPersona Is Null And @Identificacion Is Not Null
	Begin 	
		Select	C.TC_NumeroExpediente, C.TB_Confidencial, 'Split' AS Split,
				D.TN_CodClase, F.TC_Descripcion
		From	Persona.Persona E
		Inner Join Expediente.Intervencion A
			On E.TU_CodPersona = A.TU_CodPersona
		Inner Join Expediente.Interviniente B
			On	A.TU_CodInterviniente = B.TU_CodInterviniente
		Inner Join Expediente.Expediente C
			On A.TC_NumeroExpediente = C.TC_NumeroExpediente
			Inner Join Expediente.ExpedienteDetalle D
			On C.TC_NumeroExpediente = D.TC_NumeroExpediente
		Inner Join Catalogo.Clase F
			On	D.TN_CodClase= F.TN_CodClase
		Where	e.TC_Identificacion = @Identificacion
	End
	If @CodPersona Is NOT Null And @Identificacion Is NOT Null
	Begin 	
		Select	C.TC_NumeroExpediente, C.TB_Confidencial, 'Split' AS Split,
				D.TN_CodClase, F.TC_Descripcion
		From	Persona.Persona E
		Inner Join Expediente.Intervencion A
			On E.TU_CodPersona = A.TU_CodPersona
		Inner Join Expediente.Interviniente B
			On	A.TU_CodInterviniente = B.TU_CodInterviniente
		Inner Join Expediente.Expediente C
			On A.TC_NumeroExpediente = C.TC_NumeroExpediente
			Inner Join Expediente.ExpedienteDetalle D
			On C.TC_NumeroExpediente = D.TC_NumeroExpediente
		Inner Join Catalogo.Clase F
			On	D.TN_CodClase= F.TN_CodClase
		Where	A.TU_CodPersona = @CodPersona
		And		E.TC_Identificacion = @Identificacion
	End
 END


GO
