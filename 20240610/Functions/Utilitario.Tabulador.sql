SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE Function	[Utilitario].[Tabulador] (@PalabraMasGrande Int, @PalabraMasPequeña VarChar(Max))
Returns VarChar(Max)
As
Begin
	Declare	@Resultado		VarChar(Max) = @PalabraMasPequeña,
			@Iteraciones	Float = 0.0,
			@Cantidad		Float = 0.0;
	Set @Iteraciones = Iif( Round((((@PalabraMasGrande - Len(@PalabraMasPequeña)) / 4.0) + 1.0), 0) < 1, 1, Round((((@PalabraMasGrande - Len(@PalabraMasPequeña)) / 4.0) + 1.0), 0) + 1)
	While @Cantidad	<= @Iteraciones
	Begin
		Set @Cantidad += 1.0;
		Set @Resultado += Char(9);
	End
	Return @Resultado;
End
GO
