import React from "react";
import { AlertTriangle, RefreshCcw, Home } from "lucide-react";

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error("ErrorBoundary caught an error", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div style={{ 
          height: "100vh", 
          display: "flex", 
          alignItems: "center", 
          justifyContent: "center", 
          backgroundColor: "#f8fafc",
          padding: "20px"
        }}>
          <div style={{ 
            maxWidth: "500px", 
            width: "100%", 
            backgroundColor: "white", 
            padding: "40px", 
            borderRadius: "24px", 
            boxShadow: "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)",
            textAlign: "center"
          }}>
            <div style={{ 
              width: "64px", 
              height: "64px", 
              backgroundColor: "#fee2e2", 
              borderRadius: "50%", 
              display: "flex", 
              alignItems: "center", 
              justifyContent: "center", 
              margin: "0 auto 24px" 
            }}>
              <AlertTriangle size={32} color="#ef4444" />
            </div>
            
            <h1 style={{ fontSize: "24px", fontWeight: "800", color: "#1e293b", marginBottom: "12px" }}>
              Something went wrong
            </h1>
            <p style={{ color: "#64748b", lineHeight: "1.6", marginBottom: "32px" }}>
              We encountered an unexpected error while loading this page. This usually happens due to missing data or a temporary connection issue.
            </p>

            <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
              <button 
                onClick={() => window.location.reload()}
                style={{ 
                  width: "100%", 
                  padding: "12px", 
                  backgroundColor: "#3b82f6", 
                  color: "white", 
                  border: "none", 
                  borderRadius: "12px", 
                  fontWeight: "700", 
                  display: "flex", 
                  alignItems: "center", 
                  justifyContent: "center", 
                  gap: "8px",
                  cursor: "pointer",
                  boxShadow: "0 4px 6px -1px rgba(59, 130, 246, 0.3)"
                }}
              >
                <RefreshCcw size={18} />
                Reload Application
              </button>
              
              <button 
                onClick={() => window.location.href = "/"}
                style={{ 
                  width: "100%", 
                  padding: "12px", 
                  backgroundColor: "white", 
                  color: "#475569", 
                  border: "1px solid #e2e8f0", 
                  borderRadius: "12px", 
                  fontWeight: "700", 
                  display: "flex", 
                  alignItems: "center", 
                  justifyContent: "center", 
                  gap: "8px",
                  cursor: "pointer"
                }}
              >
                <Home size={18} />
                Back to Dashboard
              </button>
            </div>

            {process.env.NODE_ENV === 'development' && (
              <details style={{ marginTop: "32px", textAlign: "left", fontSize: "12px", color: "#94a3b8" }}>
                <summary style={{ cursor: "pointer", fontWeight: "600", marginBottom: "8px" }}>Error Details</summary>
                <pre style={{ 
                  padding: "12px", 
                  backgroundColor: "#f1f5f9", 
                  borderRadius: "8px", 
                  overflow: "auto",
                  maxHeight: "150px"
                }}>
                  {this.state.error && this.state.error.toString()}
                </pre>
              </details>
            )}
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
