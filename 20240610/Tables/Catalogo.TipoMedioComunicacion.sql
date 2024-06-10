SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoMedioComunicacion] (
		[TN_CodMedio]                 [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoMedio]                [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_TieneHorarioEspecial]     [bit] NOT NULL,
		[TB_PermiteCopias]            [bit] NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](1) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[CODMEDCOM]                   [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		[id_medio]                    [smallint] NULL,
		CONSTRAINT [PK_MedioComunicacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMedio])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion]
	ADD
	CONSTRAINT [CK_MedioComunicacion_TipoMedio]
	CHECK
	([TC_TipoMedio]='I' OR [TC_TipoMedio]='J' OR [TC_TipoMedio]='R' OR [TC_TipoMedio]='G' OR [TC_TipoMedio]='F' OR [TC_TipoMedio]='N' OR [TC_TipoMedio]='E' OR [TC_TipoMedio]='C' OR [TC_TipoMedio]='D' OR [TC_TipoMedio]='S')
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipos de medio de comunicación:

D - Domicilio
C - Casillero
E - Email
N - Notificación electronica interna
F - Fax
G - Gestion en linea
R - Representante
J - Notificacion electronica entidad juridica
I - No indica
S - Estrados', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'CONSTRAINT', N'CK_MedioComunicacion_TipoMedio'
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion]
CHECK CONSTRAINT [CK_MedioComunicacion_TipoMedio]
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion]
	ADD
	CONSTRAINT [DF_MedioComunicacion_TN_CodMedio]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoMedioComunicacion]) FOR [TN_CodMedio]
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion]
	ADD
	CONSTRAINT [DF_MedioComunicacion_TC_TipoMedio]
	DEFAULT ('I') FOR [TC_TipoMedio]
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion]
	ADD
	CONSTRAINT [DF_MedioComunicacion_TB_TieneHorarioEspecial]
	DEFAULT ((0)) FOR [TB_TieneHorarioEspecial]
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion]
	ADD
	CONSTRAINT [DF_MedioComunicacion_TB_RequiereCopias]
	DEFAULT ((0)) FOR [TB_PermiteCopias]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los tipos de medios de comunicacion de los intervinientes.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del medio de comunicación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TN_CodMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del medio de comunicación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de medio de comunicación. D = Domicilio, C = Casillero, E = Email, N = Notificación electrónica interna, F = Fax, G = Gestión en línea,  R = Representante, J = Notificación electrónica entidad jurídica, I = No indica, S = Estrados', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TC_TipoMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el medio de comunicación tiene horario especial para diligenciarse.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TB_TieneHorarioEspecial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica que si el tipo de medio permite copias', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TB_PermiteCopias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoMedioComunicacion', 'COLUMN', N'CODMEDCOM'
GO
ALTER TABLE [Catalogo].[TipoMedioComunicacion] SET (LOCK_ESCALATION = TABLE)
GO
