#!/bin/bash

# 在这里编写OpenVINO模型转换
# 系统会将所选择的原始模型放在目录/usr/local/ev_sdk/model下，转换后的OpenVINO模型请放在model/openvino目录下，
# 建议所有路径都使用绝对路径

# 获取当前脚本的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source /opt/snpe/snpe_venv/bin/activate
# step 0:prepare 
pip3.6 install onnx
pip3.6 install protobuf --upgrade
pip3.6 install opencv-python
pip install onnx
pip install protobuf --upgrade
pip install opencv-python
 
# step 1:to_onnx 
#commit version
python3.6 /usr/local/ev_sdk/src/to_onnx.py
ls /usr/local/ev_sdk/model


# step 2:generate file_list.txt
# commit version
mkdir  /usr/local/ev_sdk/pic
mkdir /usr/local/ev_sdk/raw
wget -O /usr/local/ev_sdk/pic/0.jpg https://www.baidu.com/img/bd_logo1.png


# commit version
python3.6 /usr/local/ev_sdk/src/create_raws.py -i /usr/local/ev_sdk/pic -d /usr/local/ev_sdk/raw -s 112
python3.6 /usr/local/ev_sdk/src/create_file_list.py -i /usr/local/ev_sdk/raw -e *.raw && echo 'creat list done!'

# step 3:generate dlc

# commit version
snpe-onnx-to-dlc --input_network /usr/local/ev_sdk/model/model.onnx --output_path /usr/local/ev_sdk/model/model.dlc -d input 1,3,112,112 && echo "snpe-onx-to-dlc done"
snpe-dlc-quantize --input_dlc /usr/local/ev_sdk/model/model.dlc --output_dlc /usr/local/ev_sdk/model/model_quantized.dlc --input_list /usr/local/ev_sdk/file_list.txt --input_dlc --enable_htp && echo 'snpe-dlc-quantize done'

rm /usr/local/ev_sdk/model/model.dlc
echo 'dlc-remove done'



