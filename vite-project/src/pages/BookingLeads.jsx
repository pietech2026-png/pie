import React, { useState } from "react";
import { Search, MoreVertical, Calendar, User, MapPin, Clock } from "lucide-react";
import { motion } from "framer-motion";

export default function BookingLeads() {
  const [searchTerm, setSearchTerm] = useState("");

  const leads = [
    { id: "L-1001", name: "Rahul Deshmukh", location: "Pune, Maharashtra", checkIn: "2026-04-05", checkOut: "2026-04-08", time: "12:00 PM", guests: 2, rooms: "1x Premium AC" },
    { id: "L-1002", name: "Sneha Kapoor", location: "Gurugram, Haryana", checkIn: "2026-04-10", checkOut: "2026-04-12", time: "02:00 PM", guests: 3, rooms: "1x Family Suite" },
    { id: "L-1003", name: "Amit Verma", location: "Shimla, HP", checkIn: "2026-04-15", checkOut: "2026-04-20", time: "11:00 AM", guests: 1, rooms: "1x Standard Non-AC" },
    { id: "L-1004", name: "Pooja Hegde", location: "Hyderabad, Telangana", checkIn: "2026-04-22", checkOut: "2026-04-25", time: "01:00 PM", guests: 2, rooms: "1x Executive King" },
  ];

  const filteredLeads = leads.filter((l) =>
    l.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    l.location.toLowerCase().includes(searchTerm.toLowerCase())
  );

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
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Location</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Dates</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Time</th>
                <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Guests/Rooms</th>
                <th style={{ padding: "16px 24px", textAlign: "right" }}></th>
              </tr>
            </thead>
            <tbody>
              {filteredLeads.map((lead) => (
                <tr 
                  key={lead.id} 
                  style={{ borderBottom: "1px solid var(--border)", transition: "background 0.2s" }}
                  onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                  onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                >
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                      <User size={16} color="var(--accent)" />
                      <span style={{ fontWeight: "600" }}>{lead.name}</span>
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                      <MapPin size={14} color="var(--text-secondary)" />
                      {lead.location}
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", flexDirection: "column", gap: "4px", fontSize: "13px" }}>
                      <span style={{ color: "#10b981" }}>IN: {lead.checkIn}</span>
                      <span style={{ color: "#ef4444" }}>OUT: {lead.checkOut}</span>
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
                      <Clock size={14} color="var(--text-secondary)" />
                      {lead.time}
                    </div>
                  </td>
                  <td style={{ padding: "16px 24px" }}>
                    <div style={{ display: "flex", flexDirection: "column", gap: "2px" }}>
                      <span style={{ fontWeight: "600" }}>{lead.guests} Guests</span>
                      <span style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{lead.rooms}</span>
                    </div>
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
