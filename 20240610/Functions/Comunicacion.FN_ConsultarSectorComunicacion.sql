SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
 --=============================================
-- Autor:				<Stefany Quesada>
-- Fecha Creación:		<26/05/2017>
-- Descripcion:			<Obtiene el código de sector de la comunicación 
-- =============================================

 --=============================================
-- Autor:				<Jeffry Hernández>
-- Fecha Modificación:	<26/10/2017>
-- Descripcion:			<* Se tabula. 
--						 * Se corrige la declaración del parámetro @CodOficinaOCJ
--						 * Se agregan comentarios>

-- Autor:				<Jeffry Hernández>
-- Fecha Modificación:	<07/11/2017>
-- Descripcion:			<* Se valida si se debe invertir o no el Ring Orientation del polígono>
-- =============================================
CREATE FUNCTION [Comunicacion].[FN_ConsultarSectorComunicacion] (@punto GEOGRAPHY, @CodOficinaOCJ VARCHAR(4))

RETURNS INT

AS
BEGIN

DECLARE
 @poligono			GEOGRAPHY,
 @listapuntos		VARCHAR(MAX) = NULL,
 @SectorEncontrado	CHAR = 0,
 @CodigoSector		INT = 0,
 @CodSector			INT = 0

 SET @CodigoSector = null;


 /*Se valida el punto geográfico*/
 IF @punto IS NULL
 BEGIN
  RETURN NULL
 END

  /*Se valida la OCJ*/
 IF @CodOficinaOCJ IS NULL
 BEGIN
  RETURN NULL
 END

 --Se obtienen los sectores asociados a la oficina OCJ recibida		
 DECLARE ListaSectores CURSOR FOR

     SELECT		TN_CodSector 
	 FROM		Comunicacion.Sector S 
	 WHERE		TC_CodOficinaOCJ	=	@CodOficinaOCJ 
	 and	(
				ISNULL(
						(SELECT count(*) 
						 FROM Comunicacion.SectorLocalizacion SL 
						 WHERE SL.TN_CodSector = S.TN_CodSector
						),0 
					  )>= 3 --Se valida que para el sector existan al menos tres puntos geográficos
			)  
						
	ORDER BY TN_CodSector

	   /*Abrimos el cursor*/
    OPEN ListaSectores

    /*Extraemos el Primer registro*/
    FETCH NEXT FROM ListaSectores
	into @CodSector;
    
    WHILE @@FETCH_STATUS = 0 
    BEGIN
		
		set @listapuntos = NULL;
    
		--Se almacena en @listapuntos todos los puntos geográficos del sector que se está usando 
		SELECT		  @listapuntos = COALESCE(@listapuntos + ', ', '') + CAST(TG_UbicacionPunto.Long AS VARCHAR) + ' ' + CAST(TG_UbicacionPunto.Lat AS VARCHAR)
		
		FROM		[Comunicacion].[SectorLocalizacion]  SL 	WITH(NOLOCK) 
		join        [Comunicacion].[Sector]              Sector	WITH(NOLOCK)
		ON          Sector.TN_CodSector                  = SL.TN_CodSector
		where       Sector.TN_CodSector                  = @CodSector
		ORDER BY	TN_OrdenPunto


		--Nota: Para poder cerrar el polígono el primer punto debe ser igual al último de la lista de puntos
		--Entonces, si se obtuvieron puntos de ese sector, se agrega el primer punto al final de la lista de puntos.
		IF (@listapuntos is not null)
			BEGIN
				SELECT		TOP 1 @listapuntos = COALESCE(@listapuntos + ', ', '') + CAST(TG_UbicacionPunto.Long AS VARCHAR) + ' ' + CAST(TG_UbicacionPunto.Lat AS VARCHAR)
				FROM		Comunicacion.SectorLocalizacion
				where       TN_CodSector                  =@CodSector
				ORDER BY	TN_OrdenPunto			

				-- Se crea el polígono
				SET @poligono = geography::STGeomFromText('POLYGON((' + @listapuntos + '))', 4326);


				--Depende del orden en que se definan los puntos (en la línea anterior) se creará un polígono que incluye o no el área deseada.
				--Es decir, se puede crear una figura que es igual al polígono definido, o, una figura que es el total de la tierra menos el polígono definido.

				--Por lo anterior se valida si se debe invertir el polígono o no				
				IF(@poligono.EnvelopeAngle() >= 90)
				BEGIN					
					SET @poligono = @poligono.ReorientObject();					
				END

				set @SectorEncontrado = (SELECT @poligono.STIntersects(@punto));

				-- El punto geográfico se encuentra dentro del sector?
				if @SectorEncontrado = 1
				BEGIN
				  SET @CodigoSector = @CodSector		  
				  BREAK
				END
			END
	
		/*Nos Movemos al siguiente registro*/
		FETCH NEXT FROM ListaSectores
		into @CodSector;

    END -- Fin del while
     
    /*cerramos el cursor*/
    CLOSE ListaSectores
    DEALLOCATE ListaSectores

RETURN @CodigoSector

END
GO
