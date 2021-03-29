import tensorflow as tf
import cv2
import numpy as np
import requests
from flask import Flask, request, jsonify
from flask_socketio import SocketIO, send, emit

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'

new_model = tf.keras.models.load_model('./leaves_detection.h5')

def create_mask(pred_mask):
  pred_mask = tf.argmax(pred_mask, axis=-1)
  pred_mask = pred_mask[..., tf.newaxis]
  return pred_mask[0]

@app.route('/landcover/', methods=['GET'])
def detect():
  lati, longi, user_id = request.args['lat'], request.args['long'], request.args['user_id']
  img_name = f'{lati}-{longi}.jpg'

  response = requests.get(f"https://maps.googleapis.com/maps/api/staticmap?center={lati},{longi}&zoom=21&size=512x512&format=jpg&maptype=satellite&key=AIzaSyCr0-s_qBQozzmLIAzQvnUWwRSQUMuhwN4")
  print("API Call: ", f"https://maps.googleapis.com/maps/api/staticmap?center={lati},{longi}&zoom=21&size=512x512&format=jpg&maptype=satellite&key=AIzaSyCr0-s_qBQozzmLIAzQvnUWwRSQUMuhwN4")

  with open(f"media/{img_name}", 'wb') as file:
    file.write(response.content)

  img = cv2.imread(f'media/{img_name}')

  # img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
  # (h,s,v) = cv2.split(img)
  # s = s*2
  # s = np.clip(s, 0, 255)
  # img = cv2.merge([h,s,v])
  # img = cv2.cvtColor(img, cv2.COLOR_HSV2BGR)

  img = np.resize(img, [1, 128,128, 3])

  pred_mask = new_model.predict(img)
  pred_mask = create_mask(pred_mask)

  p_m = pred_mask.numpy()

  mask_inv = cv2.bitwise_not(p_m)

  image = cv2.imread(f'media/{img_name}')

  # image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
  # (h,s,v) = cv2.split(image)
  # s = s*2
  # s = np.clip(s, 0, 255)
  # image = cv2.merge([h,s,v])
  # image = cv2.cvtColor(image, cv2.COLOR_HSV2BGR)

  gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

  rows, cols, channels = image.shape
  image = image[0:rows, 0:cols]

  bigger = cv2.resize(p_m.reshape((128,128)).astype('uint8'), (512, 512))

  kernel = np.ones((5,5),np.uint8)
  erosion = cv2.erode(bigger,kernel,iterations = 1)
  bigger = cv2.dilate(erosion,kernel,iterations = 1)


  colored_portion = cv2.bitwise_and(image, image, mask = bigger)
  colored_portion = colored_portion[0:rows, 0:cols]

  gray_portion = cv2.bitwise_and(gray, gray, mask = bigger)
  gray_portion = np.stack((gray_portion,)*3, axis=-1)

  output = colored_portion + gray_portion
  conditional = output.reshape(-1, 3).sum(axis=1) <= 3
  summ = np.sum(conditional)/(512 * 512)
  plantableFraction = (1 - summ) * 100
  print("Plantable area:", (1 - summ) * 100, "%")

  cv2.imwrite('output.jpg', output)

  # emit("landCoverDone", {'lat': lat, "long": long, 'user_id': user_id, 'pred': pred})

  return jsonify({"pred": plantableFraction})

@app.route("/")
def check():
  return jsonify({"Testing": 101})

if __name__=='__main__':
  app.run(debug=True)
