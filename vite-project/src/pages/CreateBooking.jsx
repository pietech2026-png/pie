import React, { useState, useEffect } from "react";
import { User, Phone, MapPin, Calendar, Users, Coffee, Plus, Save, Loader2 } from "lucide-react";
import { motion } from "framer-motion";
import { api } from "../utils/api";

export default function CreateBooking() {
  const [formData, setFormData] = useState({
    guestName: "",
    phone: "",
    hotel: "",
    checkIn: "",
    checkOut: "",
    roomType: "",
    guests: 2,
    breakfast: true,
    totalPrice: 0,
    manualPrice: false,
  });

  const [hotels, setHotels] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const fetchHotelsData = async () => {
      try {
        const data = await api.getHotels();
        setHotels(data);
      } catch (error) {
        console.error("Failed to fetch hotels:", error);
      }
    };
    fetchHotelsData();
  }, []);

  useEffect(() => {
    const fetchRoomsData = async () => {
      if (formData.hotel) {
        try {
          const data = await api.getRoomsByHotel(formData.hotel);
          setRooms(data);
          if (data.length > 0) {
            setFormData(prev => ({ ...prev, roomType: data[0].id }));
          }
        } catch (error) {
          console.error("Failed to fetch rooms:", error);
        }
      } else {
        setRooms([]);
      }
    };
    fetchRoomsData();
  }, [formData.hotel]);

  // 🔥 Auto-calculate price when dates or room changes
  useEffect(() => {
    if (formData.checkIn && formData.checkOut && formData.roomType && !formData.manualPrice) {
      const selectedRoom = rooms.find(r => r.id === formData.roomType);
      if (selectedRoom) {
        const checkInDate = new Date(formData.checkIn);
        const checkOutDate = new Date(formData.checkOut);
        const days = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24)) || 1;
        if (days > 0) {
          setFormData(prev => ({ ...prev, totalPrice: selectedRoom.basePrice * days }));
        }
      }
    }
  }, [formData.checkIn, formData.checkOut, formData.roomType, rooms, formData.manualPrice]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      // 1. Find or Create User
      const user = await api.findOrCreateUser({
        name: formData.guestName,
        phone: formData.phone
      });

      // 2. Prepare Booking Data
      const selectedRoom = rooms.find(r => r.id === formData.roomType);
      if (!selectedRoom) throw new Error("Please select a room type");

      const checkInDate = new Date(formData.checkIn);
      const checkOutDate = new Date(formData.checkOut);
      const days = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
      
      const bookingPayload = {
        hotel: formData.hotel,
        room: formData.roomType,
        user: user._id,
        checkIn: formData.checkIn,
        checkOut: formData.checkOut,
        guests: Number(formData.guests),
        totalPrice: Number(formData.totalPrice),
        source: "admin",
        specialRequests: formData.breakfast ? "Breakfast Included" : ""
      };

      await api.createBooking(bookingPayload);
      alert("Booking Created Successfully!");
      setFormData({
        guestName: "",
        phone: "",
        hotel: "",
        checkIn: "",
        checkOut: "",
        roomType: "",
        guests: 2,
        breakfast: true,
        totalPrice: 0,
        manualPrice: false,
      });
    } catch (error) {
      console.error("Booking Error:", error);
      alert("Error creating booking: " + error.message);
    } finally {
      setLoading(false);
    }
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
                {hotels.map(h => (
                  <option key={h.id} value={h.id}>{h.name}</option>
                ))}
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
              disabled={!formData.hotel}
            >
              <option value="">Select a room...</option>
              {rooms.map(r => (
                <option key={r.id} value={r.id}>{r.type} (₹{r.basePrice})</option>
              ))}
            </select>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
            <label style={{ fontSize: "14px", fontWeight: "600" }}>Total Booking Price (₹)</label>
            <div style={{ position: "relative" }}>
              <input 
                type="number" 
                value={formData.totalPrice}
                onChange={(e) => setFormData({...formData, totalPrice: e.target.value, manualPrice: true})}
                placeholder="0"
                style={{ width: "100%", fontWeight: "700", color: formData.manualPrice ? "var(--accent)" : "inherit" }} 
              />
              {formData.manualPrice && (
                <button 
                  type="button"
                  onClick={() => setFormData({...formData, manualPrice: false})}
                  style={{ position: "absolute", right: "10px", top: "50%", transform: "translateY(-50%)", background: "none", border: "none", fontSize: "12px", color: "var(--accent)", cursor: "pointer" }}
                >
                  Reset
                </button>
              )}
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
            {loading ? <Loader2 size={20} className="animate-spin" /> : <Save size={20} />}
            {loading ? "Creating..." : "Confirm and Create Booking"}
          </button>

        </form>
      </motion.div>
    </div>
  );
}
