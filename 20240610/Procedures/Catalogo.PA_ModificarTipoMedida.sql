SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Sigifredo Leitón Luna>
-- Fecha Creación:		<31/08/2015>
-- Descripcion:			<Modificar datos de un tipo de medida cautelar.>
-- Modificado:			<Alejandro Villalta><05/01/2015><Modificar el tipo de dato del codigo de tipo medida cautelar para autogenerar el valor.>
-- =================================================================================================================================================
-- Modificado por:	    <02/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificado por:      <02/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de TipoMedidaCautelar a TipoMedida>
-- =================================================================================================================================================
CREATE   PROCEDURE [Catalogo].[PA_ModificarTipoMedida] 
	@CodTipoMedida smallint, 
	@Descripcion varchar(150),
	@FechaVencimiento datetime2
AS
BEGIN
	UPDATE	Catalogo.TipoMedida
	SET		TC_Descripcion		=	@Descripcion,
			TF_Fin_Vigencia		=	@FechaVencimiento
	WHERE	TN_CodTipoMedida	=	@CodTipoMedida
END
GO
