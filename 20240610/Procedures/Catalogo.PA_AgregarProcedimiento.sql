SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<07/08/2015>
-- Descripción :			<Permitir agregar registro en la tabla Catalogo.Procedimiento > 
-- =================================================================================================================================================

  
 CREATE PROCEDURE [Catalogo].[PA_AgregarProcedimiento]
		 @Descripcion		varchar(100),
		 @InicioVigencia	datetime2(3),
		 @FinVigencia		datetime2(3)

 As
 Begin

	insert into [Catalogo].[Procedimiento] 
		(			
					TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
		)
	values 
		(		    
					@Descripcion,		@InicioVigencia,		@FinVigencia
		)
End 



GO
