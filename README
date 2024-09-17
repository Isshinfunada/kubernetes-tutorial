# kubernetes-tutorialでやったこと

1. 環境のセットアップ
   ```
   # Minikubeのインストール（既に完了していると仮定）
   
   # Minikubeの起動
   minikube start
   ```

2. Goアプリケーションの作成
   ```
   # プロジェクトディレクトリの作成
   mkdir hello-world-go
   cd hello-world-go
   
   # main.goファイルの作成
   cat << EOF > main.go
   package main

   import (
       "fmt"
       "net/http"
   )

   func main() {
       http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
           fmt.Fprintf(w, "Hello, World!")
       })
       http.ListenAndServe(":8080", nil)
   }
   EOF
   
   # go.modファイルの初期化
   go mod init hello-world-go
   ```

3. Dockerfileの作成
   ```
   cat << EOF > Dockerfile
   # ビルドステージ
   FROM golang:1.16-alpine AS builder
   WORKDIR /app
   COPY go.mod .
   COPY main.go .
   RUN go mod download
   RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -installsuffix cgo -o app .

   # 実行ステージ
   FROM alpine:latest
   RUN apk --no-cache add ca-certificates
   WORKDIR /root/
   COPY --from=builder /app/app .
   EXPOSE 8080
   CMD ["./app"]
   EOF
   ```

4. Dockerイメージのビルド
   ```
   # Minikubeのdockerデーモンを使用するように設定
   eval $(minikube docker-env)
   
   # イメージのビルド
   docker build -t hello-world-go:v2 .
   ```

5. Kubernetesマニフェストの作成
   ```
   cat << EOF > deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: hello-world-go
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: hello-world-go
     template:
       metadata:
         labels:
           app: hello-world-go
       spec:
         containers:
         - name: hello-world-go
           image: hello-world-go:v2
           ports:
           - containerPort: 8080
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: hello-world-go-service
   spec:
     selector:
       app: hello-world-go
     ports:
       - protocol: TCP
         port: 80
         targetPort: 8080
     type: LoadBalancer
   EOF
   ```

6. アプリケーションのデプロイ
   ```
   kubectl apply -f deployment.yaml
   ```

7. デプロイメントの確認
   ```
   kubectl get deployments
   kubectl get pods
   kubectl get services
   ```

8. アプリケーションへのアクセス
   ```
   minikube service hello-world-go-service --url
   ```

```
☁  kubernetes-tutorial  curl "http://127.0.0.1:54369/8080"
Hello, World!%                        
```
