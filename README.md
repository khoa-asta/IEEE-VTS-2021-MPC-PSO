# EV Energy Management with MPC and PSO

**Mô phỏng quản lý năng lượng và phân bổ lực kéo cho xe điện trong MATLAB/Simulink, dựa trên bài toán IEEE VTS Challenge 2021.**

Dự án học phần **Kỹ thuật điều khiển xe điện**. Hai phương pháp được nghiên cứu là **Particle Swarm Optimization (PSO)** và **Model Predictive Control (MPC)**, hướng đến sử dụng năng lượng hiệu quả trong khi đáp ứng yêu cầu vận hành và giới hạn của hệ truyền động.

## Tổng quan

Trong hệ truyền động xe điện dẫn động hai cầu với hai động cơ, lực kéo yêu cầu có thể được phân bổ giữa cầu trước và cầu sau. Cách phân bổ ảnh hưởng đến tổn hao của động cơ, năng lượng tiêu thụ từ pin và khả năng thu hồi năng lượng khi phanh.

Dự án nghiên cứu hệ số phân bổ lực kéo nhằm:

- Đáp ứng lực kéo và vận tốc tham chiếu theo chu trình lái.
- Cải thiện hiệu quả sử dụng năng lượng của hệ truyền động.
- Xét giới hạn mô-men kéo và mô-men phanh tái sinh.
- Theo dõi trạng thái sạc pin (**SOC — State of Charge**) và các ràng buộc của mô hình.

Mô hình xe được trình bày trong báo cáo theo phương pháp **EMR — Energetic Macroscopic Representation**. Phạm vi thực hiện là mô phỏng MATLAB/Simulink.

## Cấu trúc repository

| Thư mục | Nội dung |
| --- | --- |
| [`IEEE_VTS_Challenge_2021_MPC/`](./IEEE_VTS_Challenge_2021_MPC/) | Phiên bản mô phỏng sử dụng chiến lược MPC. |
| [`IEEE_VTS_Challenge_2021_PSO/`](./IEEE_VTS_Challenge_2021_PSO/) | Phiên bản mô phỏng sử dụng thuật toán PSO. |

Hai phiên bản được tổ chức riêng để thuận tiện nghiên cứu và chạy từng phương pháp.

## Phương pháp điều khiển

### 1. PSO — Particle Swarm Optimization

PSO tìm hệ số phân bổ lực kéo cầu trước $k_{fr}$ trong khoảng $[0,1]$. Lực kéo tại hai cầu được xác định bởi:

$$
F_{front} = k_{fr} F_{traction,ref}
$$

$$
F_{rear} = (1-k_{fr}) F_{traction,ref}
$$

Trong đó, $F_{traction,ref}$ là tổng lực kéo tham chiếu.

Các tín hiệu đầu vào được mô tả trong báo cáo gồm lực kéo tham chiếu, giới hạn mô-men kéo và giới hạn mô-men phanh tái sinh của hai cầu.

Quá trình tìm kiếm gồm:

1. Khởi tạo các hạt đại diện cho những giá trị phân bổ ứng viên.
2. Đánh giá hàm mục tiêu về hiệu suất và kiểm tra các giới hạn liên quan.
3. Cập nhật nghiệm tốt nhất của từng hạt (`pbest`) và toàn bầy (`gbest`).
4. Cập nhật vận tốc, vị trí các hạt và lặp đến điều kiện dừng.
5. Sử dụng nghiệm tốt nhất làm hệ số phân bổ lực kéo.

### 2. MPC — Model Predictive Control

Phiên bản MPC trong báo cáo đánh giá các hệ số phân bổ trên một lưới rời rạc, dự báo tổn hao và SOC, rồi chọn ứng viên có chi phí thấp nhất trong số các ứng viên thỏa mãn giới hạn mô-men.

| Thông số | Giá trị được mô tả trong báo cáo |
| --- | --- |
| Chân trời dự báo | 5 bước, tương đương 5 giây |
| Giả thiết trong khoảng dự báo | Nhu cầu mô-men và tốc độ quay không đổi |
| Tập hệ số phân bổ ứng viên | $\{0, 0.1, 0.2, \ldots, 1.0\}$ |
| SOC tham chiếu | $0.6$ |
| Trọng số phạt sai lệch SOC | $\alpha = 20000$ |
| Phương pháp tìm kiếm | Discrete Grid Search |

Hàm mục tiêu được mô tả trong báo cáo:

$$
J(k)=\sum_{t=1}^{N}P_{loss}(t\mid k)
+\alpha\left(SOC_{ref}-SOC_{predicted}\right)^2
$$

Ở đây, $k$ là hệ số phân bổ ứng viên, $P_{loss}$ là công suất tổn hao và $SOC_{predicted}$ là SOC dự báo. Tổn hao được xác định từ bản đồ hiệu suất của hai động cơ EM1 và EM2.

Khi phanh, phiên bản này chuyển sang chiến lược **dựa trên luật (rule-based)** để xử lý khả năng thu hồi năng lượng và nhu cầu phanh cơ khí.

## Kết quả mô phỏng trong báo cáo

| Chỉ tiêu | PSO | MPC |
| --- | --- | --- |
| Global point | 84.94 | 84.90 |
| SOC pin cuối chu trình | 84.94% | 84.90% |
| Giới hạn mô-men truyền động cầu trước | Được đáp ứng | Được đáp ứng |
| Giới hạn mô-men truyền động cầu sau | Được đáp ứng | Được đáp ứng |
| Giới hạn nhiệt độ cell pin | Được đáp ứng | Được đáp ứng |

Các số liệu trên được chép từ bảng **Global results** của PSO (trang 7) và MPC (trang 13) trong báo cáo cuối kỳ. Phần PSO ghi rõ chu trình lái **NEDC**.

**Global point là điểm đánh giá của mô phỏng; SOC cuối chu trình là mức sạc còn lại. Các giá trị này không phải tỷ lệ tiết kiệm năng lượng.** Các kết quả được báo cáo chưa đủ để kết luận phương pháp nào tốt hơn trên mọi chu trình hoặc cấu hình tham số.

## Môi trường thực hiện

- MATLAB.
- Simulink.
- Các dữ liệu chu trình lái, thông số xe, bản đồ hiệu suất và tệp phụ thuộc mà mô hình sử dụng.

Báo cáo chưa ghi rõ phiên bản MATLAB/Simulink và danh sách toolbox cần thiết. Cần kiểm tra yêu cầu của các script và mô hình trong từng thư mục trước khi chạy.

## Cách chạy mô phỏng

Hướng dẫn này là quy trình tổng quát; thứ tự khởi tạo dữ liệu và tên script cần được đối chiếu với từng phiên bản.

1. Clone repository hoặc chọn **Code → Download ZIP**, sau đó giải nén.
2. Mở MATLAB và đặt **Current Folder** vào thư mục `IEEE_VTS_Challenge_2021_PSO` hoặc `IEEE_VTS_Challenge_2021_MPC`.
3. Đọc tệp hướng dẫn đi kèm và kiểm tra script khởi tạo, đường dẫn dữ liệu, chu trình lái và các tham số mô phỏng.
4. Chạy script khởi tạo/khởi chạy của phiên bản đang chọn, sau đó chạy mô hình Simulink theo hướng dẫn của phiên bản đó.
5. Xem đồ thị và kết quả đánh giá sau khi mô phỏng hoàn tất.

Với thư mục PSO, các tệp đã được thể hiện trong danh sách dự án gồm:

| Tệp | Vai trò để tra cứu |
| --- | --- |
| [`Read me.txt`](./IEEE_VTS_Challenge_2021_PSO/Read%20me.txt) | Hướng dẫn đi kèm dự án. |
| [`Run.m`](./IEEE_VTS_Challenge_2021_PSO/Run.m) | Script cần kiểm tra khi xác định cách khởi chạy. |
| [`VTS_challenge_2021.slx`](./IEEE_VTS_Challenge_2021_PSO/VTS_challenge_2021.slx) | Mô hình Simulink. |
| [`EMS/Strategy.m`](./IEEE_VTS_Challenge_2021_PSO/EMS/Strategy.m) | Tệp chiến lược điều khiển để nghiên cứu. |
| [`Results/`](./IEEE_VTS_Challenge_2021_PSO/Results/) | Các tệp kết quả và báo cáo mô phỏng. |


## Nhóm thực hiện

| Thành viên | Mã số sinh viên |
| --- | --- |
| Nguyễn Minh Khánh | 20241786E |
| Trần Quang Hiếu | 20241744E |
| Lê Viết Khoa | 20250198E |

**Giảng viên hướng dẫn:** TS. Võ Duy Thành.  
**Đơn vị:** Khoa Tự động hóa, Trường Điện – Điện tử, Đại học Bách khoa Hà Nội.

