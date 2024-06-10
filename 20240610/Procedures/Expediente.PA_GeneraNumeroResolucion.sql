SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Gerardo Lopez  >
-- Fecha Creación:		<26/05/2016>
-- Descripcion:			<Obtiene el ultimo consecutivo y genera el numero de voto según el despacho
--
-- Modificación:		<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_Periodo a TN_Periodo de acuerdo al tipo de dato.>
 -- =============================================
CREATE PROCEDURE [Expediente].[PA_GeneraNumeroResolucion] 
	@CodOficina varchar(4)
As
Begin
	Declare @Consecutivo varchar(6)
	Declare @Periodo Int


    --1.Obtener el periodo actual
	Set @Periodo = DATEPART(YEAR, Getdate())		

    --2.Si no existe o esta vencido crea el registro para el AÑO ACTUAL 
    If Not Exists(Select TN_Consecutivo From Expediente.ConsecutivoResolucion With(Nolock)
	               Where TN_Periodo = @Periodo And TC_Oficina = @CodOficina)
	Begin      	
		Insert Into Expediente.ConsecutivoResolucion
				(TC_Oficina,	TN_Periodo,	TN_Consecutivo,	TB_Automatico, TF_Desactivacion,	TF_Actualizacion)
		Values  (@CodOficina,	@Periodo,	0, 	 1,			NULL,				Getdate())
	End

	
	--2.Obtener consecutivo

	Update	Expediente.ConsecutivoResolucion  With(Rowlock)
	Set		TN_Consecutivo = TN_Consecutivo + 1, 
			@Consecutivo = right('000000' + Convert(varchar,TN_Consecutivo + 1) ,6),
			TF_Actualizacion = Getdate()
	Where	TN_Periodo = @Periodo		And    
			TC_Oficina = @CodOficina	
		
		
	  --3. Obtiene el numero sentencia  formato[oficina-periodo-consecutivo] '0000-000000'
			Select    Convert(varchar, @Periodo) + @Consecutivo
End


 
GO
