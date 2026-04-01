import React, { useState, useEffect, useRef } from "react";
import { useLocation } from "react-router-dom";
import { MapPin, Plus, Hotel, Star, ShieldCheck, Heart, Coffee, Plane, Dog, Clock, Sparkles, Save, X, ImagePlus, Navigation } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

export default function Hotels() {
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const location = useLocation();
  const fileInputRef = useRef(null);

  const initialFormState = {
    name: "",
    location: "",
    rooms: "",
    category: "Luxury",
    starRating: "5",
    rating: "4.5",
    totalReviews: "0",
    landmark: "",
    nearestLandmark: "",
    tags: [],
    badges: [],
    image: [] // changed from single image to array
  };

  const [formData, setFormData] = useState(initialFormState);

  const [hotels, setHotels] = useState([
    {
      id: "HTL-DL-001",
      name: "The Leela Ambience",
      location: "Gurugram",
      rooms: 250,
      rating: 4.9,
      starRating: "5",
      totalReviews: "2933",
      landmark: "Near Ambience Mall",
      nearestLandmark: "Ambience Mall",
      status: "Active",
      badges: ["Couple Friendly", "Breakfast Available", "Airport Transfer", "Parking", "Gym"]
    },
    {
      id: "HTL-MU-045",
      name: "Taj Mahal Palace",
      location: "Colaba, Mumbai",
      rooms: 150,
      rating: 5.0,
      starRating: "5",
      totalReviews: "8421",
      landmark: "Opposite Gateway of India",
      nearestLandmark: "Gateway of India",
      status: "Active",
      badges: ["Couple Friendly", "Flexible Check-in", "Room Upgrade", "Airport Transfer"]
    },
    {
      id: "HTL-GO-088",
      name: "Novotel Goa Resort",
      location: "Candolim",
      rooms: 180,
      rating: 4.7,
      starRating: "4",
      totalReviews: "1250",
      landmark: "Near Candolim Beach",
      nearestLandmark: "Candolim Beach",
      status: "Active",
      badges: ["Couple Friendly", "Pet Friendly", "Breakfast Available", "Pool Access"]
    },
  ]);

  const badgeOptions = [
    "Couple Friendly", "Flexible Check-in", "Room Upgrade",
    "Breakfast Available", "Airport Transfer", "Pet Friendly", "Parking", "Gym"
  ];

  const isAddRoute = location.pathname === "/hotels/add";

  useEffect(() => {
    if (isAddRoute) {
      setShowAddForm(true);
    } else {
      setShowAddForm(false);
      setEditingId(null);
      setFormData(initialFormState);
    }
  }, [location.pathname]);

  const toggleBadge = (badge) => {
    setFormData(prev => ({
      ...prev,
      badges: prev.badges.includes(badge)
        ? prev.badges.filter(b => b !== badge)
        : [...prev.badges, badge]
    }));
  };

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    const readers = files.map(file => {
      return new Promise((resolve) => {
        const reader = new FileReader();
        reader.onloadend = () => resolve(reader.result);
        reader.readAsDataURL(file);
      });
    });
    Promise.all(readers).then((images) => {
      setFormData(prev => ({ ...prev, image: [...prev.image, ...images] }));
    });
    e.target.value = null; // reset input
  };

  const handleEdit = (hotel) => {
    setFormData({
      name: hotel.name,
      location: hotel.location,
      rooms: hotel.rooms,
      category: hotel.category || "Luxury",
      starRating: hotel.starRating,
      rating: hotel.rating,
      totalReviews: hotel.totalReviews,
      landmark: hotel.landmark,
      nearestLandmark: hotel.nearestLandmark || "",
      tags: hotel.tags || [],
      badges: hotel.badges || [],
      image: hotel.image || []
    });
    setEditingId(hotel.id);
    setShowAddForm(true);
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleCancel = () => {
    setFormData(initialFormState);
    setEditingId(null);
    setShowAddForm(false);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingId) {
      setHotels(hotels.map(h => h.id === editingId ? { ...h, ...formData } : h));
    } else {
      const newHotel = {
        ...formData,
        id: `HTL-NEW-${Math.floor(Math.random() * 1000)}`,
        rating: parseFloat(formData.rating) || 4.5,
        status: "Active"
      };
      setHotels([newHotel, ...hotels]);
    }
    handleCancel();
  };

  const getBadgeIcon = (badge) => {
    switch (badge) {
      case "Couple Friendly": return <Heart size={14} color="#ef4444" fill="#ef4444" />;
      case "Breakfast Available": return <Coffee size={14} color="var(--accent)" />;
      case "Airport Transfer": return <Plane size={14} color="var(--accent)" />;
      case "Pet Friendly": return <Dog size={14} color="var(--accent)" />;
      case "Flexible Check-in": return <Clock size={14} color="var(--accent)" />;
      default: return <Sparkles size={14} color="var(--accent)" />;
    }
  };

  return (
    <div style={{ maxWidth: "1400px", margin: "0 auto" }}>
      <div style={{ marginBottom: "40px", display: "flex", justifyContent: "space-between", alignItems: "flex-end" }}>
        <div>
          <h1 style={{ fontSize: "32px", fontWeight: "800", color: "var(--text-primary)", letterSpacing: "-1px", marginBottom: "8px" }}>
            Hotel Properties
          </h1>
          <p style={{ color: "var(--text-secondary)", fontSize: "16px" }}>
            Register and manage your hotel portfolio with Goibibo data standards.
          </p>
        </div>
        {!showAddForm && (
            <button 
                onClick={() => setShowAddForm(true)}
                style={{ 
                    padding: "12px 24px", 
                    background: "var(--accent)", 
                    border: "none", 
                    color: "white", 
                    fontSize: "14px", 
                    fontWeight: "700",
                    display: "flex",
                    alignItems: "center",
                    gap: "8px",
                    boxShadow: "0 4px 12px var(--accent-light)"
                }}
            >
                <Plus size={18} /> Add Property
            </button>
        )}
      </div>

      <AnimatePresence>
        {showAddForm && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="glass-card"
            style={{ padding: "48px", marginBottom: "48px", background: "white", border: editingId ? "2px solid var(--accent)" : "1px solid var(--border)" }}
          >
            <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "40px" }}>
              <div>
                <h2 style={{ fontSize: "24px", fontWeight: "800", color: "var(--text-primary)" }}>
                    {editingId ? "Edit Hotel Details" : "Register New Hotel"}
                </h2>
                <p style={{ fontSize: "14px", color: "var(--text-secondary)", marginTop: "4px" }}>Fill in the details below to update the system.</p>
              </div>
              <button
                onClick={handleCancel}
                style={{
                  background: "var(--bg-search)",
                  border: "1px solid var(--border)",
                  color: "var(--text-secondary)",
                  fontWeight: "600",
                  padding: "10px 20px",
                  borderRadius: "12px",
                  display: "flex",
                  alignItems: "center",
                  gap: "8px"
                }}
              >
                <X size={18} />
                Discard
              </button>
            </div>

            <form onSubmit={handleSubmit} style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "32px" }}>
              
              {/* Hotel Name */}
              <div style={{ gridColumn: "span 2" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Hotel Name</p>
                <div style={{ position: "relative" }}>
                  <Hotel size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="e.g. Taj Mahal Palace"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.name}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    required
                  />
                </div>
              </div>

              {/* Star Rating */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Star Rating</p>
                <select
                  style={{ width: "100%", padding: "0 20px", color: "var(--text-primary)", height: "52px" }}
                  value={formData.starRating}
                  onChange={(e) => setFormData({ ...formData, starRating: e.target.value })}
                >
                  <option value="3">3 Star Hotel</option>
                  <option value="4">4 Star Hotel</option>
                  <option value="5">5 Star Hotel</option>
                </select>
              </div>

              {/* Total Reviews */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Total Reviews</p>
                <input
                  type="number"
                  placeholder="e.g. 2933"
                  style={{ width: "100%", height: "52px" }}
                  value={formData.totalReviews}
                  onChange={(e) => setFormData({ ...formData, totalReviews: e.target.value })}
                />
              </div>

              {/* Rating Score */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Rating Score</p>
                <input
                  type="number"
                  step="0.1"
                  min="1"
                  max="5"
                  placeholder="e.g. 4.5"
                  style={{ width: "100%", height: "52px" }}
                  value={formData.rating}
                  onChange={(e) => setFormData({ ...formData, rating: e.target.value })}
                />
              </div>

              {/* Total Rooms */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Total Rooms</p>
                <input
                  type="number"
                  placeholder="e.g. 50"
                  style={{ width: "100%", height: "52px" }}
                  value={formData.rooms}
                  onChange={(e) => setFormData({ ...formData, rooms: e.target.value })}
                  required
                />
              </div>

              {/* Landmark — 50% */}
              <div style={{ gridColumn: "span 1" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Primary Landmark</p>
                <div style={{ position: "relative" }}>
                  <MapPin size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="e.g. Opposite Gateway of India"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.landmark}
                    onChange={(e) => setFormData({ ...formData, landmark: e.target.value })}
                  />
                </div>
              </div>

              {/* Nearest Landmark — 50% */}
              <div style={{ gridColumn: "span 1" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Nearest Transport Hub</p>
                <div style={{ position: "relative" }}>
                  <Navigation size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="e.g. Gateway of India"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.nearestLandmark}
                    onChange={(e) => setFormData({ ...formData, nearestLandmark: e.target.value })}
                  />
                </div>
              </div>

              {/* Hotel Image Upload */}
              <div style={{ gridColumn: "span 3" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "12px" }}>Property Gallery</p>
                <input
                  type="file"
                  accept="image/*"
                  multiple
                  ref={fileInputRef}
                  onChange={handleImageChange}
                  style={{ display: "none" }}
                />

                {formData.image.length > 0 ? (
                  <div style={{ display: "flex", gap: "16px", flexWrap: "wrap" }}>
                    {formData.image.map((imgSrc, idx) => (
                      <div key={idx} style={{ position: "relative", borderRadius: "16px", overflow: "hidden", width: "180px", height: "140px", boxShadow: "var(--shadow-sm)" }}>
                        <img
                          src={imgSrc}
                          alt={`Hotel preview ${idx + 1}`}
                          style={{ width: "100%", height: "100%", objectFit: "cover" }}
                        />
                        <button
                          type="button"
                          onClick={() => {
                            setFormData(prev => ({
                              ...prev,
                              image: prev.image.filter((_, i) => i !== idx)
                            }));
                          }}
                          style={{
                            position: "absolute",
                            top: "8px",
                            right: "8px",
                            background: "rgba(15, 23, 42, 0.8)",
                            border: "none",
                            borderRadius: "8px",
                            color: "white",
                            padding: "6px",
                            cursor: "pointer",
                            display: "flex",
                            alignItems: "center",
                            backdropFilter: "blur(4px)"
                          }}
                        >
                          <X size={14} />
                        </button>
                      </div>
                    ))}
                    <button
                      type="button"
                      onClick={() => fileInputRef.current.click()}
                      style={{
                        width: "180px",
                        height: "140px",
                        borderRadius: "16px",
                        border: "2px dashed var(--border)",
                        background: "var(--bg-search)",
                        cursor: "pointer",
                        fontWeight: "700",
                        color: "var(--text-secondary)",
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "center",
                        justifyContent: "center",
                        gap: "8px",
                        transition: "all 0.2s"
                      }}
                       onMouseOver={e => e.currentTarget.style.borderColor = "var(--accent)"}
                       onMouseOut={e => e.currentTarget.style.borderColor = "var(--border)"}
                    >
                      <Plus size={24} />
                      <span style={{ fontSize: "12px" }}>Add More</span>
                    </button>
                  </div>
                ) : (
                  <div
                    onClick={() => fileInputRef.current.click()}
                    style={{
                      border: "2px dashed var(--border)",
                      borderRadius: "16px",
                      padding: "54px",
                      textAlign: "center",
                      cursor: "pointer",
                      background: "var(--bg-search)",
                      transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)"
                    }}
                    onMouseEnter={e => {
                        e.currentTarget.style.borderColor = "var(--accent)";
                        e.currentTarget.style.background = "var(--accent-light)";
                    }}
                    onMouseLeave={e => {
                        e.currentTarget.style.borderColor = "var(--border)";
                        e.currentTarget.style.background = "var(--bg-search)";
                    }}
                  >
                    <ImagePlus size={40} color="var(--accent)" style={{ margin: "0 auto 16px", opacity: 0.8 }} />
                    <p style={{ fontSize: "16px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "4px" }}>
                      Tap to upload property images
                    </p>
                    <p style={{ fontSize: "13px", color: "var(--text-secondary)" }}>
                      High-quality JPEG or PNG files recommended (max 5MB)
                    </p>
                  </div>
                )}
              </div>

              {/* Badges */}
              <div style={{ gridColumn: "span 3" }}>
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
                    <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)" }}>Amenities & Badges</p>
                    <span style={{ fontSize: "12px", color: "var(--text-secondary)", fontWeight: "600" }}>{formData.badges.length} Selected</span>
                </div>
                <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: "12px" }}>
                  {badgeOptions.map((badge) => (
                    <div
                      key={badge}
                      onClick={() => toggleBadge(badge)}
                      style={{
                        padding: "14px 18px",
                        borderRadius: "14px",
                        fontSize: "14px",
                        fontWeight: "700",
                        cursor: "pointer",
                        border: "1.5px solid",
                        borderColor: formData.badges.includes(badge) ? "var(--accent)" : "var(--border)",
                        background: formData.badges.includes(badge) ? "var(--accent-light)" : "white",
                        color: formData.badges.includes(badge) ? "var(--accent)" : "var(--text-primary)",
                        transition: "all 0.2s cubic-bezier(0.4, 0, 0.2, 1)",
                        display: "flex",
                        alignItems: "center",
                        gap: "10px",
                        boxShadow: formData.badges.includes(badge) ? "0 4px 12px var(--accent-light)" : "none"
                      }}
                      onMouseOver={e => {
                        if (!formData.badges.includes(badge)) {
                            e.currentTarget.style.borderColor = "var(--accent)";
                            e.currentTarget.style.background = "var(--bg-search)";
                        }
                      }}
                      onMouseOut={e => {
                        if (!formData.badges.includes(badge)) {
                            e.currentTarget.style.borderColor = "var(--border)";
                            e.currentTarget.style.background = "white";
                        }
                      }}
                    >
                      <div style={{ opacity: formData.badges.includes(badge) ? 1 : 0.6 }}>
                        {getBadgeIcon(badge)}
                      </div>
                      {badge}
                    </div>
                  ))}
                </div>
              </div>

              {/* Submit */}
              <button
                type="submit"
                style={{
                  gridColumn: "span 3",
                  background: "var(--accent)",
                  border: "none",
                  color: "white",
                  padding: "18px",
                  fontWeight: "800",
                  fontSize: "16px",
                  marginTop: "16px",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  gap: "12px",
                  boxShadow: "0 8px 24px var(--accent-light)",
                  borderRadius: "16px"
                }}
              >
                {editingId ? <Save size={20} /> : <Plus size={20} />}
                {editingId ? "Save Property Changes" : "Confirm and Add Property"}
              </button>
            </form>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Hotel List Table */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="glass-card"
        style={{ overflow: "hidden", background: "white", border: "1px solid var(--border)" }}
      >
        <div style={{ padding: "24px 32px", borderBottom: "1px solid var(--border)", display: "flex", justifyContent: "space-between", alignItems: "center", background: "var(--bg-search)" }}>
            <h3 style={{ fontSize: "18px", fontWeight: "700", color: "var(--text-primary)" }}>Active Properties</h3>
            <div style={{ display: "flex", gap: "10px" }}>
                <input type="text" placeholder="Filter hotels..." style={{ height: "40px", fontSize: "13px", padding: "0 16px" }} />
            </div>
        </div>
        <div style={{ overflowX: "auto" }}>
            <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
            <thead>
                <tr style={{ background: "white" }}>
                    <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "12px", textTransform: "uppercase" }}>Property ID</th>
                    <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "12px", textTransform: "uppercase" }}>Name & Location</th>
                    <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "12px", textTransform: "uppercase" }}>Capacity</th>
                    <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "12px", textTransform: "uppercase" }}>Rating</th>
                    <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "12px", textTransform: "uppercase" }}>Status</th>
                    <th style={{ padding: "16px 32px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "12px", textTransform: "uppercase", textAlign: "right" }}>Actions</th>
                </tr>
            </thead>
            <tbody>
                {hotels.map((hotel) => (
                <tr 
                    key={hotel.id} 
                    style={{ borderBottom: "1px solid var(--border)", transition: "all 0.2s" }}
                    onMouseOver={e => e.currentTarget.style.backgroundColor = "var(--row-hover)"}
                    onMouseOut={e => e.currentTarget.style.backgroundColor = "transparent"}
                >
                    <td style={{ padding: "20px 32px", fontWeight: "600", color: "var(--text-secondary)", fontSize: "14px" }}>{hotel.id}</td>
                    <td style={{ padding: "20px 32px" }}>
                        <div style={{ fontWeight: "700", color: "var(--text-primary)", fontSize: "15px" }}>{hotel.name}</div>
                        <div style={{ fontSize: "13px", color: "var(--text-secondary)", display: "flex", alignItems: "center", gap: "4px", marginTop: "2px" }}>
                            <MapPin size={12} /> {hotel.location}
                        </div>
                    </td>
                    <td style={{ padding: "20px 32px" }}>
                        <div style={{ fontWeight: "600", color: "var(--text-primary)" }}>{hotel.rooms} Rooms</div>
                        <div style={{ fontSize: "12px", color: "var(--text-secondary)" }}>Total Capacity</div>
                    </td>
                    <td style={{ padding: "20px 32px" }}>
                        <div style={{ display: "flex", alignItems: "center", gap: "4px", marginBottom: "4px" }}>
                            <Star size={14} fill="#f59e0b" color="#f59e0b" />
                            <span style={{ fontWeight: "700", color: "var(--text-primary)" }}>{hotel.rating}</span>
                        </div>
                        <div style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{hotel.totalReviews} Reviews</div>
                    </td>
                    <td style={{ padding: "20px 32px" }}>
                        <span style={{ 
                            padding: "6px 12px", 
                            borderRadius: "10px", 
                            fontSize: "12px", 
                            fontWeight: "700",
                            background: "#10b98115",
                            color: "#10b981",
                            border: "1px solid #10b98130"
                        }}>
                            {hotel.status}
                        </span>
                    </td>
                    <td style={{ padding: "20px 32px", textAlign: "right" }}>
                        <button
                            onClick={() => handleEdit(hotel)}
                            style={{ 
                                background: "white", 
                                color: "var(--text-primary)", 
                                border: "1px solid var(--border)",
                                borderRadius: "10px", 
                                padding: "8px 16px", 
                                fontWeight: "700", 
                                cursor: "pointer",
                                fontSize: "13px",
                                transition: "all 0.2s"
                            }}
                            onMouseOver={e => {
                                e.currentTarget.style.borderColor = "var(--accent)";
                                e.currentTarget.style.color = "var(--accent)";
                            }}
                            onMouseOut={e => {
                                e.currentTarget.style.borderColor = "var(--border)";
                                e.currentTarget.style.color = "var(--text-primary)";
                            }}
                        >
                            Configure
                        </button>
                    </td>
                </tr>
                ))}
            </tbody>
            </table>
        </div>
        <div style={{ padding: "20px 32px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <p style={{ fontSize: "14px", color: "var(--text-secondary)" }}>Showing {hotels.length} properties</p>
            <div style={{ display: "flex", gap: "8px" }}>
                <button style={{ padding: "8px 16px", background: "white", border: "1px solid var(--border)", fontSize: "13px", borderRadius: "8px", fontWeight: "600" }}>Export CSV</button>
            </div>
        </div>
      </motion.div>
    </div>
  );
}