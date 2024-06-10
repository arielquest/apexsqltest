SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jeffry Hernández>
-- Fecha de creación:		<07/06/2017>
-- Descripción :			<Permite consultar registros de las jornadas de comunicación
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarJornadaComunicacion]
 @CodPuestoTrabajo    varchar(14)	= Null,
 @FechaAperturaDesde  datetime2		= null,
 @FechaAperturaHasta  datetime2		= null,
 @FechaCierreDesde    datetime2		= null,
 @FechaCierreHasta    datetime2		= null,
 @Vigentes		      bit			= null,
 @CodOficina          Varchar(4)  
As

BEGIN

	If   @CodPuestoTrabajo		Is Null 
	And  @FechaAperturaDesde	Is Null 
	And	 @FechaAperturaHasta	Is Null 
	And  @FechaCierreDesde		Is Null 
	And  @FechaCierreHasta		Is Null  
	And  @Vigentes				Is Null  
	Begin

		

		Select		JC.TU_CodJornadaComunicacion	As CodigoJornada,	JC.TF_Apertura			As FechaApertura,
					JC.TF_Cierre					As FechaCierre,		JC.TC_Observaciones		As Observaciones,
					'Split'							As Split,		    PT.TC_CodPuestoTrabajo	As Codigo,
					 PT.TC_Descripcion				As Descripcion,		'Split'					As Split,
					 F.UsuarioRed					As UsuarioRed,		F.Nombre				As Nombre, 
					 F.PrimerApellido				As PrimerApellido,	F.SegundoApellido		As SegundoApellido

		From		Comunicacion.JornadaComunicacion   As JC  
		Inner Join  Catalogo.PuestoTrabajo             AS PT
		On          JC.TC_CodPuestoTrabajo			   =  PT.TC_CodPuestoTrabajo
		And         PT.TC_CodOficina				   =  Coalesce(@CodOficina, PT.TC_CodOficina)

		Outer Apply [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](PT.TC_CodPuestoTrabajo) As F		

		Where       JC.TF_Cierre                       Is Null
	
	End


	Else
	Begin

		Select		JC.TU_CodJornadaComunicacion			As CodigoJornada,		JC.TF_Apertura			As FechaApertura,
					JC.TF_Cierre							As FechaCierre,			JC.TC_Observaciones		As Observaciones,
				   'Split'									As Split,               PT.TC_CodPuestoTrabajo	As Codigo,
					PT.TC_Descripcion           			As Descripcion,   		'Split'					As Split, 
					F.UsuarioRed							As UsuarioRed,			F.Nombre				As Nombre, 
					F.PrimerApellido						As PrimerApellido,		F.SegundoApellido		As SegundoApellido

		From	    Comunicacion.JornadaComunicacion       AS JC
		Inner Join  Catalogo.PuestoTrabajo                 AS PT
		On          JC.TC_CodPuestoTrabajo			       =  PT.TC_CodPuestoTrabajo
		And         PT.TC_CodOficina				       =  Coalesce(@CodOficina, PT.TC_CodOficina)
		
		Outer Apply [Catalogo].[FN_ConsultarFuncionarioPorPuestoTrabajo](PT.TC_CodPuestoTrabajo) As F

		Where		JC.TF_Apertura	Between Coalesce(@FechaAperturaDesde, JC.TF_Apertura)	And		Coalesce(@FechaAperturaHasta, JC.TF_Apertura)
		And 		
		(			--Si se quiere filtrar por fecha cierre
						@FechaCierreDesde	Is Not Null 
					And @FechaCierreHasta	Is Not Null 
					And JC.TF_Cierre		Between @FechaCierreDesde And @FechaCierreHasta
		Or          
					--Si se quiere ignorar filtro por fecha cierre
						@FechaCierreDesde	Is Null 
					And @FechaCierreHasta	Is Null		
		)
		And 
		(			@Vigentes = 1 and JC.TF_Cierre is null 
		Or 
					@Vigentes = 0 and JC.TF_Cierre is not null 
		Or 
					@Vigentes is null 
		)
		And         JC.TC_CodPuestoTrabajo = Coalesce(@CodPuestoTrabajo, JC.TC_CodPuestoTrabajo)	  

	End

End


GO
