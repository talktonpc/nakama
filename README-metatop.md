![Nakama](.github/logo.png?raw=true "Nakama logo")
========================================================================================
# 0. __Sortcuts__

### 📌 Run DB(postgreSQL) server ! (on linux or windows)
⚠️ NOTE: port number - 15432 (not 5432) in the .yml file.
```shell
> docker-compose -f ./docker-compose-single-postgres.yml up -d

```


### 📌 For server ! (on linux)
build server
```shell
> go build -trimpath -mod=vendor -ldflags "-s -w -X main.version=v3.9.1-metatop" 
```
run server
```shell
> ./nakama migrate up --database.address postgres:localdb@localhost:15432/metatop
> ./nakama --name nakama-metatop --database.address postgres:localdb@localhost:15432/metatop --logger.level INFO --session.token_expiry_sec 7200 --socket.server_key "metatop-choco-server" --data_dir ../nakama-addon/metatop-hello
```

### 📌 For server ! (on windows)
build server
```shell
> go build -trimpath -mod=vendor -ldflags "-s -w -X main.version=v3.9.1-metatop" 
```
run server
```shell
> docker-compose -f .\docker-compose-single-metatop.yml up
```

### 📌 For plugins In Docker build helper ! (on windows)
```shell
> docker run --rm -w "/builder" -v "D:\works\servers\nakama-addons\hello\:/builder" lonycell/nakama-pluginbuilder:v3.9.2-metatop build -buildmode=plugin -trimpath -o ./modules/metatop-hello.so
```

### 📌 For native compiler ! (on linux)
```shell
> build plugin on native compiler
> go build -buildmode=plugin -ldflags "-s -w -X main.version=v3.9.1-metatop" -trimpath -o ./modules/metatop-hello.so
```

```


```

# 1. Server Build
## 📌 Download Server source code
   ```shell
   > git clone "https://github.com/talktonpc/nakama" nakama
   > cd nakama
   ```

## 📌 Simple Builds
   ```shell
   > go build -trimpath -mod=vendor
   > ./nakama --version
   ```

---
## 📌 Full Builds

The codebase uses Protocol Buffers, GRPC, GRPC-Gateway, and the OpenAPI spec as part of the project. These dependencies are generated as sources and committed to the repository to simplify builds for contributors.

To build the codebase and generate all sources follow these steps.

1. Install the toolchain.

   ```shell
   go install "google.golang.org/protobuf/cmd/protoc-gen-go" "google.golang.org/grpc/cmd/protoc-gen-go-grpc" "github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway" "github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2"
   ```

2. If you've made changes to the embedded Console.

    ```shell
    cd console/ui
    ng serve
    ```

3. Re-generate the protocol buffers, gateway code and console UI.

   ```shell
   env PATH="$HOME/go/bin:$PATH" go generate -x ./...
   ```

4. Build the codebase.

   ```shell
   go build -trimpath -mod=vendor
   ```

5. Build for linux on windows PC.
   ```shell
   > set GOOS=linux
   > set GOARCH=amd64
   > go build -trimpath -mod=vendor 
   ```

6. Build docker image for linux container on windows PC.
   ```shell
   > docker build -f ./build/Dockerfile -t lonycell/v3.9.1-metatop --build-arg version=v3.9.1-metatop .
   > docker push lonycell/nakama-server:v3.9.1-metatop
   ```
---
# 2. Server Addon module Build
## 📌 Module build
### Setup a project

1. Setup a folder for your own plugin code.

    ```bash
    > mkdir -p "$HOME/metatop-hello"
    > cd "$HOME/metatop-hello"
    ```

2. Initialize the Go module for your plugin and add the nakama-common dependency.

    ```bash
    > go mod init "metatop-hello"
    > go get -u "github.com/talktonpc/nakama-common@v1.27.2"
    ```
3. Develop and compile your code.

    ```bash
    > go build -buildmode=plugin -trimpath -o ./modules/metatop-hello.so
    ```

4. Use `--runtime.path` flag when you start the Nakama server binary to load your built plugin. (Note: Also make sure you run the database).

    ```bash
    > ./nakama --runtime.path "$HOME/metatop-hello"
    ```

 ### 📌 Docker builds (in Windows)

1. Use the Docker plugin helper container to compile your project (works for bash/PowerShell):

    ```bash
    > cd "$HOME/metatop-hello"

    > docker run --rm -w "/builder" -v "D:\works\servers\nakama-addons\hello\:/builder" lonycell/nakama-pluginbuilder:v3.9.1-metatop build -buildmode=plugin -trimpath -o ./modules/metatop-hello.so
    ```

---

# 3. Run
1. Run DB docker instance
   ```bash


   ```

2. Copy server moules to {data/modules} folder.
   ```bash

   
   ```

3. Run Server docker instance
   ```bash

   
   ```

---
### License

This project is licensed under the [Apache-2 License](https://github.com/talktonpc/nakama/blob/master/LICENSE).
