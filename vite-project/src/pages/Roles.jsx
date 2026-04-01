import React, { useState } from "react";
import { ShieldCheck, Eye, Edit3, Trash2, Plus, Info } from "lucide-react";
import { motion } from "framer-motion";

export default function Roles() {
  const [selectedRole, setSelectedRole] = useState(1);

  const roles = [
    { 
      id: 1, 
      name: "Super Admin", 
      description: "Full access to all system features", 
      permissions: ["View Bookings", "Edit Rooms", "Manage Users", "View Revenue", "Manage Hotels", "Edit Permissions"] 
    },
    { 
      id: 2, 
      name: "Hotel Manager", 
      description: "Manage specific hotel property operations", 
      permissions: ["View Bookings", "Edit Rooms", "View Revenue", "Manage Staff"] 
    },
    { 
      id: 3, 
      name: "Receptionist", 
      description: "Handle bookings and guest check-ins", 
      permissions: ["View Bookings", "Create Bookings", "Guest Check-in"] 
    },
  ];

  const allPermissions = [
    "View Bookings", "Create Bookings", "Edit Bookings", "Delete Bookings",
    "View Revenue", "Manage Users", "Edit Rooms", "Manage Hotels", "Guest Check-in", "Edit Permissions"
  ];

  const currentRole = roles.find(r => r.id === selectedRole);

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px", display: "flex", justifyContent: "space-between", alignItems: "flex-end" }}>
        <div>
          <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>Roles & Permissions</h1>
          <p style={{ color: "var(--text-secondary)" }}>Control system access levels for your team</p>
        </div>
        <button style={{ 
          background: "var(--accent)", 
          color: "white", 
          border: "none", 
          padding: "10px 24px", 
          fontWeight: "600",
          display: "flex",
          alignItems: "center",
          gap: "8px"
        }}>
          <Plus size={18} />
          Create New Role
        </button>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "24px" }}>
        {/* Roles List */}
        <div className="glass-card" style={{ padding: "0", overflow: "hidden" }}>
          <div style={{ padding: "20px", borderBottom: "1px solid var(--border)" }}>
            <h2 style={{ fontSize: "16px", fontWeight: "600" }}>System Roles</h2>
          </div>
          {roles.map((role) => (
            <div
              key={role.id}
              onClick={() => setSelectedRole(role.id)}
              style={{
                padding: "20px",
                cursor: "pointer",
                borderBottom: "1px solid var(--border)",
                backgroundColor: selectedRole === role.id ? "var(--row-hover)" : "transparent",
                borderLeft: selectedRole === role.id ? "4px solid var(--accent)" : "4px solid transparent",
                transition: "all 0.2s"
              }}
            >
              <h3 style={{ fontSize: "16px", fontWeight: "700", color: selectedRole === role.id ? "var(--accent)" : "var(--text-primary)" }}>{role.name}</h3>
              <p style={{ fontSize: "12px", color: "var(--text-secondary)", marginTop: "4px" }}>{role.description}</p>
            </div>
          ))}
        </div>

        {/* Permissions Management */}
        <motion.div 
          key={selectedRole}
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          className="glass-card" 
          style={{ padding: "32px" }}
        >
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "32px" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
              <div style={{ background: "var(--accent)", padding: "8px", borderRadius: "10px", color: "white" }}>
                <ShieldCheck size={20} />
              </div>
              <div>
                <h2 style={{ fontSize: "20px", fontWeight: "600" }}>{currentRole.name} Permissions</h2>
                <p style={{ fontSize: "14px", color: "var(--text-secondary)" }}>Configure specific access for this role</p>
              </div>
            </div>
          </div>

          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
            {allPermissions.map((perm) => (
              <div 
                key={perm} 
                style={{ 
                  display: "flex", 
                  alignItems: "center", 
                  justifyContent: "space-between",
                  padding: "16px", 
                  borderRadius: "12px",
                  background: "var(--bg-search)",
                  border: "1px solid var(--border)"
                }}
              >
                <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
                  <div style={{ 
                    width: "20px", 
                    height: "20px", 
                    borderRadius: "6px", 
                    border: "2px solid var(--accent)",
                    background: currentRole.permissions.includes(perm) ? "var(--accent)" : "transparent",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    cursor: "pointer"
                  }}>
                    {currentRole.permissions.includes(perm) && <div style={{ width: "8px", height: "8px", borderRadius: "2px", backgroundColor: "white" }} />}
                  </div>
                  <span style={{ fontSize: "15px", color: currentRole.permissions.includes(perm) ? "var(--text-primary)" : "var(--text-secondary)" }}>{perm}</span>
                </div>
                {/* Visual indicator for different permission types */}
                {perm.startsWith("Delete") ? <Trash2 size={16} color="#ef4444" /> : perm.startsWith("Edit") ? <Edit3 size={16} color="var(--accent)" /> : <Eye size={16} color="var(--text-secondary)" />}
              </div>
            ))}
          </div>

          <div style={{ marginTop: "40px", display: "flex", gap: "12px", justifyContent: "flex-end" }}>
            <button style={{ background: "transparent", border: "1px solid var(--border)", color: "var(--text-primary)", padding: "10px 24px" }}>Discard</button>
            <button style={{ background: "var(--accent)", border: "none", color: "white", padding: "10px 24px", fontWeight: "600" }}>Save Permissions</button>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
