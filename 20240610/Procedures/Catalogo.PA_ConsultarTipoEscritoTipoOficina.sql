SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<23/09/2019>
-- Descripción :			<Permite Consultar los TipoOficinaMateria asociadas a un tipo de escrito> 
-- =================================================================================================================================================
-- Modificación :			<30/10/2019> <Isaac Dobles Mata> <Se agrega EsUrgente a la consulta>
-- =================================================================================================================================================
-- Modificación :			<30/04/2020> <Jose Gabriel Cordero Soto> <Se agrega nuevo parametro y una desición dependiendo del valor recibido y se agrega campo fechaactivacion>
-- =================================================================================================================================================
-- Modificación :			<04/05/2020> <Jose Gabriel Cordero Soto> <Se modifica uso de variables locales en consulta de SP>
-- =================================================================================================================================================
-- Modificación :			<05/05/2021> <Aida Elena Siles> <Se agrega la fecha de asociación en el where con coalesce para obtener unicamente los activos de la intermedia>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoEscritoTipoOficina]
	@CodigoTipoOficina			smallint		= Null,
	@CodigoTipoEscrito			int				= Null,
	@FechaAsociacion			datetime2		= Null,
	@CodigoMateria				varchar(5)		= Null,
	@FechaActivacion			datetime2       = Null
As
Begin	
		DECLARE @L_CodigoTipoOficina			smallint	= @CodigoTipoOficina 
		DECLARE @L_CodigoTipoEscrito			int			= @CodigoTipoEscrito
		DECLARE @L_FechaAsociacion				datetime2	= @FechaAsociacion
		DECLARE @L_CodigoMateria				varchar(5)	= @CodigoMateria
		DECLARE @L_FechaActivacion				datetime2	= @FechaActivacion

		IF(@L_FechaActivacion IS NULL)
		BEGIN
			Select		A.TF_Inicio_Vigencia						 As FechaAsociacion,
						A.TB_Urgente								 As EsUrgente,
						'Split'										 As Split,
						B.TN_CodTipoEscrito							 As Codigo,
						B.TC_Descripcion							 As Descripcion,
						B.TF_Inicio_Vigencia   						 As FechaActivacion,
						B.TF_Fin_Vigencia							 As FechaDesactivacion,
						'Split'										 As Split,
						C.TN_CodTipoOficina							 As Codigo,
						C.TC_Descripcion							 As Descripcion,
						C.TF_Inicio_Vigencia					  	 As FechaActivacion,
						C.TF_Fin_Vigencia							 As FechaDesactivacion,
						'Split'										 As Split, 
						D.TC_CodMateria								 As Codigo, 
						D.TC_Descripcion							 As Descripcion, 
						D.TF_Inicio_Vigencia						 As FechaActivacion, 
						D.TF_Fin_Vigencia							 As FechaVencimiento														 							
			From		Catalogo.TipoEscritoTipoOficina				 A With(Nolock) 
			Inner join	Catalogo.TipoEscrito						 B With(Nolock)
			On          B.TN_CodTipoEscrito						 	 = A.TN_CodTipoEscrito
			Inner Join	Catalogo.TipoOficina					 	 C With(Nolock) 
			On			C.TN_CodTipoOficina							 = A.TN_CodTipoOficina
			Inner join	Catalogo.Materia							 D With(Nolock)
			On			D.TC_CodMateria								 = A.TC_CodMateria	
			Where		A.TN_CodTipoOficina							 = COALESCE(@L_CodigoTipoOficina,A.TN_CodTipoOficina)
			And			A.TN_CodTipoEscrito							 = COALESCE(@L_CodigoTipoEscrito,A.TN_CodTipoEscrito)
			And			A.TC_CodMateria								 = COALESCE(@L_CodigoMateria,A.TC_CodMateria)
			And			A.TF_Inicio_Vigencia						 = COALESCE(@L_FechaAsociacion, A.TF_Inicio_Vigencia)
			Order By	B.TC_Descripcion
		END
		ELSE
		BEGIN
			SELECT		A.TF_Inicio_Vigencia						 As FechaAsociacion,
						A.TB_Urgente								 As EsUrgente,
						'Split'										 As Split,
						B.TN_CodTipoEscrito							 As Codigo,
						B.TC_Descripcion							 As Descripcion,
						B.TF_Inicio_Vigencia   						 As FechaActivacion,
						B.TF_Fin_Vigencia							 As FechaDesactivacion,
						'Split'										 As Split,
						C.TN_CodTipoOficina							 As Codigo,
						C.TC_Descripcion							 As Descripcion,
						C.TF_Inicio_Vigencia						 As FechaActivacion,
						C.TF_Fin_Vigencia							 As FechaDesactivacion,
						'Split'										 As Split, 
						D.TC_CodMateria								 As Codigo, 
						D.TC_Descripcion							 As Descripcion, 
						D.TF_Inicio_Vigencia						 As FechaActivacion, 
						D.TF_Fin_Vigencia							 As FechaVencimiento														 							
			FROM		Catalogo.TipoEscritoTipoOficina				 A With(Nolock) 
			Inner join	Catalogo.TipoEscrito						 B With(Nolock)
			ON          B.TN_CodTipoEscrito							 = A.TN_CodTipoEscrito
			Inner Join	Catalogo.TipoOficina						 C With(Nolock) 
			ON			C.TN_CodTipoOficina							 = A.TN_CodTipoOficina
			Inner join	Catalogo.Materia							 D With(Nolock)
			ON			D.TC_CodMateria								 = A.TC_CodMateria	
			WHERE		A.TN_CodTipoOficina							 = COALESCE(@L_CodigoTipoOficina,A.TN_CodTipoOficina)
			AND			A.TN_CodTipoEscrito							 = COALESCE(@L_CodigoTipoEscrito,A.TN_CodTipoEscrito)
			AND			A.TC_CodMateria								 = COALESCE(@L_CodigoMateria,A.TC_CodMateria)
			And			A.TF_Inicio_Vigencia						 <= COALESCE(@L_FechaAsociacion, A.TF_Inicio_Vigencia)
			AND			CONVERT(VARCHAR(8), @L_FechaActivacion, 112) BETWEEN CONVERT(VARCHAR(8), B.TF_Inicio_Vigencia, 112) AND CONVERT(VARCHAR(8), ISNULL(B.TF_Fin_Vigencia, GETDATE()), 112)  	
			ORDER BY	B.TC_Descripcion
		END
End
GO
