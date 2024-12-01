import multer from "multer";
import path from "path";

// Konfigurasi untuk penyimpanan
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads"); // Direktori penyimpanan file
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname); // Ekstensi file
    cb(null, file.fieldname + "-" + uniqueSuffix + ext); // Format nama file
  },
});

// Filter file (misalnya hanya gambar)
const fileFilter = (req, file, cb) => {
  const allowedTypes = ["image/jpeg", "image/png", "image/jpg"];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true); // Terima file
  } else {
    cb(new Error("Only .jpeg, .jpg, and .png files are allowed"), false);
  }
};

export const upload = multer({ storage, fileFilter });
