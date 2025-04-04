SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[ProductDescription] (
		[ProductDescriptionID]     [int] IDENTITY(1, 1) NOT NULL,
		[Description]              [nvarchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rowguid]                  [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]             [datetime] NOT NULL,
		CONSTRAINT [AK_ProductDescription_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid])
		ON [PRIMARY],
		CONSTRAINT [PK_ProductDescription_ProductDescriptionID]
		PRIMARY KEY
		CLUSTERED
		([ProductDescriptionID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'INDEX', N'PK_ProductDescription_ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'PK_ProductDescription_ProductDescriptionID'
GO
ALTER TABLE [SalesLT].[ProductDescription]
	ADD
	CONSTRAINT [DF_ProductDescription_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'DF_ProductDescription_rowguid'
GO
ALTER TABLE [SalesLT].[ProductDescription]
	ADD
	CONSTRAINT [DF_ProductDescription_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'DF_ProductDescription_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product descriptions in several languages.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductDescription records.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the product.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'AK_ProductDescription_rowguid'
GO
ALTER TABLE [SalesLT].[ProductDescription] SET (LOCK_ESCALATION = TABLE)
GO
