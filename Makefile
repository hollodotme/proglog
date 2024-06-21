.SILENT:

CONFIG_PATH="${HOME}/.proglog/"

init:
	mkdir -p ${CONFIG_PATH}
.PHONY: init

gencert:
	cfssl gencert \
		-initca test/ca-csr.json | cfssljson -bare ca

	cfssl gencert \
  		  -ca=ca.pem \
  		  -ca-key=ca-key.pem \
  		  -config=test/ca-config.json \
  		  -profile=server \
  		  test/server-csr.json | cfssljson -bare server

	cfssl gencert \
  		  -ca=ca.pem \
  		  -ca-key=ca-key.pem \
  		  -config=test/ca-config.json \
  		  -profile=client \
  		  test/client-csr.json | cfssljson -bare client

	mv *.pem *.csr ${CONFIG_PATH}
.PHONY: gencert

compile:
	protoc api/v1/*.proto \
	--go_out=. \
	--go-grpc_out=. \
	--go_opt=paths=source_relative \
	--go-grpc_opt=paths=source_relative \
	--proto_path=.
.PHONY: compile

test:
	go test -race -v ./...
.PHONY: test