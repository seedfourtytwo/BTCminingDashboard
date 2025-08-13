import React from 'react';
import './App.css';

function App(): React.JSX.Element {
  return (
    <div className="App">
      <header className="App-header">
        <h1>Solar Bitcoin Mining Calculator</h1>
        <p>Plan and optimize your solar-powered Bitcoin mining operations</p>
        <div className="features">
          <div className="feature">
            <h3>🌞 Solar Power Modeling</h3>
            <p>Calculate solar energy production with location-specific data</p>
          </div>
          <div className="feature">
            <h3>⚡ Mining Equipment</h3>
            <p>Model ASIC miners with realistic degradation over time</p>
          </div>
          <div className="feature">
            <h3>💰 Profitability Analysis</h3>
            <p>Compare different configurations and calculate ROI</p>
          </div>
        </div>
        <div className="status">
          <p>🚧 Development in Progress</p>
          <p>Coming soon: Equipment selection, projections, and advanced analytics</p>
        </div>
      </header>
    </div>
  );
}

export default App;
