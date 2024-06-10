SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================================================================================================
-- Author:						<Jorge A. Harris R.>
-- Create date:					<14/05/2020>
-- Description:					<Traducción de las Variable del PJEditor relacionadas para obtener Dirección, Fax, Teléfono 
--								y Email del Despacho  para LibreOffice>
-- NOTA IMPORTANTE				El parámetro @MEDIO recibe los siguientes valores:
--								E --> para obtener el valor  del campo TC_EMAIL
--								M --> para devolver todos los medios domicilio, telefonos, fax, email.-
--								F --> para devolver el valor del campo TC_Fax
--								D --> para devolver el valor del campo TC_Domicilio.
--								T --> para devolver el valor del campo TC_Telefono.
--								TF --> para devolver el valor del campo TC_Telefono y TC_Fax.
--								Este parametro puede ser ajustado a cada domicilio existente o por uno nuevo.
-- MODIFICADO:					Jorge A. Harris R. 
-- FECHA MODIFICACION:			2020-05-27T09:28:51
-- FECHA MODIFICACION:			2020-06-06 -- Se modifica para que muestre solo el valor del campo TC_Telefono,  TC_Telefono/TC_Fax.-
-- ====================================================================================================================================================================================
CREATE PROCEDURE [Variable].[PA_A_Medios]
	@Contexto				As VarChar(4),
	@Medio					as Varchar(2)
AS
BEGIN
	Declare		@L_Contexto             As VarChar(4)   = @Contexto,
				@L_Medio				As Varchar(2)	= UPPER(@Medio)

		
	 SELECT		CASE
					--E este parametro se utiliza para devolver el valor del medio TC_EMAIL
					WHEN @L_Medio='E' THEN C.TC_Email
					--M este parametro se utiliza para devolver el valor de los medios domicilio, fax, telefóno, email.
					WHEN @L_Medio='M' THEN CONCAT(O.TC_Domicilio, '. TELÉFONOS: ', C.TC_Telefono,'. FAX:',C.TC_Fax,'. CORREO ELECTRÓNICO: ',C.TC_Email, '.')		
					--F este parametro se utiliza para devolver el valor del medio TC_Fax
					WHEN @L_Medio='F' THEN C.TC_Fax
					--D este parametro se utiliza para devolver el valor del medio TC_Domicilio
					WHEN @L_Medio='D' THEN O.TC_Domicilio
					--T este parametro se utiliza para devolver el valor del medio TC_Telefono
					WHEN @L_Medio='T' THEN C.TC_Telefono
					--TF este parametro se utiliza para devolver el valor del medio TC_Telefono y TC_Fax
					WHEN @L_Medio='TF' THEN CONCAT(C.TC_Telefono, '/', C.TC_Fax)
				END AS MEDIO
	FROM 		Catalogo.Contexto	C With(NoLock)
	INNER JOIN	Catalogo.Oficina	O With(NoLock) 
	ON			O.TC_CodOficina		=C.TC_CodOficina
	WHERE 		C.TC_CodContexto	= @L_Contexto

END
GO
