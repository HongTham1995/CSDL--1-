-- Tạo cơ sở dữ liệu CSDLNC
CREATE DATABASE CSDLNC;
GO

-- Tạo cơ sở dữ liệu DLTT
CREATE DATABASE DLTT;
GO

-- Tạo cơ sở dữ liệu DLTS
CREATE DATABASE DLTS;
GO

-- Tạo cơ sở dữ liệu DLTC
CREATE DATABASE DLTC;
GO


USE CSDLNC;
GO

-- Tạo bảng Mota trong CSDLNC
CREATE TABLE Mota (
    maMT INT IDENTITY(1,1) PRIMARY KEY,       -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Link NVARCHAR(255),                       -- Link tham khảo
    Thoigian DATETIME                         -- Thời gian lấy dữ liệu
);
GO

-- Tạo bảng Cau_hoi trong CSDLNC
CREATE TABLE Cau_hoi (
    ID INT IDENTITY(1,1) PRIMARY KEY,         -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),                      -- Đáp án đúng (A, B, C, D)
    Nguoi_kiem_duyet_1 NVARCHAR(255),         -- Người kiểm duyệt 1
    Nguoi_kiem_duyet_2 NVARCHAR(255),         -- Người kiểm duyệt 2
    maMT INT,                                 -- Mã mô tả, liên kết đến bảng Mota
    Nguon NVARCHAR(10),                       -- Nguồn dữ liệu (DLTT, DLTS, DLTC)
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO

-- Tạo bảng ánh xạ tạm thời
CREATE TABLE MaMT_Map (
    Old_maMT INT,           -- Mã mô tả cũ
    New_maMT INT,           -- Mã mô tả mới
    Source_DB NVARCHAR(10)  -- Nguồn dữ liệu (DLTT, DLTS, DLTC)
);
GO

-- Tạo bảng trong cơ sở dữ liệu DLTT
USE DLTT;
GO

-- Tạo bảng Mota trong DLTT
CREATE TABLE Mota (
    maMT INT IDENTITY(1,1) PRIMARY KEY,       -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Link NVARCHAR(255),                       -- Link tham khảo
    Thoigian DATETIME,                        -- Thời gian lấy dữ liệu               -- Chương của câu hỏi
   
);
GO

-- Tạo bảng Cauhoi trong DLTT với khóa ngoại maMT tham chiếu đến bảng Mota
CREATE TABLE Cau_hoi (
    ID INT IDENTITY(1,1) PRIMARY KEY,         -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),     
    Nguoi_kiem_duyet NVARCHAR(255),                -- Đáp án đúng (A, B, C, D)
    maMT INT,                                 -- Mã mô tả, liên kết đến bảng Mota
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO

-- Tạo bảng trong cơ sở dữ liệu DLTS
USE DLTS;
GO

-- Tạo bảng Mota trong DLTS
CREATE TABLE Mota (
    maMT INT IDENTITY(1,1) PRIMARY KEY,       -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Thoigian DATETIME,                        -- Thời gian lấy dữ liệu
                       -- Chương của câu hỏi
);
GO

-- Tạo bảng Cauhoi trong DLTS với khóa ngoại maMT tham chiếu đến bảng Mota
CREATE TABLE Cau_hoi (
    ID INT IDENTITY(1,1) PRIMARY KEY,         -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),    
    Nguoi_kiem_duyet_1 NVARCHAR(255),
    Nguoi_kiem_duyet_2 NVARCHAR(255),                 -- Đáp án đúng (A, B, C, D)
    maMT INT,                                 -- Mã mô tả, liên kết đến bảng Mota
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO

-- Tạo bảng trong cơ sở dữ liệu DLTC
USE DLTC;
GO

-- Tạo bảng Mota trong DLTC
CREATE TABLE Mota (
    maMT INT IDENTITY(1,1) PRIMARY KEY,       -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Thoigian DATETIME,                        -- Thời gian lấy dữ liệu
                        -- Chương của câu hỏi
);
GO

-- Tạo bảng Cauhoi trong DLTC với khóa ngoại maMT tham chiếu đến bảng Mota
CREATE TABLE Cau_hoi (
    ID INT IDENTITY(1,1) PRIMARY KEY,         -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),                      -- Đáp án đúng (A, B, C, D)
    maMT INT,                                 -- Mã mô tả, liên kết đến bảng Mota
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO



USE DLTC;
GO


CREATE TRIGGER trg_Insert_Mota_DLTC
ON Mota
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm dữ liệu mới vào bảng Mota của CSDLNC nếu không trùng khớp
    INSERT INTO CSDLNC.dbo.Mota (De_tai, Nguon, Link, Thoigian)
    SELECT 
        i.De_tai, 
        i.Nguon, 
        NULL AS Link, 
        i.Thoigian
    FROM INSERTED i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM CSDLNC.dbo.Mota csdl_m
        WHERE csdl_m.De_tai = i.De_tai
          AND csdl_m.Nguon = i.Nguon
          AND csdl_m.Thoigian = i.Thoigian
    );

    -- Tạo hoặc sử dụng ánh xạ mã mô tả dựa trên điều kiện
    INSERT INTO CSDLNC.dbo.MaMT_Map (Old_maMT, New_maMT, Source_DB)
    SELECT 
        i.maMT, 
        ISNULL(  -- Nếu mã mô tả tồn tại, lấy mã hiện có; nếu không, tạo mã mới
            (
                SELECT csdl_m.maMT 
                FROM CSDLNC.dbo.Mota csdl_m
                WHERE csdl_m.De_tai = i.De_tai
                  AND csdl_m.Nguon = i.Nguon
                  AND csdl_m.Thoigian = i.Thoigian
            ), 
            IDENT_CURRENT('CSDLNC.dbo.Mota')  -- Mã mới nếu không tồn tại
        ) AS New_maMT,
        'DLTC' AS Source_DB
    FROM INSERTED i;
END;
GO




CREATE TRIGGER trg_Update_Mota_DLTC
ON Mota
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật dữ liệu trong bảng Mota của CSDLNC
    UPDATE CSDLNC.dbo.Mota
    SET 
        De_tai = i.De_tai,
        Nguon=i.Nguon,
        Thoigian = i.Thoigian
    FROM INSERTED i
    INNER JOIN CSDLNC.dbo.MaMT_Map map
        ON map.Old_maMT = i.maMT AND map.Source_DB = 'DLTC'
    WHERE CSDLNC.dbo.Mota.maMT = map.New_maMT;
END;
GO




CREATE TRIGGER trg_Delete_Mota_DLTC
ON Mota
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu trong CSDLNC.dbo.Mota dựa trên ánh xạ mã mô tả
    DELETE FROM CSDLNC.dbo.Mota
    WHERE maMT IN (
        SELECT map.New_maMT
        FROM DELETED d
        JOIN CSDLNC.dbo.MaMT_Map map ON map.Old_maMT = d.maMT AND map.Source_DB = 'DLTC'
    );

    -- Xóa ánh xạ mã mô tả trong bảng MaMT_Map
    DELETE FROM CSDLNC.dbo.MaMT_Map
    WHERE Old_maMT IN (SELECT maMT FROM DELETED) AND Source_DB = 'DLTC';
END;
GO



CREATE TRIGGER trg_Insert_Cauhoi_DLTC
ON Cau_hoi
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm kiểm tra để đảm bảo ánh xạ mã mô tả không bị thiếu
    INSERT INTO CSDLNC.dbo.Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, 
                                    Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT, Nguon)
    SELECT i.cau_hoi, i.dap_an_a, i.dap_an_b, i.dap_an_c, i.dap_an_d, i.dap_an_dung, 
           NULL AS Nguoi_kiem_duyet_1, NULL AS Nguoi_kiem_duyet_2, 
           map.New_maMT, 'DLTC'
    FROM INSERTED i
    JOIN CSDLNC.dbo.MaMT_Map map
        ON map.Old_maMT = i.maMT AND map.Source_DB = 'DLTC';
END;
GO




CREATE TRIGGER trg_Update_Cauhoi_DLTC
ON Cau_hoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật dữ liệu trong bảng Cau_hoi của CSDLNC
    UPDATE CSDLNC.dbo.Cau_hoi
    SET 
        cau_hoi = i.cau_hoi,
        dap_an_a = i.dap_an_a,
        dap_an_b = i.dap_an_b,
        dap_an_c = i.dap_an_c,
        dap_an_d = i.dap_an_d,
        dap_an_dung = i.dap_an_dung,
        Nguoi_kiem_duyet_1 = NULL, -- Cập nhật giá trị nếu cần
        Nguoi_kiem_duyet_2 = NULL  -- Cập nhật giá trị nếu cần
    FROM INSERTED i
    JOIN CSDLNC.dbo.Cau_hoi ch
        ON ch.ID = i.ID AND ch.Nguon = 'DLTC';
END;
GO


CREATE TRIGGER trg_Delete_Cauhoi_DLTC
ON Cau_hoi
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa câu hỏi trong bảng Cau_hoi của CSDLNC khi bị xóa trong DLTC
    DELETE ch
    FROM CSDLNC.dbo.Cau_hoi ch
    INNER JOIN DELETED d
        ON ch.cau_hoi = d.cau_hoi          -- Kiểm tra nội dung câu hỏi
        AND ch.dap_an_a = d.dap_an_a       -- Kiểm tra đáp án A
        AND ch.dap_an_b = d.dap_an_b       -- Kiểm tra đáp án B
        AND ch.dap_an_c = d.dap_an_c       -- Kiểm tra đáp án C
        AND ch.dap_an_d = d.dap_an_d       -- Kiểm tra đáp án D
        AND ch.dap_an_dung = d.dap_an_dung -- Kiểm tra đáp án đúng
    WHERE ch.Nguon = 'DLTC';               -- Chỉ áp dụng cho nguồn DLTC
END;
GO


USE DLTT;
GO

-- Trigger Insert Mota cho DLTT
CREATE TRIGGER trg_Insert_Mota_DLTT
ON Mota
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm dữ liệu mới vào bảng Mota của CSDLNC nếu không trùng khớp
    INSERT INTO CSDLNC.dbo.Mota (De_tai, Nguon, Link, Thoigian)
    SELECT 
        i.De_tai, 
        i.Nguon, 
        i.Link, 
        i.Thoigian
    FROM INSERTED i
    WHERE NOT EXISTS (
        SELECT 1 
        FROM CSDLNC.dbo.Mota csdl_m
        WHERE csdl_m.De_tai = i.De_tai
          AND csdl_m.Nguon = i.Nguon
          AND csdl_m.Thoigian = i.Thoigian
		  AND csdl_m.Link = i.Link
    );

    -- Tạo hoặc sử dụng ánh xạ mã mô tả dựa trên điều kiện
    INSERT INTO CSDLNC.dbo.MaMT_Map (Old_maMT, New_maMT, Source_DB)
    SELECT 
        i.maMT, 
        ISNULL(  -- Nếu mã mô tả tồn tại, lấy mã hiện có; nếu không, tạo mã mới
            (
                SELECT csdl_m.maMT 
                FROM CSDLNC.dbo.Mota csdl_m
                WHERE csdl_m.De_tai = i.De_tai
                  AND csdl_m.Nguon = i.Nguon
                  AND csdl_m.Thoigian = i.Thoigian
            ), 
            IDENT_CURRENT('CSDLNC.dbo.Mota')  -- Mã mới nếu không tồn tại
        ) AS New_maMT,
        'DLTT' AS Source_DB
    FROM INSERTED i;
END;
GO

-- Trigger Update Mota cho DLTT
CREATE TRIGGER trg_Update_Mota_DLTT
ON Mota
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật dữ liệu trong Mota của CSDLNC chỉ khi có câu hỏi trong Cau_hoi của DLTT có Nguoi_kiem_duyet không NULL
    UPDATE CSDLNC.dbo.Mota
    SET 
        De_tai = i.De_tai,
        Nguon = i.Nguon,
        Link = i.Link,
        Thoigian = i.Thoigian
    FROM INSERTED i
    INNER JOIN CSDLNC.dbo.MaMT_Map map
        ON map.Old_maMT = i.maMT AND map.Source_DB = 'DLTT'
    WHERE CSDLNC.dbo.Mota.maMT = map.New_maMT
      AND EXISTS (
          SELECT 1 
          FROM DLTT.dbo.Cau_hoi ch
          WHERE ch.maMT = i.maMT AND ch.Nguoi_kiem_duyet IS NOT NULL
      );
END;
GO

CREATE TRIGGER trg_Delete_Mota_DLTT
ON Mota
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu trong CSDLNC.dbo.Mota dựa trên ánh xạ mã mô tả
    DELETE FROM CSDLNC.dbo.Mota
    WHERE maMT IN (
        SELECT map.New_maMT
        FROM DELETED d
        JOIN CSDLNC.dbo.MaMT_Map map ON map.Old_maMT = d.maMT AND map.Source_DB = 'DLTT'
    );

    -- Xóa ánh xạ mã mô tả trong bảng MaMT_Map
    DELETE FROM CSDLNC.dbo.MaMT_Map
    WHERE Old_maMT IN (SELECT maMT FROM DELETED) AND Source_DB = 'DLTT';
END;
GO


-- Trigger Insert Cau_hoi cho DLTT
CREATE TRIGGER trg_Insert_Cauhoi_DLTT
ON Cau_hoi
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ thêm câu hỏi được kiểm duyệt vào bảng Cau_hoi của CSDLNC
    INSERT INTO CSDLNC.dbo.Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, 
                                    Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT, Nguon)
    SELECT i.cau_hoi, i.dap_an_a, i.dap_an_b, i.dap_an_c, i.dap_an_d, i.dap_an_dung, 
           i.Nguoi_kiem_duyet, NULL AS Nguoi_kiem_duyet_2,
           map.New_maMT, 'DLTT'
    FROM INSERTED i
    JOIN CSDLNC.dbo.MaMT_Map map
        ON map.Old_maMT = i.maMT AND map.Source_DB = 'DLTT'
    WHERE i.Nguoi_kiem_duyet IS NOT NULL;
END;
GO



-- Trigger Update Cau_hoi cho DLTT
-- Trigger Update Cau_hoi cho DLTT
CREATE TRIGGER trg_Update_Cauhoi_DLTT
ON Cau_hoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm câu hỏi mới vào CSDLNC nếu Nguoi_kiem_duyet được cập nhật từ NULL sang khác NULL
    INSERT INTO CSDLNC.dbo.Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, 
                                    Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT, Nguon)
    SELECT 
        i.cau_hoi, 
        i.dap_an_a, 
        i.dap_an_b, 
        i.dap_an_c, 
        i.dap_an_d, 
        i.dap_an_dung, 
        i.Nguoi_kiem_duyet, 
        NULL AS Nguoi_kiem_duyet_2,
        ISNULL(  
            (SELECT csdl_m.maMT
             FROM CSDLNC.dbo.Mota csdl_m
             WHERE csdl_m.De_tai = m.De_tai
               AND csdl_m.Nguon = m.Nguon
			   AND csdl_m.Link = m.Link
               AND csdl_m.Thoigian = m.Thoigian), 
            IDENT_CURRENT('CSDLNC.dbo.Mota')  
        ) AS New_maMT,
        'DLTT' AS Nguon
    FROM INSERTED i
    INNER JOIN DLTT.dbo.Mota m ON i.maMT = m.maMT
    WHERE i.Nguoi_kiem_duyet IS NOT NULL 
      
      AND NOT EXISTS (
          SELECT 1 
          FROM CSDLNC.dbo.Cau_hoi ch
          WHERE ch.cau_hoi = i.cau_hoi AND ch.Nguon = 'DLTT'
      );

    -- Cập nhật thông tin câu hỏi trong CSDLNC
    UPDATE CSDLNC.dbo.Cau_hoi
    SET 
        cau_hoi = i.cau_hoi,
        dap_an_a = i.dap_an_a,
        dap_an_b = i.dap_an_b,
        dap_an_c = i.dap_an_c,
        dap_an_d = i.dap_an_d,
        dap_an_dung = i.dap_an_dung,
        Nguoi_kiem_duyet_1 = i.Nguoi_kiem_duyet
		
    FROM INSERTED i
    INNER JOIN CSDLNC.dbo.Cau_hoi ch
        ON ch.ID = i.ID AND ch.Nguon = 'DLTT'
    WHERE i.Nguoi_kiem_duyet IS NOT NULL 
     

    -- Đảm bảo rằng mô tả liên quan được thêm vào bảng Mota
    INSERT INTO CSDLNC.dbo.Mota (De_tai, Nguon, Link, Thoigian)
    SELECT 
        m.De_tai, 
        m.Nguon,   
		m.Link, 
        m.Thoigian
    FROM INSERTED i
    INNER JOIN DLTT.dbo.Mota m ON i.maMT = m.maMT
    WHERE NOT EXISTS (
        SELECT 1 
        FROM CSDLNC.dbo.Mota csdl_m
        WHERE csdl_m.De_tai = m.De_tai
          AND csdl_m.Nguon = m.Nguon
          AND csdl_m.Thoigian = m.Thoigian
		  AND csdl_m.Link = m.Link
    );

    -- Cập nhật ánh xạ MaMT
    INSERT INTO CSDLNC.dbo.MaMT_Map (Old_maMT, New_maMT, Source_DB)
    SELECT 
        i.maMT, 
        ISNULL(
            (SELECT csdl_m.maMT
             FROM CSDLNC.dbo.Mota csdl_m
             WHERE csdl_m.De_tai = m.De_tai
               AND csdl_m.Nguon = m.Nguon
			   AND csdl_m.Link = m.Link
               AND csdl_m.Thoigian = m.Thoigian), 
            IDENT_CURRENT('CSDLNC.dbo.Mota')
        ) AS New_maMT,
        'DLTT'
    FROM INSERTED i
    INNER JOIN DLTT.dbo.Mota m ON i.maMT = m.maMT
    WHERE NOT EXISTS (
        SELECT 1 
        FROM CSDLNC.dbo.MaMT_Map map
        WHERE map.Old_maMT = i.maMT AND map.Source_DB = 'DLTT'
    );
END;

go

-- Trigger Delete Cau_hoi cho DLTT
CREATE TRIGGER trg_Delete_Cauhoi_DLTT
ON Cau_hoi
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa câu hỏi trong bảng Cau_hoi của CSDLNC khi bị xóa trong DLTT
    DELETE ch
    FROM CSDLNC.dbo.Cau_hoi ch
    INNER JOIN DELETED d
        ON ch.cau_hoi = d.cau_hoi          -- Kiểm tra nội dung câu hỏi
        AND ch.dap_an_a = d.dap_an_a       -- Kiểm tra đáp án A
        AND ch.dap_an_b = d.dap_an_b       -- Kiểm tra đáp án B
        AND ch.dap_an_c = d.dap_an_c       -- Kiểm tra đáp án C
        AND ch.dap_an_d = d.dap_an_d       -- Kiểm tra đáp án D
        AND ch.dap_an_dung = d.dap_an_dung -- Kiểm tra đáp án đúng
    WHERE ch.Nguon = 'DLTT';               -- Chỉ áp dụng cho nguồn DLTT
END;
GO





USE DLTS;
GO

CREATE TRIGGER trg_Insert_Mota_DLTS
ON Mota
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm mô tả vào bảng Mota của CSDLNC
    INSERT INTO CSDLNC.dbo.Mota (De_tai, Nguon, Link, Thoigian)
    SELECT i.De_tai, i.Nguon, NULL AS Link, i.Thoigian
    FROM INSERTED i;

    -- Tạo ánh xạ mã mô tả
    INSERT INTO CSDLNC.dbo.MaMT_Map (Old_maMT, New_maMT, Source_DB)
    SELECT i.maMT, IDENT_CURRENT('CSDLNC.dbo.Mota'), 'DLTS'
    FROM INSERTED i;
END;
GO




CREATE TRIGGER trg_Update_Mota_DLTS
ON Mota
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật dữ liệu trong bảng Mota của CSDLNC
    UPDATE CSDLNC.dbo.Mota
    SET 
        De_tai = i.De_tai,
        Thoigian = i.Thoigian
    FROM INSERTED i
    INNER JOIN CSDLNC.dbo.MaMT_Map map
        ON map.Old_maMT = i.maMT AND map.Source_DB = 'DLTS'
    WHERE CSDLNC.dbo.Mota.maMT = map.New_maMT;
END;
GO

CREATE TRIGGER trg_Delete_Mota_DLTS
ON Mota
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa dữ liệu trong bảng Mota của CSDLNC dựa trên ánh xạ mã mô tả
    DELETE FROM CSDLNC.dbo.Mota
    WHERE maMT IN (
        SELECT map.New_maMT
        FROM DELETED d
        JOIN CSDLNC.dbo.MaMT_Map map 
            ON map.Old_maMT = d.maMT AND map.Source_DB = 'DLTS'
    );

    -- Xóa ánh xạ mã mô tả khỏi bảng MaMT_Map
    DELETE FROM CSDLNC.dbo.MaMT_Map
    WHERE Old_maMT IN (SELECT maMT FROM DELETED) AND Source_DB = 'DLTS';
END;
GO



CREATE TRIGGER trg_InsertCauHoi
ON Cau_hoi
AFTER INSERT
AS
BEGIN
    -- Kiểm tra xem có câu hỏi mới nào được chèn vào không
    DECLARE @maMT INT;

    -- Lấy giá trị MaMT từ bảng Mota
    SELECT @maMT = MaMT
    FROM Mota
    WHERE De_tai = (SELECT De_tai FROM inserted) AND Nguon = (SELECT Nguon FROM inserted) AND Thoigian = (SELECT Thoigian FROM inserted);

    -- Cập nhật maMT cho các câu hỏi vừa được chèn vào bảng Cau_hoi
    UPDATE Cau_hoi
    SET maMT = @maMT
    FROM Cau_hoi ch
    INNER JOIN inserted i ON ch.cau_hoi = i.cau_hoi
    WHERE i.maMT IS NULL;  -- Chỉ cập nhật những câu hỏi chưa có maMT
END;

go

CREATE TRIGGER trg_Update_Cauhoi_DLTS
ON Cau_hoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Thêm câu hỏi mới vào CSDLNC nếu Nguoi_kiem_duyet được cập nhật từ NULL sang khác NULL
    INSERT INTO CSDLNC.dbo.Cau_hoi (cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, 
                                    Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT, Nguon)
    SELECT 
        i.cau_hoi, 
        i.dap_an_a, 
        i.dap_an_b, 
        i.dap_an_c, 
        i.dap_an_d, 
        i.dap_an_dung, 
        i.Nguoi_kiem_duyet_1, 
        i.Nguoi_kiem_duyet_2,
        -- Cập nhật maMT để tránh trùng lặp, kiểm tra trong CSDLNC.Mota trước khi chèn
        ISNULL(
            (SELECT csdl_m.maMT
             FROM CSDLNC.dbo.Mota csdl_m
             WHERE csdl_m.De_tai = m.De_tai
               AND csdl_m.Nguon = m.Nguon
               AND csdl_m.Thoigian = m.Thoigian
             LIMIT 1),  -- Chỉ lấy một maMT duy nhất
            IDENT_CURRENT('CSDLNC.dbo.Mota')  -- Nếu không có, sử dụng giá trị maMT hiện tại
        ) AS New_maMT,
        'DLTS' AS Nguon
    FROM INSERTED i
    INNER JOIN DLTS.dbo.Mota m ON i.maMT = m.maMT
    WHERE i.Nguoi_kiem_duyet_1 IS NOT NULL 
      AND i.Nguoi_kiem_duyet_2 IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM CSDLNC.dbo.Cau_hoi ch
          WHERE ch.cau_hoi = i.cau_hoi AND ch.Nguon = 'DLTS'
      );

    -- Cập nhật thông tin câu hỏi trong CSDLNC
    UPDATE CSDLNC.dbo.Cau_hoi
    SET 
        cau_hoi = i.cau_hoi,
        dap_an_a = i.dap_an_a,
        dap_an_b = i.dap_an_b,
        dap_an_c = i.dap_an_c,
        dap_an_d = i.dap_an_d,
        dap_an_dung = i.dap_an_dung,
        Nguoi_kiem_duyet_1 = i.Nguoi_kiem_duyet_1,
        Nguoi_kiem_duyet_2 = i.Nguoi_kiem_duyet_2
    FROM INSERTED i
    INNER JOIN CSDLNC.dbo.Cau_hoi ch
        ON ch.ID = i.ID AND ch.Nguon = 'DLTS'
    WHERE i.Nguoi_kiem_duyet_1 IS NOT NULL 
      AND i.Nguoi_kiem_duyet_2 IS NOT NULL;

    -- Đảm bảo rằng mô tả liên quan được thêm vào bảng Mota
    INSERT INTO CSDLNC.dbo.Mota (De_tai, Nguon, Link, Thoigian)
    SELECT 
        m.De_tai, 
        m.Nguon,   
        'null',  -- Có thể thay 'null' bằng giá trị hợp lệ nếu cần
        m.Thoigian
    FROM INSERTED i
    INNER JOIN DLTS.dbo.Mota m ON i.maMT = m.maMT
    WHERE NOT EXISTS (
        SELECT 1 
        FROM CSDLNC.dbo.Mota csdl_m
        WHERE csdl_m.De_tai = m.De_tai
          AND csdl_m.Nguon = m.Nguon
          AND csdl_m.Thoigian = m.Thoigian
    );

    -- Cập nhật ánh xạ MaMT
    INSERT INTO CSDLNC.dbo.MaMT_Map (Old_maMT, New_maMT, Source_DB)
    SELECT 
        i.maMT, 
        ISNULL(
            (SELECT csdl_m.maMT
             FROM CSDLNC.dbo.Mota csdl_m
             WHERE csdl_m.De_tai = m.De_tai
               AND csdl_m.Nguon = m.Nguon
               AND csdl_m.Thoigian = m.Thoigian
             LIMIT 1),  -- Chỉ lấy một maMT duy nhất
            IDENT_CURRENT('CSDLNC.dbo.Mota')  -- Nếu không có, sử dụng giá trị maMT hiện tại
        ) AS New_maMT,
        'DLTS'
    FROM INSERTED i
    INNER JOIN DLTS.dbo.Mota m ON i.maMT = m.maMT
    WHERE NOT EXISTS (
        SELECT 1 
        FROM CSDLNC.dbo.MaMT_Map map
        WHERE map.Old_maMT = i.maMT AND map.Source_DB = 'DLTS'
    );
END;
GO


CREATE TRIGGER trg_Delete_Cauhoi_DLTS
ON Cau_hoi
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Xóa câu hỏi trong bảng Cau_hoi của CSDLNC khi bị xóa trong DLTS
    DELETE ch
    FROM CSDLNC.dbo.Cau_hoi ch
    INNER JOIN DELETED d
        ON ch.cau_hoi = d.cau_hoi          -- Kiểm tra nội dung câu hỏi
        AND ch.dap_an_a = d.dap_an_a       -- Kiểm tra đáp án A
        AND ch.dap_an_b = d.dap_an_b       -- Kiểm tra đáp án B
        AND ch.dap_an_c = d.dap_an_c       -- Kiểm tra đáp án C
        AND ch.dap_an_d = d.dap_an_d       -- Kiểm tra đáp án D
        AND ch.dap_an_dung = d.dap_an_dung -- Kiểm tra đáp án đúng
    WHERE ch.Nguon = 'DLTS';               -- Chỉ áp dụng cho nguồn DLTS
END;
GO
