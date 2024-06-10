SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Stefany Quesada Cascante>
-- Fecha de creación:		<1187/05/2016>
-- Descripción:				<Permite agregar un registro a [Comunicacion].[ArchivoComunicacion].>
-- ===========================================================================================
CREATE PROCEDURE [Comunicacion].[PA_AgregarArchivoComunicacion]
	@CodArchivoComunicacion Uniqueidentifier,
	@CodComunicacion Uniqueidentifier,	
	@EsActa char(1),	
	@FechaAsociacion Datetime2(7),
	@CodArchivo Uniqueidentifier,
	@EsPrincipal bit
As
Begin

	Insert Into [Comunicacion].[ArchivoComunicacion]
	(
		TU_CodArchivoComunicacion,  TU_CodComunicacion,     TB_EsActa,     TF_FechaAsociacion,
        TU_CodArchivo,              TB_EsPrincipal
	)
	Values
	(
	   @CodArchivoComunicacion ,	@CodComunicacion ,		@EsActa ,		@FechaAsociacion ,
	   @CodArchivo ,	            @EsPrincipal     
    )

End
GO
