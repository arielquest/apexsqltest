SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================
-- Autor:				<Esteban Cordero Benavides.>
-- Fecha Creación:		<26 de abril de 2016.>
-- Descripcion:			<Permite Consultar los tipos de archivo.>
--
-- Modificación:		<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarTipoArchivo]
	@TN_CodTipoArchivo	Int				= Null,
	@TC_Descripcion		VarChar(100)	= Null,
	@TC_CodMateria		VarChar(5)		= Null,
	@TC_CodPrioridad	SmallInt		= Null,
	@TF_Inicio_Vigencia	DateTime2(3)	= Null,
	@TF_Fin_Vigencia	DateTime2(3)	= Null
As
Begin
	--Variable para almacenar la descripcion.
	Declare	@ExpresionLike VarChar(200);
	Set	@ExpresionLike	= iif(@TC_Descripcion Is Not Null, '%' + @TC_Descripcion + '%', '%')

	--Si todo es nulo se devuelven todos los registros
	If	@TN_CodTipoArchivo Is Null 
	And @TC_CodMateria Is Null 
	And @TC_CodPrioridad Is Null 
	And @TF_Inicio_Vigencia Is Null 
	And @TF_Fin_Vigencia Is Null
	Begin	
			Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
						A.TF_Fin_Vigencia FechaDesactivacion,
						'Split_Materia' Split_Materia,
						A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
						B.TF_Fin_Vigencia FechaDesactivacion,	
						'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
						C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
			From		Catalogo.TipoArchivo					A With(NoLock)
			Inner Join	Catalogo.Materia						B With(NoLock)
			On			B.TC_CodMateria							= A.TC_CodMateria
			Inner Join	Catalogo.Prioridad						C With(NoLock)
			On			C.TN_CodPrioridad						= A.TN_CodPrioridad
			Where		A.TC_Descripcion						Like @ExpresionLike
			Order By	A.TC_Descripcion;
	End
	Else Begin
		--Sólo por código.
		If	@TN_CodTipoArchivo Is Not Null
		Begin
			Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
						A.TF_Fin_Vigencia FechaDesactivacion,
						'Split_Materia' Split_Materia,
						A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
						B.TF_Fin_Vigencia FechaDesactivacion,	
						'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
						C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
			From		Catalogo.TipoArchivo					A With(NoLock)
			Inner Join	Catalogo.Materia						B With(NoLock)
			On			B.TC_CodMateria							= A.TC_CodMateria
			Inner Join	Catalogo.Prioridad						C With(NoLock)
			On			C.TN_CodPrioridad						= A.TN_CodPrioridad
			Where		A.TN_CodTipoArchivo						= @TN_CodTipoArchivo
			Order By	A.TC_Descripcion;
		End
		Else Begin
			--Sólo por materia.
			If @TC_CodMateria Is Not Null
			Begin
				Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
							A.TF_Fin_Vigencia FechaDesactivacion,
							'Split_Materia' Split_Materia,
							A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
							B.TF_Fin_Vigencia FechaDesactivacion,	
							'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
							C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
				From		Catalogo.TipoArchivo					A With(NoLock)
				Inner Join	Catalogo.Materia						B With(NoLock)
				On			B.TC_CodMateria							= A.TC_CodMateria
				Inner Join	Catalogo.Prioridad						C With(NoLock)
				On			C.TN_CodPrioridad						= A.TN_CodPrioridad
				Where		A.TC_CodMateria							= @TC_CodMateria
				Order By	A.TC_Descripcion;
			End
			Else Begin
				--Sólo por Prioridad.
				If @TC_CodPrioridad Is Not Null
				Begin
					Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
								A.TF_Fin_Vigencia FechaDesactivacion,
								'Split_Materia' Split_Materia,
								A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
								B.TF_Fin_Vigencia FechaDesactivacion,	
								'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
								C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
					From		Catalogo.TipoArchivo					A With(NoLock)
					Inner Join	Catalogo.Materia						B With(NoLock)
					On			B.TC_CodMateria							= A.TC_CodMateria
					Inner Join	Catalogo.Prioridad						C With(NoLock)
					On			C.TN_CodPrioridad						= A.TN_CodPrioridad
					Where		A.TN_CodPrioridad						= @TC_CodPrioridad
					Order By	A.TC_Descripcion;
				End
				Else Begin
					--Fechas.
					If @TF_Fin_Vigencia Is Null And @TF_Inicio_Vigencia Is Not Null
					Begin
						Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
									A.TF_Fin_Vigencia FechaDesactivacion,
									'Split_Materia' Split_Materia,
									A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
									B.TF_Fin_Vigencia FechaDesactivacion,	
									'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
									C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
						From		Catalogo.TipoArchivo					A With(NoLock)
						Inner Join	Catalogo.Materia						B With(NoLock)
						On			B.TC_CodMateria							= A.TC_CodMateria
						Inner Join	Catalogo.Prioridad						C With(NoLock)
						On			C.TN_CodPrioridad						= A.TN_CodPrioridad
						Where		A.TC_Descripcion						Like @ExpresionLike
						And			A.TF_Inicio_Vigencia					< GetDate()
						And			(
										A.TF_Fin_Vigencia					Is Null
									Or
										A.TF_Fin_Vigencia					>= GetDate()
									)
						Order By	A.TC_Descripcion;
					End
					Else Begin
						If @TF_Fin_Vigencia Is Not Null And @TF_Inicio_Vigencia Is Null
						Begin
							Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
										A.TF_Fin_Vigencia FechaDesactivacion,
										'Split_Materia' Split_Materia,
										A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
										B.TF_Fin_Vigencia FechaDesactivacion,	
										'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
										C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
							From		Catalogo.TipoArchivo					A With(NoLock)
							Inner Join	Catalogo.Materia						B With(NoLock)
							On			B.TC_CodMateria							= A.TC_CodMateria
							Inner Join	Catalogo.Prioridad						C With(NoLock)
							On			C.TN_CodPrioridad						= A.TN_CodPrioridad
							Where		A.TC_Descripcion						Like @ExpresionLike
							And			(
											A.TF_Inicio_Vigencia				> GetDate()
										Or
											A.TF_Fin_Vigencia					< GetDate()
										)
							Order By	A.TC_Descripcion;
						End
						Else Begin
							If @TF_Fin_Vigencia Is Not Null And @TF_Inicio_Vigencia Is Not Null
							Begin
								Select		A.TN_CodTipoArchivo Codigo,				A.TC_Descripcion Descripcion,			A.TF_Inicio_Vigencia FechaActivacion,
											A.TF_Fin_Vigencia FechaDesactivacion,
											'Split_Materia' Split_Materia,
											A.TC_CodMateria Codigo,					B.TC_Descripcion Descripcion,			B.TF_Inicio_Vigencia FechaActivacion,
											B.TF_Fin_Vigencia FechaDesactivacion,	
											'Split_Prioridad' Split_Prioridad,		A.TN_CodPrioridad Codigo,				C.TC_Descripcion Descripcion,
											C.TF_Inicio_Vigencia FechaActivacion,	C.TF_Fin_Vigencia FechaDesactivacion,	C.TC_ColorAlerta ColorAlerta
								From		Catalogo.TipoArchivo					A With(NoLock)
								Inner Join	Catalogo.Materia						B With(NoLock)
								On			B.TC_CodMateria							= A.TC_CodMateria
								Inner Join	Catalogo.Prioridad						C With(NoLock)
								On			C.TN_CodPrioridad						= A.TN_CodPrioridad
								Where		A.TC_Descripcion						Like @ExpresionLike
								And			A.TF_Inicio_Vigencia					>= @TF_Inicio_Vigencia
								And			A.TF_Fin_Vigencia						<= @TF_Fin_Vigencia 
								Order By	A.TC_Descripcion;
							End
						End
					End
				End
			End
		End
	End
End;
GO
