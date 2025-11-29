import React from 'react';
import { Leaf, BarChart3, Camera } from 'lucide-react';

const Home = ({ setActiveTab }) => (
  <div className="animate-fade-in">
    <div className="bg-gradient-to-b from-green-700 to-green-600 text-white py-20 px-4 text-center rounded-b-3xl shadow-xl">
      <h1 className="text-4xl md:text-5xl font-extrabold mb-4">Smart Farming for a Better Future</h1>
      <p className="text-lg md:text-xl text-green-100 max-w-2xl mx-auto mb-8">
        Leverage the power of Artificial Intelligence to optimize your crop yields, detect diseases early, and get expert agricultural advice.
      </p>
      <button 
        onClick={() => setActiveTab('detect')}
        className="bg-white text-green-800 px-8 py-3 rounded-full font-bold shadow-lg hover:bg-green-50 transition transform hover:scale-105"
      >
        Try Disease Detector
      </button>
    </div>

    <div className="max-w-7xl mx-auto px-4 py-16">
      <h2 className="text-3xl font-bold text-center text-gray-800 mb-12">Our AI Tools</h2>
      <div className="grid md:grid-cols-3 gap-8">
        {[
          { title: "Crop Recommendation", desc: "Analyze soil & weather to find the perfect crop.", icon: <Leaf className="w-12 h-12 text-green-600" />, tab: 'crop' },
          { title: "Yield Prediction", desc: "Forecast your harvest based on historical data.", icon: <BarChart3 className="w-12 h-12 text-blue-600" />, tab: 'yield' },
          { title: "Disease Detection", desc: "Upload a leaf photo to identify diseases instantly.", icon: <Camera className="w-12 h-12 text-red-500" />, tab: 'detect' },
        ].map((feature, idx) => (
          <div key={idx} onClick={() => setActiveTab(feature.tab)} className="bg-white p-6 rounded-xl shadow-md hover:shadow-xl transition cursor-pointer border border-gray-100 group">
            <div className="mb-4 group-hover:scale-110 transition-transform duration-300">{feature.icon}</div>
            <h3 className="text-xl font-bold mb-2 text-gray-800">{feature.title}</h3>
            <p className="text-gray-600">{feature.desc}</p>
          </div>
        ))}
      </div>
    </div>
  </div>
);

export default Home;