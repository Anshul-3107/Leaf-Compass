import React, { useState } from 'react';
import axios from 'axios';

const DiseasePredictor = () => {
  const [selectedFile, setSelectedFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  const onSelectFile = (e) => {
    if (!e.target.files || e.target.files.length === 0) return;
    const file = e.target.files[0];
    setSelectedFile(file);
    setPreview(URL.createObjectURL(file));
    setResult(null);
  };

  const handlePredict = async () => {
    if (!selectedFile) return;
    setLoading(true);
    
    const formData = new FormData();
    formData.append("file", selectedFile);

    try {
      const response = await axios.post("https://leafcompass.onrender.com/predict-disease", formData, {
        headers: { "Content-Type": "multipart/form-data" }
      });
      setResult(response.data);
    } catch (error) {
      console.error("Error", error);
      alert("Error predicting disease");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h2>Plant Disease Detection</h2>
      <input type="file" onChange={onSelectFile} accept="image/*" />
      
      {preview && <img src={preview} alt="Preview" style={{ maxWidth: '100%', marginTop: '10px' }} />}
      
      <button onClick={handlePredict} disabled={!selectedFile || loading} style={{marginTop: '10px'}}>
        {loading ? "Analyzing..." : "Analyze Plant"}
      </button>

      {result && (
        <div className="result">
          <h3>Result: {result.class}</h3>
          <p>Confidence: {(result.confidence * 100).toFixed(2)}%</p>
        </div>
      )}
    </div>
  );
};

export default DiseasePredictor;