
# Backup and Restore Kubernetes Applications Using Longhorn
![Introduction](https://longhorn.io/img/logos/longhorn-icon-color.png)



## CHUẨN BỊ
Mỗi node trong cụm Kubernetes, nơi Longhorn được cài đặt, phải đáp ứng các yêu cầu sau:
1. Một runtime container tương thích với Kubernetes (Docker v1.13+, containerd v1.3.7+, v.v.).
2. Kubernetes phiên bản >= v1.25.
3. Open-iscsi phải được cài đặt và daemon iscsid phải đang chạy trên tất cả các node. Điều này cần thiết vì Longhorn dựa vào iscsiadm trên máy chủ để cung cấp các volumes persistent cho Kubernetes. Để cài đặt open-iscsi, tham khảo phần hướng dẫn này.
4. (Optional) Đối với hỗ trợ RWX, mỗi node cần có một client NFSv4 được cài đặt.
5. Filesystem của máy chủ phải hỗ trợ tính năng file extents để lưu trữ dữ liệu. Hiện tại, Longhorn hỗ trợ: ext4, XFS
6. Các công cụ sau phải được cài đặt: bash, curl, findmnt, grep, awk, blkid, lsblk, Mount propagation phải được bật.
7. Các workload Longhorn phải có khả năng chạy với quyền root để Longhorn có thể được triển khai và hoạt động đúng cách.

Bạn có thể sử dụng script này để kiểm tra môi trường Longhorn và phát hiện các vấn đề tiềm năng.
   ```bash
   curl -sSfL https://raw.githubusercontent.com/longhorn/longhorn/v1.8.0/scripts/environment_check.sh | bash
```
Một số pack có thể thiếu, thiếu gì chọn nấy.
  ```bash
apt-get install open-iscsi -y
modprobe iscsi_tcp
apt-get install nfs-common -y
sudo systemctl stop multipathd
sudo systemctl disable multipathd
  ```
## CÀI ĐẶT LONGHORN
Longhorn hiện tại hỗ trợ rất nhiều cách cài: Kubectl, Helm, Flux, ArgoCd,... <br>
Đọc thêm ở đây: https://longhorn.io/docs/1.8.0/deploy/install/
```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.8.0/deploy/longhorn.yaml
kubectl get pods \
--namespace longhorn-system \
--watch
```

## SETUP LONGHORN BACKUP TARGET
Sau khi cài đặt Longhorn, tiện nhất là dùng Rancher để quản lí Longhorn storage <br>
Tuy nhiên cũng có thể tự dùng Ui longhorn không cần rancher (tham khảo: https://longhorn.io/docs/1.8.0/deploy/accessing-the-ui/) <br>
Vào được Longhorn xong, ta phải thiết kế nơi để backup dữ liệu vào: Trỏ chuột vào setting --> Backup Target 
![](https://longhorn.io/img/screenshots/backup-target/page.png)
Tiếp đó chọn new backup target, hoặc sửa luôn default backup target
![](https://longhorn.io/img/screenshots/backup-target/edit.png)
#### Với S3
Tạo trước 1 secret ở namespace longhorn-system. ( cái này là khóa để access vào bucket )
```bash
// Tạo secret
kubectl create secret generic <your-secret> \
    --from-literal=AWS_ACCESS_KEY_ID=<your-aws-access-key-id> \
    --from-literal=AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key> \
    -n longhorn-system
```
```bash
// Ở URL điền url bucket
s3://<your-bucket-name>@<your-aws-region>/mypath/
// Ở Credential tên secret ( dùng lệnh: kubectl get secret -n longhorn-system )
```
#### Với NFS 
Đơn giản hơn,, không cần điền credential, chỉ cần url đến cái share sever đấy thôi
Ví dụ:
```bash
nfs://longhorn-test-nfs-svc.default:/opt/backupstore
nfs://10.200.10.20:/share/nfsk8s/
```
#### Với Cloudian
Tạm thời thử nghiệm thành công với cloudian node sẵn ip. Còn config cloudian với domain url thì chưa thành công do nhiều yếu tố. Tạo secret ở trong file "cloudian.sh" <br>
```bash
// Ở URL điền url bucket
s3://<your-bucket-name>@<your-aws-region>/mypath/
// Ví dụ 
s3://longhorn@hn/stableapp/

```
#### Với mục Credential Secret
Run command 
```bash 
kubectl get secret -n longhorn-system
```
List name secret ra <br>
Backup target nào dùng secret nào thì điền tên nó vào <br>
Lưu ý các backup target có thể trùng secret nhưng ko thể trùng url 