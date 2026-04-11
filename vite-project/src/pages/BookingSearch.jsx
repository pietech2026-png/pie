import React, { useState, useEffect } from "react";
import { Search, Phone, User, Calendar, MapPin, MoreVertical, Loader2 } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { api } from "../utils/api";

export default function BookingSearch() {
  const [phone, setPhone] = useState("");
  const [results, setResults] = useState([]);
  const [isSearched, setIsSearched] = useState(false);
  const [isSearching, setIsSearching] = useState(false);

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!phone.trim()) return;
    
    setIsSearching(true);
    try {
      const allBookings = await api.getBookings();
      const found = allBookings.filter(b => 
        b.user?.phone?.includes(phone) || 
        (b.phone && b.phone.includes(phone))
      );
      setResults(found);
      setIsSearched(true);
    } catch (error) {
      console.error("Search error:", error);
      alert("Error searching bookings");
    } finally {
      setIsSearching(false);
    }
  };

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

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px" }}>
        <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>Booking Search</h1>
        <p style={{ color: "var(--text-secondary)" }}>Find all historical and current bookings by customer phone number</p>
      </div>

      <motion.div
        initial={{ opacity: 0, scale: 0.98 }}
        animate={{ opacity: 1, scale: 1 }}
        className="glass-card"
        style={{ padding: "40px", marginBottom: "32px", textAlign: "center" }}
      >
        <h2 style={{ fontSize: "20px", fontWeight: "600", marginBottom: "24px" }}>Search by Guest Phone</h2>
        <form onSubmit={handleSearch} style={{ display: "flex", gap: "12px", justifyContent: "center", maxWidth: "600px", margin: "0 auto" }}>
          <div style={{ position: "relative", flex: 1 }}>
            <Phone size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
            <input 
              type="text" 
              placeholder="Enter mobile number..." 
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              style={{ width: "100%", paddingLeft: "44px" }} 
            />
          </div>
          <button 
            type="submit"
            disabled={isSearching}
            style={{ 
              background: "var(--accent)", 
              color: "white", 
              border: "none", 
              padding: "12px 32px", 
              fontWeight: "600",
              display: "flex",
              alignItems: "center",
              gap: "8px",
              opacity: isSearching ? 0.7 : 1,
              cursor: isSearching ? "not-allowed" : "pointer"
            }}
          >
            {isSearching ? <Loader2 size={18} className="animate-spin" /> : <Search size={18} />}
            {isSearching ? "Searching..." : "Search"}
          </button>
        </form>
      </motion.div>

      <AnimatePresence>
        {isSearched && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="glass-card"
            style={{ overflow: "hidden" }}
          >
            <div style={{ padding: "24px", borderBottom: "1px solid var(--border)" }}>
              <h3 style={{ fontSize: "18px", fontWeight: "600" }}>Search Results ({results.length})</h3>
            </div>

            {results.length > 0 ? (
              <div style={{ padding: "32px", display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(340px, 1fr))", gap: "24px", background: "var(--bg-search)" }}>
                {results.map((booking) => (
                  <motion.div
                    key={booking._id}
                    layout
                    initial={{ opacity: 0, scale: 0.95 }}
                    animate={{ opacity: 1, scale: 1 }}
                    whileHover={{ y: -5, boxShadow: "0 12px 30px rgba(0,0,0,0.08)" }}
                    className="glass-card"
                    style={{ padding: "24px", background: "white", border: "1px solid var(--border)", position: "relative", cursor: "pointer", transition: "all 0.3s" }}
                  >
                    <div style={{ position: "absolute", top: "20px", right: "20px" }}>
                      <span style={{ 
                        padding: "6px 12px", 
                        borderRadius: "10px", 
                        fontSize: "12px", 
                        fontWeight: "700",
                        backgroundColor: `${getStatusColor(booking.status)}15`,
                        color: getStatusColor(booking.status),
                        border: `1px solid ${getStatusColor(booking.status)}20`
                      }}>
                        {booking.status || "Confirmed"}
                      </span>
                    </div>

                    <div style={{ display: "flex", alignItems: "center", gap: "12px", marginBottom: "20px" }}>
                        <div style={{ width: "48px", height: "48px", borderRadius: "14px", background: "var(--accent-light)", display: "flex", alignItems: "center", justifyContent: "center", color: "var(--accent)" }}>
                            <User size={24} />
                        </div>
                        <div>
                            <h4 style={{ fontSize: "16px", fontWeight: "700", color: "var(--text-primary)" }}>{booking.user?.name || "Premium Guest"}</h4>
                            <p style={{ fontSize: "13px", color: "var(--text-secondary)", fontWeight: "500" }}>{booking.user?.phone || "Private Contact"}</p>
                        </div>
                    </div>

                    <div style={{ height: "1px", background: "var(--border)", margin: "0 0 20px" }} />

                    <div style={{ display: "flex", flexDirection: "column", gap: "14px" }}>
                        <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                            <MapPin size={16} color="var(--text-secondary)" />
                            <div>
                                <p style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600", textTransform: "uppercase" }}>Property</p>
                                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)" }}>{booking.hotel?.name || "Grand Palace Hotel"}</p>
                            </div>
                        </div>

                        <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                            <Calendar size={16} color="var(--text-secondary)" />
                            <div>
                                <p style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600", textTransform: "uppercase" }}>Check-in Date</p>
                                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)" }}>
                                    {booking.checkIn ? new Date(booking.checkIn).toLocaleDateString(undefined, { dateStyle: 'medium' }) : "Not Available"}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div style={{ marginTop: "24px", padding: "16px", background: "var(--bg-search)", borderRadius: "12px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                        <div>
                            <p style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600" }}>TOTAL AMOUNT</p>
                            <p style={{ fontSize: "18px", fontWeight: "800", color: "var(--accent)" }}>₹{Number(booking.totalPrice || 0).toLocaleString()}</p>
                        </div>
                        <button style={{ background: "white", border: "1px solid var(--border)", padding: "8px", borderRadius: "10px", color: "var(--text-secondary)" }}>
                            <MoreVertical size={18} />
                        </button>
                    </div>
                  </motion.div>
                ))}
              </div>
            ) : (
              <div style={{ padding: "60px", textAlign: "center", color: "var(--text-secondary)" }}>
                <div style={{ fontSize: "16px", fontWeight: "600", marginBottom: "4px" }}>No results found</div>
                <p style={{ fontSize: "14px" }}>No bookings found for this phone number. Please try another one.</p>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
