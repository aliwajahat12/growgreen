const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

require('dotenv').config();

const app = express();

mongoose
  .connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Growgreen database connected'))
  .catch(err => console.error(err))

const userRouter = require('./routes/api/user');

//Middlewares
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

//API routers
app.use("/api/user", userRouter);

app.get('/', (req, res) => {
  res.json({"hello": 'hello mehran'});
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Growgreen backend listening at ${PORT}`);
})