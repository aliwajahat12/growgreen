import tensorflow as tf
import cv2
import numpy as np
from flask import Flask, request
import json

def create_mask(pred_mask):
  pred_mask = tf.argmax(pred_mask, axis=-1)
  pred_mask = pred_mask[..., tf.newaxis]
  return pred_mask[0]

new_model = tf.keras.models.load_model('./leaves_detection.h5')

img_path = '../map.jpg'
img = cv2.imread(img_path)
img = np.resize(img, [1, 128,128, 3])
pred_mask = new_model.predict(img)
pred_mask = create_mask(pred_mask)
p_m = pred_mask.numpy()
mask_inv = cv2.bitwise_not(p_m)
image = cv2.imread(img_path)
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
rows, cols, channels = image.shape
image = image[0:rows, 0:cols]
bigger = cv2.resize(p_m.reshape((128,128)).astype('uint8'), (512, 512))
kernel = np.ones((5,5),np.uint8)
erosion = cv2.erode(bigger,kernel,iterations = 1)
bigger = cv2.dilate(erosion,kernel,iterations = 1)
bigger = cv2.dilate(erosion,kernel,iterations = 1)
colored_portion = cv2.bitwise_and(image, image, mask = bigger)
colored_portion = colored_portion[0:rows, 0:cols]
gray_portion = cv2.bitwise_and(gray, gray, mask = bigger)
gray_portion = np.stack((gray_portion,)*3, axis=-1)
output = colored_portion + gray_portion
resulting_path = img_path['path'].split('.')[0] + "-detected.jpg"
cv2.imwrite(resulting_path, output)