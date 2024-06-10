SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:					Johan Acosta
-- Fecha Creación:			<10/11/2015>
-- Descripcion:				<Modificar una Barrio>
-- Modificación:			<Andrés Díaz><15/12/2016><Se agrega el campo TG_UbicacionPunto.>
-- Modificado por:			<Adrián Arias Abarca>
-- Fecha de modificación:	<08/01/2020>
-- Motivo:					<Se debe permitir modificar la provincia, cantón y distrito de un barrio, cuando este no esta asociado a ningun registro.> 
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_ModificarBarrio] 
	@CodigoProvincia		smallint, 
	@CodigoCanton			smallint, 
	@CodigoDistrito			smallint, 
	@Codigo					smallint, 
	@Descripcion			varchar(150),
	@Latitud				float			= Null,
	@Longitud				float			= Null,
	@FechaDesactivacion		datetime2		= Null
AS
BEGIN
	Declare		@CodigoProvinciaN		smallint		= @CodigoProvincia, 
				@CodigoCantonN			smallint		= @CodigoCanton, 
				@CodigoDistritoN		smallint		= @CodigoDistrito, 
				@CodigoN				smallint		= @Codigo, 
				@DescripcionN			varchar(150)	= @Descripcion,
				@LatitudN				float			= @Latitud,
				@LongitudN				float			= @Longitud,
				@FechaDesactivacionN	datetime2		= @FechaDesactivacion
	
	If Exists	(	
					Select	* 
					From	Catalogo.Barrio 
					Where	TN_CodProvincia		=	@CodigoProvinciaN 
					And		TN_CodCanton		=   @CodigoCantonN
					And		TN_CodDistrito		=   @CodigoDistritoN
					And		TN_CodBarrio		=   @CodigoN 
				)
	Begin
		Update	Catalogo.Barrio
		Set		TC_Descripcion			=	@DescripcionN,
				TG_UbicacionPunto		=	Iif(@LatitudN Is Not Null And @LongitudN Is Not Null, geography::Point(@LatitudN,@LongitudN,4326), Null),
				TF_Fin_Vigencia			=	@FechaDesactivacionN
		Where	TN_CodProvincia			=	@CodigoProvinciaN
		And		TN_CodCanton			=   @CodigoCantonN
		And		TN_CodDistrito			=   @CodigoDistritoN
		And		TN_CodBarrio			=   @CodigoN
	End
	Else
	Begin
		If Exists (Select Top 1 * From Comunicacion.Comunicacion Where TN_CodBarrio = @CodigoN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From DefensaPublica.ContraParteDomicilio Where TN_CodBarrio = @CodigoN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From DefensaPublica.RepresentacionDomicilio Where TN_CodBarrio = @CodigoN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Persona.Domicilio Where TN_CodBarrio = @CodigoN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Expediente.Expediente Where TN_CodBarrio = @CodigoN)
		Begin 
			Return
		End

		If Exists (Select Top 1 * From Expediente.IntervencionMedioComunicacion Where TN_CodBarrio = @CodigoN)
		Begin 
			Return
		End

		Update	Catalogo.Barrio
		Set		TN_CodProvincia			=	@CodigoProvinciaN,
				TN_CodCanton			=	@CodigoCantonN,
				TN_CodDistrito			=   @CodigoDistritoN,
				TC_Descripcion			=	@DescripcionN,
				TG_UbicacionPunto		=	Iif(@LatitudN Is Not Null And @LongitudN Is Not Null, geography::Point(@LatitudN,@LongitudN,4326), Null),
				TF_Fin_Vigencia			=	@FechaDesactivacionN
		Where	TN_CodBarrio			=   @CodigoN

	End	
End
GO
