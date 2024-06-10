SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<17/11/2015>
-- Descripción:				<Permite Modificar un Canton en la tabla Catalogo.Canton>
-- Modificado por:			<Adrián Arias Abarca>
-- Fecha de modificación:	<08/01/2020>
-- Motivo:					<Se debe permitir modificar la provincia de un cantón, cuando no tiene ningún registro asociado> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ModificarCanton]
	@CodProvincia	smallint,
	@CodCanton		smallint,
	@Descripcion	varchar(150),	
	@FinVigencia	datetime2
AS  
BEGIN
	Declare	@CodProvinciaN	smallint		= @CodProvincia,
			@CodCantonN		smallint		= @CodCanton,
			@DescripcionN	varchar(150)	= @Descripcion,	
			@FinVigenciaN	datetime2		= @FinVigencia

	If Exists (Select * From Catalogo.Canton Where TN_CodProvincia = @CodProvinciaN And TN_CodCanton = @CodCantonN)
	Begin 
		Update	Catalogo.Canton
		Set		TC_Descripcion		=	@DescripcionN,		
				TF_Fin_Vigencia		=	@FinVigenciaN				
		Where	TN_CodProvincia		=	@CodProvinciaN
		And		TN_CodCanton		=	@CodCantonN
	End 
	Else
	Begin
		If Exists (Select Top 1 * From Comunicacion.Comunicacion Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From DefensaPublica.ContraParteDomicilio Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From DefensaPublica.RepresentacionDomicilio Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Persona.Domicilio Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Expediente.Expediente Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Expediente.IntervencionMedioComunicacion Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Catalogo.Distrito Where TN_CodCanton = @CodCantonN)
		Begin 
			Return
		End

		Update	Catalogo.Canton
		Set		TC_Descripcion		=	@DescripcionN,		
				TF_Fin_Vigencia		=	@FinVigenciaN,
				TN_CodProvincia		=	@CodProvinciaN
		Where   TN_CodCanton		=	@CodCantonN
	End	
End





GO
