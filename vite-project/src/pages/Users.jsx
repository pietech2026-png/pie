import React, { useState, useEffect } from "react";
import { Search, MoreVertical, User, Phone, Mail, Shield, X, Plus, Loader2, Key } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { api } from "../utils/api";

export default function Users() {
  const [searchTerm, setSearchTerm] = useState("");
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [issubmitting, setIsSubmitting] = useState(false);

  const initialFormState = {
    name: "",
    email: "",
    phone: "",
    password: "",
    role: "Staff"
  };
  const [formData, setFormData] = useState(initialFormState);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const data = await api.getUsers();
      setUsers(Array.isArray(data) ? data : []);
    } catch (error) {
      console.error("Failed to fetch users:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleAddUser = async (e) => {
    e.preventDefault();
    try {
      setIsSubmitting(true);
      await api.registerUser(formData);
      
      // Briefly show success before modal closes
      setShowAddModal(false);
      setFormData(initialFormState);
      
      // Small delay to ensure DB persistence and provide nice UI feel
      setTimeout(async () => {
        await fetchUsers();
      }, 500);
      
    } catch (error) {
      console.error("User registration failed:", error);
      alert("Error adding user: " + error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const filteredUsers = users.filter((u) =>
    (u.name || "").toLowerCase().includes(searchTerm.toLowerCase()) ||
    (u.phone || "").includes(searchTerm) ||
    (u.email || "").toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px", display: "flex", justifyContent: "space-between", alignItems: "flex-end" }}>
        <div>
          <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>User Management</h1>
          <p style={{ color: "var(--text-secondary)" }}>Manage administrator and staff accounts</p>
        </div>
        <button 
          onClick={() => setShowAddModal(true)}
          style={{ 
            background: "var(--accent)", 
            color: "white", 
            border: "none", 
            padding: "12px 24px", 
            fontWeight: "700",
            display: "flex",
            alignItems: "center",
            gap: "8px",
            boxShadow: "0 4px 12px var(--accent-light)"
          }}
        >
          <Plus size={18} />
          Add New User
        </button>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="glass-card"
        style={{ overflow: "hidden", background: "white", border: "1px solid var(--border)" }}
      >
        <div style={{ 
          padding: "24px", 
          display: "flex", 
          justifyContent: "space-between", 
          alignItems: "center",
          borderBottom: "1px solid var(--border)"
        }}>
          <h2 style={{ fontSize: "20px", fontWeight: "700" }}>All Users</h2>
          <div style={{ position: "relative", width: "320px" }}>
            <Search 
              size={18} 
              style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
            />
            <input 
              type="text" 
              placeholder="Search by name, phone or email..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{ width: "100%", paddingLeft: "44px", backgroundColor: "var(--bg-search)" }} 
            />
          </div>
        </div>

        <div style={{ overflowX: "auto" }}>
          {loading ? (
            <div style={{ padding: "100px", textAlign: "center", color: "var(--text-secondary)" }}>
              <Loader2 size={40} className="animate-spin" style={{ margin: "0 auto 16px" }} />
              <p>Fetching user accounts...</p>
            </div>
          ) : (
            <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
              <thead>
                <tr style={{ background: "var(--bg-search)" }}>
                  <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase" }}>Name</th>
                  <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase" }}>Phone Number</th>
                  <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase" }}>Email</th>
                  <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase" }}>Role</th>
                  <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase" }}>Status</th>
                  <th style={{ padding: "16px 24px", textAlign: "right" }}></th>
                </tr>
              </thead>
              <tbody>
                {filteredUsers.length > 0 ? filteredUsers.map((user) => (
                  <tr 
                    key={user._id} 
                    style={{ borderBottom: "1px solid var(--border)", transition: "all 0.2s" }}
                    onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                    onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                  >
                    <td style={{ padding: "16px 24px", fontWeight: "700", color: "var(--text-primary)" }}>{user.name}</td>
                    <td style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500" }}>
                      <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                        <Phone size={14} />
                        {user.phone}
                      </div>
                    </td>
                    <td style={{ padding: "16px 24px", color: "var(--text-primary)" }}>{user.email}</td>
                    <td style={{ padding: "16px 24px" }}>
                      <div style={{ display: "flex", alignItems: "center", gap: "6px", color: "var(--accent)", fontWeight: "700" }}>
                        <Shield size={14} />
                        {user.role || "Staff"}
                      </div>
                    </td>
                    <td style={{ padding: "16px 24px" }}>
                      <span style={{ 
                        padding: "6px 12px", 
                        borderRadius: "10px", 
                        fontSize: "12px", 
                        fontWeight: "700",
                        backgroundColor: "#10b98115",
                        color: "#10b981",
                      }}>
                        Active
                      </span>
                    </td>
                    <td style={{ padding: "16px 24px", textAlign: "right" }}>
                      <button style={{ background: "transparent", border: "none", color: "var(--text-secondary)" }}>
                        <MoreVertical size={18} />
                      </button>
                    </td>
                  </tr>
                )) : (
                  <tr>
                    <td colSpan="6" style={{ padding: "60px", textAlign: "center", color: "var(--text-secondary)" }}>
                      No users found.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          )}
        </div>
      </motion.div>

      {/* Add User Modal */}
      <AnimatePresence>
        {showAddModal && (
          <div style={{ position: "fixed", inset: 0, zIndex: 1000, display: "flex", alignItems: "center", justifyContent: "center", padding: "20px" }}>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowAddModal(false)}
              style={{ position: "absolute", inset: 0, background: "rgba(15, 23, 42, 0.4)", backdropFilter: "blur(8px)" }}
            />
            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 20 }}
              style={{ position: "relative", width: "100%", maxWidth: "500px", background: "white", padding: "40px", borderRadius: "24px", boxShadow: "0 20px 25px -5px rgba(0,0,0,0.1)" }}
            >
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "32px" }}>
                <h2 style={{ fontSize: "24px", fontWeight: "800", color: "var(--text-primary)" }}>New User Account</h2>
                <button onClick={() => setShowAddModal(false)} style={{ background: "transparent", border: "none", color: "var(--text-secondary)", cursor: "pointer" }}>
                  <X size={24} />
                </button>
              </div>

              <form onSubmit={handleAddUser} style={{ display: "flex", flexDirection: "column", gap: "24px" }}>
                <div>
                  <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Full Name</p>
                  <div style={{ position: "relative" }}>
                    <User size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                    <input
                      type="text"
                      placeholder="e.g. Rhythm Shesha"
                      style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      required
                    />
                  </div>
                </div>

                <div>
                  <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Phone Number</p>
                  <div style={{ position: "relative" }}>
                    <Phone size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                    <input
                      type="text"
                      placeholder="e.g. +91 98765 43210"
                      style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      required
                    />
                  </div>
                </div>

                <div>
                  <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Email Address</p>
                  <div style={{ position: "relative" }}>
                    <Mail size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                    <input
                      type="email"
                      placeholder="e.g. rhythm@example.com"
                      style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                      value={formData.email}
                      onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                      required
                    />
                  </div>
                </div>

                <div>
                  <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Password</p>
                  <div style={{ position: "relative" }}>
                    <Key size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                    <input
                      type="password"
                      placeholder="Min 6 characters"
                      style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                      value={formData.password}
                      onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                      required
                      minLength={6}
                    />
                  </div>
                </div>

                <div>
                  <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>User Role</p>
                  <select
                    style={{ width: "100%", height: "52px", padding: "0 20px" }}
                    value={formData.role}
                    onChange={(e) => setFormData({ ...formData, role: e.target.value })}
                  >
                    <option value="Admin">Admin</option>
                    <option value="Manager">Manager</option>
                    <option value="Receptionist">Receptionist</option>
                    <option value="Staff">Staff</option>
                  </select>
                </div>

                <button
                  type="submit"
                  disabled={issubmitting}
                  style={{
                    background: "var(--accent)",
                    color: "white",
                    border: "none",
                    padding: "16px",
                    fontWeight: "800",
                    fontSize: "16px",
                    borderRadius: "16px",
                    marginTop: "8px",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    gap: "10px",
                    boxShadow: "0 8px 24px var(--accent-light)",
                    opacity: issubmitting ? 0.7 : 1,
                    cursor: issubmitting ? "not-allowed" : "pointer"
                  }}
                >
                  {issubmitting ? <Loader2 size={20} className="animate-spin" /> : <Plus size={20} />}
                  {issubmitting ? "Creating..." : "Confirm and Create"}
                </button>
              </form>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
