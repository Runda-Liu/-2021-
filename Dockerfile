FROM uhub.service.ucloud.cn/eagle_nest/ubuntu16.04-cuda10.0-cudnn7.4-opencv4.1-snpe1.47-pytorch1.5

RUN rm -rf /usr/local/ev_sdk && mkdir -p /usr/local/ev_sdk
COPY ./ /usr/local/ev_sdk

RUN \
    cd /usr/local/ev_sdk && mkdir -p build && rm -rf build/* \
    && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j4 install && rm -rf ../build/*

# RUN python -m pip install -r /usr/local/ev_sdk/requirements.txt
RUN pip3.6 install torchvision
RUN pip3.6 install scikit-image
RUN pip3.6 install scikit-learn
RUN pip3.6 install efficientnet_pytorch
    
ENV AUTO_TEST_USE_JI_PYTHON_API=1
