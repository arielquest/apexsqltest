SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[ListToTable] (@list varchar(8000))
returns @tab table (item varchar(100))
begin

if CHARINDEX(',',@list) = 0 or CHARINDEX(',',@list) is null
begin
    insert into @tab (item) values (@list);
    return;
end


declare @c_pos int;
declare @n_pos int;
declare @l_pos int;

set @c_pos = 0;
set @n_pos = CHARINDEX(',',@list,@c_pos);

while @n_pos > 0
begin
    insert into @tab (item) values  (LTRIM(RTRIM((SUBSTRING(@list,@c_pos+1,@n_pos - @c_pos-1)))));
    set @c_pos = @n_pos;
    set @l_pos = @n_pos;
    set @n_pos = CHARINDEX(',',@list,@c_pos+1);
end;

insert into @tab (item) values  (LTRIM(RTRIM(SUBSTRING(@list,@l_pos+1,4000))));

return;
end;
GO
