SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Pablo Alvarez>
-- Fecha Creación:		<28/08/2015>
-- Descripcion:			<Obtiene el ultimo consecutivo y genera el numero de expediente según el despacho
-- =====================================================================================================================================================
-- Modificado:			<Johan Acosta> 
-- Fecha Modificación:	<01/12/2015>
-- Descripcion:			<Se realiza por periodo (DATEPART(YEAR, Getdate())) y se invalida si es activo o no según la fecha>
--
-- Modificación:		<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_Periodo y TC_CodTipoOficina a TN_Periodo y TN_CodTipoOficina de acuerdo al tipo de dato.>
-- Modificación:		<06/11/2017> <Diego Navarrete Alvarez>  <Se corrige 2. Obtener el tipo de oficina para obtener la materia, ya que la tabla ahora tiene el codigo de materia no es necesario realizar el join >
-- Modificación:		<30/04/2018> <Jonathan Aguilar Navarro>  <Se cambia TC_Oficina por TC_CodContexto >
-- Modificación:		<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_GeneraNumeroExpediente] 
	@CodContexto varchar(4)
As
Begin
	
	Declare @NumeroExpediente varchar(14)
	Declare @CONSECUTIVO Int
	Declare @ConsecutivoNue varchar(6)
	Declare @Periodo Int
	Declare @ANNIO VARCHAR(2)
	Declare @Materia Varchar(2)


    --1.Obtener el periodo actual
	Set @Periodo = DATEPART(YEAR, Getdate())		

    --2.Si no existe o esta vencido crea el registro para el AÑO ACTUAL 
    If Not Exists(Select * From Expediente.ConsecutivoExpediente With(Nolock) Where TN_Periodo = @Periodo And TC_CodContexto = @CodContexto)
	Begin      	
		Insert Into Expediente.ConsecutivoExpediente
				(TC_CodContexto,	TN_Periodo,	TN_Consecutivo,	TF_Desactivacion,	TF_Actualizacion)
		Values  (@CodContexto,	@Periodo,	0, 				NULL,				Getdate())
	End

	 --2. Obtener la materia.			

	Select		@Materia			= B.TC_CodMateria
	from		Catalogo.Contexto		as B With(NoLock)
	where		B.TC_CodContexto		= @CodContexto

	--3.Obtener consecutivo

	Update	Expediente.ConsecutivoExpediente  With(Rowlock)
	Set		TN_Consecutivo = TN_Consecutivo + 1, 
			@ConsecutivoNue = right('000000' + Convert(varchar,TN_Consecutivo + 1) ,6),
			TF_Actualizacion = Getdate()
	Where	TN_Periodo = @Periodo		And    
			TC_CodContexto = @CodContexto	
		
		
	  --4. Obtiene el año en 2 digitos
			Select Convert(varchar, Substring(Convert(varchar,@Periodo),3,4)) + @ConsecutivoNue + @CodContexto + @Materia  
End
GO
