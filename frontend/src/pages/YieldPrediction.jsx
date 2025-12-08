import React, { useState } from 'react';
import axios from 'axios';

const YieldPredictor = () => {
  const [formData, setFormData] = useState({
    Rainfall_mm: 1200,
    Temperature_Celsius: 25,
    Days_to_Harvest: 90,
    Region: 'North',
    Soil_Type: 'Loam',
    Crop: 'Wheat',
    Weather_Condition: 'Sunny',
    Fertilizer_Used: false,
    Irrigation_Used: false
  });

  const [prediction, setPrediction] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData({
      ...formData,
      [name]: type === 'checkbox' ? checked : value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setPrediction(null);
    
    try {
      const response = await axios.post("https://leafcompass.onrender.com/predict-yield", formData);
      setPrediction(response.data.predicted_yield);
    } catch (error) {
      console.error(error);
      alert("Error: Ensure backend is running.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h2>📈 Crop Yield Estimator</h2>
      <p style={{marginBottom: '20px', color: '#555'}}>
        Provide field conditions to estimate your potential harvest tonnage per hectare.
      </p>
      
      <form onSubmit={handleSubmit} style={gridStyle}>
        
        {/* Row 1: Environment */}
        <div className="form-group">
          <label>💧 Rainfall (mm)</label>
          <input type="number" name="Rainfall_mm" value={formData.Rainfall_mm} onChange={handleChange} required />
        </div>

        <div className="form-group">
          <label>🌡️ Temperature (°C)</label>
          <input type="number" name="Temperature_Celsius" value={formData.Temperature_Celsius} onChange={handleChange} required />
        </div>

        {/* Row 2: Crop Info */}
        <div className="form-group">
          <label>🌱 Crop Type</label>
          <select name="Crop" value={formData.Crop} onChange={handleChange}>
            <option value="Wheat">Wheat</option>
            <option value="Rice">Rice</option>
            <option value="Maize">Maize</option>
            <option value="Soybean">Soybean</option>
            <option value="Barley">Barley</option>
            <option value="Cotton">Cotton</option>
          </select>
        </div>

        <div className="form-group">
          <label>⏳ Days to Harvest</label>
          <input type="number" name="Days_to_Harvest" value={formData.Days_to_Harvest} onChange={handleChange} required />
        </div>

        {/* Row 3: Location & Soil */}
        <div className="form-group">
          <label>📍 Region</label>
          <select name="Region" value={formData.Region} onChange={handleChange}>
            <option value="North">North</option>
            <option value="South">South</option>
            <option value="East">East</option>
            <option value="West">West</option>
          </select>
        </div>

        <div className="form-group">
          <label>🟤 Soil Type</label>
          <select name="Soil_Type" value={formData.Soil_Type} onChange={handleChange}>
            <option value="Loam">Loam</option>
            <option value="Clay">Clay</option>
            <option value="Sandy">Sandy</option>
            <option value="Silt">Silt</option>
            <option value="Peat">Peat</option>
            <option value="Chalk">Chalk</option>
          </select>
        </div>

        {/* Row 4: Weather (Full Width) */}
        <div className="form-group" style={{gridColumn: 'span 2'}}>
          <label>☁️ Weather Condition</label>
          <select name="Weather_Condition" value={formData.Weather_Condition} onChange={handleChange}>
            <option value="Sunny">Sunny</option>
            <option value="Rainy">Rainy</option>
            <option value="Cloudy">Cloudy</option>
          </select>
        </div>

        {/* Row 5: Toggles (Aligned with Flexbox) */}
        <div style={checkboxGroupStyle}>
          <input 
            type="checkbox" 
            name="Fertilizer_Used" 
            checked={formData.Fertilizer_Used} 
            onChange={handleChange} 
            id="fert" 
            style={{width: '20px', height: '20px'}} // Ensure checkbox isn't full width
          /> 
          <label htmlFor="fert" style={{marginBottom: 0, cursor:'pointer'}}>Used Fertilizer?</label>
        </div>
        
        <div style={checkboxGroupStyle}>
          <input 
            type="checkbox" 
            name="Irrigation_Used" 
            checked={formData.Irrigation_Used} 
            onChange={handleChange} 
            id="irrig" 
            style={{width: '20px', height: '20px'}} // Ensure checkbox isn't full width
          /> 
          <label htmlFor="irrig" style={{marginBottom: 0, cursor:'pointer'}}>Used Irrigation?</label>
        </div>

        <button type="submit" style={{gridColumn: 'span 2'}} disabled={loading}>
          {loading ? "Calculating..." : "Predict Yield"}
        </button>
      </form>

      {prediction !== null && (
        <div className="result">
          <h3>Estimated Yield: {parseFloat(prediction).toFixed(2)} tons/hectare</h3>
        </div>
      )}
    </div>
  );
};

// Inline styles for layout alignment
const gridStyle = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: '20px',
  textAlign: 'left'
};

// Inline style for centering checkboxes
const checkboxGroupStyle = {
  display: 'flex',
  alignItems: 'center',
  gap: '10px',
  padding: '10px 0'
};

export default YieldPredictor;