import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import { Hotel, Mail, Lock, User, ArrowRight } from "lucide-react";

export default function Login() {
  const [isLogin, setIsLogin] = useState(true);
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    // In a real app, this would perform authentication
    // For now, we'll just redirect to the dashboard
    navigate("/");
  };

  return (
    <div className="flex-center" style={{ minHeight: "100vh", padding: "20px" }}>
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="glass-card"
        style={{ width: "100%", maxWidth: "420px", padding: "40px" }}
      >
        <div style={{ textAlign: "center", marginBottom: "32px" }}>
          <div className="flex-center" style={{ marginBottom: "12px", gap: "10px" }}>
            <Hotel size={32} color="#3b82f6" />
            <h1 style={{ fontSize: "28px", fontWeight: "700" }}>Pie Admin</h1>
          </div>
          <p style={{ color: "var(--text-secondary)", fontSize: "14px" }}>
            {isLogin ? "Welcome back! Please login to continue." : "Create a new account to get started."}
          </p>
        </div>

        <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "20px" }}>
          {!isLogin && (
            <div style={{ position: "relative" }}>
              <User 
                size={18} 
                style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
              />
              <input 
                type="text" 
                placeholder="Full Name" 
                style={{ width: "100%", paddingLeft: "44px" }} 
                required
              />
            </div>
          )}

          <div style={{ position: "relative" }}>
            <Mail 
              size={18} 
              style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
            />
            <input 
              type="email" 
              placeholder="Email address" 
              style={{ width: "100%", paddingLeft: "44px" }} 
              required
            />
          </div>

          <div style={{ position: "relative" }}>
            <Lock 
              size={18} 
              style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
            />
            <input 
              type="password" 
              placeholder="Password" 
              style={{ width: "100%", paddingLeft: "44px" }} 
              required
            />
          </div>

          <button 
            type="submit"
            className="flex-center"
            style={{ 
              background: "var(--accent)", 
              color: "white", 
              border: "none", 
              padding: "14px", 
              fontSize: "16px", 
              fontWeight: "600",
              marginTop: "8px",
              gap: "8px"
            }}
          >
            {isLogin ? "Login Now" : "Create Account"}
            <ArrowRight size={20} />
          </button>
        </form>

        <div style={{ textAlign: "center", marginTop: "24px" }}>
          <p style={{ color: "var(--text-secondary)", fontSize: "14px" }}>
            {isLogin ? "Don't have an account?" : "Already have an account?"}{" "}
            <span 
              onClick={() => setIsLogin(!isLogin)}
              style={{ color: "var(--accent)", cursor: "pointer", fontWeight: "500" }}
            >
              {isLogin ? "Sign up" : "Log in"}
            </span>
          </p>
        </div>
      </motion.div>
    </div>
  );
}