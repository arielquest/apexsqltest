SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<26/01/2021>
-- Descripción :			<Permite asociar motivos de estado de eventos, estado evento por tipo oficina por materia>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarMotivoEstadoEventoTipoOficina]
   @CodMotivoEstadoEvento		SMALLINT,
   @CodEstadoEvento				SMALLINT,
   @CodTipoOficina	        	SMALLINT,
   @CodMateria			        VARCHAR(5),
   @Inicio_Vigencia		        DATETIME2(7)
AS 
BEGIN          
-- VARIABLES
DECLARE		@L_CodMotivoEstadoEvento	SMALLINT		= @CodMotivoEstadoEvento,
            @L_CodEstadoEvento	        SMALLINT		= @CodEstadoEvento,
			@L_CodTipoOficina	      	SMALLINT		= @CodTipoOficina,
			@L_CodMateria			    VARCHAR(5)		= @CodMateria,
			@L_Inicio_Vigencia		    DATETIME2(7)	= @Inicio_Vigencia
--LÓGICA
	INSERT INTO Catalogo.MotivoEstadoEventoTipoOficina WITH(ROWLOCK)
	(	
		TN_CodMotivoEstado,		  TN_CodEstadoEvento,		TN_CodTipoOficina,		TC_CodMateria,		TF_Inicio_Vigencia
	)
	VALUES
	(	
		@L_CodMotivoEstadoEvento, @L_CodEstadoEvento,		@L_CodTipoOficina,		@L_CodMateria,		@L_Inicio_Vigencia
	);
END
GO
