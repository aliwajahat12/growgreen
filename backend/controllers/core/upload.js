const {upload} = require("../middlewares/storage");
const mongoose = require("mongoose");
const UploadModel = require("../../models/upload");

module.exports = {
    handleUpload: async (req, res) => {
        upload(req, res, async (err) => {
            const {user_id} = req.params;
            if(err){
                res.json({"status": "fail", "reason": "error", "error": err.message});
            } else {
                try {
                    const newUpload = new UploadModel({"userId": mongoose.Types.ObjectId(user_id), "url": "/media/" + req.file.filename});
                    console.log(req.file);
                    await newUpload.save();
                    res.json({"status": "success", "url": newUpload.url, "upload_id": newUpload._id});
                } catch (err) {
                    console.log("Error: ", err.message);
                    res.json({ 'status': 'fail', 'reason': err.message });
                }
            }
        });
    }
}