SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Josué Quirós Batista>
-- Fecha de creación:		<29/06/2021>
-- Descripción :			<Permite Consultar los tipos de los escritos que se han recibido en una oficina, con el objetivo de mostrarlos en el filtro del buzón.> 
-- =========================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoEscritoBuzon]
	@CodigoTipoOficina			smallint		= Null,
	@CodigoContexto				varchar(4)		= Null,
	@CodigoTipoEscrito			int				= Null,
	@FechaAsociacion			datetime2		= Null,
	@CodigoMateria				varchar(5)		= Null,
	@FechaActivacion			datetime2       = Null
As
Begin	
		DECLARE @L_CodigoTipoOficina			smallint	= @CodigoTipoOficina 
		DECLARE @L_CodigoContexto				varchar(4)	= @CodigoContexto
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
						B.TF_Fin_Vigencia							 As FechaDesactivacion
			From		Catalogo.TipoEscritoTipoOficina				 A With(Nolock) 
			Inner join	Catalogo.TipoEscrito						 B With(Nolock)
			On          B.TN_CodTipoEscrito						 	 = A.TN_CodTipoEscrito
			Inner Join	Catalogo.TipoOficina					 	 C With(Nolock) 
			On			C.TN_CodTipoOficina							 = A.TN_CodTipoOficina
			Inner join	Catalogo.Materia							 D With(Nolock)
			On			D.TC_CodMateria								 = A.TC_CodMateria	
			Where		A.TN_CodTipoEscrito							 = A.TN_CodTipoEscrito
			And			A.TN_CodTipoOficina							 =  COALESCE(@L_CodigoTipoOficina,A.TN_CodTipoOficina)
			And			A.TN_CodTipoEscrito							 = COALESCE(@L_CodigoTipoEscrito,A.TN_CodTipoEscrito)
			And         A.TC_CodMateria							     =  COALESCE(@L_CodigoMateria,A.TC_CodMateria)
			And			A.TF_Inicio_Vigencia						 = COALESCE(@L_FechaAsociacion, A.TF_Inicio_Vigencia)


	Union
			Select
			ISNULL(D.Inicio_Vigencia_TipoEscrito,GetDate())	 As FechaAsociacion,
			ISNULL(D.EsUrgente, 0)							 As EsUrgente,
			'Split'											 As Split,
			A.TN_CodTipoEscrito								 As Codigo,
			A.TC_Descripcion								 As Descripcion,
			A.TF_Inicio_Vigencia   							 As FechaActivacion,
			A.TF_Fin_Vigencia								 As FechaDesactivacion
		     From		Catalogo.TipoEscrito				 A With(Nolock) 
			Outer Apply (
			Select Distinct B.TN_CodTipoEscrito,		B.TC_Descripcion 
			From		Expediente.EscritoExpediente		A WITH(NOLOCK)
			Inner join	Catalogo.TipoEscrito				B With(Nolock)
			On          B.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
			Where		A.TC_CodContexto					= @L_CodigoContexto) OA
				OUTER APPLY	(
						SELECT		X.TB_Urgente						EsUrgente,
									X.TF_Inicio_Vigencia				Inicio_Vigencia_TipoEscrito,
									Y.TN_CodTipoOficina					CodigoTipoOficina,
									Y.TC_Nombre							DescripcionOficina,
									Y.TF_Inicio_Vigencia				Oficina_Inicio_Vigencia,
									Y.TF_Fin_Vigencia					Oficina_Fin_Vigencia,
									M.TC_CodMateria,
									M.TC_Descripcion					Descripcion_Materia,
									M.TF_Inicio_Vigencia				Inicio_Vigencia_Materia,
									M.TF_Fin_Vigencia					Fin_Vigencia_Materia
						FROM		Catalogo.Contexto					Z WITH(NOLOCK)
						INNER JOIN	Catalogo.Oficina					Y WITH(NOLOCK)
						ON			Y.TC_CodOficina						= Z.TC_CodOficina
						INNER JOIN Catalogo.Materia						M WITH(NOLOCK)
						On			M.TC_CodMateria						= Z.TC_CodMateria
						LEFT JOIN	Catalogo.TipoEscritoTipoOficina		X WITH(NOLOCK)
						ON			X.TC_CodMateria						= Z.TC_CodMateria
						AND			X.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
						AND			X.TN_CodTipoOficina					= Y.TN_CodTipoOficina
						WHERE		Z.TC_CodContexto					= @L_CodigoContexto
					) D
			where oa.TN_CodTipoEscrito  = a.TN_CodTipoEscrito
			Order By	B.TC_Descripcion
		END
		ELSE
		BEGIN

			Select		A.TF_Inicio_Vigencia						 As FechaAsociacion,
						A.TB_Urgente								 As EsUrgente,
						'Split'										 As Split,
						B.TN_CodTipoEscrito							 As Codigo,
						B.TC_Descripcion							 As Descripcion,
						B.TF_Inicio_Vigencia   						 As FechaActivacion,
						B.TF_Fin_Vigencia							 As FechaDesactivacion
			From		Catalogo.TipoEscritoTipoOficina				 A With(Nolock) 
			Inner join	Catalogo.TipoEscrito						 B With(Nolock)
			On          B.TN_CodTipoEscrito						 	 = A.TN_CodTipoEscrito
			Inner Join	Catalogo.TipoOficina					 	 C With(Nolock) 
			On			C.TN_CodTipoOficina							 = A.TN_CodTipoOficina
			Inner join	Catalogo.Materia							 D With(Nolock)
			On			D.TC_CodMateria								 = A.TC_CodMateria	
			Where		A.TN_CodTipoEscrito							 = A.TN_CodTipoEscrito
			And			A.TN_CodTipoOficina							 =  COALESCE(@L_CodigoTipoOficina,A.TN_CodTipoOficina)
			And         A.TC_CodMateria							     =  COALESCE(@L_CodigoMateria,A.TC_CodMateria)
			And			A.TN_CodTipoEscrito							 = COALESCE(@L_CodigoTipoEscrito,A.TN_CodTipoEscrito)
			And			A.TF_Inicio_Vigencia						 = COALESCE(@L_FechaAsociacion, A.TF_Inicio_Vigencia)
	Union
			Select
			ISNULL(D.Inicio_Vigencia_TipoEscrito,GetDate())	 As FechaAsociacion,
			ISNULL(D.EsUrgente, 0)							 As EsUrgente,
			'Split'											 As Split,
			A.TN_CodTipoEscrito								 As Codigo,
			A.TC_Descripcion								 As Descripcion,
			A.TF_Inicio_Vigencia   							 As FechaActivacion,
			A.TF_Fin_Vigencia								 As FechaDesactivacion
		     From		Catalogo.TipoEscrito				 A With(Nolock) 
			Outer Apply (
			Select Distinct B.TN_CodTipoEscrito,		B.TC_Descripcion 
			From		Expediente.EscritoExpediente		A WITH(NOLOCK)
			Inner join	Catalogo.TipoEscrito				B With(Nolock)
			On          B.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
			Where		A.TC_CodContexto					= @L_CodigoContexto) OA
				OUTER APPLY	(
						SELECT		X.TB_Urgente						EsUrgente,
									X.TF_Inicio_Vigencia				Inicio_Vigencia_TipoEscrito,
									Y.TN_CodTipoOficina					CodigoTipoOficina,
									Y.TC_Nombre							DescripcionOficina,
									Y.TF_Inicio_Vigencia				Oficina_Inicio_Vigencia,
									Y.TF_Fin_Vigencia					Oficina_Fin_Vigencia,
									M.TC_CodMateria,
									M.TC_Descripcion					Descripcion_Materia,
									M.TF_Inicio_Vigencia				Inicio_Vigencia_Materia,
									M.TF_Fin_Vigencia					Fin_Vigencia_Materia
						FROM		Catalogo.Contexto					Z WITH(NOLOCK)
						INNER JOIN	Catalogo.Oficina					Y WITH(NOLOCK)
						ON			Y.TC_CodOficina						= Z.TC_CodOficina
						INNER JOIN Catalogo.Materia						M WITH(NOLOCK)
						On			M.TC_CodMateria						= Z.TC_CodMateria
						LEFT JOIN	Catalogo.TipoEscritoTipoOficina		X WITH(NOLOCK)
						ON			X.TC_CodMateria						= Z.TC_CodMateria
						AND			X.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
						AND			X.TN_CodTipoOficina					= Y.TN_CodTipoOficina
						WHERE		Z.TC_CodContexto					= @L_CodigoContexto
					) D
			Where oa.TN_CodTipoEscrito  = a.TN_CodTipoEscrito
			And			CONVERT(VARCHAR(8), @L_FechaActivacion, 112) BETWEEN CONVERT(VARCHAR(8), A.TF_Inicio_Vigencia, 112) AND CONVERT(VARCHAR(8), ISNULL(A.TF_Fin_Vigencia, GETDATE()), 112)  	
			Order By	B.TC_Descripcion
End

End

GO
