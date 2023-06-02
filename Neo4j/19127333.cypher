
//MSSV: 19127333
//Ho va ten: Nguyen Trung Anh
//sau khi tao csdl mẫu và bắt đầu làm theo đề bài
//Giang vien luu y xem file .cypher truoc vi em da co gang import thu file .cypher nhung không biết cách import để test chạy 1 lần
//Luu y': maHV,MaKH,maDA la` thuoc tinh duoc tao khi viet mac du mac dinh cac node khi tao se co field _id,
//Tuy nhien de truy van de dang hon nên tạo tay, thay một số _id `x` để dễ truy vấn trên mẫu tạo sẵn

CREATE (:HocVien {mahv:'HV01',ho: 'Nguyen',ten:'Trung Anh', diaChi: 'tp hcm', gioiTinh: 'Nam', namSinh: '2001'})
CREATE (:HocVien {mahv:'HV02',ho: 'Nguyen',ten:'Thi Be',diaChi: 'ha noi', gioiTinh: 'Nam', namSinh: '1995'})
CREATE (:KhoaHoc {maKH:1,tenKhoaHoc: 'Java Programming', soBuoi: 40})
CREATE (:KhoaHoc {maKH:2,tenKhoaHoc: 'Python Programming', soBuoi: 30})
CREATE (:KhoaHoc {maKH:3,tenKhoaHoc: 'chuyên đề phân tích dữ liệu', soBuoi: 35})
CREATE (:DoAn {maDA:10,tenDoAn: 'Quan ly sinh vien', moTa: 'Ứng dụng quản lý sinh viên', soGio: 50})
CREATE (:DoAn {maDA:11,tenDoAn: 'Quan ly nhan su', moTa: 'Ứng dụng quản lý nhân sự', soGio: 60})
CREATE (:DoAn {maDA:12,tenDoAn: 'Phân tích số liệu covid19', moTa: 'Phân tích số liệu người bệnh tăng giảm real-time', soGio: 35})
CREATE (:PhongHoc {tenPhong: 'Phong A'})
CREATE (:PhongHoc {tenPhong: 'Phong B'})
CREATE (:PhongHoc {tenPhong: 'Phong C'})

MATCH (hv:HocVien {mahv:'HV01'}), (kh:KhoaHoc {tenKhoaHoc: 'Java Programming'})
CREATE (hv)-[:THAM_GIA_KHOA_HOC]->(kh)

MATCH (hv:HocVien {mahv:'HV01'}), (kh:KhoaHoc {tenKhoaHoc: 'chuyên đề phân tích dữ liệu'})
CREATE (hv)-[:THAM_GIA_KHOA_HOC]->(kh)

MATCH (hv:HocVien {mahv:'HV02'}), (kh:KhoaHoc {tenKhoaHoc: 'Python Programming'})
CREATE (hv)-[:THAM_GIA_KHOA_HOC]->(kh)

MATCH (hv:HocVien {mahv:'HV01'}), (da:DoAn {tenDoAn: 'Quan ly sinh vien'})
CREATE (hv)-[:THAM_GIA_DO_AN {soGioLamViec: 30}]->(da)

MATCH (hv:HocVien {mahv:'HV01'}), (da:DoAn {tenDoAn: 'Phân tích số liệu covid19'})
CREATE (hv)-[:THAM_GIA_DO_AN {soGioLamViec: 35}]->(da)

MATCH (hv:HocVien {mahv:'HV02'}), (da:DoAn {tenDoAn: 'Quan ly nhan su'})
CREATE (hv)-[:THAM_GIA_DO_AN {soGioLamViec: 40}]->(da)


//
MATCH (hv:HocVien {mahv:'HV01'}), (da:DoAn {tenDoAn: 'Quan ly nhan su'})
CREATE (hv)-[:THAM_GIA_DO_AN {soGioLamViec: 40}]->(da)

MATCH (kh:KhoaHoc {tenKhoaHoc: 'Java Programming'}), (ph:PhongHoc {tenPhong: 'Phong A'})
CREATE (kh)-[:DIEN_RA_TAI]->(ph)

MATCH (kh:KhoaHoc {tenKhoaHoc: 'chuyên đề phân tích dữ liệu'}), (ph:PhongHoc {tenPhong: 'Phong C'})
CREATE (kh)-[:DIEN_RA_TAI]->(ph)

MATCH (kh:KhoaHoc {tenKhoaHoc: 'Python Programming'}), (ph:PhongHoc {tenPhong: 'Phong B'})
CREATE (kh)-[:DIEN_RA_TAI]->(ph)

//1 
MATCH (hv:HocVien {diaChi: 'tp hcm'})
RETURN hv.ho AS Ho, hv.ten as ten, hv.diaChi AS DiaChi, hv.gioiTinh AS GioiTinh, hv.namSinh AS NamSinh
ORDER BY Ho DESC
//2
MATCH (kh:KhoaHoc)
WHERE kh.soBuoi > 32
RETURN kh.tenKhoaHoc AS TenKhoaHoc, kh.soBuoi AS SoBuoi
ORDER BY SoBuoi DESC

//3
MATCH (ph:PhongHoc)<-[:DIEN_RA_TAI]-(kh:KhoaHoc)<-[:THAM_GIA_KHOA_HOC]-(hv:HocVien)
RETURN DISTINCT ph.tenPhong AS TenPhongHoc, hv.ho AS Ho, hv.ten as Ten

//4Tìm thông tin đồ án có ít nhất 5 học viên tham gia. Thông tin trả về bao gồm tên đồ án, học tên học viên, sắp xếp theo họ học viên.
MATCH (da:DoAn)<-[:THAM_GIA_DO_AN]-(hv:HocVien)
WITH da, COUNT(hv) AS SoLuongHocVien
WHERE SoLuongHocVien >= 5
MATCH (hv:HocVien)-[:THAM_GIA_DO_AN]->(da)
RETURN da.tenDoAn AS TenDoAn, hv.ho AS Ho, hv.ten AS Ten
ORDER BY Ho

//5 Tìm thông tin phòng có khóa học có mã là "1" đang diễn ra, thông tin trả về gồm tên khóa học, tên phòng.
//ma khoa hoc ben tren dinh nghia int
MATCH (kh:KhoaHoc {maKH: 1})-[:DIEN_RA_TAI]->(ph:PhongHoc)
RETURN kh.tenKhoaHoc AS TenKhoaHoc, ph.tenPhong AS TenPhongHoc

//6 Tìm những đồ án mà học viên số “1” tham gia, thông tin bao gồm tên học viên, tên dự án mà học viên tham gia, 
//số giờ mà học viên làm việc trên dự án đó.
MATCH (hv:HocVien {mahv: 'HV01'})-[a:THAM_GIA_DO_AN]->(da:DoAn)
RETURN hv.ho as ho,hv.ten as ten, da.tenDoAn AS TenDoAn, a.soGioLamViec AS SoGioLamViec

//7 Tìm thông tin học viên làm việc trên đồ án số “12”, thông tin trả về gồm tên học viên, số
//giờ làm việc, tên dự án tham gia.
MATCH (hv:HocVien)-[a:THAM_GIA_DO_AN]->(da:DoAn {maDA: 12})
RETURN hv.ten AS TenHocVien, a.soGioLamViec AS SoGioLamViec, da.tenDoAn AS TenDoAn


//8. Tìm thông tin học viên có tham gia các dự án cùng số giờ làm việc dự án đó, 
//sắp xếp theo họ học viên, giới hạn trả về 4 kết quả

MATCH (hv:HocVien)-[a:THAM_GIA_DO_AN]->(da:DoAn)
where a.soGioLamViec=da.soGio
RETURN hv.mahv as MaHV,hv.ho as Ho,hv.ten AS Ten, a.soGioLamViec AS SoGioLamViec, da.tenDoAn AS TenDoAn
ORDER BY Ho
LIMIT 4

//9.Tìm thông tin học viên làm việc trên 2 đồ án. Thông tin bao gồm họ tên học viên, số
//lượng đồ án tham gia, sắp xếp giảm dần theo số lượng đồ án.

MATCH (hv:HocVien)-[:THAM_GIA_DO_AN]->(da:DoAn)
WITH hv, count(distinct da) as SoLuongDoAnThamGia
WHERE SoLuongDoAnThamGia >= 2
RETURN hv.ho as Ho, hv.ten as Ten,  SoLuongDoAnThamGia
ORDER BY SoLuongDoAnThamGia DESC

//10 Tìm học viên nào có cùng họ và cùng tham gia đồ án, thông tin trả về bao gồm họ tên
học viên, tên đồ án, sắp xếp theo họ học viên

 MATCH (hv1:HocVien)-[:THAM_GIA_DO_AN]->(da:DoAn)<-[:THAM_GIA_DO_AN]-(hv2:HocVien)
WHERE hv1.ho = hv2.ho AND hv1.mahv <> hv2.mahv
RETURN hv1.ho as HoHocVien,hv1.ten as TenHocVien, da.tenDoAn
ORDER BY hv1.ho

//11 Tìm thông tin phòng đang diễn ra khóa học “chuyên đề phân tích dữ liệu” và các thông
//tin học viên đang tham gia khóa học này. Thông tin trả về bao gồm tên phòng, tên khóa
//học, họ tên học viên

MATCH (p:PhongHoc)<-[:DIEN_RA_TAI]-(k:KhoaHoc {tenKhoaHoc: 'chuyên đề phân tích dữ liệu'})<-[:THAM_GIA_KHOA_HOC]-(hv:HocVien)
RETURN p.tenPhong AS TenPhong, k.tenKhoaHoc AS TenKhoaHoc, hv.ho AS HoHocVien, hv.ten as TenHocVien








