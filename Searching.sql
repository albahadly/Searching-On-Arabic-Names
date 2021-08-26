
BEGIN
		DECLARE @Text NVARCHAR(MAX) = 'حمزة', --Search Value
	        @Text2 NVARCHAR(MAX) = ''
	        
	        
	CREATE TABLE #DictionaryHeader
	(
		Id              INT NOT NULL,
		[GroupName]     [nvarchar](150) NULL
	)
	
	
	CREATE TABLE #DictionaryBody
	(
		Id              INT NOT NULL,
		[GroupId]       INT NULL,
		[CharValue]     [nvarchar](50) NULL,
	)
	CREATE TABLE #tb_char
	(
		ID      INT IDENTITY(1, 1) PRIMARY KEY,
		col     NVARCHAR(1)
	)
	
	
	CREATE TABLE #Items
	(
		ItemName NVARCHAR(100)
	)
	
	INSERT INTO #Items
	  (
	    ItemName
	  )
	VALUES
	  ('حمزة'),('حمزه'),('احمد'),('أحمد')
	
	INSERT #DictionaryHeader
	  (
	    Id,
	    [GroupName]
	  )
	VALUES
	  (1,N'حرف التاء'),
	  (2, N'حرف الباء'),
	  (3, N'حرف الالف')
	---------
	
	INSERT #DictionaryBody
	  (
	    Id,
	    [GroupId],
	    [CharValue]
	  )
	VALUES
	  (
	    1,
	    3,
	    N'أ'
	  )
	,
	(2, 3, N'ا')
	,
	(3, 3, N'إ')
	,
	(4, 3, N'آ')
	,
	(5, 2, N'ب')
	,
	(6, 1, N'ه')
	,
	(7, 1, N'ة')
	
	
	

	
	
	DECLARE @po INT = 1
	DECLARE @exp NVARCHAR(MAX)
	DECLARE @stc NVARCHAR(1)
	
	
	SET @Text = REPLACE(@Text, ' ', '')
	WHILE (@po <= LEN(@Text))
	BEGIN
	    SELECT @stc = SUBSTRING(@Text, @po, 1); 
	    SET @po += 1
	    INSERT INTO #tb_char
	      (
	        col
	      )
	    SELECT @stc
	END
	
	
	DECLARE @TableSearch NVARCHAR(50)
	
	DECLARE _SearchForCateg CURSOR 
	FOR
	    SELECT col
	    FROM   #tb_char
	    ORDER BY
	           ID
	
	OPEN _SearchForCateg;
	FETCH NEXT FROM _SearchForCateg INTO @TableSearch
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SELECT @exp = '[' + STUFF(
	               (
	                   SELECT CharValue
	                   FROM   #DictionaryBody
	                   WHERE  GroupId IN (SELECT GroupId
	                                      FROM   #DictionaryBody
	                                      WHERE  CharValue = @TableSearch) FOR XML PATH('')
	               ),
	               1,
	               0,
	               ''
	           ) + ']'
	    
	    IF (LEN(@exp) > 0)
	    BEGIN
	        SET @Text2 += @exp
	    END
	    ELSE
	    BEGIN
	        SET @Text2 += @TableSearch
	    END
	    
	    FETCH NEXT FROM _SearchForCateg INTO @TableSearch
	END
	CLOSE _SearchForCateg;
	
	DEALLOCATE _SearchForCateg;
	SET @Text = @Text2
	
	
	
	SELECT *
	FROM   #Items
	WHERE  ItemName LIKE '%' + @Text + '%'
	
	DROP TABLE #DictionaryHeader 
	DROP TABLE #DictionaryBody
	DROP TABLE #tb_char
	DROP TABLE #Items
END
