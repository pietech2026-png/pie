import React, { useState } from "react";
import { Search, Phone, User, Calendar, MapPin, MoreVertical } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

export default function BookingSearch() {
  const [phone, setPhone] = useState("");
  const [results, setResults] = useState([]);
  const [isSearched, setIsSearched] = useState(false);

  const mockBookings = [
    { id: "GO-109283", guest: "Arjun Singh", phone: "9876543210", hotel: "Taj Mahal Palace", checkIn: "2026-03-25", status: "Completed", total: "₹24,500" },
    { id: "GO-109299", guest: "Arjun Singh", phone: "9876543210", hotel: "Novotel Goa Resort", checkIn: "2026-04-12", status: "Confirmed", total: "₹18,200" },
    { id: "GO-109310", guest: "Arjun Singh", phone: "9876543210", hotel: "The Leela Ambience", checkIn: "2026-05-02", status: "Confirmed", total: "₹12,400" },
  ];

  const handleSearch = (e) => {
    e.preventDefault();
    const found = mockBookings.filter(b => b.phone.includes(phone) && phone !== "");
    setResults(found);
    setIsSearched(true);
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
            style={{ 
              background: "var(--accent)", 
              color: "white", 
              border: "none", 
              padding: "12px 32px", 
              fontWeight: "600",
              display: "flex",
              alignItems: "center",
              gap: "8px"
            }}
          >
            <Search size={18} />
            Search
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
              <div style={{ overflowX: "auto" }}>
                <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
                  <thead>
                    <tr style={{ borderBottom: "1px solid var(--border)" }}>
                      <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Guest</th>
                      <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Hotel / Property</th>
                      <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Check-in</th>
                      <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Status</th>
                      <th style={{ padding: "16px 24px", color: "var(--text-secondary)", fontWeight: "500", fontSize: "14px" }}>Total</th>
                      <th style={{ padding: "16px 24px", textAlign: "right" }}></th>
                    </tr>
                  </thead>
                  <tbody>
                    {results.map((booking) => (
                      <tr 
                        key={booking.id} 
                        style={{ borderBottom: "1px solid var(--border)", transition: "background 0.2s" }}
                        onMouseOver={(e) => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                        onMouseOut={(e) => e.currentTarget.style.backgroundColor = "transparent"}
                      >
                        <td style={{ padding: "16px 24px" }}>
                          <div style={{ fontWeight: "600" }}>{booking.guest}</div>
                          <div style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{booking.phone}</div>
                        </td>
                        <td style={{ padding: "16px 24px" }}>
                          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                            <MapPin size={14} color="var(--text-secondary)" />
                            {booking.hotel}
                          </div>
                        </td>
                        <td style={{ padding: "16px 24px" }}>{booking.checkIn}</td>
                        <td style={{ padding: "16px 24px" }}>
                          <span style={{ 
                            padding: "4px 10px", 
                            borderRadius: "20px", 
                            fontSize: "12px", 
                            fontWeight: "600",
                            backgroundColor: booking.status === "Completed" ? "#10b98120" : "#3b82f620",
                            color: booking.status === "Completed" ? "#10b981" : "#3b82f6",
                          }}>
                            {booking.status}
                          </span>
                        </td>
                        <td style={{ padding: "16px 24px", fontWeight: "600" }}>{booking.total}</td>
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
            ) : (
              <div style={{ padding: "60px", textAlign: "center", color: "var(--text-secondary)" }}>
                No bookings found for this phone number. Please try another one.
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
