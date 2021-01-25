const express = require('express');

const userRouter = require('./routes/api/Users');
require('dotenv').config();

const app = express();

//API routers
app.use("/api/user", userRouter);

app.get('/', (req, res) => {
    res.send("Hello");
})

const port = process.env.PORT;
app.listen(port, () => {
    console.log(`Growgreen backend listening at ${port}`);
})