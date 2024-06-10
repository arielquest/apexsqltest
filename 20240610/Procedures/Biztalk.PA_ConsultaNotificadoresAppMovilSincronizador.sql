SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Cristian Cerdas Camacho>
-- Fecha de creación:		<02/12/2020>
-- Descripción:				<Consulta los sectores para la sincronización en la aplicación móvil> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultaNotificadoresAppMovilSincronizador]
(	
	@CodOficina INT
)
AS
BEGIN

	DECLARE	@TempCodOficina				VARCHAR(4)
    SET @TempCodOficina = REPLICATE ('0', 4-len( @CodOficina)) + cast( @CodOficina as varchar)	  

	SELECT 
	 f.TC_UsuarioRed AS CodNotificador
	,convert(nvarchar(70), p.TU_CodPuestoFuncionario) AS CodReferencia
	,f.TC_Nombre + ' ' + f.TC_PrimerApellido + ' ' + f.TC_SegundoApellido AS NombreCompleto
	 ,1 AS 'activo',				
	  iif(t.TN_CodJornadaLaboral <> 2, 0,1) AS 'rolNocturno',
	 0 AS 'supervisor' 
	,'split' split,    
	t.TC_CodOficina Codigo
	,c.TC_Descripcion	
	,1 AS 'predeterminado' 
	FROM Catalogo.Funcionario f WITH(NOLOCK)
	INNER JOIN CATALOGO.PuestoTrabajoFuncionario p WITH(NOLOCK)
	ON p.TC_UsuarioRed = f.TC_UsuarioRed
	INNER JOIN Catalogo.PuestoTrabajo t WITH(NOLOCK)
	on t.TC_CodPuestoTrabajo = p.TC_CodPuestoTrabajo
	INNER JOIN Catalogo.Contexto c WITH(NOLOCK)
	ON c.TC_CodOficina = t.TC_CodOficina
	WHERE T.TC_CodOficina = @TempCodOficina
	AND T.TN_CodTipoFuncionario = 11
	And	F.TF_Inicio_Vigencia		<=	GETDATE ()
	And	(F.TF_Fin_Vigencia		Is	Null OR F.TF_Fin_Vigencia  >= GETDATE ()) 





END
 
GO
