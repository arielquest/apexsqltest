SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Valida si los datos se pueden insertar/modificar en PuestoTrabajo, retorna 1 cuando es válido.> 
-- =================================================================================================================================================
CREATE FUNCTION [Catalogo].[FN_ValidarOficinaTipoFuncionario]
(
	@CodOficina					varchar(4),
	@CodTipoFuncionario			smallint
)
RETURNS bit
AS
BEGIN
	Declare	@Valido				As bit = 0;

		Set	@Valido =	(select 1 Where Exists( Select		A.TN_CodTipoOficina
															From		Catalogo.TipoOficinaTipoFuncionario		A With(NoLock)
															inner join Catalogo.Oficina B With(NoLock) on A.TN_CodTipoOficina=B.TN_CodTipoOficina
															Where		A.TN_CodTipoFuncionario=@CodTipoFuncionario and B.TC_CodOficina=@CodOficina 
															--and
														--	A.TF_Inicio_Vigencia<=GETDATE()
						  					  ) 
																		
						) 

		if @Valido is null begin
			set @Valido = 0
		end
		  
	Return @Valido ;
END
GO
