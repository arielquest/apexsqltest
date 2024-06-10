SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<30/10/2015>
-- Descripción :			<Permite Agregar una tarea a un perfil de puesto>
-- Modificado:              <Pablo Alvarez Espinoza>
-- Fecha Modifica:		    <17/12/2015>
-- Descripcion:				<Se cambia la llave a smallint squence>
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- Modificado : Pablo Alvarez
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarPerfilPuestoTarea]
	--@CodPerfilPuesto smallint,
	@CodTarea smallint,
	@FechaAsociacion datetime2,
	@PlazoHoras int
AS 
    BEGIN
          
			 INSERT INTO Catalogo.PerfilPuestoTarea
			   (TN_CodTarea, TF_Inicio_Vigencia, TN_PlazoHoras )
			 VALUES
				   (@CodTarea, @FechaAsociacion, @PlazoHoras)
    END
 



GO
