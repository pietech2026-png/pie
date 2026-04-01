import React, { useState } from "react";
import { User, Phone, MapPin, Calendar, Users, Coffee, Plus, Save } from "lucide-react";
import { motion } from "framer-motion";

export default function CreateBooking() {
  const [formData, setFormData] = useState({
    guestName: "",
    phone: "",
    hotel: "",
    checkIn: "",
    checkOut: "",
    roomType: "Deluxe Room",
    guests: 2,
    breakfast: true,
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    alert("Booking Created Successfully!");
  };

  return (
    <div style={{ maxWidth: "800px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px" }}>
        <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>Create New Booking</h1>
        <p style={{ color: "var(--text-secondary)" }}>Manually register a booking for a new or existing guest</p>
      </div>

      <motion.div
        initial={{ opacity: 0, scale: 0.98 }}
        animate={{ opacity: 1, scale: 1 }}
        className="glass-card"
        style={{ padding: "40px" }}
      >
        <form onSubmit={handleSubmit} style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "24px" }}>
          
          <div style={{ gridColumn: "span 2" }}>
            <h3 style={{ fontSize: "16px", fontWeight: "600", marginBottom: "16px", color: "var(--accent)" }}>Guest Information</h3>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Guest Full Name</label>
            <div style={{ position: "relative" }}>
              <User size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
              <input 
                type="text" 
                placeholder="e.g. Rahul Sharma" 
                value={formData.guestName}
                onChange={(e) => setFormData({...formData, guestName: e.target.value})}
                style={{ width: "100%", paddingLeft: "44px" }} 
              />
            </div>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Phone Number</label>
            <div style={{ position: "relative" }}>
              <Phone size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
              <input 
                type="text" 
                placeholder="e.g. +91 98765 43210" 
                value={formData.phone}
                onChange={(e) => setFormData({...formData, phone: e.target.value})}
                style={{ width: "100%", paddingLeft: "44px" }} 
              />
            </div>
          </div>

          <div style={{ gridColumn: "span 2", marginTop: "16px" }}>
            <h3 style={{ fontSize: "16px", fontWeight: "600", marginBottom: "16px", color: "var(--accent)" }}>Booking Details</h3>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px", gridColumn: "span 2" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Select Hotel Property</label>
            <div style={{ position: "relative" }}>
              <MapPin size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
              <select 
                value={formData.hotel}
                onChange={(e) => setFormData({...formData, hotel: e.target.value})}
                style={{ width: "100%", paddingLeft: "44px" }} 
              >
                <option value="">Select a hotel...</option>
                <option value="Grand Pie Resort">Grand Pie Resort</option>
                <option value="Pie Boutique Hotel">Pie Boutique Hotel</option>
                <option value="Mountain Pie Inn">Mountain Pie Inn</option>
              </select>
            </div>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Check-in Date</label>
            <div style={{ position: "relative" }}>
              <Calendar size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
              <input 
                type="date" 
                value={formData.checkIn}
                onChange={(e) => setFormData({...formData, checkIn: e.target.value})}
                style={{ width: "100%", paddingLeft: "44px" }} 
              />
            </div>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Check-out Date</label>
            <div style={{ position: "relative" }}>
              <Calendar size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
              <input 
                type="date" 
                value={formData.checkOut}
                onChange={(e) => setFormData({...formData, checkOut: e.target.value})}
                style={{ width: "100%", paddingLeft: "44px" }} 
              />
            </div>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Room Type</label>
            <select 
              value={formData.roomType}
              onChange={(e) => setFormData({...formData, roomType: e.target.value})}
              style={{ width: "100%" }} 
            >
              <option>Standard Room</option>
              <option>Deluxe Room</option>
              <option>Family Suite</option>
              <option>Penthouse</option>
            </select>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Number of Guests</label>
            <div style={{ position: "relative" }}>
              <Users size={18} style={{ position: "absolute", left: "14px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
              <input 
                type="number" 
                value={formData.guests}
                onChange={(e) => setFormData({...formData, guests: e.target.value})}
                style={{ width: "100%", paddingLeft: "44px" }} 
              />
            </div>
          </div>

          <div style={{ gridColumn: "span 2", padding: "16px", background: "var(--bg-search)", borderRadius: "12px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
              <Coffee size={20} color="var(--accent)" />
              <span style={{ fontSize: "14px", fontWeight: "600" }}>Include Breakfast Buffet</span>
            </div>
            <input 
              type="checkbox" 
              checked={formData.breakfast}
              onChange={(e) => setFormData({...formData, breakfast: e.target.checked})}
              style={{ width: "20px", height: "20px", cursor: "pointer" }}
            />
          </div>

          <button 
            type="submit"
            style={{ 
              gridColumn: "span 2", 
              background: "var(--accent)", 
              color: "white", 
              border: "none", 
              padding: "16px", 
              fontWeight: "700",
              fontSize: "16px",
              marginTop: "16px",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "10px"
            }}
          >
            <Save size={20} />
            Confirm and Create Booking
          </button>

        </form>
      </motion.div>
    </div>
  );
}
