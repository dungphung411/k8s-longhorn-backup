#!bin/bash
# Để setup 1 back up target, ta cần 2 phần chính là url và secret ( aka credential )
kubectl apply -f secret.yaml
#   AWS_ACCESS_KEY_ID: MDZiZGY3MzZlNGNiZmZmOTI0YmM=    # base64 của accesskey mình nhé
#   AWS_SECRET_ACCESS_KEY: N1hvR3pmY1dJbHBCdDJsancwOG1qQllVSTFsUk1UYW1ZNjZUcVRDZg== # base64 của secret key mình nhénhé
#   AWS_ENDPOINTS: aHR0cDovLzEwLjIwMC4zLjEzMTo4MC8=    # http://10.200.3.131:80/  

# Lưu ý endpoint cực kì quan trọng, thêm http ở đầu và / ở cuối, nếu có port thì ghi port vào, và đổi sang base64 