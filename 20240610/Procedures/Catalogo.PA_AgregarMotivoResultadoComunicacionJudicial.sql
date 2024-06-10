SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
/*  OBJETO      : PA_AgregarMateria 
**  DESCRIPCION : Permitir agregar registro en la tabla de MotivoResultadoComunicacionJudicial                     
**  CREACION    : 08/12/2016 : Pablo Alvarez E. */
-- =================================================================================================================================================
-- Modificación:	<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia' y 'TF_FinalizaVigencia' a 'TF_Fin_Vigencia'.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoResultadoComunicacionJudicial] 
	@Descripcion varchar(50),
	@Resultado char(1),
	@InicioVigencia datetime2,
	@FinVigencia datetime2
As
Begin
	Insert into [Catalogo].[MotivoResultadoComunicacionJudicial] 
		(TC_Descripcion, TC_Resultado, TF_Inicio_Vigencia, TF_Fin_Vigencia)
    Values (@Descripcion,@Resultado ,@InicioVigencia ,@FinVigencia)
End 


GO
