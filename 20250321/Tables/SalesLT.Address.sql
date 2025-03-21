SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[Address] (
		[AddressID]         [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
		[AddressLine1]      [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[AddressLine2]      [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[City]              [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[StateProvince]     [dbo].[Name] NOT NULL,
		[CountryRegion]     [dbo].[Name] NOT NULL,
		[PostalCode]        [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rowguid]           [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]      [datetime] NOT NULL,
		CONSTRAINT [AK_Address_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid])
		ON [PRIMARY],
		CONSTRAINT [PK_Address_AddressID]
		PRIMARY KEY
		CLUSTERED
		([AddressID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'INDEX', N'PK_Address_AddressID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'CONSTRAINT', N'PK_Address_AddressID'
GO
ALTER TABLE [SalesLT].[Address]
	ADD
	CONSTRAINT [DF_Address_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'CONSTRAINT', N'DF_Address_rowguid'
GO
ALTER TABLE [SalesLT].[Address]
	ADD
	CONSTRAINT [DF_Address_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'CONSTRAINT', N'DF_Address_ModifiedDate'
GO
CREATE NONCLUSTERED INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion]
	ON [SalesLT].[Address] ([AddressLine1], [AddressLine2], [City], [StateProvince], [PostalCode], [CountryRegion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'INDEX', N'IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion'
GO
CREATE NONCLUSTERED INDEX [IX_Address_StateProvince]
	ON [SalesLT].[Address] ([StateProvince])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'INDEX', N'IX_Address_StateProvince'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street address information for customers.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Address records.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'AddressID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First street address line.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'AddressLine1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Second street address line.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'AddressLine2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the city.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of state or province.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'StateProvince'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Postal code for the street address.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'PostalCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'Address', 'CONSTRAINT', N'AK_Address_rowguid'
GO
ALTER TABLE [SalesLT].[Address] SET (LOCK_ESCALATION = TABLE)
GO
