const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
    destination: "./public/media",
    filename: function(req, file, cb) {
        cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 1000000
    },
    // fileFilter: function(req, file, cb) {
    //     const filetypes = /jpeg|jpg|png|gif/;
    //     const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    //     const mimetype = filetypes.test(file.mimetype);
    //     if(mimetype && extname){
    //         console.log('CallBack null');
    //         return cb(null, true);
    //     } else {
    //         console.log('CallBack Error');
    //         cb('Error: Images only.',false);
    //     }
    // }
}).single('image-upload');

module.exports = {upload};