SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Autor:				<Ailyn López>
-- Fecha Creación:		<29/11/2017>
-- Descripcion:			<Remueve las tildes de la descripción> 
-- ===========================================================================================
-- Modificación:		<2018-07-11><Andrés Díaz><Se cambia el parámetro de varchar(max) a varchar(500).>
-- ===========================================================================================
CREATE FUNCTION [dbo].[FN_RemoverTildes] 
( 
	@Descripcion varchar(500) 
)
RETURNS varchar(500)
BEGIN
    return @Descripcion COLLATE SQL_Latin1_General_CP1253_CI_AI    
END
GO
