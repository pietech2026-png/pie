import React, { useState } from "react";

export default function UploadHotels() {
  const [file, setFile] = useState(null);

  const handleUpload = async () => {
    if (!file) return alert("Select file first");

    const formData = new FormData();
    formData.append("file", file);

    try {
      const res = await fetch("http://localhost:3000/api/hotels/upload", {
        method: "POST",
        body: formData,
      });

      const data = await res.json();
      console.log(data);

      alert("Hotels Uploaded Successfully ✅");
    } catch (err) {
      console.error(err);
      alert("Upload Failed ❌");
    }
  };

  return (
    <div style={{ maxWidth: "600px" }}>
      <h2>Upload Hotels from Document</h2>

      <input
        type="file"
        accept=".csv,.xlsx"
        onChange={(e) => setFile(e.target.files[0])}
      />

      <br /><br />

      <button onClick={handleUpload}>
        Upload File
      </button>
    </div>
  );
}