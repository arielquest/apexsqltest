SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<16/08/2018>
-- Descripción :			<Permite consultar los redactores de resoluciones de un contexto. 
-- =========================================================================================================
 -- [Expediente].[PA_ConsultarRedactoresContexto]  '0515'
 
CREATE PROCEDURE [Expediente].[PA_ConsultarRedactoresContexto]  
   @CodContexto  			 varchar(4)	
As
Begin
 	 
		Select  	
		                R.TU_CodPuestoFuncionario			As	Codigo,		 
						'SplitPuestoTrabajo'				As	SplitPuestoTrabajo,	
						R.TC_CodPuestoTrabajo				As	Codigo,					
						R.TC_Descripcion					As	Descripcion,					 
						'SplitFuncionario'					As	SplitFuncionario,		
						F.TC_UsuarioRed						As	UsuarioRed,				
						F.TC_Nombre							As	Nombre,					
						F.TC_PrimerApellido					As	PrimerApellido,			
						F.TC_SegundoApellido				As	SegundoApellido,		
						F.TC_CodPlaza						As	CodigoPlaza	, 		
		                'SplitOficina'						As	SplitOficina,			
						R.TC_CodContexto					As	Codigo
		 
		From  Catalogo.Funcionario                 As F With(Nolock) 
		     INNER JOIN
		       (--//OBTENER LOS CODIGOS DE FUNCIONARIOS ASIGNADOS COMO REDACTORES
			    SELECT   C.TU_CodPuestoFuncionario , C.TC_CodPuestoTrabajo , A.TC_Descripcion ,B.TC_CodContexto  ,  C.TC_UsuarioRed 
				  FROM  Catalogo.PuestoTrabajo   A
						INNER JOIN  Catalogo .ContextoPuestoTrabajo  B
					   ON A.TC_CodOficina = B.TC_CodContexto AND A.TC_CodPuestoTrabajo = B.TC_CodPuestoTrabajo  
					   INNER JOIN Catalogo . PuestoTrabajoFuncionario C
					   ON A.TC_CodPuestoTrabajo = C.TC_CodPuestoTrabajo 
					   INNER JOIN Expediente .Resolucion  R
					   ON C.TU_CodPuestoFuncionario  = R.TU_RedactorResponsable 
				WHERE B.TC_CodContexto = @CodContexto
				GROUP BY  C.TU_CodPuestoFuncionario , C.TC_CodPuestoTrabajo ,A.TC_Descripcion ,B.TC_CodContexto, C.TC_UsuarioRed 			 
	         )  AS R
			  on F.TC_UsuarioRed                              = R.TC_UsuarioRed
	   
		 
	  
 
End 

GO
