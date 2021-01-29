const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');

require('dotenv').config();

const app = express();

mongoose
  .connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Growgreen database connected'))
  .catch(err => console.error(err))

const userRouter = require('./routes/api/user');
const plantedRouter = require('./routes/api/planted');
const creditRouter = require('./routes/api/credit');
const plantRouter = require('./routes/api/plant');
const placeRouter = require('./routes/api/place');
const uploadRouter = require('./routes/api/upload');

//Middlewares
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());
app.use(express.static(path.join(__dirname, 'public')));

//API routers
app.use("/api/user", userRouter);
app.use('/api/planted', plantedRouter);
app.use('/api/credit', creditRouter);
app.use('/api/plant', plantRouter);
app.use('/api/place', placeRouter);
app.use('/api/upload', uploadRouter);

app.get('/', (req, res) => {
  res.json({"Testing": '123'});
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Growgreen backend listening at ${PORT}`);
})