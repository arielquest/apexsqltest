SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Alejandro Villalta Ruiz>
-- Fecha de creación:		<14/08/2015>
-- Descripción :			<Permite Agregar fases a una ubicacion> 

-- Fecha Modificacion       <2-12-2015>
-- Mofificado por:          <Pablo Alvarez Espinoza>
-- Descripción              <Se agrega la columna por defecto>

-- Modificado por:			<Alejandro Villalta><07/01/2016><Modificar el tipo de dato del codigo de fase.>
-- Modificado por:			<Pablo Alvarez><02/12/2016><Modificar el nombre TN_CodFase por estandar.>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarMateriaFase]  
   @CodMateria		varchar(5),
   @CodFase			smallint,
   @InicioVigencia	datetime2(7),
   @PorDefecto		bit,
   @CodTipoOficina	smallint 
AS 

BEGIN          
	 INSERT INTO Catalogo.MateriaFase
	 (
		TC_CodMateria, TN_CodFase, TF_Inicio_Vigencia, TB_PorDefecto, TN_CodTipoOficina 
	 )
	 VALUES
	 (
		@CodMateria, @CodFase ,@InicioVigencia, @PorDefecto, @CodTipoOficina
	 )
END
 

GO
