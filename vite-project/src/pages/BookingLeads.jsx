import React, { useState, useEffect } from "react";
import { Search, MoreVertical, Calendar, User, MapPin, Clock } from "lucide-react";
import { motion } from "framer-motion";
import { api } from "../utils/api";

export default function BookingLeads() {
  const [searchTerm, setSearchTerm] = useState("");

  const [leads, setLeads] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchLeads = async () => {
      try {
        const data = await api.getLeads();
        setLeads(data);
      } catch (error) {
        console.error("Failed to fetch leads:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchLeads();
    
    // 🔥 Auto-refresh leads every 15 seconds
    const interval = setInterval(fetchLeads, 15000);
    return () => clearInterval(interval);
  }, []);

  const filteredLeads = leads.filter((l) =>
    (l.guestName || "").toLowerCase().includes(searchTerm.toLowerCase()) ||
    (l.location || "").toLowerCase().includes(searchTerm.toLowerCase()) ||
    (l.phone || "").toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleStatusUpdate = async (id, newStatus) => {
    try {
      await api.updateLeadStatus(id, newStatus);
      setLeads((prev) => 
        prev.map(l => l._id === id ? { ...l, status: newStatus } : l)
      );
    } catch (error) {
      alert("Failed to update lead status: " + error.message);
    }
  };

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px" }}>
        <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>Booking Leads</h1>
        <p style={{ color: "var(--text-secondary)" }}>Review and manage incoming booking inquiries</p>
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
          <h2 style={{ fontSize: "20px", fontWeight: "600" }}>All Leads</h2>
          <div style={{ position: "relative", width: "300px" }}>
            <Search 
              size={18} 
              style={{ position: "absolute", left: "12px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
            />
            <input 
              type="text" 
              placeholder="Search by name or location..." 
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
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Guest Name</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Mobile Number</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Location</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Check-in</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Check-out</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Guests/Rooms</th>
                <th style={{ padding: "16px 24px", textAlign: "right" }}></th>
              </tr>
            </thead>
            <tbody>
               {filteredLeads.map((lead) => (
                <tr 
                  key={lead._id} 
                  style={{ borderBottom: "1px solid var(--border)", transition: "background 0.2s" }}
                  onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                  onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                >
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                      <User size={16} color="var(--accent)" />
                      <span style={{ fontWeight: "600" }}>{lead.guestName}</span>
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <span style={{ fontSize: "13px", color: "var(--text-primary)" }}>{lead.phone || "N/A"}</span>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                      <MapPin size={14} color="var(--text-secondary)" />
                      {lead.location || "N/A"}
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <span style={{ color: "#10b981", fontWeight: "500" }}>
                      {lead.preferredDates?.checkIn ? new Date(lead.preferredDates.checkIn).toLocaleDateString() : "TBD"}
                    </span>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <span style={{ color: "#ef4444", fontWeight: "500" }}>
                      {lead.preferredDates?.checkOut ? new Date(lead.preferredDates.checkOut).toLocaleDateString() : "TBD"}
                    </span>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", flexDirection: "column", gap: "2px" }}>
                      <span style={{ fontWeight: "600" }}>{lead.guests} Guests</span>
                      <span style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{lead.roomPreference}</span>
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px", textAlign: "right" }}>
                    <div style={{ display: "flex", gap: "8px", justifyContent: "flex-end" }}>
                      <select 
                        value={lead.status || "New"}
                        onChange={(e) => handleStatusUpdate(lead._id, e.target.value)}
                        style={{ 
                          padding: "6px 12px", 
                          borderRadius: "8px", 
                          fontSize: "12px", 
                          background: 
                            lead.status === "Converted" ? "#10b98115" : 
                            lead.status === "Lost" ? "#ef444415" : 
                            lead.status === "New" ? "#3b82f615" : "var(--bg-search)",
                          color: 
                            lead.status === "Converted" ? "#10b981" : 
                            lead.status === "Lost" ? "#ef4444" : 
                            lead.status === "New" ? "#3b82f6" : "var(--text-primary)",
                          border: "1px solid var(--border)",
                          fontWeight: "700"
                        }}
                      >
                        <option value="New">New</option>
                        <option value="Contacted">Contacted</option>
                        <option value="Followed Up">Followed Up</option>
                        <option value="Converted">Converted</option>
                        <option value="Lost">Lost</option>
                      </select>
                      <button style={{ background: "transparent", border: "none", color: "var(--text-secondary)" }}>
                        <MoreVertical size={18} />
                      </button>
                    </div>
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
