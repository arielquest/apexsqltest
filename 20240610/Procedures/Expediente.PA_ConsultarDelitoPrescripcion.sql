SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<28/09/2015>
-- Descripción :			<Permite Consultar los delitos de prescripcionn de delitos de un imputado 
--
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre de los campos TC_CodDelito, TC_CodInterrupcion y TC_CodSuspensionPrescripcion a TN_CodDelito, TN_CodInterrupcion y TN_CodSuspensionPrescripcion de acuerdo al tipo de dato.>
-- =================================================================================================================================================

  
CREATE PROCEDURE [Expediente].[PA_ConsultarDelitoPrescripcion]
 @CodigoInterviniente uniqueidentifier
    As
 Begin
 select a.TU_CodDelitoPrescripcion		as Codigo,
		a.TF_Prescribe					as Prescribe,
		a.TF_FechaActo					as FechaActo,	'SplitDE' AS SplitDE,
		a.TN_CodDelito					as Codigo,   
		b.TC_Descripcion				as Descripcion,	'SplitCI' AS SplitCI,
		a.TN_CodInterrupcion			as Codigo,
		c.TC_Descripcion				as Descripcion, 'SplitSU' AS SplitSU,
		a.TN_CodSuspensionPrescripcion  as Codigo,
		d.TC_Descripcion				as Descripcion,	'SplitUR' AS SplitUR,
		a.TC_UsuarioRed					as UsuarioRed,
		e.TC_Nombre						as NOmbre

 from Expediente.DelitoPrescripcion as a WITH (Nolock)
 join							Catalogo.Delito						as b on a.TN_CodDelito=b.TN_CodDelito
 left outer join				Catalogo.InterrupcionPrescripcion	as c on a.TN_CodInterrupcion=c.TN_CodInterrupcion
 left outer join				Catalogo.SuspensionPrescripcion		as d on a.TN_CodSuspensionPrescripcion=d.TN_CodSuspensionPrescripcion
 join							Catalogo.Funcionario				as e on a.TC_UsuarioRed=e.TC_UsuarioRed
 where TU_CodInterviniente=@CodigoInterviniente

  End




GO
