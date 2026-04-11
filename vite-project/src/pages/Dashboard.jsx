import React, { useState, useEffect } from "react";
import { Search, MoreVertical, Bed, CalendarCheck, Users, TrendingUp } from "lucide-react";
import { motion } from "framer-motion";
import { api } from "../utils/api";

export default function Dashboard() {
  const [searchTerm, setSearchTerm] = useState("");

  const [bookings, setBookings] = useState([]);
  const [hotels, setHotels] = useState([]);
  const [statsData, setStatsData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [bookingsData, hotelsData, adminStats] = await Promise.all([
          api.getBookings(),
          api.getHotels(),
          api.getAdminStats()
        ]);
        setBookings(Array.isArray(bookingsData) ? bookingsData : []);
        setHotels(Array.isArray(hotelsData) ? hotelsData : []);
        setStatsData(adminStats);
      } catch (error) {
        console.error("Failed to fetch dashboard data:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const filteredBookings = bookings.filter((b) => {
    const guestName = b.user?.name || "Unknown Guest";
    const hotelName = b.hotel?.name || "Unknown Hotel";
    return guestName.toLowerCase().includes(searchTerm.toLowerCase()) ||
           hotelName.toLowerCase().includes(searchTerm.toLowerCase());
  });

  const stats = [
    { 
      label: "Total Properties", 
      value: statsData?.totalHotels || 0, 
      change: "Active across all regions", 
      icon: <Bed size={20} /> 
    },
    { 
      label: "Total Bookings", 
      value: statsData?.totalBookings || 0, 
      change: "Cumulative stay volume", 
      icon: <CalendarCheck size={20} /> 
    },
    { 
      label: "Total Revenue", 
      value: `₹${(statsData?.totalRevenue || 0).toLocaleString()}`, 
      change: "Net earnings from stays", 
      icon: <TrendingUp size={20} /> 
    },
    { 
      label: "Cancelled Stays", 
      value: statsData?.cancelledBookings || 0, 
      change: "Lost booking volume", 
      icon: <Users size={20} /> 
    },
  ];

  const getStatusColor = (status) => {
    if (!status) return 'var(--text-secondary)';
    switch (status.toLowerCase()) {
      case 'upcoming':
      case 'confirmed': return '#10b981';
      case 'completed': return '#3b82f6';
      case 'cancelled': return '#ef4444';
      default: return 'var(--text-secondary)';
    }
  };

  if (loading) {
    return (
      <div style={{ display: "flex", justifyContent: "center", alignItems: "center", height: "100%", padding: "100px" }}>
        <p style={{ fontSize: "18px", color: "var(--text-secondary)" }}>Loading Dashboard Data...</p>
      </div>
    );
  }

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
                <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "13px", textTransform: "uppercase", letterSpacing: "0.5px" }}>Hotel / Property</th>
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
                    key={booking._id} 
                    style={{ borderBottom: "1px solid var(--border)", transition: "all 0.2s" }}
                    onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                    onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                  >
                    <td style={{ padding: "20px 32px" }}>
                        <div style={{ fontWeight: "700", color: "var(--text-primary)" }}>{booking.user?.name || "Guest"}</div>
                        <div style={{ fontSize: "12px", color: "var(--text-secondary)", marginTop: "2px" }}>{booking._id.slice(-8).toUpperCase()}</div>
                    </td>
                    <td style={{ padding: "20px 32px", color: "var(--text-secondary)", fontWeight: "500" }}>{booking.hotel?.name || "N/A"}</td>
                    <td style={{ padding: "20px 32px", color: "var(--text-primary)", fontWeight: "500" }}>{booking.checkIn ? new Date(booking.checkIn).toLocaleDateString() : "N/A"}</td>
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
                        {booking.status || "Unknown"}
                      </span>
                    </td>
                    <td style={{ padding: "20px 32px", fontWeight: "700", color: "var(--text-primary)" }}>₹{Number(booking.totalPrice || 0).toLocaleString()}</td>
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
            <p style={{ fontSize: "14px", color: "var(--text-secondary)" }}>Showing {filteredBookings.length} of {bookings.length} bookings</p>
            <div style={{ display: "flex", gap: "8px" }}>
                <button style={{ padding: "8px 16px", background: "white", border: "1px solid var(--border)", fontSize: "14px", borderRadius: "8px" }}>Previous</button>
                <button style={{ padding: "8px 16px", background: "white", border: "1px solid var(--border)", fontSize: "14px", borderRadius: "8px" }}>Next</button>
            </div>
        </div>
      </motion.div>
    </div>
  );
}