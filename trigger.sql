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
    maMT NVARCHAR(255) PRIMARY KEY,       -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Link NVARCHAR(255),                       -- Link tham khảo
    Thoigian DATETIME                         -- Thời gian lấy dữ liệu
);
GO

-- Tạo bảng Cau_hoi trong CSDLNC
CREATE TABLE Cau_hoi (
    ID  NVARCHAR(255) PRIMARY KEY,           -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),                      -- Đáp án đúng (A, B, C, D)
    Nguoi_kiem_duyet_1 NVARCHAR(255),         -- Người kiểm duyệt 1
    Nguoi_kiem_duyet_2 NVARCHAR(255),         -- Người kiểm duyệt 2
    maMT  NVARCHAR(255),                                 -- Mã mô tả, liên kết đến                       -- Nguồn dữ liệu (DLTT, DLTS, DLTC)
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO



-- Tạo bảng trong cơ sở dữ liệu DLTT
USE DLTT;
GO

-- Tạo bảng Mota trong DLTT
CREATE TABLE Mota (
    maMT NVARCHAR(255) PRIMARY KEY,           -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Link NVARCHAR(255),                       -- Link tham khảo
    Thoigian DATETIME,                        -- Thời gian lấy dữ liệu               -- Chương của câu hỏi
   
);
GO

-- Tạo bảng Cauhoi trong DLTT với khóa ngoại maMT tham chiếu đến bảng Mota
CREATE TABLE Cau_hoi (
    ID  NVARCHAR(255) PRIMARY KEY,           -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),     
    Nguoi_kiem_duyet NVARCHAR(255),                -- Đáp án đúng (A, B, C, D)
    maMT NVARCHAR(255),                                 -- Mã mô tả, liên kết đến bảng Mota
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO

-- Tạo bảng trong cơ sở dữ liệu DLTS
USE DLTS;
GO

-- Tạo bảng Mota trong DLTS
CREATE TABLE Mota (
    maMT NVARCHAR(255) PRIMARY KEY,           -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Thoigian DATETIME,                        -- Thời gian lấy dữ liệu
                       -- Chương của câu hỏi
);
GO

-- Tạo bảng Cauhoi trong DLTS với khóa ngoại maMT tham chiếu đến bảng Mota
CREATE TABLE Cau_hoi (
    ID  NVARCHAR(255) PRIMARY KEY,           -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),    
    Nguoi_kiem_duyet_1 NVARCHAR(255),
    Nguoi_kiem_duyet_2 NVARCHAR(255),                 -- Đáp án đúng (A, B, C, D)
    maMT NVARCHAR(255),                                 -- Mã mô tả, liên kết đến bảng Mota
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO

-- Tạo bảng trong cơ sở dữ liệu DLTC
USE DLTC;
GO

-- Tạo bảng Mota trong DLTC
CREATE TABLE Mota (
    maMT NVARCHAR(255) PRIMARY KEY,           -- Mã mô tả
    De_tai NVARCHAR(255),                     -- Chủ đề câu hỏi
    Nguon NVARCHAR(255),                      -- Nguồn tài liệu
    Thoigian DATETIME,                        -- Thời gian lấy dữ liệu
                        -- Chương của câu hỏi
);
GO

-- Tạo bảng Cauhoi trong DLTC với khóa ngoại maMT tham chiếu đến bảng Mota
CREATE TABLE Cau_hoi (
    ID  NVARCHAR(255) PRIMARY KEY,         -- ID của câu hỏi
    cau_hoi NVARCHAR(255),                    -- Nội dung câu hỏi
    dap_an_a NVARCHAR(255),                   -- Đáp án A
    dap_an_b NVARCHAR(255),                   -- Đáp án B
    dap_an_c NVARCHAR(255),                   -- Đáp án C
    dap_an_d NVARCHAR(255),                   -- Đáp án D
    dap_an_dung CHAR(1),                      -- Đáp án đúng (A, B, C, D)
    maMT  NVARCHAR(255),                                 -- Mã mô tả, liên kết đến bảng Mota
    CONSTRAINT FK_Cauhoi_Mota FOREIGN KEY (maMT) REFERENCES Mota(maMT)  -- Thiết lập khóa ngoại
);
GO


USE DLTC;
GO

CREATE TRIGGER trg_InsertCauHoi
ON Cau_hoi
AFTER INSERT
AS
BEGIN
    -- Sử dụng TRY...CATCH để xử lý lỗi
    BEGIN TRY
        -- Kiểm tra nếu mã mô tả đã tồn tại trong CSDLNC
        IF EXISTS (
            SELECT 1
            FROM inserted i
            WHERE NOT EXISTS (
                SELECT 1
                FROM CSDLNC.dbo.Mota m
                WHERE m.maMT = i.maMT
            )
        )
        BEGIN
            -- Chèn mô tả mới vào bảng Mota của CSDLNC
            INSERT INTO CSDLNC.dbo.Mota (maMT, De_tai, Nguon, Link, Thoigian)
            SELECT i.maMT, m.De_tai, m.Nguon,null, m.Thoigian
            FROM inserted i
            INNER JOIN Mota m ON i.maMT = m.maMT;
        END

        -- Chèn câu hỏi vào bảng Cau_hoi của CSDLNC
        INSERT INTO CSDLNC.dbo.Cau_hoi (ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT)
        SELECT ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, NULL, NULL, maMT
        FROM inserted;
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi (có thể thêm log nếu cần)
        PRINT 'Lỗi xảy ra khi thêm dữ liệu vào CSDLNC';
    END CATCH
END;
GO

USE DLTC;
GO

CREATE TRIGGER trg_DeleteCauHoi
ON Cau_hoi
AFTER DELETE
AS
BEGIN
    BEGIN TRY
        -- Xóa bản ghi tương ứng trong bảng Cau_hoi của CSDLNC dựa trên ID
        DELETE FROM CSDLNC.dbo.Cau_hoi
        WHERE ID IN (SELECT ID FROM deleted);
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi xóa dữ liệu trong CSDLNC';
    END CATCH
END;
GO


USE DLTC;
GO

CREATE TRIGGER trg_UpdateCauHoi
ON Cau_hoi
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Cập nhật dữ liệu câu hỏi tương ứng trong bảng Cau_hoi của CSDLNC
        UPDATE CSDLNC.dbo.Cau_hoi
        SET 
            cau_hoi = i.cau_hoi,
            dap_an_a = i.dap_an_a,
            dap_an_b = i.dap_an_b,
            dap_an_c = i.dap_an_c,
            dap_an_d = i.dap_an_d,
            dap_an_dung = i.dap_an_dung,
            Nguoi_kiem_duyet_1 = null,
            Nguoi_kiem_duyet_2 =null,
            maMT = i.maMT
        FROM CSDLNC.dbo.Cau_hoi c
        INNER JOIN inserted i ON c.ID = i.ID;
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi cập nhật dữ liệu trong CSDLNC';
    END CATCH
END;
GO


USE DLTT;
GO

CREATE TRIGGER trg_InsertCauHoi
ON Cau_hoi
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        -- Chèn mô tả nếu mã mô tả chưa tồn tại trong CSDLNC
        INSERT INTO CSDLNC.dbo.Mota (maMT, De_tai, Nguon, Link, Thoigian)
        SELECT 
            i.maMT, m.De_tai, m.Nguon, m.Link, m.Thoigian
        FROM inserted i
        LEFT JOIN CSDLNC.dbo.Mota mt ON i.maMT = mt.maMT
        INNER JOIN Mota m ON i.maMT = m.maMT
        WHERE mt.maMT IS NULL;

        -- Thêm câu hỏi vào CSDLNC nếu Nguoi_kiem_duyet không NULL
        INSERT INTO CSDLNC.dbo.Cau_hoi (ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, Nguoi_kiem_duyet_1, maMT)
        SELECT 
            ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, Nguoi_kiem_duyet, maMT
        FROM inserted
        WHERE Nguoi_kiem_duyet IS NOT NULL;
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi thêm dữ liệu vào CSDLNC';
    END CATCH
END;
GO

USE DLTT;
GO

CREATE TRIGGER trg_UpdateCauHoi
ON Cau_hoi
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Chèn mô tả nếu mã mô tả chưa tồn tại trong CSDLNC
        INSERT INTO CSDLNC.dbo.Mota (maMT, De_tai, Nguon, Link, Thoigian)
        SELECT 
            i.maMT, m.De_tai, m.Nguon, m.Link, m.Thoigian
        FROM inserted i
        LEFT JOIN CSDLNC.dbo.Mota mt ON i.maMT = mt.maMT
        INNER JOIN Mota m ON i.maMT = m.maMT
        WHERE mt.maMT IS NULL;

        -- Cập nhật hoặc thêm câu hỏi nếu Nguoi_kiem_duyet không NULL
        MERGE CSDLNC.dbo.Cau_hoi AS target
        USING (SELECT * FROM inserted WHERE Nguoi_kiem_duyet IS NOT NULL) AS source
        ON target.ID = source.ID
        WHEN MATCHED THEN
            UPDATE SET 
                cau_hoi = source.cau_hoi,
                dap_an_a = source.dap_an_a,
                dap_an_b = source.dap_an_b,
                dap_an_c = source.dap_an_c,
                dap_an_d = source.dap_an_d,
                dap_an_dung = source.dap_an_dung,
                Nguoi_kiem_duyet_1 = source.Nguoi_kiem_duyet,
                maMT = source.maMT
        WHEN NOT MATCHED THEN
            INSERT (ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, Nguoi_kiem_duyet_1, maMT)
            VALUES (source.ID, source.cau_hoi, source.dap_an_a, source.dap_an_b, source.dap_an_c, source.dap_an_d, source.dap_an_dung, source.Nguoi_kiem_duyet, source.maMT);

        -- Xóa câu hỏi nếu Nguoi_kiem_duyet là NULL
        DELETE FROM CSDLNC.dbo.Cau_hoi
        WHERE ID IN (SELECT ID FROM inserted WHERE Nguoi_kiem_duyet IS NULL);
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi cập nhật dữ liệu trong CSDLNC';
    END CATCH
END;
GO


USE DLTT;
GO

CREATE TRIGGER trg_DeleteCauHoi
ON Cau_hoi
AFTER DELETE
AS
BEGIN
    BEGIN TRY
        -- Xóa dữ liệu tương ứng trong CSDLNC
        DELETE FROM CSDLNC.dbo.Cau_hoi
        WHERE ID IN (SELECT ID FROM deleted);
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi xóa dữ liệu trong CSDLNC';
    END CATCH
END;
GO


USE DLTS;
GO

CREATE TRIGGER trg_InsertCauHoi_DLTS
ON Cau_hoi
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        -- Thêm mô tả mới vào bảng Mota của CSDLNC nếu chưa tồn tại
        INSERT INTO CSDLNC.dbo.Mota (maMT, De_tai, Nguon, Link, Thoigian)
        SELECT i.maMT, m.De_tai, m.Nguon, null, m.Thoigian
        FROM inserted i
        JOIN Mota m ON i.maMT = m.maMT
        WHERE NOT EXISTS (
            SELECT 1 FROM CSDLNC.dbo.Mota WHERE maMT = i.maMT
        );

        -- Thêm câu hỏi vào bảng Cau_hoi của CSDLNC nếu có đủ 2 người kiểm duyệt
        INSERT INTO CSDLNC.dbo.Cau_hoi (ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT)
        SELECT i.ID, i.cau_hoi, i.dap_an_a, i.dap_an_b, i.dap_an_c, i.dap_an_d, i.dap_an_dung, i.Nguoi_kiem_duyet_1, i.Nguoi_kiem_duyet_2, i.maMT
        FROM inserted i
        WHERE i.Nguoi_kiem_duyet_1 IS NOT NULL AND i.Nguoi_kiem_duyet_2 IS NOT NULL;
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi thêm dữ liệu vào CSDLNC';
    END CATCH
END;
GO



USE DLTS;
GO

CREATE TRIGGER trg_DeleteCauHoi_DLTS
ON Cau_hoi
AFTER DELETE
AS
BEGIN
    BEGIN TRY
        -- Xóa dữ liệu tương ứng trong CSDLNC
        DELETE FROM CSDLNC.dbo.Cau_hoi
        WHERE ID IN (SELECT ID FROM deleted);
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi xóa dữ liệu trong CSDLNC';
    END CATCH
END;
GO

USE DLTS;
GO

CREATE TRIGGER trg_UpdateCauHoi_DLTS
ON Cau_hoi
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Cập nhật dữ liệu trong CSDLNC nếu cả hai người kiểm duyệt đều khác NULL và câu hỏi đã tồn tại
        UPDATE CSDLNC.dbo.Cau_hoi
        SET cau_hoi = i.cau_hoi,
            dap_an_a = i.dap_an_a,
            dap_an_b = i.dap_an_b,
            dap_an_c = i.dap_an_c,
            dap_an_d = i.dap_an_d,
            dap_an_dung = i.dap_an_dung,
            Nguoi_kiem_duyet_1 = i.Nguoi_kiem_duyet_1,
            Nguoi_kiem_duyet_2 = i.Nguoi_kiem_duyet_2,
            maMT = i.maMT
        FROM inserted i
        WHERE CSDLNC.dbo.Cau_hoi.ID = i.ID
          AND i.Nguoi_kiem_duyet_1 IS NOT NULL
          AND i.Nguoi_kiem_duyet_2 IS NOT NULL;

        -- Thêm dữ liệu mới vào CSDLNC nếu cả hai người kiểm duyệt khác NULL và câu hỏi chưa tồn tại trong CSDLNC
        INSERT INTO CSDLNC.dbo.Cau_hoi (ID, cau_hoi, dap_an_a, dap_an_b, dap_an_c, dap_an_d, dap_an_dung, Nguoi_kiem_duyet_1, Nguoi_kiem_duyet_2, maMT)
        SELECT i.ID, i.cau_hoi, i.dap_an_a, i.dap_an_b, i.dap_an_c, i.dap_an_d, i.dap_an_dung, i.Nguoi_kiem_duyet_1, i.Nguoi_kiem_duyet_2, i.maMT
        FROM inserted i
        WHERE i.Nguoi_kiem_duyet_1 IS NOT NULL 
          AND i.Nguoi_kiem_duyet_2 IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM CSDLNC.dbo.Cau_hoi WHERE ID = i.ID
          );

        -- Xóa dữ liệu trong CSDLNC nếu một trong hai người kiểm duyệt là NULL
        DELETE FROM CSDLNC.dbo.Cau_hoi
        WHERE ID IN (
            SELECT i.ID
            FROM inserted i
            WHERE i.Nguoi_kiem_duyet_1 IS NULL OR i.Nguoi_kiem_duyet_2 IS NULL
        );
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi
        PRINT 'Lỗi xảy ra khi cập nhật dữ liệu vào CSDLNC';
    END CATCH
END;
GO
