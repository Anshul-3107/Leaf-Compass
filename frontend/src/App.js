import React, { useState } from 'react';
import { FaLeaf, FaChartLine, FaSeedling, FaFlask, FaRobot, FaHome } from 'react-icons/fa';
import DiseasePredictor from './pages/DiseaseDetector';
import YieldPredictor from './pages/YieldPrediction';
import CropRecommendation from './pages/CropRecommendation';
import FertilizerRecommendation from './pages/FertilizerRec';
import ChatPage from './pages/Chatpage';
import Chatbot from './components/Chatbot';
import './App.css';
import logo from './assets/logo.png';


function App() {
  const [activeTab, setActiveTab] = useState('home');

  const renderContent = () => {
    switch (activeTab) {
      case 'home':
        return <Home setTab={setActiveTab} />;
      case 'disease':
        return <DiseasePredictor />;
      case 'yield':
        return <YieldPredictor />;
      case 'crop':
        return <CropRecommendation />;
      case 'fertilizer':
        return <FertilizerRecommendation />;
      case 'chat':
        return <ChatPage />;
      default:
        return <Home setTab={setActiveTab} />;
    }
  };

  return (
    <div className="app-container">
      {/* Sidebar Navigation */}
      <nav className="sidebar">
        <div className="logo">
          <img src={logo} alt="CropCompass Logo" style={{ width: '250px', height: '250px' } } />
        </div>
        <button className={`nav-btn ${activeTab === 'home' ? 'active' : ''}`} onClick={() => setActiveTab('home')}>
          <FaHome /> Home
        </button>
        <button className={`nav-btn ${activeTab === 'disease' ? 'active' : ''}`} onClick={() => setActiveTab('disease')}>
          <FaLeaf /> Disease Detection
        </button>
        <button className={`nav-btn ${activeTab === 'yield' ? 'active' : ''}`} onClick={() => setActiveTab('yield')}>
          <FaChartLine /> Yield Prediction
        </button>
        <button className={`nav-btn ${activeTab === 'crop' ? 'active' : ''}`} onClick={() => setActiveTab('crop')}>
          <FaSeedling /> Crop Recommender
        </button>
        <button className={`nav-btn ${activeTab === 'fertilizer' ? 'active' : ''}`} onClick={() => setActiveTab('fertilizer')}>
          <FaFlask /> Fertilizer Advisor
        </button>
        <button className={`nav-btn ${activeTab === 'chat' ? 'active' : ''}`} onClick={() => setActiveTab('chat')}>
          <FaRobot /> AI Expert
        </button>
      </nav>

      {/* Main Content Area */}
      <main className="main-content">
        {renderContent()}
      </main>

      {/* Floating Chatbot (Hidden on Chat Page) */}
      {activeTab !== 'chat' && <Chatbot />}
    </div>
  );
}

// Simple Home Component for the Dashboard
const Home = ({ setTab }) => (
  <div className="home-hero">
    <div className="home-content"></div>
    <h1>Welcome to Smart Farming</h1>
    <p>Leverage the power of AI to improve your crop health, yield, and decision-making.</p>
    
    <div className="features-grid">
      <div className="feature-card" onClick={() => setTab('disease')}>
        <FaLeaf size={40} className='aaa'/>
        <h3>Identify Diseases</h3>
        <p>Upload a leaf photo to diagnose issues instantly.</p>
      </div>
      <div className="feature-card" onClick={() => setTab('yield')}>
        <FaChartLine size={40} className='aaa' />
        <h3>Predict Yield</h3>
        <p>Estimate your harvest based on environmental factors.</p>
      </div>
      <div className="feature-card" onClick={() => setTab('crop')}>
        <FaSeedling size={40} className='aaa'/>
        <h3>Best Crop</h3>
        <p>Find out what grows best in your soil conditions.</p>
      </div>
      <div className="feature-card" onClick={() => setTab('fertilizer')}>
        <FaFlask size={40} className='aaa'/>
        <h3>Smart Fertilizer</h3>
        <p>Get tailored nutrient advice for your crops.</p>
      </div>
    </div>
  </div>
);

export default App;