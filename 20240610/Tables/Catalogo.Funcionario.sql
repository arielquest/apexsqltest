SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Funcionario] (
		[TC_UsuarioRed]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Nombre]              [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_PrimerApellido]      [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_SegundoApellido]     [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPlaza]            [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TC_CodSexo]             [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodFirma]            [uniqueidentifier] NULL,
		[TC_CodTitulo]           [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Funcionarios]
		PRIMARY KEY
		CLUSTERED
		([TC_UsuarioRed])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Funcionario]
	ADD
	CONSTRAINT [CK_Funcionario_Titulo]
	CHECK
	([TC_CodTitulo]='L' OR [TC_CodTitulo]='A' OR [TC_CodTitulo]='M' OR [TC_CodTitulo]='D' OR [TC_CodTitulo]='B')
GO
EXEC sp_addextendedproperty N'MS_Description', N'Restringe valores que se pueden ingresar a L(Licenciado), A(Licenciada), M(Master), D(Doctor), B(Doctora)', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'CONSTRAINT', N'CK_Funcionario_Titulo'
GO
ALTER TABLE [Catalogo].[Funcionario]
CHECK CONSTRAINT [CK_Funcionario_Titulo]
GO
ALTER TABLE [Catalogo].[Funcionario]
	ADD
	CONSTRAINT [DF_Funcionario_TC_CodPlaza]
	DEFAULT ('Valor no definido.') FOR [TC_CodPlaza]
GO
ALTER TABLE [Catalogo].[Funcionario]
	WITH CHECK
	ADD CONSTRAINT [FK_Funcionario_Sexo]
	FOREIGN KEY ([TC_CodSexo]) REFERENCES [Catalogo].[Sexo] ([TC_CodSexo])
ALTER TABLE [Catalogo].[Funcionario]
	CHECK CONSTRAINT [FK_Funcionario_Sexo]

GO
CREATE NONCLUSTERED INDEX [_dta_index_Funcionario_5_1036543472__K1_K2_K3_K4_K5_K6_K7]
	ON [Catalogo].[Funcionario] ([TC_UsuarioRed])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_por_Carga_1116]
	ON [Catalogo].[Funcionario] ([TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	INCLUDE ([TC_Nombre], [TC_PrimerApellido], [TC_SegundoApellido], [TC_CodPlaza], [TC_CodSexo], [TU_CodFirma], [TC_CodTitulo])
	ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de funcionarios del sistema.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red del funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primer apellido del funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_PrimerApellido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Segundo apellido del funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_SegundoApellido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de plaza asignada al funcionario por personal.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_CodPlaza'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no requerido que indica el género del funcionario', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_CodSexo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código archivo de la firma del funcionario', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TU_CodFirma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Título del funcionario, los valores que se pueden ingresar son L(Licenciado), A(Licenciada), M(Master), D(Doctor), B(Doctora)', 'SCHEMA', N'Catalogo', 'TABLE', N'Funcionario', 'COLUMN', N'TC_CodTitulo'
GO
ALTER TABLE [Catalogo].[Funcionario] SET (LOCK_ESCALATION = TABLE)
GO
