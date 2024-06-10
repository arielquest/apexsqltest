SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<15/04/2020>
-- Descripcion:			<Se obtiene el número consecutivo del Historial Procesal para un expediente>
-- =========================================================================================================
-- Modificación:		<29/05/2020> <Isaac Dobles Mata> <Se agregan variables internas>
-- Modificación:		<06/06/2021> <Olger Gamboa Castillo> <No se modific Sp, se hace comentario para que se considere que cualquier modificación en este Sp debe realizarla en este otro [Biztalk].[PA_AsociarActaComunicacion] ya que estan relacionados>
-- Modificación:		<13/09/2022> <Josué Quirós Batista> <Se modifica el select que obtiene el consecutivo del historial procesal de un expediente para obtener un único valor.>
-- =========================================================================================================

CREATE PROCEDURE [Expediente].[PA_GenerarConsecutivoHistorialProcesal]
	@NumeroExpediente		char(14),
	@CodigoLegajo			uniqueidentifier = null
As
Begin

	DECLARE
	@L_CodConsecutivo					uniqueidentifier,
	@L_Consecutivo					int,
	@L_TC_NumeroExpediente          char(14)            = @NumeroExpediente,    
	@L_TU_CodLegajo					uniqueidentifier    = @CodigoLegajo

	BEGIN	
		If @CodigoLegajo IS NOT NULL
			Begin
				Set @L_CodConsecutivo =		( SELECT Top 1  TU_CodHistorialConsecutivo
											  From			Expediente.ConsecutivoHistorialProcesal With(Nolock) 
											  Where			TC_NumeroExpediente						= @NumeroExpediente
											  And			TU_CodLegajo							= @CodigoLegajo
											  Order by		TN_Consecutivo Desc,					TF_Actualizacion Desc
											  )				
				
				If @L_CodConsecutivo IS NULL
					Begin
						Set @L_Consecutivo = 1
						Insert Into Expediente.ConsecutivoHistorialProcesal
							(TU_CodHistorialConsecutivo, TC_NumeroExpediente, TU_CodLegajo)
						Values  (NEWID(), @NumeroExpediente, @CodigoLegajo)
					End
				Else
					Begin
						Update	Expediente.ConsecutivoHistorialProcesal
						Set		TN_Consecutivo		= TN_Consecutivo + 1, 
								@L_Consecutivo		= TN_Consecutivo,
								TF_Actualizacion	= Getdate()
						Where	TU_CodHistorialConsecutivo	= @L_CodConsecutivo
						Set		@L_Consecutivo = (Select TN_Consecutivo From Expediente.ConsecutivoHistorialProcesal With (NoLock) Where TU_CodHistorialConsecutivo	= @L_CodConsecutivo)
					End
			End
		Else
			Begin
				Set @L_CodConsecutivo =		( SELECT Top 1  TU_CodHistorialConsecutivo
											  From			Expediente.ConsecutivoHistorialProcesal With(Nolock) 
											  Where			TC_NumeroExpediente						= @NumeroExpediente
											  And			TU_CodLegajo							IS NULL
											  Order by		TN_Consecutivo Desc,					TF_Actualizacion Desc
											  )				
				
				If @L_CodConsecutivo IS NULL
					Begin
						Set @L_Consecutivo = 1
						Insert Into Expediente.ConsecutivoHistorialProcesal
							(TU_CodHistorialConsecutivo, TC_NumeroExpediente)
						Values  (NEWID(), @NumeroExpediente)
					End
				Else
					Begin
						Update	Expediente.ConsecutivoHistorialProcesal
						Set		TN_Consecutivo		= TN_Consecutivo + 1, 
								@L_Consecutivo		= TN_Consecutivo,
								TF_Actualizacion	= Getdate()
						Where	TU_CodHistorialConsecutivo	= @L_CodConsecutivo
						Set		@L_Consecutivo = (Select TN_Consecutivo From Expediente.ConsecutivoHistorialProcesal With (NoLock) Where TU_CodHistorialConsecutivo	= @L_CodConsecutivo)
					End
			End		
		Select @L_Consecutivo
	END	
End
GO
