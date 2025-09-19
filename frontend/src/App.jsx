import React, { useState } from 'react';
import { FiSearch } from 'react-icons/fi'; // Import the search icon
import './App.css';

const API_INVOKE_URL = import.meta.env.VITE_API_URL;

function App() {
  const [term, setTerm] = useState('');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSearch = async () => {
    if (!term) return; // Don't search if the input is empty
    setLoading(true);
    setError('');
    setResult(null);

    if (!API_INVOKE_URL) {
        setError('Error: API URL is not configured.');
        setLoading(false);
        return;
    }

    try {
      const response = await fetch(`${API_INVOKE_URL}/definition/${term}`);
      if (!response.ok) {
        const errorData = await response.json().catch(() => ({ message: `The term "${term}" was not found.` }));
        throw new Error(errorData.message);
      }
      const data = await response.json();
      setResult(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const renderResult = () => {
    if (loading) {
      return <div className="spinner"></div>;
    }
    if (error) {
      return <p className="error-message">{error}</p>;
    }
    if (result) {
      return (
        <div className="result-card">
          <h2>{result.term}</h2>
          <p>{result.definition}</p>
        </div>
      );
    }
    return <p className="empty-state">Enter a term to get started.</p>;
  };

  return (
    <div className="container">
      <div className="card">
        <h1 className="title">Cloud Dictionary</h1>
        <div className="search-form">
          <input
            type="text"
            className="search-input"
            value={term}
            onChange={(e) => setTerm(e.target.value)}
            placeholder="Enter a cloud term (e.g., EC2, S3)"
            onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
          />
          <button className="search-button" onClick={handleSearch} disabled={loading}>
            <FiSearch />
            <span>Search</span>
          </button>
        </div>
        <div className="result-area">
          {renderResult()}
        </div>
      </div>
    </div>
  );
}

export default App;