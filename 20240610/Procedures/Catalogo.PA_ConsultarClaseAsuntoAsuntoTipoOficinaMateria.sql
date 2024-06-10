SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<05/05/2021>
-- Descripción :			<Permite Consultar los AsuntoTipoOficinaMateria asociadas a una ClaseAsunto> 
-- =================================================================================================================================================
-- Modificado por:         <Jefferson Parker>
-- fecha de modificacion:  <05-08-2022>
-- Descripción:			   <Se agraga validacion para que solo se lleve los vigentes>
-- =================================================================================================================================================
CREATE       PROCEDURE [Catalogo].[PA_ConsultarClaseAsuntoAsuntoTipoOficinaMateria]
	@CodigoClaseAsunto			int				= Null,
	@CodigoTipoOficina			smallint		= Null,
	@CodigoAsunto				int				= Null,
	@FechaAsociacion			datetime2(7)	= Null,
	@CodigoMateria				varchar(5)		= Null
As
Begin	

		Declare     @L_TN_CodClaseAsunto  int		   = @CodigoClaseAsunto
		Declare     @L_TN_CodTipoOficina  smallint	   = @CodigoTipoOficina
		Declare     @L_TN_CodAsunto       int		   = @CodigoAsunto
		Declare     @L_TF_Inicio_Vigencia datetime2(7) = @FechaAsociacion
		Declare     @L_TC_CodMateria      varchar(5)   = @CodigoMateria

	--Registros activos
	IF @L_TF_Inicio_Vigencia  IS NOT NULL 
	BEGIN

		Select		A.TF_Inicio_Vigencia							As FechaAsociacion,	
					'Split'											As Split,
					B.TN_CodAsunto									As Codigo,
					B.TC_Descripcion								As Descripcion,
					B.TF_Inicio_Vigencia							As FechaActivacion,
					B.TF_Fin_Vigencia								As FechaDesactivacion,
					'Split'											As Split,
					C.TN_CodTipoOficina								As Codigo,
					C.TC_Descripcion								As Descripcion,
					C.TF_Inicio_Vigencia							As FechaActivacion,
					C.TF_Fin_Vigencia								As FechaDesactivacion,
					'Split'											As Split, 
					D.TC_CodMateria									As Codigo, 
					D.TC_Descripcion								As Descripcion, 
					D.TF_Inicio_Vigencia							As FechaActivacion, 
					D.TF_Fin_Vigencia								As FechaVencimiento,
				    'Split'											As Split, 
					E.TN_CodClaseAsunto								As Codigo, 
					E.TC_Descripcion								As Descripcion, 
					E.TF_Inicio_Vigencia							As FechaActivacion, 
					E.TF_Fin_Vigencia								As FechaVencimiento		
		From		Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria	A With(Nolock) 
		Inner join	Catalogo.Asunto									B With(Nolock)
		On          B.TN_CodAsunto									= A.TN_CodAsunto
		Inner Join	Catalogo.TipoOficina							C With(Nolock) 
		On			C.TN_CodTipoOficina								= A.TN_CodTipoOficina
		Inner join	Catalogo.Materia								D With(Nolock)
		On			D.TC_CodMateria									= A.TC_CodMateria	
		Inner join  Catalogo.ClaseAsunto							E With (Nolock)
		On			E.TN_CodClaseAsunto								=A.TN_CodClaseAsunto
		Where		A.TN_CodTipoOficina								= COALESCE(@L_TN_CodTipoOficina,A.TN_CodTipoOficina)
		And			A.TN_CodAsunto									= COALESCE(@L_TN_CodAsunto,A.TN_CodAsunto)
		And			A.TC_CodMateria									= COALESCE(@L_TC_CodMateria,A.TC_CodMateria)
		And			A.TN_CodClaseAsunto								= COALESCE(@L_TN_CodClaseAsunto,A.TN_CodClaseAsunto)
		AND			(A.TF_Inicio_Vigencia < GETDATE())
		And			E.TF_Inicio_Vigencia  < GETDATE ()
		And			(E.TF_Fin_Vigencia Is Null OR E.TF_Fin_Vigencia  >= GETDATE ())
		Order By	B.TC_Descripcion;
END
	-- Todos registros
	ELSE
	BEGIN		Select		A.TF_Inicio_Vigencia							As FechaAsociacion,	
					'Split'											As Split,
					B.TN_CodAsunto									As Codigo,
					B.TC_Descripcion								As Descripcion,
					B.TF_Inicio_Vigencia							As FechaActivacion,
					B.TF_Fin_Vigencia								As FechaDesactivacion,
					'Split'											As Split,
					C.TN_CodTipoOficina								As Codigo,
					C.TC_Descripcion								As Descripcion,
					C.TF_Inicio_Vigencia							As FechaActivacion,
					C.TF_Fin_Vigencia								As FechaDesactivacion,
					'Split'											As Split, 
					D.TC_CodMateria									As Codigo, 
					D.TC_Descripcion								As Descripcion, 
					D.TF_Inicio_Vigencia							As FechaActivacion, 
					D.TF_Fin_Vigencia								As FechaVencimiento,
				    'Split'											As Split, 
					E.TN_CodClaseAsunto								As Codigo, 
					E.TC_Descripcion								As Descripcion, 
					E.TF_Inicio_Vigencia							As FechaActivacion, 
					E.TF_Fin_Vigencia								As FechaVencimiento		
		From		Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria	A With(Nolock) 
		Inner join	Catalogo.Asunto									B With(Nolock)
		On          B.TN_CodAsunto									= A.TN_CodAsunto
		Inner Join	Catalogo.TipoOficina							C With(Nolock) 
		On			C.TN_CodTipoOficina								= A.TN_CodTipoOficina
		Inner join	Catalogo.Materia								D With(Nolock)
		On			D.TC_CodMateria									= A.TC_CodMateria	
		Inner join  Catalogo.ClaseAsunto							E With (Nolock)
		On			E.TN_CodClaseAsunto								=A.TN_CodClaseAsunto
		Where		A.TN_CodTipoOficina								= COALESCE(@L_TN_CodTipoOficina,A.TN_CodTipoOficina)
		And			A.TN_CodAsunto									= COALESCE(@L_TN_CodAsunto,A.TN_CodAsunto)
		And			A.TC_CodMateria									= COALESCE(@L_TC_CodMateria,A.TC_CodMateria)
		And			A.TN_CodClaseAsunto								= COALESCE(@L_TN_CodClaseAsunto,A.TN_CodClaseAsunto)
		Order By	B.TC_Descripcion;
	END

End
GO
