<!---
markmeta_title: 安装PaddleOCR
markmeta_author: 斜风
markmeta_date: 2022-11-25
markmeta_categories: 技术
markmeta_tags: OCR
-->

# 安装PaddleOCR

## aliyun 镜像加速

ref: https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors

```bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://99m45837.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 使用已构建好的docker镜像

基于 Serverless 架构部署通用文字识别 PaddleOCR https://github.com/duolabmeng6/paddlehub_ppocr



```bash

# docker run -it --name ppocr -p 9000:9000 duolabmeng666/paddlehub_ppocr:1.0 /bin/bash -c "sh /PaddleOCR/start.sh"

docker run -itd --name ppocr -p 9000:9000 registry.cn-hongkong.aliyuncs.com/llapi/ppocr:1.8 /bin/bash -c "sh /PaddleOCR/start.sh"


curl -H "Content-Type:application/json" -X POST --data "{\"images\": [\"iVBORw0KGgAAAElFTkSuQmCC\"]}" http://127.0.0.1:9000/predict/ocr_system

# {"msg":"","results":[[{"confidence":0.9853195548057556,"text":"测试图像路径，可以是单张图片路径，也可以是图像集合目录路径","text_region":[[5,10],[466,10],[466,24],[5,24]]}]],"status":"000"}

```

## 安装官方镜像

paddleocr 官方镜像, 查看最新版本 https://hub.docker.com/r/paddlecloud/paddleocr/tags: 

```bash
docker run --rm --name ppocr -v $PWD:/mnt -p 8888:8888 -it --shm-size=32g paddlecloud/paddleocr:2.6-cpu-latest /bin/bash -c hub serving start --modules ocr_system ocr_cls ocr_det ocr_rec -p 8888

```

## 自己打包镜像

基于cpu类型构建docker镜像，
参考文件 https://github.com/PaddlePaddle/PaddleOCR/blob/release/2.6/deploy/docker/hubserving/cpu/Dockerfile ，修改dockerfile文件内容：


```
# 版本查看 https://hub.docker.com/r/paddlepaddle/paddle/tags
ARG PADDLE_VERSION=2.4.0
FROM registry.baidubce.com/paddlepaddle/paddle:${PADDLE_VERSION}

# PaddleOCR base on Python3.7
RUN pip3.7 install --upgrade pip -i https://mirror.baidu.com/pypi/simple

RUN pip3.7 install paddlehub --upgrade -i https://mirror.baidu.com/pypi/simple

RUN git clone --depth=1 https://github.com/PaddlePaddle/PaddleOCR.git /PaddleOCR

WORKDIR /PaddleOCR

RUN pip3.7 install -r requirements.txt -i https://mirror.baidu.com/pypi/simple

# -------------------------
# 下载模型
# 模型选择: https://github.com/PaddlePaddle/PaddleOCR#%EF%B8%8F-pp-ocr-series-model-listupdate-on-september-8th
# Chinese and English general PP-OCR model (143.4M) 通用 OCR 模型
# -------------------------
RUN mkdir -p /PaddleOCR/inference/

ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_det_infer.tar /PaddleOCR/inference/
RUN tar xf /PaddleOCR/inference/ch_ppocr_mobile_v2.0_det_infer.tar -C /PaddleOCR/inference/

ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_cls_infer.tar /PaddleOCR/inference/
RUN tar xf /PaddleOCR/inference/ch_ppocr_mobile_v2.0_cls_infer.tar -C /PaddleOCR/inference/

ADD https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_rec_infer.tar /PaddleOCR/inference/
RUN tar xf /PaddleOCR/inference/ch_ppocr_mobile_v2.0_rec_infer.tar -C /PaddleOCR/inference/

# ------------------------
# 安装 OCR 能力
# ------------------------

RUN hub install /PaddleOCR/deploy/hubserving/ocr_system/
RUN hub install /PaddleOCR/deploy/hubserving/ocr_cls/
RUN hub install /PaddleOCR/deploy/hubserving/ocr_det/
RUN hub install /PaddleOCR/deploy/hubserving/ocr_rec/

EXPOSE 8868

CMD ["/bin/bash","-c","hub serving start -m ocr_system ocr_cls ocr_det ocr_rec -p 8868"]
```


执行打包命令：
```bash
docker build -t paddleocr-cpu:v20221125 .

docker tag paddleocr-cpu:v20221125 registry.cn-hangzhou.aliyuncs.com/mycompany/paddleocr-cpu:latest
docker push registry.cn-hangzhou.aliyuncs.com/mycompany/paddleocr-cpu:latest
```

## golang client 

```go
// Copyright © Homeking365.com. All rights reserved.

package main

import (
	"bytes"
	"encoding/base64"
	"fmt"
	"io"
	"net/http"
	"os"
)

const serveAddress = "http://10.225.51.84:9000/predict/ocr_system"

func main() {
	content := ocrRecognize("/Users/gelnyang/Downloads/ocr/1.jpg")

	println(string(content))
}

func ocrRecognize(f string) []byte {
	b, err := os.ReadFile(f)
	if err != nil {
		panic(err)
	}

	body := fmt.Sprintf(`{"images":["%s"]}`, base64.StdEncoding.EncodeToString(b))

	resp, err := http.Post(serveAddress, "application/json", bytes.NewBufferString(body))
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	content, err := io.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}

	return content
}
```

## 参考

- paddleocr 打包docker镜像说明: https://github.com/PaddlePaddle/PaddleOCR/tree/release/2.6/deploy/docker/hubserving
- paddleocr docker镜像: https://hub.docker.com/r/paddlecloud/paddleocr