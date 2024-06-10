SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<14/09/2015>
-- Descripción :			<Permite Modificar un Medio de Comunicacion en la tabla Catalogo.MedioComunicacion> 
-- Modificación :			<Alejandro Villalta><11/01/2016><Modificar el tipo de dato del codigo de codigo de medio de comunicación> 
-- Modificación:			<Andrés Díaz> <04-03-2016> <Se agrega el campo TipoMedio. Se cambia la descripción a varchar(50).> 
-- Modificación:			<Andrés Díaz> <15-07-2016> <Se agregan los campos TB_TieneHorarioEspecial y TB_PermiteCopias.>
-- Modificación:	    	<Pablo Alvarez> <02-12-2016> <Se modifica TN_CodMedioComunicación por estandar.>
-- Modificación:		    <Pablo Alvarez> <19-01-2017> <Se camnbia TB_RequiereCopias por PermiteCopias.>
-- Modificación:		    <Pablo Alvarez> <20-01-2017> <Se cambia el nombre del SP MedioComunicacion a TipoMedioComunicación.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoMedioComunicacion]
	@CodMedio				smallint,
	@Descripcion			varchar(50),
	@TipoMedio				varchar(1),	
	@TieneHorarioEspecial	bit,
	@PermiteCopias			bit,
	@FinVigencia			datetime2		
AS  
BEGIN
	Update	Catalogo.TipoMedioComunicacion
	Set		TC_Descripcion				=	@Descripcion,	
			TC_TipoMedio				=	@TipoMedio,
			TB_TieneHorarioEspecial		=	@TieneHorarioEspecial,
			TB_PermiteCopias			=	@PermiteCopias,
			TF_Fin_Vigencia				=	@FinVigencia				
	Where	TN_CodMedio					=	@CodMedio;
End



GO
