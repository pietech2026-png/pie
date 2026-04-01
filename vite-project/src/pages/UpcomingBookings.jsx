import React from "react";
import { Calendar, User, MapPin, Clock, MoreVertical, CheckCircle, ArrowRight } from "lucide-react";
import { motion } from "framer-motion";

export default function UpcomingBookings() {
  const upcoming = [
    { id: "GO-CONF-101", guest: "Vikram Malhotra", hotel: "Taj Mahal Palace", checkIn: "2026-03-31", checkOut: "2026-04-05", status: "Confirmed", room: "Heritage Wing Room" },
    { id: "GO-CONF-102", guest: "Ananya Iyer", hotel: "The Leela Ambience", checkIn: "2026-04-02", checkOut: "2026-04-04", status: "Confirmed", room: "Executive Club Suite" },
    { id: "GO-CONF-103", guest: "Priya Reddy", hotel: "Novotel Goa Resort", checkIn: "2026-04-12", checkOut: "2026-04-15", status: "Confirmed", room: "Superior Pool View" },
  ];

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px" }}>
        <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>Upcoming Bookings</h1>
        <p style={{ color: "var(--text-secondary)" }}>Track all confirmed stays scheduled for today and future dates</p>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "24px" }}>
        {upcoming.map((booking, i) => (
          <motion.div
            key={booking.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.1 }}
            className="glass-card"
            style={{ padding: "24px", position: "relative", overflow: "hidden" }}
          >
            <div style={{ 
              position: "absolute", 
              top: "0", 
              right: "0", 
              padding: "8px 16px", 
              background: "#10b981", 
              color: "white", 
              fontSize: "12px", 
              fontWeight: "700",
              borderBottomLeftRadius: "12px"
            }}>
              CONFIRMED
            </div>

            <div style={{ display: "flex", gap: "20px" }}>
              <div style={{ 
                width: "60px", 
                height: "60px", 
                background: "var(--bg-search)", 
                borderRadius: "15px", 
                display: "flex", 
                alignItems: "center", 
                justifyContent: "center" 
              }}>
                <Calendar size={28} color="var(--accent)" />
              </div>
              
              <div style={{ flex: 1 }}>
                <h3 style={{ fontSize: "18px", fontWeight: "700", marginBottom: "4px" }}>{booking.guest}</h3>
                <div style={{ display: "flex", alignItems: "center", gap: "6px", color: "var(--text-secondary)", fontSize: "14px", marginBottom: "16px" }}>
                  <MapPin size={14} />
                  {booking.hotel}
                </div>

                <div style={{ 
                  display: "flex", 
                  alignItems: "center", 
                  gap: "24px", 
                  padding: "16px", 
                  background: "var(--bg-search)", 
                  borderRadius: "12px" 
                }}>
                  <div>
                    <p style={{ fontSize: "11px", color: "var(--text-secondary)", textTransform: "uppercase", fontWeight: "700", marginBottom: "4px" }}>Check In</p>
                    <p style={{ fontSize: "14px", fontWeight: "600" }}>{booking.checkIn}</p>
                  </div>
                  <ArrowRight size={16} color="var(--text-secondary)" />
                  <div>
                    <p style={{ fontSize: "11px", color: "var(--text-secondary)", textTransform: "uppercase", fontWeight: "700", marginBottom: "4px" }}>Check Out</p>
                    <p style={{ fontSize: "14px", fontWeight: "600" }}>{booking.checkOut}</p>
                  </div>
                </div>

                <div style={{ marginTop: "16px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                    <CheckCircle size={16} color="#10b981" />
                    <span style={{ fontSize: "14px", fontWeight: "500" }}>{booking.room}</span>
                  </div>
                  <button style={{ background: "transparent", border: "none", color: "var(--accent)", fontSize: "14px", fontWeight: "600" }}>View Details</button>
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
