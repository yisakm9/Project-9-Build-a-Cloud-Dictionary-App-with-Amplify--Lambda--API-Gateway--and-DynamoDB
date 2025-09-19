import React, { useState } from 'react';
import { FiSearch } from 'react-icons/fi';
import './App.css';

const API_INVOKE_URL = import.meta.env.VITE_API_URL;

function App() {
  const [term, setTerm] = useState('');
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  // --- NEW STATE ---
  // This will track if the user has performed a search yet.
  const [hasSearched, setHasSearched] = useState(false);

  const handleSearch = async () => {
    if (!term) return;
    
    // --- LOGIC UPDATE ---
    // A search is now being performed.
    setHasSearched(true); 
    
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
      
      // --- LOGIC UPDATE ---
      // A 404 is a "not found" state, not a generic error. We will handle it gracefully.
      if (response.status === 404) {
        // We successfully searched but found nothing. By leaving `result` as null,
        // our render logic will know to display the "not found" message.
      } else if (!response.ok) {
        // Handle real errors like 500 Internal Server Error
        const errorData = await response.json().catch(() => ({ message: 'An unexpected server error occurred.' }));
        throw new Error(errorData.message);
      } else {
        // This is the success case
        const data = await response.json();
        setResult(data);
      }
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
    
    // --- LOGIC UPDATE ---
    // If a search has been performed but there is no result and no error,
    // it means the term was not found.
    if (hasSearched) {
      return <p className="empty-state">No definition was found for the term you searched.</p>;
    }

    // This is now ONLY for the initial state, before any search is made.
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