SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Isaac Dobles Mata>
-- Fecha de creación:		<14/02/2019>
-- Descripción :			<Permite Consultar los TipoOficinaMateria asociadas a un Asunto> 
-- Modificación:			<31/10/2021> <Luis Alonso Leiva Tames> <Se agrega la fecha fin para obtener solo los activos>  

-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ConsultarAsuntoTipoOficina]
	@CodigoTipoOficina			smallint		= Null,
	@CodigoAsunto				int				= Null,
	@FechaAsociacion			datetime2(7)	= Null,
	@CodigoMateria				varchar(5)		= Null
As
Begin	
--Registros activos
	IF @FechaAsociacion  IS NOT NULL 
	BEGIN
		Select		A.TF_Inicio_Vigencia					As FechaAsociacion,	
					'Split'									As Split,
					B.TN_CodAsunto							As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia					As FechaActivacion,
					B.TF_Fin_Vigencia						As FechaDesactivacion,
					'Split'									As Split,
					C.TN_CodTipoOficina						As Codigo,
					C.TC_Descripcion						As Descripcion,
					C.TF_Inicio_Vigencia					As FechaActivacion,
					C.TF_Fin_Vigencia						As FechaDesactivacion,
					'Split'									As Split, 
					D.TC_CodMateria							As Codigo, 
					D.TC_Descripcion						As Descripcion, 
					D.TF_Inicio_Vigencia					As FechaActivacion, 
					D.TF_Fin_Vigencia						As FechaVencimiento														 							
		From		Catalogo.AsuntoTipoOficina				A With(Nolock) 
		Inner join	Catalogo.Asunto							B With(Nolock)
		On          B.TN_CodAsunto							= A.TN_CodAsunto
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			C.TN_CodTipoOficina						= A.TN_CodTipoOficina
		Inner join	Catalogo.Materia						D With(Nolock)
		On			D.TC_CodMateria							= A.TC_CodMateria	
		Where		A.TN_CodTipoOficina						= COALESCE(@CodigoTipoOficina,A.TN_CodTipoOficina)
		And			A.TN_CodAsunto							= COALESCE(@CodigoAsunto,A.TN_CodAsunto)
		And			A.TC_CodMateria							= COALESCE(@CodigoMateria,A.TC_CodMateria)
		AND			(A.TF_Inicio_Vigencia < GETDATE())
		AND			(B.TF_Fin_Vigencia >= GETDATE() OR B.TF_Fin_Vigencia IS NULL)
		Order By	B.TC_Descripcion;
	END
	-- Todos registros
	ELSE
	BEGIN
			Select		A.TF_Inicio_Vigencia					As FechaAsociacion,	
					'Split'									As Split,
					B.TN_CodAsunto							As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia					As FechaActivacion,
					B.TF_Fin_Vigencia						As FechaDesactivacion,
					'Split'									As Split,
					C.TN_CodTipoOficina						As Codigo,
					C.TC_Descripcion						As Descripcion,
					C.TF_Inicio_Vigencia					As FechaActivacion,
					C.TF_Fin_Vigencia						As FechaDesactivacion,
					'Split'									As Split, 
					D.TC_CodMateria							As Codigo, 
					D.TC_Descripcion						As Descripcion, 
					D.TF_Inicio_Vigencia					As FechaActivacion, 
					D.TF_Fin_Vigencia						As FechaVencimiento														 							
		From		Catalogo.AsuntoTipoOficina				A With(Nolock) 
		Inner join	Catalogo.Asunto							B With(Nolock)
		On          B.TN_CodAsunto							= A.TN_CodAsunto
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			C.TN_CodTipoOficina						= A.TN_CodTipoOficina
		Inner join	Catalogo.Materia						D With(Nolock)
		On			D.TC_CodMateria							= A.TC_CodMateria	
		Where		A.TN_CodTipoOficina						= COALESCE(@CodigoTipoOficina,A.TN_CodTipoOficina)
		And			A.TN_CodAsunto							= COALESCE(@CodigoAsunto,A.TN_CodAsunto)
		And			A.TC_CodMateria							= COALESCE(@CodigoMateria,A.TC_CodMateria)
		Order By	B.TC_Descripcion;
	END
End
GO
