SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<18/11/2019>
-- Descripción:			<Permite consultar un registro en la tabla: Compartimiento.>
-- ==================================================================================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha de modificación	<02/12/2019>
-- Modificación				<Se actualiza para incluir filtrado por código de circuito, oficina, bodega, sección y estante>
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarCompartimiento]
	@Codigo				SmallInt		= Null,
	@Descripcion		VarChar(100)	= Null,
	@CodCircuito		SmallInt		= Null,
	@CodOficina			Varchar(4)		= Null,
	@CodBodega			Smallint		= Null,
	@CodSeccion			Smallint		= Null,
	@CodEstante			Smallint		= Null,
	@FechaActivacion	DateTime2		= Null,
	@FechaDesactivacion	DateTime2		= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodCompartimiento	SmallInt		= @Codigo,
			@L_TN_CodCircuito		Smallint		= @CodCircuito,
			@L_TC_CodOficina		Varchar(4)		= @CodOficina,
			@L_TN_CodBodega			Smallint		= @CodBodega,
			@L_TN_CodSeccion		Smallint		= @CodSeccion,
			@L_TN_CodEstante		SmallInt		= @CodEstante,
			@L_TF_Inicio_Vigencia	DateTime2(3)	= @FechaActivacion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion,
			@L_TC_Descripcion		VarChar(Max)	= Iif (@Descripcion Is Not Null, '%' + dbo.FN_RemoverTildes(@Descripcion) + '%', '%')
	--Lógica.
	--Todos.
	If	@L_TF_Inicio_Vigencia	Is Null
	And	@L_TF_Fin_Vigencia		Is Null
	Begin
		Select		A.TN_CodCompartimiento					Codigo,
					A.TC_Descripcion						Descripcion,
					A.TC_Observacion						Observacion,
					A.TF_Inicio_Vigencia					FechaActivacion,
					A.TF_Fin_Vigencia						FechaDesactivacion,
					'SplitCircuito'		   					SplitCircuito, 
					D.TN_CodCircuito						Codigo, 
					D.TC_Descripcion						Descripcion,
					'SplitOficina'		   					SplitOficina, 
					B.TC_CodOficina							Codigo, 
					B.TC_Nombre								Descripcion,
					'SplitBodega'		   					SplitBodega,
					C.TN_CodBodega							Codigo, 
					C.TC_Descripcion						Descripcion,					
					'SplitSeccion'		   					SplitSeccion,
					E.TN_CodSeccion							Codigo, 
					E.TC_Descripcion						Descripcion,
					'SplitEstante'		   					SplitEstante,
					F.TN_CodEstante							Codigo, 
					F.TC_Descripcion						Descripcion
		From		Catalogo.Compartimiento					A With(NoLock)		INNER JOIN	
					Catalogo.Estante						F WITH (NoLock)		
					ON A.TN_CodEstante						= F.TN_CodEstante	INNER JOIN					
					Catalogo.Seccion						E WITH (NoLock)		
					ON F.TN_CodSeccion						= E.TN_CodSeccion	INNER JOIN
					Catalogo.Oficina						B WITH (Nolock) 
					ON E.TC_CodOficina 						= B.TC_CodOficina 	INNER JOIN
					Catalogo.Bodega							C WITH (Nolock) 
					ON E.TN_CodBodega 						= C.TN_CodBodega	INNER JOIN
					Catalogo.Circuito						D WITH (NoLock)		
					ON B.TN_CodCircuito						= D.TN_CodCircuito
					
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion)	Like @L_TC_Descripcion
		And			A.TN_CodCompartimiento					= Coalesce(@L_TN_CodCompartimiento, A.TN_CodCompartimiento)
		And			D.TN_CodCircuito						= Coalesce(@L_TN_CodCircuito, D.TN_CodCircuito)
		And			B.TC_CodOficina							= Coalesce(@L_TC_CodOficina, B.TC_CodOficina)		
		And			C.TN_CodBodega							= Coalesce(@L_TN_CodBodega, C.TN_CodBodega)
		And			E.TN_CodSeccion							= Coalesce(@L_TN_CodSeccion, E.TN_CodSeccion)
		And			F.TN_CodEstante							= Coalesce(@L_TN_CodEstante, F.TN_CodEstante)
		Order By	A.TC_Descripcion
	End	Else
	Begin
		--Activos.
		If	@L_TF_Inicio_Vigencia	Is Not Null
		And	@L_TF_Fin_Vigencia		Is Null
		Begin
			Select			A.TN_CodCompartimiento					Codigo,
							A.TC_Descripcion						Descripcion,
							A.TC_Observacion						Observacion,
							A.TF_Inicio_Vigencia					FechaActivacion,
							A.TF_Fin_Vigencia						FechaDesactivacion,
							'SplitCircuito'		   					SplitCircuito, 
							D.TN_CodCircuito						Codigo, 
							D.TC_Descripcion						Descripcion,
							'SplitOficina'		   					SplitOficina, 
							B.TC_CodOficina							Codigo, 
							B.TC_Nombre								Descripcion,
							'SplitBodega'		   					SplitBodega,
							C.TN_CodBodega							Codigo, 
							C.TC_Descripcion						Descripcion,					
							'SplitSeccion'		   					SplitSeccion,
							E.TN_CodSeccion							Codigo, 
							E.TC_Descripcion						Descripcion,
							'SplitEstante'		   					SplitEstante,
							F.TN_CodEstante							Codigo, 
							F.TC_Descripcion						Descripcion
			From			Catalogo.Compartimiento					A With(NoLock)		INNER JOIN	
							Catalogo.Estante						F WITH (NoLock)		
							ON A.TN_CodEstante						= F.TN_CodEstante	INNER JOIN					
							Catalogo.Seccion						E WITH (NoLock)		
							ON F.TN_CodSeccion						= E.TN_CodSeccion	INNER JOIN
							Catalogo.Oficina						B WITH (Nolock) 
							ON E.TC_CodOficina 						= B.TC_CodOficina 	INNER JOIN
							Catalogo.Bodega							C WITH (Nolock) 
							ON E.TN_CodBodega 						= C.TN_CodBodega	INNER JOIN
							Catalogo.Circuito						D WITH (NoLock)		
							ON B.TN_CodCircuito						= D.TN_CodCircuito
			Where			dbo.FN_RemoverTildes(A.TC_Descripcion)	Like @L_TC_Descripcion
			And				A.TF_Inicio_Vigencia						< GetDate()
			And				(
								A.TF_Fin_Vigencia						Is Null
							Or
								A.TF_Fin_Vigencia						>= GetDate()
							)
			And				A.TN_CodCompartimiento					= Coalesce(@L_TN_CodCompartimiento, A.TN_CodCompartimiento)
			And				D.TN_CodCircuito						= Coalesce(@L_TN_CodCircuito, D.TN_CodCircuito)
			And				B.TC_CodOficina							= Coalesce(@L_TC_CodOficina, B.TC_CodOficina)		
			And				C.TN_CodBodega							= Coalesce(@L_TN_CodBodega, C.TN_CodBodega)
			And				E.TN_CodSeccion							= Coalesce(@L_TN_CodSeccion, E.TN_CodSeccion)
			And				F.TN_CodEstante							= Coalesce(@L_TN_CodEstante, F.TN_CodEstante)
			Order By		A.TC_Descripcion
		End Else
		Begin
			--Inactivos.
			If	@L_TF_Inicio_Vigencia	Is Null
			And	@L_TF_Fin_Vigencia		Is Not Null
			Begin
				Select			A.TN_CodCompartimiento					Codigo,
								A.TC_Descripcion						Descripcion,
								A.TC_Observacion						Observacion,
								A.TF_Inicio_Vigencia					FechaActivacion,
								A.TF_Fin_Vigencia						FechaDesactivacion,
								'SplitCircuito'		   					SplitCircuito, 
								D.TN_CodCircuito						Codigo, 
								D.TC_Descripcion						Descripcion,
								'SplitOficina'		   					SplitOficina, 
								B.TC_CodOficina							Codigo, 
								B.TC_Nombre								Descripcion,
								'SplitBodega'		   					SplitBodega,
								C.TN_CodBodega							Codigo, 
								C.TC_Descripcion						Descripcion,					
								'SplitSeccion'		   					SplitSeccion,
								E.TN_CodSeccion							Codigo, 
								E.TC_Descripcion						Descripcion,
								'SplitEstante'		   					SplitEstante,
								F.TN_CodEstante							Codigo, 
								F.TC_Descripcion						Descripcion
				From			Catalogo.Compartimiento					A With(NoLock)		INNER JOIN	
								Catalogo.Estante						F WITH (NoLock)		
								ON A.TN_CodEstante						= F.TN_CodEstante	INNER JOIN					
								Catalogo.Seccion						E WITH (NoLock)		
								ON F.TN_CodSeccion						= E.TN_CodSeccion	INNER JOIN
								Catalogo.Oficina						B WITH (Nolock) 
								ON E.TC_CodOficina 						= B.TC_CodOficina 	INNER JOIN
								Catalogo.Bodega							C WITH (Nolock) 
								ON E.TN_CodBodega 						= C.TN_CodBodega	INNER JOIN
								Catalogo.Circuito						D WITH (NoLock)		
								ON B.TN_CodCircuito						= D.TN_CodCircuito
				Where			dbo.FN_RemoverTildes(A.TC_Descripcion)	Like @L_TC_Descripcion
				And				(
									A.TF_Inicio_Vigencia					> GetDate()
								Or
									A.TF_Fin_Vigencia						< GetDate()
								)
				And				A.TN_CodCompartimiento					= Coalesce(@L_TN_CodCompartimiento, A.TN_CodCompartimiento)
				And				D.TN_CodCircuito						= Coalesce(@L_TN_CodCircuito, D.TN_CodCircuito)
				And				B.TC_CodOficina							= Coalesce(@L_TC_CodOficina, B.TC_CodOficina)		
				And				C.TN_CodBodega							= Coalesce(@L_TN_CodBodega, C.TN_CodBodega)
				And				E.TN_CodSeccion							= Coalesce(@L_TN_CodSeccion, E.TN_CodSeccion)
				And				F.TN_CodEstante							= Coalesce(@L_TN_CodEstante, F.TN_CodEstante)
				Order By		A.TC_Descripcion
			End Else
			Begin
				--Inactivos por fecha.
				If	@L_TF_Inicio_Vigencia	Is Not Null
				And	@L_TF_Fin_Vigencia		Is Not Null
				Begin
					Select			A.TN_CodCompartimiento					Codigo,
									A.TC_Descripcion						Descripcion,
									A.TC_Observacion						Observacion,
									A.TF_Inicio_Vigencia					FechaActivacion,
									A.TF_Fin_Vigencia						FechaDesactivacion,
									'SplitCircuito'		   					SplitCircuito, 
									D.TN_CodCircuito						Codigo, 
									D.TC_Descripcion						Descripcion,
									'SplitOficina'		   					SplitOficina, 
									B.TC_CodOficina							Codigo, 
									B.TC_Nombre								Descripcion,
									'SplitBodega'		   					SplitBodega,
									C.TN_CodBodega							Codigo, 
									C.TC_Descripcion						Descripcion,					
									'SplitSeccion'		   					SplitSeccion,
									E.TN_CodSeccion							Codigo, 
									E.TC_Descripcion						Descripcion,
									'SplitEstante'		   					SplitEstante,
									F.TN_CodEstante							Codigo, 
									F.TC_Descripcion						Descripcion
					From			Catalogo.Compartimiento					A With(NoLock)		INNER JOIN	
									Catalogo.Estante						F WITH (NoLock)		
									ON A.TN_CodEstante						= F.TN_CodEstante	INNER JOIN					
									Catalogo.Seccion						E WITH (NoLock)		
									ON F.TN_CodSeccion						= E.TN_CodSeccion	INNER JOIN
									Catalogo.Oficina						B WITH (Nolock) 
									ON E.TC_CodOficina 						= B.TC_CodOficina 	INNER JOIN
									Catalogo.Bodega							C WITH (Nolock) 
									ON E.TN_CodBodega 						= C.TN_CodBodega	INNER JOIN
									Catalogo.Circuito						D WITH (NoLock)		
									ON B.TN_CodCircuito						= D.TN_CodCircuito
					Where			dbo.FN_RemoverTildes(A.TC_Descripcion)	Like @L_TC_Descripcion
					And				(
										A.TF_Inicio_Vigencia					> @L_TF_Inicio_Vigencia
									Or
										A.TF_Fin_Vigencia						< @L_TF_Fin_Vigencia
									)
					And				A.TN_CodCompartimiento					= Coalesce(@L_TN_CodCompartimiento, A.TN_CodCompartimiento)
					And				D.TN_CodCircuito						= Coalesce(@L_TN_CodCircuito, D.TN_CodCircuito)
					And				B.TC_CodOficina							= Coalesce(@L_TC_CodOficina, B.TC_CodOficina)		
					And				C.TN_CodBodega							= Coalesce(@L_TN_CodBodega, C.TN_CodBodega)
					And				E.TN_CodSeccion							= Coalesce(@L_TN_CodSeccion, E.TN_CodSeccion)
					And				F.TN_CodEstante							= Coalesce(@L_TN_CodEstante, F.TN_CodEstante)
					Order By		A.TC_Descripcion
				End
			End
		End
	End
End
GO
