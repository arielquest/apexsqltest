SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Contexto] (
		[TC_CodOficina]                         [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                        [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoOCJ]                     [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodMateria]                         [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]                        [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Telefono]                           [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Fax]                                [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Email]                              [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Inicio_Vigencia]                    [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]                       [datetime2](3) NULL,
		[TB_EnvioEscrito_GL_AM]                 [bit] NOT NULL,
		[TB_EnvioDemandaDenuncia_GL_AM]         [bit] NOT NULL,
		[TB_ConsultaPublicaCiudadano]           [bit] NOT NULL,
		[TB_ConsultaPrivadaCiudadano]           [bit] NOT NULL,
		[TB_SolicitudCitas_GL_AM]               [bit] NOT NULL,
		[TB_UtilizaSiagpj]                      [bit] NOT NULL,
		[TB_SolicitudApremios_GL_AM]            [bit] NOT NULL,
		[NUMDEJ]                                [int] NULL,
		[CODTIDEJ]                              [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_PaginaWeb]                          [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodProvincia]                       [smallint] NULL,
		[TN_CodCanton]                          [smallint] NULL,
		[TN_CodDistrito]                        [smallint] NULL,
		[TN_CodBarrio]                          [smallint] NULL,
		[TB_ValidacionDocumento_GL_AM]          [bit] NULL,
		[TC_CodContextoSuperior]                [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_EnvioInformesFacilitador_GL_AM]     [bit] NOT NULL,
		CONSTRAINT [PK_Contexto]
		PRIMARY KEY
		CLUSTERED
		([TC_CodContexto])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF_Catalogo_Contexto_TB_EnvioEscrito_GL_AM]
	DEFAULT ((0)) FOR [TB_EnvioEscrito_GL_AM]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF_Catalogo_Contexto_TB_EnvioDemandaDenuncia_GL_AM]
	DEFAULT ((0)) FOR [TB_EnvioDemandaDenuncia_GL_AM]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF_Catalogo_Contexto_TB_ConsultaPublicaCiudadano]
	DEFAULT ((0)) FOR [TB_ConsultaPublicaCiudadano]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF_Catalogo_Contexto_TB_ConsultaPrivadaCiudadano]
	DEFAULT ((0)) FOR [TB_ConsultaPrivadaCiudadano]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF_Contexto_TB_SolicitudCitas_GL_AM]
	DEFAULT ((0)) FOR [TB_SolicitudCitas_GL_AM]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF__Contexto__TB_Uti__3F099E7E]
	DEFAULT ((0)) FOR [TB_UtilizaSiagpj]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF_Contexto_TB_SolicitudApremios_GL_AM]
	DEFAULT ((0)) FOR [TB_SolicitudApremios_GL_AM]
GO
ALTER TABLE [Catalogo].[Contexto]
	ADD
	CONSTRAINT [DF__Contexto__TB_Env__092A4EB5]
	DEFAULT ((0)) FOR [TB_EnvioInformesFacilitador_GL_AM]
GO
ALTER TABLE [Catalogo].[Contexto]
	WITH CHECK
	ADD CONSTRAINT [FK_Contexto_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [Catalogo].[Contexto]
	CHECK CONSTRAINT [FK_Contexto_Barrio]

GO
ALTER TABLE [Catalogo].[Contexto]
	WITH CHECK
	ADD CONSTRAINT [FK_Contexto_Canton]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton]) REFERENCES [Catalogo].[Canton] ([TN_CodProvincia], [TN_CodCanton])
ALTER TABLE [Catalogo].[Contexto]
	CHECK CONSTRAINT [FK_Contexto_Canton]

GO
ALTER TABLE [Catalogo].[Contexto]
	WITH CHECK
	ADD CONSTRAINT [FK_Contexto_Distrito]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito]) REFERENCES [Catalogo].[Distrito] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
ALTER TABLE [Catalogo].[Contexto]
	CHECK CONSTRAINT [FK_Contexto_Distrito]

GO
ALTER TABLE [Catalogo].[Contexto]
	WITH CHECK
	ADD CONSTRAINT [FK_Contexto_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[Contexto]
	CHECK CONSTRAINT [FK_Contexto_Materia]

GO
ALTER TABLE [Catalogo].[Contexto]
	WITH CHECK
	ADD CONSTRAINT [FK_Contexto_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Catalogo].[Contexto]
	CHECK CONSTRAINT [FK_Contexto_Oficina]

GO
ALTER TABLE [Catalogo].[Contexto]
	WITH CHECK
	ADD CONSTRAINT [FK_Contexto_Provincia]
	FOREIGN KEY ([TN_CodProvincia]) REFERENCES [Catalogo].[Provincia] ([TN_CodProvincia])
ALTER TABLE [Catalogo].[Contexto]
	CHECK CONSTRAINT [FK_Contexto_Provincia]

GO
CREATE NONCLUSTERED INDEX [IDX_CONTEXTO_MIGRACION_PRECARGA]
	ON [Catalogo].[Contexto] ([TC_CodMateria], [CODTIDEJ])
	ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que asocia los contextos de una oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la oficina a la cual pertenece un contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto de la oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto OCJ', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_CodContextoOCJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de materia del contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion del contexto de una oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de telefono del contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_Telefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de fax del contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cuenta de correo electronico del contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del cotexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se realiza el envío de escritos desde Gestión en Línea a la Aplicación Móvil', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_EnvioEscrito_GL_AM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se realiza el envío de demandas y denuncias desde Gestión en Línea a la Aplicación Móvil', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_EnvioDemandaDenuncia_GL_AM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se realiza la consulta pública al ciudadano', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_ConsultaPublicaCiudadano'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si se realiza la consulta privada al ciudadano', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_ConsultaPrivadaCiudadano'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si para el contexto se habilita la solicitud de citas desde GL o app movil', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_SolicitudCitas_GL_AM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para establecer que el ámbito de trabajo del contexto es en el SIAGPJ', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_UtilizaSiagpj'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para solicitud de ordenes de apremio desde Gestión en Línea o la Aplicación Móvil', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_SolicitudApremios_GL_AM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número correlativo que se le asigna a un despacho en Gestión, se registra para mantener la forma de generar IDINT en Gestión y facilitar las itineraciones', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'NUMDEJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de despacho que utiliza Gestión, se registra para facilitar las itineraciones entre SIAGPJ y Gestión', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'CODTIDEJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'URL de página Web asociada al contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_PaginaWeb'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de provincia', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'Description', N'Validación de documentos desde Gestión en Línea o la Aplicación Móvil', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_ValidacionDocumento_GL_AM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto superior utilizado en GL para que el usuario pueda señalar si un escrito es de apelación', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TC_CodContextoSuperior'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si el contexto está habilitado para el envío de informes de facilitador judicial desde Gestión en Línea o Aplicación Móvil', 'SCHEMA', N'Catalogo', 'TABLE', N'Contexto', 'COLUMN', N'TB_EnvioInformesFacilitador_GL_AM'
GO
ALTER TABLE [Catalogo].[Contexto] SET (LOCK_ESCALATION = TABLE)
GO
