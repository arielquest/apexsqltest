SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<28-03-2023>
-- Descripción :			<Permite consultar los barrios de un sector>
-- ===========================================================================================
CREATE   PROCEDURE [Comunicacion].[PA_ConsultarSectorBarrio]
	@CodSector		smallint
As
Begin
	 
	 		Select		A.TN_CodBarrio				As	Codigo,
						A.TC_Descripcion			As	Descripcion,
						A.TF_Inicio_Vigencia		As	FechaActivacion,
						A.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Distrito,
						B.TN_CodDistrito			As	Codigo,
						B.TC_Descripcion			As	Descripcion,
						B.TF_Inicio_Vigencia		As	FechaActivacion,
						B.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Canton,
						C.TN_CodCanton				As	Codigo,
						C.TC_Descripcion			As	Descripcion,
						C.TF_Inicio_Vigencia		As	FechaActivacion,
						C.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Provincia,
						D.TN_CodProvincia			As	Codigo,
						D.TC_Descripcion			As	Descripcion,
						D.TF_Inicio_Vigencia		As	FechaActivacion,
						D.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split,
						A.TG_UbicacionPunto.Lat		As	Latitud,
						A.TG_UbicacionPunto.Long	As	Longitud
			From	    Catalogo.Barrio				As	A With(Nolock) 	
			Inner Join	Catalogo.Distrito			As	B With(Nolock) 	
			On			B.TN_CodProvincia			=	A.TN_CodProvincia 
			And			B.TN_CodCanton				=	A.TN_CodCanton
			And			B.TN_CodDistrito			=	A.TN_CodDistrito  
			Inner Join	Catalogo.Canton				As	C With(Nolock) 	
			On			C.TN_CodProvincia			=	B.TN_CodProvincia 
			And			C.TN_CodCanton				=	B.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As	D With(Nolock)
			On			D.TN_CodProvincia			=	C.TN_CodProvincia

			Inner Join	Comunicacion.SectorBarrio  as   S With(Nolock)
			On			A.TN_CodBarrio				=   S.TN_CodBarrio
			And			B.TN_CodDistrito			=	S.TN_CodDistrito
			And			C.TN_CodCanton				=	S.TN_CodCanton
			And			D.TN_CodProvincia			=	S.TN_CodProvincia

			Where		S.TN_CodSector			 =   @CodSector
			And			A.TF_Inicio_Vigencia	<=		GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;

	  		
End

GO
