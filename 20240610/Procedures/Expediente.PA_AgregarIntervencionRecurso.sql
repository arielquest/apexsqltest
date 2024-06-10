SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================================================================================================== 
-- Versión:    <1.0> 
-- Creado por:   <Jonathan Aguilar Navarro> 
-- Fecha de creación: <12/11/2019> 
-- Descripción:   <Permite agregar un registro en la tabla: IntervencionRecurso.> 
-- ================================================================================================================================================================================== 
CREATE Procedure [Expediente].[PA_AgregarIntervencionRecurso]  
@Recurso		uniqueidentifier,  
@Interviniente  uniqueidentifier  

As Begin  

--Variables  

Declare 
@L_TU_CodRecurso   uniqueidentifier			= @Recurso,    
@L_TU_CodInterviniente  uniqueidentifier	= @Interviniente  

--Cuerpo  
Insert Into Expediente.IntervencionRecurso With(RowLock)  
(   
	TU_CodRecurso,     
	TU_CodInterviniente      
)  
Values  
(   
	@L_TU_CodRecurso,    
	@L_TU_CodInterviniente     
) 
End
GO
