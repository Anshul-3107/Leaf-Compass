import React, { useState } from 'react';
import axios from 'axios';

const CropRecommendation = () => {
  const [formData, setFormData] = useState({
    N: 90, 
    P: 42, 
    K: 43,
    temperature: 20,
    humidity: 82,
    ph: 6.5,
    rainfall: 202,
    state: "Punjab" // Default value
  });
  
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  // List of states used in training (Add/Edit as needed based on your dataset)
  const states = [
    "Andaman and Nicobar Islands", "Andhra Pradesh", "Assam", "Chattisgarh", 
    "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", 
    "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", 
    "Meghalaya", "Nagaland", "Odisha", "Pondicherry", "Punjab", "Rajasthan", 
    "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttrakhand", "West Bengal"
  ];

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ 
      ...formData, 
      [name]: name === 'state' ? value : parseFloat(value) 
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setResult(null);

    try {
      const response = await axios.post("https://leafcompass.onrender.com/recommend-crop", formData);
      setResult(response.data.recommended_crop);
    } catch (error) {
      console.error("Error:", error);
      alert("Error: Ensure backend is running and crop model is loaded.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h2>🌱 Crop Recommendation</h2>
      
      <form onSubmit={handleSubmit} className="form-grid">
        <label>Nitrogen (N): <input type="number" name="N" value={formData.N} onChange={handleChange} required /></label>
        <label>Phosphorus (P): <input type="number" name="P" value={formData.P} onChange={handleChange} required /></label>
        <label>Potassium (K): <input type="number" name="K" value={formData.K} onChange={handleChange} required /></label>
        <label>pH Level: <input type="number" name="ph" step="0.1" value={formData.ph} onChange={handleChange} required /></label>
        <label>Temperature (°C): <input type="number" name="temperature" step="0.1" value={formData.temperature} onChange={handleChange} required /></label>
        <label>Humidity (%): <input type="number" name="humidity" step="0.1" value={formData.humidity} onChange={handleChange} required /></label>
        <label>Rainfall (mm): <input type="number" name="rainfall" step="0.1" value={formData.rainfall} onChange={handleChange} required /></label>
        
        <label>
          State:
          <select name="state" value={formData.state} onChange={handleChange}>
            {states.map(state => <option key={state} value={state}>{state}</option>)}
          </select>
        </label>
        
        <button type="submit" className="full-width" disabled={loading} style={{marginTop: '15px'}}>
          {loading ? "Analyzing..." : "Recommend Crop"}
        </button>
      </form>

      {result && (
        <div className="result">
          <h3>Best Crop to Plant:</h3>
          <span className="crop-name">{result}</span> 🌾
        </div>
      )}
    </div>
  );
};

export default CropRecommendation;