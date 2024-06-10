SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================================
-- Autor:				<Luis ALonso Leiva Tames>
-- Fecha Creación:		<29/10/2021>
-- Descripcion:			<Funcion que valida los numero devuelve varchar formato numerico> 
CREATE FUNCTION [Itineracion].[FN_DevuelveNumeroDecimal] 
( 
	@Valor varchar(100) 
)
RETURNS Varchar(100)
AS
BEGIN



	-- DECLARACION DE VARIABLES
	DECLARE  @L_ValorRecibido varchar(100) = @Valor,
			 @CantidadComas int = 0,
			 @CantidadPuntos int = 0,
			 @SeparadorMiles char(1) = '', 
			 @SeparadorDecimales char(1) = ''




	IF (@L_ValorRecibido IS NOT NULL AND LEN(@L_ValorRecibido) > 0)  BEGIN


		-- QUITAR TODOS LOS ESPACIOS
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, ' ', '') 

		-- LOGICA PARA OBTENER EL SEPARADOR DE MILES Y DECIMALES
		SET	 @CantidadPuntos = ( (len(@L_ValorRecibido) - len(replace(@L_ValorRecibido, '.', ''))) / len('.') )
		SET	 @CantidadComas = ((len(@L_ValorRecibido) - len(replace(@L_ValorRecibido, ',', ''))) / len(','))

	

		IF(@CantidadPuntos > 1) AND (@CantidadComas <= 1) BEGIN
			SET @SeparadorMiles = '.'
			SET @SeparadorDecimales = ','
		END
		ELSE IF (@CantidadComas > 1) AND (@CantidadPuntos <= 1) BEGIN		
			SET @SeparadorMiles = ','
			SET @SeparadorDecimales = '.'
		END
		ELSE IF (@CantidadPuntos = 1) AND (@CantidadComas = 0) BEGIN 
			SET @SeparadorDecimales = '.'
		END
		ELSE IF (@CantidadPuntos = 0) AND (@CantidadComas = 1) BEGIN 
			SET @SeparadorDecimales = ','
		END
		ELSE IF (@CantidadPuntos = 1) AND (@CantidadComas = 1) BEGIN 
			IF(charindex('.',REVERSE(@L_ValorRecibido)) < charindex(',',REVERSE(@L_ValorRecibido))) BEGIN
				SET @SeparadorMiles = ','
				SET @SeparadorDecimales = '.'
			END
			ELSE BEGIN 
				SET @SeparadorMiles = '.'
				SET @SeparadorDecimales = ','
			END
		END

		IF(charindex(@SeparadorDecimales,REVERSE(@L_ValorRecibido)) > charindex(@SeparadorMiles,REVERSE(@L_ValorRecibido))) 
			RETURN NULL
	
		-- QUITAR SIGNOS DE MONEDA 
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, '¢', '') 
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, '$', '')
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, '€', '')
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, '¥', '')
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, '£', '')

		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, @SeparadorMiles, '')
		SET @L_ValorRecibido = REPLACE(@L_ValorRecibido, @SeparadorDecimales, ',')


		IF ISNUMERIC(@L_ValorRecibido) = 1
			RETURN @L_ValorRecibido
		ELSE  
			RETURN NULL

	END 
	ELSE BEGIN
		-- SI ES NULL o VACIO, retorna un NULL
		RETURN NULL 
	END

	RETURN NULL 

END


 


GO
