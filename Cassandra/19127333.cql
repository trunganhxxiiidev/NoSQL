drop keyspace IF EXISTS university ;
CREATE KEYSPACE IF NOT EXISTS university
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

USE university;

CREATE TABLE IF NOT EXISTS SINHVIEN (
  MaSV INT PRIMARY KEY,
  HoTen TEXT,
  Email TEXT,
  DiaChi TEXT
);

CREATE TABLE IF NOT EXISTS MONHOC (
  MaMH TEXT PRIMARY KEY,
  TenMH TEXT,
  SoChi INT
);

CREATE TABLE IF NOT EXISTS SV_MH (
  MaSV INT,
  HoTen TEXT,
  MaMH TEXT,
  TenMH TEXT,
  PRIMARY KEY (MaSV, MaMH)
);

INSERT INTO SINHVIEN (MaSV, HoTen, Email, DiaChi) VALUES (1, 'An', 'an@gmail.com', 'Q6');
INSERT INTO SINHVIEN (MaSV, HoTen, Email, DiaChi) VALUES (2, 'Thuy', 'thuy@gmail.com', 'Q6');
INSERT INTO SINHVIEN (MaSV, HoTen, Email, DiaChi) VALUES (3, 'Hai', 'hai@gmail.com', 'Q5');

INSERT INTO MONHOC (MaMH, TenMH, SoChi) VALUES ('MH1', 'CSDL', 4);
INSERT INTO MONHOC (MaMH, TenMH, SoChi) VALUES ('MH2', 'CTDL', 4);
INSERT INTO MONHOC (MaMH, TenMH, SoChi) VALUES ('MH3', 'NMCNTT', 2);

INSERT INTO SV_MH (MaSV, HoTen, MaMH, TenMH) VALUES (1, 'An', 'MH1', 'CSDL');
INSERT INTO SV_MH (MaSV, HoTen, MaMH, TenMH) VALUES (2, 'Thuy', 'MH1', 'CSDL');
INSERT INTO SV_MH (MaSV, HoTen, MaMH, TenMH) VALUES (3, 'Hai', 'MH2', 'CTDL');

//1/
ALTER TABLE SINHVIEN ADD NamSinh INT;
ALTER TABLE SINHVIEN ADD CMND TEXT;

//2/
delete diachi from sinhvien where masv=2;

//3/
alter table sinhvien add loptruong text;
UPDATE SINHVIEN SET LopTruong = 'x' WHERE MaSV = 3;

//4
UPDATE SINHVIEN SET DiaChi = 'Tan Binh' WHERE MaSV IN (1, 3);
//5
SELECT Email FROM SINHVIEN WHERE MaSV = 1;
//6
 SELECT TenMH FROM SV_MH WHERE MaSV IN (1, 3);

CREATE MATERIALIZED VIEW SV_MH_VIEW AS
  SELECT MaSV, HoTen, MaMH, TenMH
  FROM SV_MH
  WHERE MaSV IS NOT NULL AND MaMH IS NOT NULL
  PRIMARY KEY (MaMH, MaSV);

//7
SELECT HoTen, MaMH, TenMH FROM SV_MH_VIEW WHERE MaSV > 1 allow filtering;


//8
 SELECT TenMH FROM SV_MH WHERE HoTen = 'An' allow filtering;

//9 dssv hoc csdl 
 SELECT masv,HoTen FROM SV_MH WHERE TenMH = 'CSDL' allow filtering;


