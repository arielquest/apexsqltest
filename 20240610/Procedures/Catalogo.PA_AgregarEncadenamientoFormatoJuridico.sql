SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Xinia Soto V.>
-- Fecha Creación:		<04/11/2021>
-- Descripcion:			<Crear nuevo encadenamiento de formato jurídico>
-- =========================================================================================================================================
-- Modificación:		<Xinia Soto V. 22/11/2021> Se pasa a varchar(5) la materia
-- =========================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarEncadenamientoFormatoJuridico] 
	@CodTipoOficina		SMALLINT,
	@CodMateria			VARCHAR(5),
	@CodFormatoJuridico	VARCHAR(8)
AS
BEGIN

	--Variables locales
	DECLARE @L_CodTipoOficina		SMALLINT   = @CodTipoOficina,
			@L_CodMateria			VARCHAR(5) = @CodMateria,
			@L_CodFormatoJuridico	VARCHAR(8) = @CodFormatoJuridico


	--Aplicación de inserción
	INSERT INTO Catalogo.EncadenamientoFormatoJuridico
	(
		 [TN_CodTipoOficina],	[TC_CodMateria],	[TC_CodFormatoJuridico],	[TF_Actualizacion]  
	)
	OUTPUT INSERTED.TN_CodEncadenamientoFormatoJuridico
	VALUES
	(
		 @L_CodTipoOficina,		@L_CodMateria,		@L_CodFormatoJuridico,		GETDATE()
	)

	

END

GO
