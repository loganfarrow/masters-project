import React, { useState } from 'react';
import { Settings, Grid, Save, Undo, Upload, Play, Edit3 } from 'lucide-react';

const App = () => {
  const [activeTab, setActiveTab] = useState('individual');
  const [selectedRegion, setSelectedRegion] = useState(null);
  const [selectedMirrors, setSelectedMirrors] = useState([]);
  
  // Define the regions based on the image
  const regions = [
    // Top row - 6 small regions (5x8 each)
    { id: 'top1', label: 'Top Left 1', rows: 5, cols: 8, x: 0, y: 0, width: 16.6, height: 30 },
    { id: 'top2', label: 'Top Left 2', rows: 5, cols: 8, x: 16.6, y: 0, width: 16.6, height: 30 },
    { id: 'top3', label: 'Top Left 3', rows: 5, cols: 8, x: 33.2, y: 0, width: 16.6, height: 30 },
    { id: 'top4', label: 'Top Right 1', rows: 5, cols: 8, x: 50, y: 0, width: 16.6, height: 30 },
    { id: 'top5', label: 'Top Right 2', rows: 5, cols: 8, x: 66.6, y: 0, width: 16.6, height: 30 },
    { id: 'top6', label: 'Top Right 3', rows: 5, cols: 8, x: 83.2, y: 0, width: 16.6, height: 30 },
    
    // Bottom row - 4 larger regions (8x11 each) with gap for door
    { id: 'bottom1', label: 'Bottom Left 1', rows: 8, cols: 11, x: 0, y: 35, width: 22, height: 65 },
    { id: 'bottom2', label: 'Bottom Left 2', rows: 8, cols: 11, x: 22, y: 35, width: 22, height: 65 },
    { id: 'bottom3', label: 'Bottom Right 1', rows: 8, cols: 11, x: 56, y: 35, width: 22, height: 65 },
    { id: 'bottom4', label: 'Bottom Right 2', rows: 8, cols: 11, x: 78, y: 35, width: 22, height: 65 },
  ];
  
  const handleRegionSelect = (region) => {
    setSelectedRegion(region);
    setSelectedMirrors([]); // Reset mirror selection
  };
  
  const handleMirrorSelect = (mirrorId) => {
    if (selectedMirrors.includes(mirrorId)) {
      setSelectedMirrors(selectedMirrors.filter(id => id !== mirrorId));
    } else {
      setSelectedMirrors([...selectedMirrors, mirrorId]);
    }
  };
  
  return (
    <div className="flex flex-col h-screen bg-gray-100">
      {/* Header */}
      <header className="bg-blue-600 text-white p-4 shadow-md">
        <div className="flex justify-between items-center">
          <h1 className="text-xl font-bold">Mirror Array Control</h1>
          <Settings size={24} />
        </div>
      </header>
      
      {/* Tab Navigation */}
      <div className="flex bg-white shadow-sm">
        <button 
          className={`flex-1 py-3 font-medium ${activeTab === 'individual' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-600'}`}
          onClick={() => setActiveTab('individual')}
        >
          Mirror Control
        </button>
        <button 
          className={`flex-1 py-3 font-medium ${activeTab === 'image' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-600'}`}
          onClick={() => setActiveTab('image')}
        >
          Image Mode
        </button>
        <button 
          className={`flex-1 py-3 font-medium ${activeTab === 'patterns' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-600'}`}
          onClick={() => setActiveTab('patterns')}
        >
          Patterns
        </button>
      </div>
      
      {/* Content Area */}
      <div className="flex-1 overflow-auto p-4">
        {activeTab === 'individual' && <IndividualControl 
          regions={regions} 
          selectedRegion={selectedRegion} 
          onRegionSelect={handleRegionSelect}
          selectedMirrors={selectedMirrors}
          onMirrorSelect={handleMirrorSelect}
        />}
        {activeTab === 'image' && <ImageMode />}
        {activeTab === 'patterns' && <PatternsMode />}
      </div>
    </div>
  );
};

// Individual Mirror Control Tab
const IndividualControl = ({ regions, selectedRegion, onRegionSelect, selectedMirrors, onMirrorSelect }) => {
  return (
    <div className="h-full flex flex-col">
      <div className="mb-4 flex justify-between items-center">
        <div className="text-sm text-gray-500">
          {selectedRegion ? `${selectedRegion.label} Selected - ${selectedMirrors.length} of ${selectedRegion.rows * selectedRegion.cols} mirrors selected` : 'Select a region on the window'}
        </div>
        <div className="flex space-x-2">
          <button className="p-2 bg-white rounded-full shadow"><Grid size={18} /></button>
          <button className="p-2 bg-white rounded-full shadow"><Undo size={18} /></button>
          <button className="p-2 bg-white rounded-full shadow"><Save size={18} /></button>
        </div>
      </div>
      
      {/* 3D Representation of Window with Regions */}
      <div className="bg-white rounded-lg shadow-md p-4 mb-4">
        <h3 className="font-medium mb-3">Window Layout - Select a Region</h3>
        <div className="relative w-full h-64 bg-gray-800 rounded-lg overflow-hidden border-4 border-gray-700">
          {/* This is a simplified 3D-like representation */}
          <div className="absolute inset-0 bg-blue-900 opacity-30"></div>
          
          {/* Window frame structure - vertical separator between left and right sides */}
          <div className="absolute left-1/2 top-0 bottom-0 w-4 bg-gray-300 transform -translate-x-1/2"></div>
          
          {/* Door gap representation - just empty space */}
          <div className="absolute left-44 right-44 bottom-0 top-35 bg-gray-800 border-l-2 border-r-2 border-gray-300"></div>
          
          {regions.map(region => (
            <div 
              key={region.id} 
              onClick={() => onRegionSelect(region)}
              className={`absolute rounded cursor-pointer transition-all duration-200 hover:opacity-80 ${
                selectedRegion && selectedRegion.id === region.id ? 'bg-blue-300 border-2 border-blue-500' : 'bg-gray-200 border border-gray-300'
              }`}
              style={{
                left: `${region.x}%`,
                top: `${region.y}%`,
                width: `${region.width}%`,
                height: `${region.height}%`,
              }}
            >
              <div className="w-full h-full flex items-center justify-center">
                <span className="text-xs font-medium text-gray-700">{region.label}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
      
      {/* Selected Region Mirror Grid */}
      {selectedRegion && (
        <div className="bg-white rounded-lg shadow-md p-4 mb-4">
          <h3 className="font-medium mb-3">{selectedRegion.label} - Individual Mirrors</h3>
          <div className={`grid grid-cols-${selectedRegion.cols} gap-1`} style={{ gridTemplateColumns: `repeat(${selectedRegion.cols}, minmax(0, 1fr))` }}>
            {Array(selectedRegion.rows * selectedRegion.cols).fill(0).map((_, i) => (
              <div 
                key={i} 
                onClick={() => onMirrorSelect(i)}
                className={`${
                  selectedMirrors.includes(i) ? 'bg-blue-200 border-blue-500 border-2' : 'bg-gray-200 border'
                } rounded-full aspect-square hover:border-blue-500 cursor-pointer`}
              />
            ))}
          </div>
        </div>
      )}
      
      {/* Mirror Control Panel (placed below the mirror grid, not floating) */}
      {selectedRegion && (
        <div className="bg-white rounded-lg shadow-md p-4 border-t border-gray-200 mt-4">
          <h3 className="font-medium mb-3">Mirror Angle Controls</h3>
          
          <div className="flex flex-col mb-4 border border-gray-300 rounded-lg p-3 bg-gray-50">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium">Motor Controls</span>
              <div className="flex space-x-2">
                <button className="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs">Reset</button>
                <button className="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs">Calibrate</button>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div className="flex items-center justify-center">
                <div className="relative w-32 h-32 bg-white rounded-full shadow-inner flex items-center justify-center">
                  <div className="w-20 h-20 rounded-full bg-gray-200 flex items-center justify-center">
                    <div className="w-12 h-1 bg-blue-500 transform -rotate-45"></div>
                  </div>
                  <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                    <span className="text-xs text-gray-400">X-Motor</span>
                  </div>
                </div>
              </div>
              <div className="flex items-center justify-center">
                <div className="relative w-32 h-32 bg-white rounded-full shadow-inner flex items-center justify-center">
                  <div className="w-20 h-20 rounded-full bg-gray-200 flex items-center justify-center">
                    <div className="w-12 h-1 bg-blue-500 transform rotate-90"></div>
                  </div>
                  <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                    <span className="text-xs text-gray-400">Y-Motor</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div className="mb-4">
            <label className="block text-sm text-gray-600 mb-1">X-Axis Rotation (0-360°)</label>
            <div className="flex items-center">
              <span className="text-xs mr-2">0°</span>
              <input type="range" min="0" max="360" className="flex-1 mx-2" />
              <span className="text-xs ml-2">360°</span>
              <span className="ml-4 text-sm font-medium">45°</span>
            </div>
          </div>
          
          <div className="mb-4">
            <label className="block text-sm text-gray-600 mb-1">Y-Axis Rotation (0-360°)</label>
            <div className="flex items-center">
              <span className="text-xs mr-2">0°</span>
              <input type="range" min="0" max="360" className="flex-1 mx-2" />
              <span className="text-xs ml-2">360°</span>
              <span className="ml-4 text-sm font-medium">90°</span>
            </div>
          </div>
          
          <div className="flex justify-between">
            <button className="px-3 py-2 bg-gray-200 rounded text-sm font-medium">Reset Selected</button>
            <button className="px-3 py-2 bg-blue-600 text-white rounded text-sm font-medium">Apply to Selected</button>
          </div>
        </div>
      )}
    </div>
  );
};

// Image Mode Tab
const ImageMode = () => {
  return (
    <div className="h-full flex flex-col">
      {/* Image Upload Area */}
      <div className="flex-1 bg-white rounded-lg shadow-md p-4 mb-4 flex flex-col items-center justify-center">
        <div className="border-2 border-dashed border-gray-300 rounded-lg p-8 w-full h-64 flex flex-col items-center justify-center">
          <Upload size={48} className="text-gray-400 mb-4" />
          <h3 className="text-lg font-medium text-gray-700 mb-1">Upload an Image</h3>
          <p className="text-sm text-gray-500 mb-4 text-center">Drag and drop an image here or click to browse</p>
          <button className="px-4 py-2 bg-blue-600 text-white rounded">Browse Files</button>
        </div>
      </div>
      
      {/* Image Settings */}
      <div className="bg-white rounded-lg shadow-md p-4">
        <h3 className="font-medium mb-3">Image Processing</h3>
        
        <div className="mb-4">
          <label className="block text-sm text-gray-600 mb-1">Brightness</label>
          <div className="flex items-center">
            <input type="range" className="flex-1" />
            <span className="ml-2 text-sm">100%</span>
          </div>
        </div>
        
        <div className="mb-4">
          <label className="block text-sm text-gray-600 mb-1">Contrast</label>
          <div className="flex items-center">
            <input type="range" className="flex-1" />
            <span className="ml-2 text-sm">100%</span>
          </div>
        </div>
        
        <div className="flex justify-between items-center mb-4">
          <label className="text-sm text-gray-600">Invert Colors</label>
          <input type="checkbox" />
        </div>
        
        <div className="flex justify-between">
          <button className="px-3 py-2 bg-gray-200 rounded text-sm font-medium">Preview</button>
          <button className="px-3 py-2 bg-blue-600 text-white rounded text-sm font-medium">Project Image</button>
        </div>
      </div>
    </div>
  );
};

// Patterns Mode Tab
const PatternsMode = () => {
  return (
    <div className="h-full flex flex-col">
      {/* Patterns Library */}
      <div className="mb-4">
        <h3 className="font-medium mb-3">Pattern Library</h3>
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-4">
          {['Wave', 'Ripple', 'Spiral', 'Random', 'Checkerboard', 'Gradient'].map(pattern => (
            <div key={pattern} className="bg-white rounded-lg shadow p-3 text-center cursor-pointer hover:shadow-md">
              <div className="h-16 bg-gray-200 rounded mb-2"></div>
              <span className="text-sm">{pattern}</span>
            </div>
          ))}
          <div className="bg-white rounded-lg shadow p-3 text-center cursor-pointer hover:shadow-md border-2 border-dashed border-gray-300">
            <div className="h-16 flex items-center justify-center">
              <Plus size={24} className="text-gray-400" />
            </div>
            <span className="text-sm">Create New</span>
          </div>
        </div>
      </div>
      
      {/* Pattern Editor */}
      <div className="flex-1 bg-white rounded-lg shadow-md p-4 mb-4">
        <div className="flex justify-between items-center mb-4">
          <h3 className="font-medium">Pattern Editor</h3>
          <div className="flex space-x-2">
            <button className="p-2 bg-gray-100 rounded"><Edit3 size={18} /></button>
            <button className="p-2 bg-gray-100 rounded"><Play size={18} /></button>
            <button className="p-2 bg-gray-100 rounded"><Save size={18} /></button>
          </div>
        </div>
        
        <div className="border border-gray-200 rounded-lg p-4 h-64 flex items-center justify-center">
          <span className="text-gray-400">Select a pattern to edit or create a new one</span>
        </div>
      </div>
      
      {/* Animation Timeline */}
      <div className="bg-white rounded-lg shadow-md p-4">
        <h3 className="font-medium mb-3">Animation Timeline</h3>
        <div className="h-16 bg-gray-100 rounded-lg p-2 flex items-center">
          <div className="w-full h-8 bg-gray-200 rounded relative">
            <div className="absolute left-0 top-0 h-full w-1 bg-red-500"></div>
          </div>
        </div>
        
        <div className="flex justify-between mt-4">
          <div className="flex space-x-2">
            <button className="p-2 bg-gray-200 rounded"><Rewind size={18} /></button>
            <button className="p-2 bg-gray-200 rounded"><Play size={18} /></button>
          </div>
          <button className="px-3 py-2 bg-blue-600 text-white rounded text-sm font-medium">Apply Pattern</button>
        </div>
      </div>
    </div>
  );
};

// Helper components
const Plus = ({ size, className }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <line x1="12" y1="5" x2="12" y2="19"></line>
    <line x1="5" y1="12" x2="19" y2="12"></line>
  </svg>
);

const Rewind = ({ size, className }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <polygon points="11 19 2 12 11 5 11 19"></polygon>
    <polygon points="22 19 13 12 22 5 22 19"></polygon>
  </svg>
);

export default App;