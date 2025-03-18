# K8S LONGHORN BACKUP PROCESS

## Chuẩn bị.
1. Có cụm K8S chạy version 1.25 đổ lên
2. Các cụm có bộ nhớ trong lớn, 50GB mỗi node là tốt (để 30 cũng được nhưng yếu)
3. Có một ứng dụng để deploy 

## Cài đặt Longhorn.
Các bước cài đặt Longhorn xem ở folder longhorninstall <br>
Đảm bảo longhorn được cài và truy cập được vào backup target <br>
Nên dùng Rancher để quản lí Longhorn, vì giao diện dễ nhìn <br>

## Quy trình deploy ứng dụng.
Ở đây dùng sẵn một application nhỏ: Wordpress với MySQLdatabase <br>
Đảm bảo rằng longhorn được cài lên cụm trước, đảm bảo longhorn được set là default storage class ( nếu ko thì khi tạo pv, pvc phải set thêm storageclass namename) 
```bash
kubectl get sc
NAME                 PROVISIONER          RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
longhorn (default)   driver.longhorn.io   Delete          Immediate           true                   9d
longhorn-static      driver.longhorn.io   Delete          Immediate           true                   9d 
```
Triển khai ứng dụng lên cụm 1 
```bash 
git clone https://github.com/dungphung411/k8s-longhorn-backup.git && cd ./k8s-longhorn-backup/lh-example
kubectl apply -f predefine.yaml
kubectl apply -f sql-deployment.yaml
kubectl apply -f wp-deployment.yaml
```
Ta được
```bash
Cloning into 'k8s-longhorn-backup'...
remote: Enumerating objects: 99, done.
remote: Counting objects: 100% (99/99), done.
remote: Compressing objects: 100% (74/74), done.
remote: Total 99 (delta 23), reused 38 (delta 6), pack-reused 0 (from 0)
Receiving objects: 100% (99/99), 23.80 KiB | 23.80 MiB/s, done.
Resolving deltas: 100% (23/23), done.
namespace/wordpress created
secret/mysql-pass created
service/wordpress-mysql created
persistentvolumeclaim/mysql-pv-claim created
deployment.apps/wordpress-mysql created
service/wordpress created
persistentvolumeclaim/wp-pv-claim created
deployment.apps/wordpress created

kubectl get deployment -n wordpress
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
wordpress         1/1     1            1           105s
wordpress-mysql   1/1     1            1           105s
```
Kiểm tra service ứng dụng ta có frontend wordpress chạy trên port 30080 và backend sql chạy trên port 30036 <br>
Có thể truy cập vào database sql thông qua các ứng dụng quản lí db, ip là <NODE-IP>, username là wordpress, mật khẩu xem ở file predefine.yaml <br>
Truy cập ứng dụng qua <NODE-IP>:30080  (ví dụ 10.200.10.230:30080)
```bash
kubectl get svc -n wordpress
NAME              TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
wordpress         NodePort   10.110.150.183   <none>        80:30080/TCP     85m
wordpress-mysql   NodePort   10.98.178.225    <none>        3306:30036/TCP   85m
``` 

![Alt text](https://drive.google.com/uc?export=view&id=1JR0aLk2jmvFqPDxA6UPmgIGDneVmwzTL)

Chạy wordpress, tạo account, thêm sửa xóa bài viết theo ý muốn. Để có dữ liệu được sinh ra vào database
## Quy trình backup và restore, migration.
[Download the file here](https://drive.google.com/uc?export=download&id=1I4-FAxAspM91ryLySnJJ5XOp3sqGVxpp)
- Đầu tiên ta vào UI Longhorn ở cụm 1, ở góc trên màn hình chuyển sang tab "Volume"
[Download the file here](https://drive.google.com/uc?export=download&id=1EVdXwmtARhDzE2hvQpV6K9O8jYdhTACF)
- Ta chọn 2 volume cần backup của ứng dụng wordpress, đánh tag label và để full backup ( lần đầu backup nên để full, sau có thể ko cần để tối ưu dụng lượng)
[Download the file here](https://drive.google.com/uc?export=download&id=1iQa3aOqXMK5TH01ZUsce4TJgV73AX6Rq)
- Chờ một lúc, vào tab "Backup" để xem volume của mình đã được backup hay chưa, ở đây cũng có thể xem thông tin về bản backup này

- Tiến hành vào cụm 2 để triển khai ứng dụng, ai chỉ có 1 cụm lab có thể ```kubectl delete ns wordpress``` để xóa project đi. Tạo sẵn namespace wordpress trên cụm 2 ``` kubectl create ns wordpress ``` 
- Nếu config longhorn backup target 2 cụm đều trỏ vào cùng một nơi lưu trữ dữ liệu ( NFS, S3, EBS,..) thì khi đó những bản ghi back up sẽ xuất hiện ở trong tab "back up" của cụm 2 luôn.
- Chọn tên backup cần restore, có thể chọn "Restore latest backup" hoặc bấm vào tên để chọn bản mình muốn backup. Tick chọn "Using previous name" để giữ lại tên và config của PV, PVC. Rồi chọn backup nó
[Download the file here](https://drive.google.com/uc?export=download&id=1LlASSxz7As583eOG1gapqICBlVjpt65T)
- Quay trở lại tab "volume" ta thấy volume đã được restore, tiến hành dựng lại pv, pvc từ volume. Đơn giản là dùng previous pvc, nó sẽ tự dựng lại tên của đúng PV, PVC ở workload cũ. 
[Download the file here](https://drive.google.com/uc?export=download&id=1bgP-yzifk5XqH4sdx7XXK4OW3bCIntfs)
- Tiến hành deploy lại ứng dụng ở trên cụm 2, xem folder lh-example để chạy lại ứng dụng
- Ta thấy ứng dụng hoạt động bình thường với toàn bộ dữ liệu được chuyển đổi từ cụm cũ sang cụm mới.
## Chi tiết các bước xem ở video