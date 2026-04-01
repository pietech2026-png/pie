import React, { useState } from "react";
import { Search, MoreVertical, User, Phone, Mail, Shield } from "lucide-react";
import { motion } from "framer-motion";

export default function Users() {
  const [searchTerm, setSearchTerm] = useState("");

  const users = [
    { id: 1, name: "Arjun Sharma", phone: "+91 98765 43210", email: "arjun@example.com", role: "Manager", status: "Active" },
    { id: 2, name: "Priya Patel", phone: "+91 91234 56789", email: "priya@example.com", role: "Receptionist", status: "Active" },
    { id: 3, name: "Vikram Singh", phone: "+91 88888 77777", email: "vikram@example.com", role: "Admin", status: "Inactive" },
    { id: 4, name: "Ananya Iyer", phone: "+91 77777 66666", email: "ananya@example.com", role: "Staff", status: "Active" },
  ];

  const filteredUsers = users.filter((u) =>
    u.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    u.phone.includes(searchTerm)
  );

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px", display: "flex", justifyContent: "space-between", alignItems: "flex-end" }}>
        <div>
          <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>User Management</h1>
          <p style={{ color: "var(--text-secondary)" }}>Manage administrator and staff accounts</p>
        </div>
        <button style={{ 
          background: "var(--accent)", 
          color: "white", 
          border: "none", 
          padding: "10px 20px", 
          fontWeight: "600",
          display: "flex",
          alignItems: "center",
          gap: "8px"
        }}>
          <User size={18} />
          Add New User
        </button>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="glass-card"
        style={{ overflow: "hidden" }}
      >
        <div style={{ 
          padding: "24px", 
          display: "flex", 
          justifyContent: "space-between", 
          alignItems: "center",
          borderBottom: "1px solid var(--border)"
        }}>
          <h2 style={{ fontSize: "20px", fontWeight: "600" }}>All Users</h2>
          <div style={{ position: "relative", width: "300px" }}>
            <Search 
              size={18} 
              style={{ position: "absolute", left: "12px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
            />
            <input 
              type="text" 
              placeholder="Search by name or phone..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{ width: "100%", paddingLeft: "40px", backgroundColor: "var(--bg-search)" }} 
            />
          </div>
        </div>

        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
            <thead>
              <tr style={{ borderBottom: "1px solid var(--border)" }}>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Name</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Phone Number</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Email</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Role</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Status</th>
                <th style={{ padding: "16px 24px", textAlign: "right" }}></th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((user) => (
                <tr 
                  key={user.id} 
                  style={{ borderBottom: "1px solid var(--border)", transition: "background 0.2s" }}
                  onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                  onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                >
                  <td style={{ padding: "16px 24px", fontWeight: "600" }}>{user.name}</td>
                  <td style={{ padding: "16px 24px", color: "var(--text-secondary)" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                      <Phone size={14} />
                      {user.phone}
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>{user.email}</td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "6px", color: "var(--accent)" }}>
                      <Shield size={14} />
                      {user.role}
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <span style={{ 
                      padding: "4px 10px", 
                      borderRadius: "20px", 
                      fontSize: "12px", 
                      fontWeight: "600",
                      backgroundColor: user.status === "Active" ? "#10b98120" : "#ef444420",
                      color: user.status === "Active" ? "#10b981" : "#ef4444",
                    }}>
                      {user.status}
                    </span>
                  </td>
                  <td style={{ padding: "16px 24px", textAlign: "right" }}>
                    <button style={{ background: "transparent", border: "none", color: "var(--text-secondary)" }}>
                      <MoreVertical size={18} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </motion.div>
    </div>
  );
}
