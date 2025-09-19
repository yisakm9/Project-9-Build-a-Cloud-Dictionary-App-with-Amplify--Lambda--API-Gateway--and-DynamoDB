import React, { useState } from 'react';
import './App.css';

// IMPORTANT: This URL has been updated to your latest Terraform output.
const API_INVOKE_URL = 'https://j7ozjpk3ej.execute-api.us-east-1.amazonaws.com/v1';

function App() {
  const [term, setTerm] = useState('');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSearch = async () => {
    if (!term) {
      setError('Please enter a term to search.');
      return;
    }
    setLoading(true);
    setError('');
    setResult(null);

    try {
      // Use the correct URL and the term from the input
      const response = await fetch(`${API_INVOKE_URL}/definition/${term}`);
      
      if (response.status === 404) {
        throw new Error(`The term "${term}" was not found.`);
      }
      
      if (!response.ok) {
        throw new Error('An error occurred while fetching the data.');
      }

      const data = await response.json();
      setResult(data);

    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Cloud Dictionary</h1>
        <div className="search-container">
          <input
            type="text"
            value={term}
            onChange={(e) => setTerm(e.target.value)}
            placeholder="Enter a cloud term (e.g., S3)"
            onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
          />
          <button onClick={handleSearch} disabled={loading}>
            {loading ? 'Searching...' : 'Search'}
          </button>
        </div>
        <div className="result-container">
          {error && <p className="error">{error}</p>}
          {result && (
            <div className="result-card">
              <h2>{result.term}</h2>
              <p>{result.definition}</p>
            </div>
          )}
        </div>
      </header>
    </div>
  );
}

export default App;