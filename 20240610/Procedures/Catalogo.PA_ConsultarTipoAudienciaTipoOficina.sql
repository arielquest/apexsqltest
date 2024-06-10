SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<21/11/2019>
-- Descripción :			<Permite Consultar los TipoOficinaMateria asociadas a un tipo de escrito> 
-- =================================================================================================================================================
-- Modificación:			<Jonathan Aguilar Navarro> <26/11/2019> <Se agragan las variables para T-SQL>
-- =================================================================================================================================================
-- Modificación:			<Jose Gabriel Cordero Soto> <21/05/2020> <Se ajusta condicion de fecha asociacion en WHERE>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoAudienciaTipoOficina]
	@CodigoTipoAudiencia		int				= Null,
	@CodigoTipoOficina			smallint		= Null,
	@CodigoMateria				varchar(5)		= Null,
	@FechaAsociacion			datetime2(3)	= Null
As
Begin	

	DECLARE	@L_CodigoTipoAudiencia		int					= @CodigoTipoAudiencia,
			@L_CodigoTipoOficina		smallint			= @CodigoTipoOficina,
			@L_CodigoMateria			varchar(5)			= @CodigoMateria,
			@L_FechaAsociacion			datetime2(3)		= @FechaAsociacion

		Select		A.TF_Inicio_Vigencia					As FechaAsociacion,
					'Split'									As Split,
					B.TN_CodTipoAudiencia					As Codigo,
					B.TC_Descripcion						As Descripcion,
					B.TF_Inicio_Vigencia   				    As FechaActivacion,
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
		From		Catalogo.TipoAudienciaTipoOficina		A With(Nolock) 
		Inner join	Catalogo.TipoAudiencia					B With(Nolock)
		On          B.TN_CodTipoAudiencia					= A.TN_CodTipoAudiencia
		Inner Join	Catalogo.TipoOficina					C With(Nolock) 
		On			C.TN_CodTipoOficina						= A.TN_CodTipoOficina
		Inner join	Catalogo.Materia						D With(Nolock)
		On			D.TC_CodMateria							= A.TC_CodMateria	
		Where		A.TN_CodTipoOficina						= COALESCE(@L_CodigoTipoOficina,A.TN_CodTipoOficina)
		And			A.TN_CodTipoAudiencia					= COALESCE(@L_CodigoTipoAudiencia,A.TN_CodTipoAudiencia)
		And			A.TC_CodMateria							= COALESCE(@L_CodigoMateria,A.TC_CodMateria)
		And			A.TF_Inicio_Vigencia					<= COALESCE(@L_FechaAsociacion, A.TF_Inicio_Vigencia)
		Order By	B.TC_Descripcion;
End
GO
