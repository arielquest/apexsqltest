SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Uriel García Regalado>
-- Fecha de creación:		<06/08/2015>
-- Descripción:				<Permitir agregar registro en la tabla Catalogo.Prioridad >
-- 
--Modificación:				<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 150.>
-- =================================================================================================================================================
 CREATE PROCEDURE [Catalogo].[PA_AgregarPrioridad]
		 @Descripcion varchar(150),
		 @InicioVigencia datetime2,
		 @FinVigencia datetime2,
		 @ColorAlerta varchar(10)
 As
 Begin

		insert into [Catalogo].[Prioridad] 
			(			
						TC_Descripcion,		TF_Inicio_Vigencia,		
						TF_Fin_Vigencia,	TC_ColorAlerta
			)
		values 
		    (		    
						@Descripcion,		@InicioVigencia,
						@FinVigencia,		@ColorAlerta
			)
 End 
GO
