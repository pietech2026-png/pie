import React, { useState } from "react";
import { Star, MapPin, Share2, Heart, Navigation, Info, Check, Coffee, ShieldCheck, Clock, ChevronRight, X, Image as ImageIcon } from "lucide-react";
import { motion } from "framer-motion";

export default function HotelDetail({ hotel, onBack }) {
  const [activeTab, setActiveTab] = useState("Room Options");

  if (!hotel) return null;

  const tabs = ["Room Options", "Amenities", "Restaurants", "Guest Reviews", "Property Policies", "Location"];

  // Helper to handle gallery images
  const images = hotel.image && hotel.image.length > 0 ? hotel.image : ["https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80"];
  const mainImage = images[0];
  const sideImage1 = images[1] || images[0];
  const sideImage2 = images[2] || images[0];

  return (
    <motion.div 
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      style={{ 
        background: "white", 
        position: "fixed", 
        top: 0, 
        left: 0, 
        width: "100vw", 
        height: "100vh", 
        zIndex: 9999, 
        overflowY: "auto",
        paddingBottom: "100px"
      }}
    >
      {/* Top Navigation Bar (Sticky-ish) */}
      <div style={{ background: "white", padding: "16px 40px", borderBottom: "1px solid var(--border)", display: "flex", justifyContent: "space-between", alignItems: "center", position: "sticky", top: 0, zIndex: 100, boxShadow: "0 2px 10px rgba(0,0,0,0.05)" }}>
        <div style={{ display: "flex", alignItems: "center", gap: "24px" }}>
            <button onClick={onBack} style={{ display: "flex", alignItems: "center", gap: "8px", background: "none", border: "none", color: "#3b82f6", fontWeight: "700", cursor: "pointer", fontSize: "15px" }}>
                <X size={20} /> Close Preview
            </button>
            <div style={{ padding: "0 1px", height: "24px", background: "var(--border)" }} />
            <span style={{ fontSize: "14px", fontWeight: "600", color: "var(--text-secondary)" }}>Property Preview: {hotel.name}</span>
        </div>
        <div style={{ display: "flex", gap: "16px" }}>
            <button style={{ background: "none", border: "1px solid var(--border)", padding: "8px 16px", borderRadius: "8px", display: "flex", alignItems: "center", gap: "8px", fontSize: "14px", fontWeight: "600" }}>
                <Share2 size={16} /> Share
            </button>
            <button style={{ background: "none", border: "1px solid var(--border)", padding: "8px 16px", borderRadius: "8px", display: "flex", alignItems: "center", gap: "8px", fontSize: "14px", fontWeight: "600" }}>
                <Heart size={16} /> Save
            </button>
        </div>
      </div>

      <div style={{ maxWidth: "1300px", margin: "0 auto", padding: "32px 20px" }}>
        
        {/* Header Section */}
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "24px" }}>
          <div style={{ flex: 1 }}>
            <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "12px" }}>
                <div style={{ background: "white", border: "1px solid var(--border)", padding: "2px 8px", borderRadius: "4px", fontSize: "12px", fontWeight: "700", display: "flex", alignItems: "center", gap: "4px" }}>
                   {hotel.starRating} <Star size={12} fill="#f59e0b" color="#f59e0b" />
                </div>
                <span style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600" }}>• Hotel</span>
            </div>
            <h1 style={{ fontSize: "28px", fontWeight: "800", color: "var(--text-primary)", marginBottom: "8px", lineHeight: "1.2" }}>
                {hotel.name}
            </h1>
            <div style={{ display: "flex", alignItems: "center", gap: "16px", flexWrap: "wrap" }}>
                <div style={{ display: "flex", alignItems: "center", gap: "4px", color: "var(--text-secondary)", fontSize: "14px" }}>
                    <MapPin size={16} color="#3b82f6" />
                    <span style={{ color: "#3b82f6", fontWeight: "600" }}>{hotel.location}</span>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: "6px", color: "var(--text-secondary)", fontSize: "14px" }}>
                    <Navigation size={14} color="#f97316" />
                    <span>{hotel.landmark}</span>
                </div>
            </div>
          </div>

          <div style={{ display: "flex", gap: "12px" }}>
            <div style={{ background: "white", padding: "12px 20px", borderRadius: "12px", border: "1px solid var(--border)", display: "flex", alignItems: "center", gap: "12px", boxShadow: "var(--shadow-sm)" }}>
                <div style={{ background: "#eff6ff", padding: "8px", borderRadius: "8px" }}>
                    <MapPin size={24} color="#3b82f6" />
                </div>
                <span style={{ color: "#3b82f6", fontWeight: "700", fontSize: "14px" }}>View Map</span>
            </div>
            <div style={{ background: "white", padding: "12px 20px", borderRadius: "12px", border: "1px solid var(--border)", display: "flex", alignItems: "center", gap: "12px", boxShadow: "var(--shadow-sm)" }}>
                <div style={{ background: "#22c55e", color: "white", padding: "6px 10px", borderRadius: "8px", fontWeight: "800", fontSize: "18px" }}>
                    {hotel.rating}/5
                </div>
                <span style={{ color: "#3b82f6", fontWeight: "700", fontSize: "14px" }}>View Reviews</span>
            </div>
          </div>
        </div>

        {/* Hero Gallery Section */}
        <div style={{ display: "grid", gridTemplateColumns: "1.8fr 1fr", gap: "12px", height: "480px", marginBottom: "32px", borderRadius: "24px", overflow: "hidden" }}>
          {/* Main Large Image */}
          <div style={{ position: "relative", overflow: "hidden" }}>
            <img src={mainImage} alt="Hotel View" style={{ width: "100%", height: "100%", objectFit: "cover" }} />
            <div style={{ position: "absolute", bottom: "24px", left: "24px", background: "rgba(0,0,0,0.6)", color: "white", padding: "8px 16px", borderRadius: "30px", fontSize: "13px", fontWeight: "600", backdropFilter: "blur(8px)" }}>
                Property Photos (127)
            </div>
            <div style={{ position: "absolute", bottom: "24px", right: "24px", color: "white", fontSize: "14px", fontWeight: "700", display: "flex", alignItems: "center", gap: "8px" }}>
                View All <ChevronRight size={18} />
            </div>
          </div>
          
          {/* Side Small Images */}
          <div style={{ display: "grid", gridRows: "1fr 1fr", gap: "12px" }}>
            <div style={{ position: "relative", overflow: "hidden" }}>
                <img src={sideImage1} alt="Room View" style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                <div style={{ position: "absolute", bottom: "16px", left: "16px", color: "white", fontWeight: "700", fontSize: "14px" }}>Room(36)</div>
            </div>
            <div style={{ position: "relative", overflow: "hidden" }}>
                <img src={sideImage2} alt="Guest View" style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                <div style={{ position: "absolute", bottom: "16px", left: "16px", color: "white", fontWeight: "700", fontSize: "14px" }}>Traveller Photos(1498)</div>
            </div>
          </div>
        </div>

        {/* Main Content & Sidebar Grid */}
        <div style={{ display: "grid", gridTemplateColumns: "1fr 400px", gap: "32px", alignItems: "flex-start" }}>
          
          {/* Left Column */}
          <div>
            {/* Navigation Tabs */}
            <div style={{ display: "flex", borderBottom: "1px solid var(--border)", marginBottom: "32px", overflowX: "auto", whiteSpace: "nowrap" }}>
                {tabs.map(tab => (
                    <button
                        key={tab}
                        onClick={() => setActiveTab(tab)}
                        style={{
                            padding: "16px 24px",
                            fontSize: "15px",
                            fontWeight: activeTab === tab ? "800" : "600",
                            color: activeTab === tab ? "var(--text-primary)" : "var(--text-secondary)",
                            border: "none",
                            background: "none",
                            borderBottom: activeTab === tab ? "3px solid #3b82f6" : "3px solid transparent",
                            cursor: "pointer",
                            transition: "all 0.2s"
                        }}
                    >
                        {tab}
                    </button>
                ))}
            </div>

            {/* Dynamic Content Section (Room Options Example) */}
            <div className="glass-card" style={{ background: "white", padding: "32px", borderRadius: "24px", border: "1px solid var(--border)" }}>
                <h3 style={{ fontSize: "20px", fontWeight: "800", color: "var(--text-primary)", marginBottom: "20px" }}>About This Property</h3>
                <p style={{ fontSize: "16px", color: "var(--text-secondary)", lineHeight: "1.7", marginBottom: "24px" }}>
                    {hotel.description || "Experience world-class luxury and comfort in the heart of the city. This property offers state-of-the-art facilities, premium dining, and exceptional hospitality for both business and leisure travellers."}
                </p>

                <div style={{ height: "1px", background: "var(--border)", margin: "32px 0" }} />

                <h3 style={{ fontSize: "18px", fontWeight: "800", color: "var(--text-primary)", marginBottom: "16px" }}>Top Amenities</h3>
                <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: "16px" }}>
                    {hotel.badges && hotel.badges.length > 0 ? hotel.badges.map((badge, i) => (
                        <div key={i} style={{ display: "flex", alignItems: "center", gap: "10px", color: "var(--text-secondary)", fontSize: "14px", fontWeight: "600" }}>
                            <div style={{ color: "#10b981", background: "#f0fdf4", padding: "4px", borderRadius: "6px" }}>
                                <Check size={16} />
                            </div>
                            {badge}
                        </div>
                    )) : (
                        <p style={{ color: "var(--text-secondary)", fontSize: "14px" }}>Standard amenities included.</p>
                    )}
                </div>
            </div>
          </div>

          {/* Right Sidebar - Pricing Card */}
          <div style={{ position: "sticky", top: "100px" }}>
            <div className="glass-card" style={{ background: "white", padding: "32px", borderRadius: "24px", border: "1px solid var(--border)", boxShadow: "0 20px 40px rgba(0,0,0,0.05)" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "12px" }}>
                    <span style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-secondary)" }}>For 4 Adults</span>
                    <Info size={16} color="var(--text-secondary)" />
                </div>
                <h4 style={{ fontSize: "18px", fontWeight: "800", color: "var(--text-primary)", marginBottom: "20px" }}>
                    2 x Deluxe Silver Room
                </h4>

                <ul style={{ listStyle: "none", padding: 0, margin: "0 0 24px", display: "flex", flexDirection: "column", gap: "10px" }}>
                    <li style={{ display: "flex", alignItems: "center", gap: "8px", fontSize: "13px", color: "var(--text-secondary)", fontWeight: "600" }}>
                        <div style={{ width: "6px", height: "6px", background: "#ef4444", borderRadius: "50%" }} />
                        Rooms Only
                    </li>
                    <li style={{ display: "flex", alignItems: "center", gap: "8px", fontSize: "13px", color: "var(--text-secondary)", fontWeight: "600" }}>
                        <div style={{ width: "6px", height: "6px", background: "#ef4444", borderRadius: "50%" }} />
                        Non Refundable
                    </li>
                </ul>

                <button style={{ background: "none", border: "none", color: "#3b82f6", fontWeight: "800", fontSize: "14px", marginBottom: "24px", cursor: "pointer" }}>
                    Other options ▾
                </button>

                <div style={{ textAlign: "right", marginBottom: "24px" }}>
                    <p style={{ fontSize: "14px", color: "var(--text-secondary)", textDecoration: "line-through", marginBottom: "4px" }}>₹{(hotel.price * 1.5).toLocaleString()}</p>
                    <div style={{ display: "flex", justifyContent: "flex-end", alignItems: "baseline", gap: "8px" }}>
                        <span style={{ fontSize: "32px", fontWeight: "900", color: "var(--text-primary)" }}>₹{hotel.price.toLocaleString()}</span>
                    </div>
                    <p style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600", marginTop: "4px" }}>+ ₹475 taxes & fees</p>
                    <p style={{ fontSize: "13px", color: "#3b82f6", fontWeight: "800", marginTop: "4px" }}>Per Night For 2 Rooms</p>
                </div>

                <button style={{ width: "100%", background: "#f97316", color: "white", padding: "18px", borderRadius: "16px", border: "none", fontWeight: "800", fontSize: "16px", cursor: "pointer", boxShadow: "0 10px 20px rgba(249, 115, 22, 0.3)" }}>
                    View this Combo
                </button>
            </div>

            {/* Offer Coupon Badge */}
            <div style={{ background: "white", border: "1.5px solid #e2e8f0", borderRadius: "20px", padding: "20px", marginTop: "16px", display: "flex", alignItems: "center", gap: "16px" }}>
                <div style={{ width: "40px", height: "40px", borderRadius: "10px", background: "#eff6ff", display: "flex", alignItems: "center", justifyContent: "center" }}>
                    <ImageIcon size={20} color="#3b82f6" />
                </div>
                <div>
                    <h5 style={{ fontSize: "14px", fontWeight: "800", color: "#3b82f6", marginBottom: "2px" }}>Use GOBAJAJEMI Code</h5>
                    <p style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600" }}>Get extra ₹1507 off on this booking</p>
                </div>
                <div style={{ color: "#3b82f6", fontWeight: "800", fontSize: "12px", marginLeft: "auto" }}>+2 More</div>
            </div>
          </div>

        </div>

      </div>
    </motion.div>
  );
}
