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
python3.6 /project/ev_sdk/src/convert_to_onnx.py
ls /project/ev_sdk/model


# step 2:generate file_list.txt
# commit version
mkdir  /project/ev_sdk/pic
mkdir /project/ev_sdk/raw
wget -O /project/ev_sdk/pic/0.jpg https://www.baidu.com/img/bd_logo1.png


# commit version
python3.6 /project/ev_sdk/src/create_raws.py -i /project/ev_sdk/pic -d /project/ev_sdk/raw -s 112
python3.6 /project/ev_sdk/src/create_file_list.py -i /project/ev_sdk/raw -e *.raw && echo 'creat list done!'

# step 3:generate dlc

# commit version
snpe-onnx-to-dlc --input_network /project/ev_sdk/model/model.onnx --output_path /project/ev_sdk/model/model.dlc -d input 1,3,112,112 && echo "snpe-onx-to-dlc done"
snpe-dlc-quantize --input_dlc /project/ev_sdk/model/model.dlc --output_dlc /project/ev_sdk/model/model_quantized.dlc --input_list /project/ev_sdk/file_list.txt --input_dlc --enable_htp && echo 'snpe-dlc-quantize done'

rm /project/ev_sdk/model/model.dlc
echo 'dlc-remove done'

