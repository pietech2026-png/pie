import React, { useState } from "react";
import { Search, MoreVertical, Bed, CalendarCheck, Users, TrendingUp } from "lucide-react";
import { motion } from "framer-motion";

export default function Dashboard() {
  const [searchTerm, setSearchTerm] = useState("");

  const bookings = [
    { id: "GO-109283", guest: "Arjun Singh", roomType: "Premium AC Room", checkIn: "2026-03-30", status: "Confirmed", price: "₹4,250" },
    { id: "GO-109284", guest: "Sneha Reddy", roomType: "Deluxe Family Suite", checkIn: "2026-03-31", status: "Pending", price: "₹7,899" },
    { id: "GO-109285", guest: "Vikram Malhotra", roomType: "Standard Non-AC", checkIn: "2026-03-29", status: "Checked-in", price: "₹2,450" },
    { id: "GO-109286", guest: "Ananya Iyer", roomType: "Luxury Villa", checkIn: "2026-04-02", status: "Confirmed", price: "₹15,400" },
  ];

  const filteredBookings = bookings.filter((b) =>
    b.guest.toLowerCase().includes(searchTerm.toLowerCase()) ||
    b.roomType.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const stats = [
    { label: "Available Rooms", value: "24 / 40", change: "8 rooms cleaning", icon: <Bed size={20} /> },
    { label: "Active Bookings", value: "12", change: "+2 from yesterday", icon: <CalendarCheck size={20} /> },
    { label: "Check-ins Today", value: "5", change: "3 arrived", icon: <Users size={20} /> },
    { label: "Occupancy Rate", value: "72%", change: "+5.4% this week", icon: <TrendingUp size={20} /> },
  ];

  const getStatusColor = (status) => {
    switch (status.toLowerCase()) {
      case 'confirmed': return '#10b981';
      case 'pending': return '#f59e0b';
      case 'checked-in': return '#3b82f6';
      default: return 'var(--text-secondary)';
    }
  };

  return (
    <div style={{ maxWidth: "1400px", margin: "0 auto" }}>
      {/* Header Section */}
      <div style={{ marginBottom: "40px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <div>
          <h1 style={{ fontSize: "32px", fontWeight: "800", color: "var(--text-primary)", letterSpacing: "-1px", marginBottom: "8px" }}>
            Hotel Overview
          </h1>
          <p style={{ color: "var(--text-secondary)", fontSize: "16px" }}>
            Experience real-time insights into your daily operations.
          </p>
        </div>
        <div style={{ display: "flex", gap: "12px" }}>
            <button style={{ padding: "10px 20px", background: "white", border: "1px solid var(--border)", color: "var(--text-primary)", fontSize: "14px" }}>
                Export Report
            </button>
            <button style={{ padding: "10px 20px", background: "var(--accent)", border: "none", color: "white", fontSize: "14px", boxShadow: "0 4px 12px var(--accent-light)" }}>
                New Booking
            </button>
        </div>
      </div>

      {/* Stats Section */}
      <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: "24px", marginBottom: "48px" }}>
        {stats.map((stat, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.1, duration: 0.4 }}
            className="glass-card"
            style={{ padding: "28px", display: "flex", flexDirection: "column", gap: "16px" }}
          >
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
              <div style={{ 
                padding: "10px", 
                borderRadius: "12px", 
                background: "var(--accent-light)", 
                color: "var(--accent)",
                display: "flex"
              }}>
                {stat.icon}
              </div>
              <span style={{ 
                fontSize: "12px", 
                fontWeight: "700", 
                color: stat.change.includes("+") ? "#10b981" : "var(--text-secondary)",
                background: stat.change.includes("+") ? "#10b98115" : "var(--bg-search)",
                padding: "4px 8px",
                borderRadius: "6px"
              }}>
                {stat.change}
              </span>
            </div>
            <div>
              <p style={{ fontSize: "14px", fontWeight: "600", color: "var(--text-secondary)", marginBottom: "4px" }}>{stat.label}</p>
              <h3 style={{ fontSize: "28px", fontWeight: "800", color: "var(--text-primary)" }}>{stat.value}</h3>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Recent Bookings Table Section */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
        className="glass-card"
        style={{ border: "1px solid var(--border)", background: "white" }}
      >
        <div style={{ 
          padding: "24px 32px", 
          display: "flex", 
          justifyContent: "space-between", 
          alignItems: "center",
          borderBottom: "1px solid var(--border)"
        }}>
          <div>
            <h2 style={{ fontSize: "20px", fontWeight: "700", color: "var(--text-primary)" }}>Recent Bookings</h2>
            <p style={{ fontSize: "13px", color: "var(--text-secondary)", marginTop: "2px" }}>Showing the latest 10 transactions</p>
          </div>
          
          <div style={{ position: "relative", width: "320px" }}>
            <Search 
              size={18} 
              style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} 
            />
            <input 
              type="text" 
              placeholder="Search guests or rooms..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={{ 
                width: "100%", 
                paddingLeft: "44px", 
                backgroundColor: "var(--bg-search)",
                border: "1px solid var(--border)",
                borderRadius: "12px",
                fontSize: "14px"
              }} 
            />
          </div>
        </div>

        <div style={{ overflowX: "auto" }}>
          <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
            <thead>
              <tr style={{ background: "var(--bg-search)" }}>
                <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Guest</th>
                <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Room Type</th>
                <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Check-in</th>
                <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Status</th>
                <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Price</th>
                <th style={{ padding: "16px 32px", textAlign: "right" }}></th>
              </tr>
            </thead>
            <tbody>
              {filteredBookings.length > 0 ? (
                filteredBookings.map((booking) => (
                  <tr 
                    key={booking.id} 
                    style={{ borderBottom: "1px solid var(--border)", transition: "all 0.2s" }}
                    onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                    onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                  >
                    <td style={{ padding: "20px 32px" }}>
                        <div style={{ fontWeight: "700", color: "var(--text-primary)" }}>{booking.guest}</div>
                        <div style={{ fontSize: "12px", color: "var(--text-secondary)", marginTop: "2px" }}>{booking.id}</div>
                    </td>
                    <td style={{ padding: "20px 32px", color: "var(--text-secondary)", fontWeight: "500" }}>{booking.roomType}</td>
                    <td style={{ padding: "20px 32px", color: "var(--text-primary)", fontWeight: "500" }}>{booking.checkIn}</td>
                    <td style={{ padding: "20px 32px" }}>
                      <span style={{ 
                        padding: "6px 12px", 
                        borderRadius: "10px", 
                        fontSize: "12px", 
                        fontWeight: "700",
                        backgroundColor: `${getStatusColor(booking.status)}15`,
                        color: getStatusColor(booking.status),
                        border: `1px solid ${getStatusColor(booking.status)}30`
                      }}>
                        {booking.status}
                      </span>
                    </td>
                    <td style={{ padding: "20px 32px", fontWeight: "700", color: "var(--text-primary)" }}>{booking.price}</td>
                    <td style={{ padding: "20px 32px", textAlign: "right" }}>
                      <button style={{ background: "var(--bg-search)", border: "none", color: "var(--text-secondary)", padding: "8px", borderRadius: "10px" }}>
                        <MoreVertical size={18} />
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="6" style={{ padding: "60px", textAlign: "center", color: "var(--text-secondary)" }}>
                    <div style={{ fontSize: "16px", fontWeight: "600" }}>No results found</div>
                    <p style={{ fontSize: "14px", marginTop: "4px" }}>Try adjusting your search filters.</p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
        <div style={{ padding: "20px 32px", borderTop: "1px solid var(--border)", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <p style={{ fontSize: "14px", color: "var(--text-secondary)" }}>Showing 4 of 48 bookings</p>
            <div style={{ display: "flex", gap: "8px" }}>
                <button style={{ padding: "8px 16px", background: "white", border: "1px solid var(--border)", fontSize: "14px", borderRadius: "8px" }}>Previous</button>
                <button style={{ padding: "8px 16px", background: "white", border: "1px solid var(--border)", fontSize: "14px", borderRadius: "8px" }}>Next</button>
            </div>
        </div>
      </motion.div>
    </div>
  );
}