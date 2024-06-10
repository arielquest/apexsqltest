SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<07/08/2015>
-- Descripción :			<Permitir agregar registro en la tabla Catalogo.Proceso > 
-- Modificación :			<05/02/2019> <Isaac Dobles Mata> <Se cambia nombre a PA_AgregarProceso y direcciona a tabla Catalogo.Proceso > 
-- =================================================================================================================================================

  
 CREATE PROCEDURE [Catalogo].[PA_AgregarProceso]
		 @Descripcion		varchar(100),
		 @InicioVigencia	datetime2(3),
		 @FinVigencia		datetime2(3)

 As
 Begin

	insert into [Catalogo].[Proceso] 
		(			
					TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
		)
	values 
		(		    
					@Descripcion,		@InicioVigencia,		@FinVigencia
		)
End 




GO
