import torch
import torch.onnx
from efficientnet_pytorch import EfficientNet
from res18_network import resnet18
# device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
#记得改路径
m_path = '/usr/local/ev_sdk/model/models.pkl'
model = torch.load(m_path,map_location=torch.device('cpu'))
# model.set_swish(memory_efficient=False)
print('load model finish!')
dummy_input1 = torch.randn(1,3,112,112)
input_names = ["input"]
output_names = ["output1"]
#记得改路径
torch.onnx.export(model, dummy_input1,"/usr/local/ev_sdk/model/model.onnx", verbose=True,input_names=input_names,output_names=output_names)
# torch.onnx.export(model, dummy_input1,"/usr/local/ev_sdk/model/model.onnx", verbose=True,input_names=input_names,output_names=output_names)
print('to_onnx is finish!')
