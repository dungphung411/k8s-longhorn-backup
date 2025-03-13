#!bin/bash
# This script is used to install Cloudian on Longhorn
# This script is tested on Ubuntu 24.01 LTS
# This script is tested on Longhorn 1.8.0
# This script is tested on Cloudian 8.1.1

# Để setup 1 back up target, ta cần 2 phần chính là url và secret ( aka credential )
kubectl apply -f secret.yaml
# apiVersion: v1
# kind: Secret
# metadata:
#   name: cloudian
#   namespace: longhorn-system
# type: Opaque
# data:
#   AWS_ACCESS_KEY_ID: MDZiZGY3MzZlNGNiZmZmOTI0YmM=    # base64 của accesskey mình nhé
#   AWS_SECRET_ACCESS_KEY: N1hvR3pmY1dJbHBCdDJsancwOG1qQllVSTFsUk1UYW1ZNjZUcVRDZg== # base64 của secret key mình nhénhé
#   AWS_ENDPOINTS: aHR0cDovLzEwLjIwMC4zLjEzMTo4MC8=    # http://10.200.3.131:80/  

# Lưu ý endpoint cực kì quan trọng, thêm http ở đầu và / ở cuối, nếu có port thì ghi port vào, và đổi sang base64 