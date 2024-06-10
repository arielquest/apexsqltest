SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[DepositoBancario] (
		[TU_CodObjeto]             [uniqueidentifier] NOT NULL,
		[TF_FechaDeposito]         [datetime] NOT NULL,
		[TC_NumeroTransaccion]     [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroCuenta]          [varchar](22) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroFolio]           [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreDepositante]     [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [UQ__Deposito__9E0B2123245E3969]
		UNIQUE
		NONCLUSTERED
		([TU_CodObjeto])
		ON [PRIMARY],
		CONSTRAINT [PK_DepositoBancario]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodObjeto])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[DepositoBancario]
	ADD
	CONSTRAINT [DF__DepositoB__TF_Pa__7450C40E]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[DepositoBancario]
	WITH CHECK
	ADD CONSTRAINT [FK_DepositoBancario_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[DepositoBancario]
	CHECK CONSTRAINT [FK_DepositoBancario_Objeto]

GO
CREATE CLUSTERED INDEX [IX_Objeto_DepositoBancario_TF_Particion]
	ON [Objeto].[DepositoBancario] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de DepositoBancario', 'SCHEMA', N'Objeto', 'TABLE', N'DepositoBancario', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha en que se realizó el depósito bancario,', 'SCHEMA', N'Objeto', 'TABLE', N'DepositoBancario', 'COLUMN', N'TF_FechaDeposito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el número de boleta de depósito,', 'SCHEMA', N'Objeto', 'TABLE', N'DepositoBancario', 'COLUMN', N'TC_NumeroTransaccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el número de cuenta en el que se hizo el depósito', 'SCHEMA', N'Objeto', 'TABLE', N'DepositoBancario', 'COLUMN', N'TC_NumeroCuenta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el número de folio del libro de depósitos bancarios donde está agregada la copia de la boleta de depósito', 'SCHEMA', N'Objeto', 'TABLE', N'DepositoBancario', 'COLUMN', N'TC_NumeroFolio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el nombre de la persona que realiza el depósito', 'SCHEMA', N'Objeto', 'TABLE', N'DepositoBancario', 'COLUMN', N'TC_NombreDepositante'
GO
ALTER TABLE [Objeto].[DepositoBancario] SET (LOCK_ESCALATION = TABLE)
GO
