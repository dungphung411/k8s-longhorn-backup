# K8S LONGHORN BACKUP PROCESS

## Chuẩn bị.
1. Có 2 cụm K8S chạy version 1.25 đổ lên
2. Các cụm có bộ nhớ trong lớn, 50GB mỗi node là tốt (để 30 cũng được nhưng yếu)
3. Có một ứng dụng để deploy 

## Cài đặt Longhorn.
Các bước cài đặt Longhorn xem ở folder longhorninstall
Đảm bảo longhorn được cài và truy cập được vào backup target
Nên dùng Rancher để quản lí Longhorn, vì giao diện dễ nhìn

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
kubectl apply -f ./*

```

## Quy trình backup và restore, migration.

