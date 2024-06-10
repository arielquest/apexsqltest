SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==============================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Cordero Benavides.>
-- Fecha de creación:		<17-Jul-2014.>
-- Descripción :			<Función para hacer un Split en SQL Server.>
-- ==============================================================================================================================
/*
Select	*
From	dbo.Util_Split ('A,B,C', ',')
*/
CREATE Function	[dbo].[Util_Split]
(
	@Cadena		NVarChar(Max),
    @Divisor	Char(1)
) 
Returns @Resultado Table	(
								Dato NVarChar(Max)
							) 
Begin
	--Declaración de variables.
	Declare @Inicio	Int = 1;
	Declare @Fin	Int = 0;
	Declare @msg	VarChar(Max);
	--Validaciones
	If Len(@Cadena) > 0 And CharIndex(@Divisor,@Cadena)> 0
	Begin
		--Determina el inicio y fin de la cadena.
		Set	@Fin	= CharIndex(@Divisor, @Cadena);
		--Recorrido de cadena para encontrar dato a dato
		While	@Inicio < Len(@Cadena) + 1
		Begin
		    If	@Fin = 0
			Begin
				Set	@Fin = Len(@Cadena) + 1;
			End
			Insert Into	@Resultado
			(
				Dato
			)  
		    Values
			(
				SubString(@Cadena, @Inicio, @Fin - @Inicio)
			);
		    Set @Inicio = @Fin + 1;
		    Set @Fin = CharIndex(@Divisor, @Cadena, @Inicio);
		End;
	End
	Else
	Begin
		Insert Into	@Resultado
		(
			Dato
		)  
		Values
		(
			@Cadena
		);
	End;
	Return;
End


GO
