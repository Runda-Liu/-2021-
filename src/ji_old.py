import cv2
import json
import numpy as np
import torch
from skimage import io,transform,color
from PIL import Image
from torchvision import transforms, models
# 自己的模型

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

def init():
    # 测试时选择的文件名
    pth = '/usr/local/ev_sdk/model/models.pkl'
    model = torch.load(pth) 
    
    return model

# 根据训练的标签设置

class_dict = {}
f = open('/usr/local/ev_sdk/src/class.txt','r')
a = f.read()
class_dict = eval(a)
class_dict = {value:key for key, value in class_dict.items()}
f.close()

def process_image(net, input_image, args=None):
    
    img = input_image
    img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = Image.fromarray(img)
    #作相应的图像变换，resize,totensor,normalize注意totensor一定要在normalize之前
    norm_mean = [0.485, 0.456, 0.406]
    norm_std = [0.229, 0.224, 0.225]
    pic_transform = transforms.Compose([transforms.Resize(112),transforms.ToTensor(),transforms.Normalize(norm_mean,norm_std)]) 
    img = pic_transform(img)
    img = np.array(img)
    img = img.transpose(0,2,1)
    img = torch.tensor([img])
    img = img.to(device)
    net.eval()
    with torch.no_grad():
        out = net(img)
        print(out)
        _, pred = torch.max(out.data, 1)
        data = json.dumps({'class': class_dict[pred[0].item()]},indent=4)
    return data


if __name__ == '__main__':
    net = init()
    x = cv2.imread('../pic/0.jpg')
