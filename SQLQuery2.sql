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
