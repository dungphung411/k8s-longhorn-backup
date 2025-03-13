# K8S LONGHORN BACKUP PROCESS

## Chuẩn bị.
1. Có 2 cụm K8S chạy version 1.25 đổ lên
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
kubectl apply -f ./*.yaml

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
Chạy wordpress, tạo account, thêm sửa xóa bài viết theo ý muốn. Để có dữ liệu được sinh ra vào database
## Quy trình backup và restore, migration.
Xem thêm các quy trình tạo backup, restore backup ở video