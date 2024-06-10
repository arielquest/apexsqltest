SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Henry Mendez Chavarria>
-- Fecha de creación:	<08/09/2015>
-- Descripción :		<Permite Agregar un nuevo medio de comunicacion en la tabla Catalogo.MedioComunicacion> 
-- Modificado :			<Alejandro Villalta><11/01/2016><Autogenerar el codigo de medio de comunicacion.> 
-- Modificación:		<Andrés Díaz> <04-03-2016> <Se agrega el campo TipoMedio.> 
-- Modificación:		<Andrés Díaz> <15-07-2016> <Se agregan los campos TB_TieneHorarioEspecial y TB_RequiereCopias.>
-- Modificación:		<Pablo Alvarez> <19-01-2017> <Se camnbia TB_RequiereCopias por PermiteCopias.>
-- Modificación:		<Pablo Alvarez> <20-01-2017> <Se camnbia el nombre del SP MedioComunicacion a TipoMedioComunicación.>
-- =================================================================================================================================================


CREATE PROCEDURE [Catalogo].[PA_AgregarTipoMedioComunicacion]
	@Descripcion			varchar(50),
	@TipoMedio				varchar(1),
	@TieneHorarioEspecial	bit,
	@PermiteCopias			bit,
	@InicioVigencia			datetime2(7),
	@FinVigencia			datetime2(7)
AS  
BEGIN  

	Insert Into		Catalogo.TipoMedioComunicacion
	(
		TC_Descripcion,		
		TC_TipoMedio,	
		TB_TieneHorarioEspecial,
		TB_PermiteCopias,
		TF_Inicio_Vigencia,		
		TF_Fin_Vigencia
	)
	Values
	(
		@Descripcion,		
		@TipoMedio,			
		@TieneHorarioEspecial,
		@PermiteCopias,
		@InicioVigencia,		
		@FinVigencia
	)
End
GO
