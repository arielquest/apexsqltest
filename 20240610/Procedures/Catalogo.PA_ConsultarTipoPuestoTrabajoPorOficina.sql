SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<18/06/2020>
-- Descripción:			<Permite consultar los  registro de  la tabla: PuestoTrabajo según filtros de Oficina y fecha vigencia.>
-- ==================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><18/06/2020> <Se modifica resultado a devolver por ser solo Tipo Puesto de Trabajo>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><24/06/2020> <Se elimina tabla puesto de consulta luego de revisión par>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><21/08/2020> <Se ajusta en WHERE la condición en la fecha fin vigencia>
-- ==================================================================================================================================================================================
-- Modificado por:		<Jose Gabriel Cordero Soto><30/09/2020> <Se agrega parametro para consultar por contexto los tipos de oficina>
-- ==================================================================================================================================================================================
-- Modificado por:      <Jose Gabriel Cordero Soto><26/10/2020> <Se agrega Codigo Tipo Funcionario para validación en formulario para limitar registros en Defensa Publica>
-- ==================================================================================================================================================================================
-- Modificado por:		<Roger Lara><08/03/2021> <Se agrega validacion en tipo de puesto de trabajo, para que considera solo las que estan activas>
CREATE PROCEDURE	[Catalogo].[PA_ConsultarTipoPuestoTrabajoPorOficina]
	@CodOficina		  VARCHAR(4) = NULL,
	@CodContexto	  VARCHAR(4) = NULL 	
AS
BEGIN
	--Variables
	DECLARE		  @L_CodOficina										VARCHAR(4)	 = @CodOficina
	DECLARE		  @L_CodContexto									VARCHAR(4)   = @CodContexto
	
	--Lógica
	IF (@L_CodContexto IS NULL)
		BEGIN
				SELECT			  TPT.TN_CodTipoPuestoTrabajo					Codigo,								  
								  TPT.TC_Descripcion							Descripcion,
								  TPT.TF_Inicio_Vigencia						FechaActivacion,
								  TPT.TF_Fin_Vigencia							FechaDesactivacion,
								  'splitOtros'									splitOtros,
								  TPT.TN_CodTipoFuncionario					    CodigoTipoFuncionario


				FROM		      Catalogo.Oficina								O WITH (NOLOCK)
				INNER JOIN		  Catalogo.TipoOficina							OT WITH (NOLOCK)
				ON				  OT.TN_CodTipoOficina							= O.TN_CodTipoOficina			  
				INNER JOIN		  Catalogo.TipoOficinaTipoFuncionario			TOF WITH (NOLOCK)
				ON				  TOF.TN_CodTipoOficina							= OT.TN_CodTipoOficina
				INNER JOIN		  Catalogo.TipoFuncionario						TFU WITH (NOLOCK)
				ON				  TOF.TN_CodTipoFuncionario						= TFU.TN_CodTipoFuncionario and
								  (TFU.TF_Fin_Vigencia							>= getdate() OR
								  TFU.TF_Fin_Vigencia							Is Null )
				INNER JOIN		  Catalogo.TipoPuestoTrabajo					TPT WITH (NOLOCK)
				ON				  TFU.TN_CodTipoFuncionario						= TPT.TN_CodTipoFuncionario 

				WHERE			  O.TC_CodOficina								= COALESCE(@L_CodOficina, O.TC_CodOficina)
				And              (TPT.TF_Fin_Vigencia							Is Null
				OR				  TPT.TF_Fin_Vigencia							>= getdate())	
				Order by		  TPT.TC_Descripcion
		END
	ELSE
		BEGIN
				SELECT			  TPT.TN_CodTipoPuestoTrabajo					Codigo,								  
								  TPT.TC_Descripcion							Descripcion,
								  TPT.TF_Inicio_Vigencia						FechaActivacion,
								  TPT.TF_Fin_Vigencia							FechaDesactivacion,
								  'splitOtros'									splitOtros,
								  TPT.TN_CodTipoFuncionario					    CodigoTipoFuncionario
								  

				FROM		      Catalogo.Oficina								O WITH (NOLOCK)
				INNER JOIN		  Catalogo.TipoOficina							OT WITH (NOLOCK)
				ON				  OT.TN_CodTipoOficina							= O.TN_CodTipoOficina			  
				INNER JOIN		  Catalogo.TipoOficinaTipoFuncionario			TOF WITH (NOLOCK)
				ON				  TOF.TN_CodTipoOficina							= OT.TN_CodTipoOficina
				INNER JOIN		  Catalogo.TipoFuncionario						TFU WITH (NOLOCK)
				ON				  TOF.TN_CodTipoFuncionario						= TFU.TN_CodTipoFuncionario and 
								  (TFU.TF_Fin_Vigencia							>= getdate() OR
								  TFU.TF_Fin_Vigencia							Is Null )
				INNER JOIN		  Catalogo.TipoPuestoTrabajo					TPT WITH (NOLOCK)
				ON				  TFU.TN_CodTipoFuncionario						= TPT.TN_CodTipoFuncionario 
				INNER JOIN		  Catalogo.Contexto								C WITH (NOLOCK)
				ON				  C.TC_CodOficina								= O.TC_CodOficina	

				WHERE			  C.TC_CodContexto								= @L_CodContexto
				And              (TPT.TF_Fin_Vigencia							Is Null
				OR				  TPT.TF_Fin_Vigencia							>= getdate())	
				Order by		  TPT.TC_Descripcion

		END
END
GO
