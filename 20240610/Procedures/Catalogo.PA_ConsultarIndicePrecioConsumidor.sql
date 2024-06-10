SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<22/11/2018>
-- Descripción :			<Permite consultar el indice del precio de consumidor> 
-- Modificado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de modificación:	<19/12/2018>
-- Descripción :			<Permite consultar el indice del precio de consumidor por rangos> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarIndicePrecioConsumidor]
	@Codigo				int	= Null,
	@MesInicio			int = Null,
	@AnnoInicio			int = Null,
	@MesFin				int = Null,
	@AnnoFin			int = Null
 As
 Begin
  
  If (@AnnoInicio IS NOT NULL AND @MesInicio IS NOT NULL AND @AnnoFin IS NOT NULL AND @MesFin IS NOT NULL)
	Begin
			Select		DISTINCT	TN_Codigo	As	Codigo,
									TN_Valor	As	Valor,
									TN_Mes		As	Mes,
									TN_Anno		As	Anno	
			From		Catalogo.IndicePrecioConsumidor	With(Nolock) 	
			Where		CAST(CAST(TN_Anno AS Varchar(4)) + RIGHT('0' + CAST(TN_Mes AS VARCHAR(2)), 2) + '01' AS datetime2) >=  CAST(CAST(@AnnoInicio AS Varchar(4)) + RIGHT('0' + CAST(@MesInicio AS VARCHAR(2)), 2) + '01' AS datetime2)
			And			CAST(CAST(TN_Anno AS Varchar(4)) + RIGHT('0' + CAST(TN_Mes AS VARCHAR(2)), 2) + '01' AS datetime2) <=  CAST(CAST(@Annofin AS Varchar(4)) + RIGHT('0' + CAST(@MesFin AS VARCHAR(2)), 2) + '01' AS datetime2)
			Order By	TN_Anno, TN_Mes;
	End
  Else
	Begin
			Select		TN_Codigo	As	Codigo,
						TN_Valor	As	Valor,
						TN_Mes		As	Mes,
						TN_Anno		As	Anno	
			From		Catalogo.IndicePrecioConsumidor	With(Nolock) 	
			Where		TN_Codigo	=	Coalesce(@Codigo, TN_Codigo) 
			Order By	TN_Anno, TN_Mes;
	End
 End
GO
