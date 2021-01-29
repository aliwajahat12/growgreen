const mongoose = require("mongoose");

const uploadSchema = mongoose.Schema({
  userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user",
      required: true
  },
  url: {
      type: String,
      required: true
  }
});

module.exports = mongoose.model("upload", uploadSchema);