import React, { useState } from 'react';
import axios from 'axios';

const FertilizerRecommendation = () => {
  const [formData, setFormData] = useState({
    Temperature: 26,
    Humidity: 52,
    Moisture: 38,
    Soil_Type: 'Sandy',
    Crop_Type: 'Maize',
    Nitrogen: 37,
    Potassium: 0,
    Phosphorous: 0
  });
  
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  // Options based on standard fertilizer datasets
  const soilTypes = ["Sandy", "Loamy", "Black", "Red", "Clayey"];
  const cropTypes = ["Maize", "Sugarcane", "Cotton", "Tobacco", "Paddy", "Barley", "Wheat", "Millets", "Oil seeds", "Pulses", "Ground Nuts"];

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ 
      ...formData, 
      [name]: name === 'Soil_Type' || name === 'Crop_Type' ? value : parseFloat(value) 
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setResult(null);

    try {
      const response = await axios.post("https://leafcompass.onrender.com/recommend-fertilizer", formData);
      setResult(response.data.recommended_fertilizer);
    } catch (error) {
      console.error("Error:", error);
      alert("Error: Ensure backend is running and fertilizer model is loaded.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h2>🧪 Fertilizer Recommendation</h2>
      <p>Get advice on the best fertilizer for your soil.</p>
      
      <form onSubmit={handleSubmit} className="form-grid">
        <label>
          Temperature (°C):
          <input type="number" name="Temperature" value={formData.Temperature} onChange={handleChange} required />
        </label>

        <label>
          Humidity (%):
          <input type="number" name="Humidity" value={formData.Humidity} onChange={handleChange} required />
        </label>

        <label>
          Moisture:
          <input type="number" name="Moisture" value={formData.Moisture} onChange={handleChange} required />
        </label>

        <label>
          Nitrogen:
          <input type="number" name="Nitrogen" value={formData.Nitrogen} onChange={handleChange} required />
        </label>

        <label>
          Potassium:
          <input type="number" name="Potassium" value={formData.Potassium} onChange={handleChange} required />
        </label>

        <label>
          Phosphorous:
          <input type="number" name="Phosphorous" value={formData.Phosphorous} onChange={handleChange} required />
        </label>

        <label>
          Soil Type:
          <select name="Soil_Type" value={formData.Soil_Type} onChange={handleChange}>
            {soilTypes.map(soil => <option key={soil} value={soil}>{soil}</option>)}
          </select>
        </label>

        <label>
          Crop Type:
          <select name="Crop_Type" value={formData.Crop_Type} onChange={handleChange}>
            {cropTypes.map(crop => <option key={crop} value={crop}>{crop}</option>)}
          </select>
        </label>

        <button type="submit" className="full-width" disabled={loading}>
          {loading ? "Analyzing..." : "Get Recommendation"}
        </button>
      </form>

      {result && (
        <div className="result">
          <h3>Recommended Fertilizer:</h3>
          <span className="crop-name">{result}</span> 💊
        </div>
      )}
    </div>
  );
};

export default FertilizerRecommendation;