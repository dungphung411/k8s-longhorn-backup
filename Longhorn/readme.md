
# Backup and Restore Kubernetes Applications Using velero

[![Watch the video](https://img.youtube.com/vi/hV98fuCQJ48/maxresdefault.jpg)](https://youtu.be/hV98fuCQJ48)


## Chuẩn bị 
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
## Cài đặt Longhorn
Longhorn hiện tại hỗ trợ rất nhiều cách cài: Kubectl, Helm, Flux, ArgoCd,... 
Đọc thêm ở đây: https://longhorn.io/docs/1.8.0/deploy/install/
```bash
velero restore create --from-backup <NAME> # restore bản backup
velero get restore # list cac ban restore 
velero restore logs <RESTORE_NAME>      # doc logs ban restore minh muon

```

## Setup velero 
Đảm bảo máy chạy đã cài kubectl, và đã kết nối với cluster K8S cần backup. <br>
Sửa file credentials_velero với access key và secret key bạn có.


```bash
#vao folder minh muon clone ve, neu bi loi hay chay lai voi quyen root
git clone https://github.com/dungphung411/velero-backup-csc.git
cd ./velero-backup-csc/velero-setup 
chmod +x k8s_add_velero.sh && chmod +x velero_install.sh
sh ./velero_install.sh && sh ./k8s_add_velero.sh
```
