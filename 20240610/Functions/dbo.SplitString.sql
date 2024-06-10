SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[SplitString] 
(
    @str nvarchar(max), 
    @separator char(1)
)
returns table
AS
return (
with tokens(p, a, b) AS (
    select 
        cast(1 as bigint), 
        cast(1 as bigint), 
        charindex(@separator, @str)
    union all
    select
        p + 1, 
        b + 1, 
        charindex(@separator, @str, b + 1)
    from tokens
    where b > 0
)
select
    p-1 ItemIndex,
    substring(
        @str, 
        a, 
        case when b > 0 then b-a ELSE LEN(@str) end) 
    AS s
from tokens
);


GO
