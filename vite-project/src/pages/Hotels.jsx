import React, { useState, useEffect, useRef } from "react";
import { useLocation } from "react-router-dom";
import { MapPin, Plus, Hotel, Star, ShieldCheck, Heart, Coffee, Plane, Dog, Clock, Sparkles, Save, X, ImagePlus, Navigation, Eye, Bed, Trash2 } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { api } from "../utils/api";
import HotelDetail from "./HotelDetail";
import ManageRooms from "./ManageRooms";

export default function Hotels() {
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [viewingHotel, setViewingHotel] = useState(null);
  const [viewingRoomsFor, setViewingRoomsFor] = useState(null);
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
    image: [], // changed from single image to array
    description: "",
    reviews: "",
    price: "",
    state: "",
    pinCode: "",
    city: ""
  };


  const [formData, setFormData] = useState(initialFormState);

  const [newBadge, setNewBadge] = useState("");
  const availableEmojis = ["✨", "🏊", "🍸", "❄️", "🔥", "🛏️", "🛀", "📺", "🚗", "🍽️", "🏋️", "💆", "🚭", "🐕", "💼", "🥂", "🚲", "🌐"];
  const [selectedEmoji, setSelectedEmoji] = useState("✨");
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [customIcons, setCustomIcons] = useState({});

  // 🔥 Streetmap API States
  const [citySuggestions, setCitySuggestions] = useState([]);
  const [isCityLoading, setIsCityLoading] = useState(false);
  const [showCitySuggestions, setShowCitySuggestions] = useState(false);
  const searchTimeout = useRef(null);
  const cityInputRef = useRef(null);

  const [hotels, setHotels] = useState([]);
  const [loading, setLoading] = useState(true);
  const [statusConfirm, setStatusConfirm] = useState(null); 

  const [badgeOptions, setBadgeOptions] = useState([
    "Couple Friendly", "Flexible Check-in", "Room Upgrade",
    "Breakfast Available", "Airport Transfer", "Pet Friendly", "Parking", "Gym"
  ]);

  const fetchHotels = async () => {
    try {
      setLoading(true);
      const data = await api.getHotels();
      setHotels(data);
    } catch (error) {
      console.error("Failed to fetch hotels:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchHotels();
  }, []);

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
      image: hotel.image || [],
      price: hotel.price || "",
      state: hotel.state || "",
      pinCode: hotel.pinCode || "",
      city: hotel.city || ""
    });

    setEditingId(hotel.id);
    setShowAddForm(true);
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleCancel = () => {
    setFormData(initialFormState);
    setEditingId(null);
    setShowAddForm(false);
    setCitySuggestions([]);
    setShowCitySuggestions(false);
  };

  const handleCityChange = (e) => {
    const value = e.target.value;
    setFormData({ ...formData, city: value });

    if (searchTimeout.current) clearTimeout(searchTimeout.current);

    if (value.length > 2) {
      searchTimeout.current = setTimeout(() => {
        fetchCitySuggestions(value);
      }, 500);
    } else {
      setCitySuggestions([]);
      setShowCitySuggestions(false);
    }
  };

  const fetchCitySuggestions = async (query) => {
    setIsCityLoading(true);
    try {
      const response = await fetch(
        `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(query)}&format=json&addressdetails=1&limit=5&countrycodes=in`
      );
      const data = await response.json();
      setCitySuggestions(data);
      setShowCitySuggestions(data.length > 0);
    } catch (error) {
      console.error("Nominatim API Error:", error);
    } finally {
      setIsCityLoading(false);
    }
  };

  const selectCitySuggestion = (suggestion) => {
    const address = suggestion.address;
    const city = address.city || address.town || address.village || address.suburb || suggestion.display_name.split(',')[0];
    const state = address.state || "";
    const pinCode = address.postcode || "";
    
    setFormData(prev => ({
      ...prev,
      city: city,
      state: state,
      pinCode: pinCode,
      // Optional: Auto-fill location if it's a specific area
      location: prev.location || suggestion.display_name.split(',')[0]
    }));
    
    setCitySuggestions([]);
    setShowCitySuggestions(false);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingId) {
        const updatedHotel = await api.updateHotel(editingId, formData);
        setHotels(hotels.map(h => h.id === editingId ? updatedHotel : h));
      } else {
        const newHotel = await api.createHotel(formData);
        setHotels([newHotel, ...hotels]);
      }
      handleCancel();
    } catch (error) {
      console.error("Failed to save hotel:", error);
      alert("Error saving hotel: " + error.message);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this property? This action cannot be undone.")) {
      try {
        await api.deleteHotel(id);
        setHotels(hotels.filter(h => h.id !== id));
      } catch (error) {
        console.error("Failed to delete hotel:", error);
        alert("Error deleting hotel: " + error.message);
      }
    }
  };

  const getBadgeIcon = (badge) => {
    if (customIcons[badge]) {
        return <span style={{ fontSize: "14px", lineHeight: "1" }}>{customIcons[badge]}</span>;
    }
    switch (badge) {
      case "Couple Friendly": return <Heart size={14} color="#ef4444" fill="#ef4444" />;
      case "Breakfast Available": return <Coffee size={14} color="var(--accent)" />;
      case "Airport Transfer": return <Plane size={14} color="var(--accent)" />;
      case "Pet Friendly": return <Dog size={14} color="var(--accent)" />;
      case "Flexible Check-in": return <Clock size={14} color="var(--accent)" />;
      default: return <Sparkles size={14} color="var(--accent)" />;
    }
  };

  if (viewingHotel) {
    return <HotelDetail hotel={viewingHotel} onBack={() => setViewingHotel(null)} />;
  }

  if (viewingRoomsFor) {
    return <ManageRooms hotel={viewingRoomsFor} onBack={() => setViewingRoomsFor(null)} />;
  }

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

              {/* Property Location / Address */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Property Address / Landmark</p>
                <div style={{ position: "relative" }}>
                  <MapPin size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="e.g. Near Gateway of India, Colaba"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.location}
                    onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                    required
                  />
                </div>
              </div>

              {/* City — For Filtering */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "4px" }}>Search City (App Link)</p>
                <p style={{ fontSize: "11px", color: "var(--text-secondary)", marginBottom: "10px" }}>Use suggestions to ensure discoverability in user app.</p>
                <div style={{ position: "relative" }} ref={cityInputRef}>
                  <Navigation size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="Search city e.g. Mumbai"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.city}
                    onChange={handleCityChange}
                    onFocus={() => citySuggestions.length > 0 && setShowCitySuggestions(true)}
                    required
                  />
                  {isCityLoading && (
                    <div style={{ position: "absolute", right: "16px", top: "50%", transform: "translateY(-50%)" }}>
                      <div className="spinner-small"></div>
                    </div>
                  )}

                  {/* Suggestions Dropdown */}
                  <AnimatePresence>
                    {showCitySuggestions && (
                      <motion.div
                        initial={{ opacity: 0, y: 5 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: 5 }}
                        style={{
                          position: "absolute",
                          top: "100%",
                          left: 0,
                          right: 0,
                          zIndex: 100,
                          marginTop: "8px",
                          background: "rgba(255, 255, 255, 0.95)",
                          backdropFilter: "blur(10px)",
                          border: "1px solid var(--border)",
                          borderRadius: "12px",
                          boxShadow: "0 10px 25px rgba(0,0,0,0.1)",
                          overflow: "hidden"
                        }}
                      >
                        {citySuggestions.map((item, idx) => (
                          <div
                            key={idx}
                            onClick={() => selectCitySuggestion(item)}
                            style={{
                              padding: "12px 16px",
                              cursor: "pointer",
                              fontSize: "13px",
                              borderBottom: idx === citySuggestions.length - 1 ? "none" : "1px solid var(--border)",
                              transition: "background 0.2s"
                            }}
                            onMouseOver={e => e.currentTarget.style.background = "#f8fafc"}
                            onMouseOut={e => e.currentTarget.style.background = "transparent"}
                          >
                            <div style={{ fontWeight: "700", color: "var(--text-primary)" }}>
                                {item.address.city || item.address.town || item.address.village || item.display_name.split(',')[0]}
                            </div>
                            <div style={{ fontSize: "11px", color: "var(--text-secondary)", marginTop: "2px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                {item.display_name}
                            </div>
                          </div>
                        ))}
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              </div>


              {/* State */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>State</p>
                <div style={{ position: "relative" }}>
                  <MapPin size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="e.g. Maharashtra"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.state}
                    onChange={(e) => setFormData({ ...formData, state: e.target.value })}
                  />
                </div>
              </div>

              {/* Pin Code */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Pin Code</p>
                <div style={{ position: "relative" }}>
                  <MapPin size={18} style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)" }} />
                  <input
                    type="text"
                    placeholder="e.g. 400001"
                    style={{ width: "100%", paddingLeft: "48px", height: "52px" }}
                    value={formData.pinCode}
                    onChange={(e) => setFormData({ ...formData, pinCode: e.target.value })}
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

              {/* Base Price */}
              <div>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Base Price (per night)</p>
                <div style={{ position: "relative" }}>
                  <span style={{ position: "absolute", left: "16px", top: "50%", transform: "translateY(-50%)", color: "var(--text-secondary)", fontWeight: "700" }}>₹</span>
                  <input
                    type="number"
                    placeholder="e.g. 4500"
                    style={{ width: "100%", paddingLeft: "32px", height: "52px" }}
                    value={formData.price}
                    onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                  />
                </div>
              </div>

              {/* Landmark — 33% */}
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

              {/* Nearest Landmark — 33% */}
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

              {/* About The Hotel */}
              <div style={{ gridColumn: "span 3" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>About The Hotel</p>
                <textarea
                  placeholder="Describe the hotel's features, history, and unique selling points..."
                  style={{ width: "100%", padding: "16px", borderRadius: "12px", border: "1.5px solid var(--border)", background: "white", fontSize: "14px", minHeight: "120px", resize: "vertical", outline: "none" }}
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                />
              </div>

              {/* Reviews Section */}
              <div style={{ gridColumn: "span 3" }}>
                <p style={{ fontSize: "14px", fontWeight: "700", color: "var(--text-primary)", marginBottom: "10px" }}>Featured Reviews / Summary</p>
                <textarea
                  placeholder="Add featured customer reviews or a summary of guest experiences..."
                  style={{ width: "100%", padding: "16px", borderRadius: "12px", border: "1.5px solid var(--border)", background: "white", fontSize: "14px", minHeight: "100px", resize: "vertical", outline: "none" }}
                  value={formData.reviews}
                  onChange={(e) => setFormData({ ...formData, reviews: e.target.value })}
                />
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
                  <div style={{ display: "flex", gap: "8px", gridColumn: "span 2", position: "relative" }}>
                    <button
                      type="button"
                      onClick={() => setShowEmojiPicker(!showEmojiPicker)}
                      style={{ padding: "0 18px", borderRadius: "14px", border: "1.5px solid var(--border)", background: "white", cursor: "pointer", fontSize: "18px", display: "flex", alignItems: "center", justifyContent: "center" }}
                    >
                      {selectedEmoji}
                    </button>
                    {showEmojiPicker && (
                      <div style={{ position: "absolute", top: "100%", left: 0, marginTop: "8px", background: "white", border: "1px solid var(--border)", borderRadius: "12px", padding: "12px", display: "grid", gridTemplateColumns: "repeat(6, 1fr)", gap: "8px", zIndex: 10, boxShadow: "0 10px 25px rgba(0,0,0,0.1)" }}>
                        {availableEmojis.map(emoji => (
                          <div
                            key={emoji}
                            onClick={() => { setSelectedEmoji(emoji); setShowEmojiPicker(false); }}
                            style={{ cursor: "pointer", fontSize: "20px", textAlign: "center", padding: "4px", borderRadius: "8px", transition: "background 0.2s" }}
                            onMouseOver={e => e.currentTarget.style.background = "var(--bg-search)"}
                            onMouseOut={e => e.currentTarget.style.background = "transparent"}
                          >
                            {emoji}
                          </div>
                        ))}
                      </div>
                    )}
                    <input 
                      type="text" 
                      placeholder="Custom amenity..." 
                      value={newBadge}
                      onChange={(e) => setNewBadge(e.target.value)}
                      style={{ flex: 1, padding: "14px 18px", borderRadius: "14px", border: "1.5px solid var(--border)", fontSize: "14px", background: "white", outline: "none" }}
                    />
                    <button 
                      type="button"
                      onClick={() => {
                        const trimmed = newBadge.trim();
                        if (trimmed && !badgeOptions.includes(trimmed)) {
                          setBadgeOptions([...badgeOptions, trimmed]);
                          setFormData(prev => ({ ...prev, badges: [...prev.badges, trimmed] }));
                          setCustomIcons(prev => ({ ...prev, [trimmed]: selectedEmoji }));
                          setNewBadge("");
                        }
                      }}
                      style={{ padding: "0 24px", borderRadius: "14px", background: "var(--accent)", color: "white", border: "none", fontWeight: "700", display: "flex", alignItems: "center", gap: "8px", cursor: "pointer" }}
                    >
                      <Plus size={16} /> Add
                    </button>
                  </div>
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
                <tr style={{ background: "#f1f5f9" }}>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase" }}>ID</th>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase" }}>Name & Location</th>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase" }}>Rating</th>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase" }}>Rooms</th>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase" }}>Price</th>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase" }}>Status</th>
                    <th style={{ padding: "14px 20px", color: "var(--text-secondary)", fontWeight: "600", fontSize: "11px", textTransform: "uppercase", textAlign: "right" }}>Actions</th>
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
                    <td style={{ padding: "14px 20px", fontWeight: "600", color: "var(--text-secondary)", fontSize: "12px" }}>{hotel.id.slice(-6).toUpperCase()}</td>
                    <td style={{ padding: "14px 20px" }}>
                        <div style={{ fontWeight: "700", color: "var(--text-primary)", fontSize: "13px" }}>{hotel.name}</div>
                        <div style={{ fontSize: "11px", color: "var(--accent)", fontWeight: "700", marginBottom: "4px" }}>{hotel.city}</div>
                        <div style={{ fontSize: "11px", color: "var(--text-secondary)", display: "flex", alignItems: "center", gap: "4px" }}>
                            <MapPin size={10} /> {hotel.location}
                        </div>
                    </td>
                    <td style={{ padding: "14px 20px" }}>
                        <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                            <Star size={12} fill="#f59e0b" color="#f59e0b" />
                            <span style={{ fontWeight: "700", color: "var(--text-primary)", fontSize: "13px" }}>{hotel.rating}</span>
                        </div>
                        <div style={{ fontSize: "11px", color: "var(--text-secondary)" }}>{hotel.totalReviews} Reviews</div>
                    </td>
                    <td style={{ padding: "14px 20px" }}>
                        <div style={{ fontWeight: "600", color: "var(--text-primary)", fontSize: "13px" }}>{hotel.roomsCount} Rooms</div>
                        <div style={{ fontSize: "11px", color: "var(--text-secondary)" }}>Capacity</div>
                    </td>
                    <td style={{ padding: "14px 20px" }}>
                        <div style={{ fontWeight: "800", color: "var(--accent)", fontSize: "14px" }}>₹{hotel.price}</div>
                        <div style={{ fontSize: "11px", color: "var(--text-secondary)" }}>/ Night</div>
                    </td>
                    <td style={{ padding: "14px 20px" }}>
                        <button
                            onClick={() => {
                                const newStatus = hotel.status === "Active" ? "Inactive" : "Active";
                                if (newStatus === "Inactive") {
                                    setStatusConfirm({ hotelId: hotel.id, newStatus, hotelName: hotel.name });
                                } else {
                                    // Turning Active doesn't necessarily need confirmation, but we could add it if needed
                                    // For now, let's keep it simple as per request for "Active to Inactive"
                                    (async () => {
                                        try {
                                            await api.updateHotel(hotel.id, { status: "Active" });
                                            fetchHotels();
                                        } catch (error) {
                                            alert(error.message);
                                        }
                                    })();
                                }
                            }}
                            style={{ 
                                padding: "4px 8px", 
                                borderRadius: "10px", 
                                fontSize: "11px", 
                                fontWeight: "700",
                                background: hotel.status === "Inactive" ? "#f1f5f9" : (hotel.isSoldOut ? "#fee2e2" : "#dcfce7"),
                                color: hotel.status === "Inactive" ? "#64748b" : (hotel.isSoldOut ? "#ef4444" : "#16a34a"),
                                border: `1px solid ${hotel.status === "Inactive" ? "#e2e8f0" : (hotel.isSoldOut ? "#fecaca" : "#bbf7d0")}`,
                                cursor: "pointer",
                                transition: "all 0.2s"
                            }}
                        >
                            {hotel.status === "Inactive" ? "Inactive" : "Active"}
                        </button>
                    </td>
                    <td style={{ padding: "14px 20px", textAlign: "right" }}>
                        <div style={{ display: "flex", gap: "6px", justifyContent: "flex-end" }}>
                            <button
                                onClick={() => setViewingHotel(hotel)}
                                style={{ 
                                    background: "#eff6ff", 
                                    color: "#3b82f6", 
                                    border: "1px solid #3b82f630",
                                    borderRadius: "10px", 
                                    padding: "6px 10px", 
                                    fontWeight: "700", 
                                    cursor: "pointer",
                                    fontSize: "11px",
                                    display: "flex",
                                    alignItems: "center",
                                    gap: "4px"
                                }}
                            >
                                <Eye size={14} /> Preview
                            </button>
                            <button
                                onClick={() => setViewingRoomsFor(hotel)}
                                style={{ 
                                    background: "#fdf4ff", 
                                    color: "#c026d3", 
                                    border: "1px solid #c026d330",
                                    borderRadius: "10px", 
                                    padding: "6px 10px", 
                                    fontWeight: "700", 
                                    cursor: "pointer",
                                    fontSize: "11px",
                                    display: "flex",
                                    alignItems: "center",
                                    gap: "4px"
                                }}
                            >
                                <Bed size={14} /> Rooms
                            </button>
                            <button
                                onClick={() => handleEdit(hotel)}
                                style={{ 
                                    background: "white", 
                                    color: "var(--text-primary)", 
                                    border: "1px solid var(--border)",
                                    borderRadius: "10px", 
                                    padding: "6px 12px", 
                                    fontWeight: "700", 
                                    cursor: "pointer",
                                    fontSize: "11px"
                                }}
                            >
                                Configure
                            </button>
                            <button
                                onClick={() => handleDelete(hotel.id)}
                                style={{ 
                                    background: "#fee2e2", 
                                    color: "#ef4444", 
                                    border: "1px solid #fecaca",
                                    borderRadius: "10px", 
                                    padding: "6px 12px", 
                                    fontWeight: "700", 
                                    cursor: "pointer",
                                    fontSize: "11px",
                                    display: "flex",
                                    alignItems: "center",
                                    gap: "4px"
                                }}
                            >
                                <Trash2 size={14} /> Remove
                            </button>
                        </div>
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

      <AnimatePresence>
        {statusConfirm && (
          <div style={{
            position: "fixed",
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            background: "rgba(0,0,0,0.4)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            zIndex: 1000,
            backdropFilter: "blur(4px)"
          }}>
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              style={{
                background: "white",
                padding: "24px",
                borderRadius: "16px",
                maxWidth: "360px",
                width: "90%",
                boxShadow: "0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04)"
              }}
            >
              <h3 style={{ fontSize: "18px", fontWeight: "800", marginBottom: "12px", color: "var(--text-primary)" }}>Confirm Status Change</h3>
              <p style={{ fontSize: "14px", color: "var(--text-secondary)", marginBottom: "24px", lineHeight: "1.5" }}>
                Are you sure you want to inactive <strong>{statusConfirm.hotelName}</strong>? This property will no longer be visible to users.
              </p>
              <div style={{ display: "flex", gap: "12px" }}>
                <button
                  onClick={() => setStatusConfirm(null)}
                  style={{
                    flex: 1,
                    padding: "10px",
                    borderRadius: "10px",
                    border: "1px solid var(--border)",
                    background: "white",
                    fontWeight: "600",
                    cursor: "pointer",
                    fontSize: "14px"
                  }}
                >
                  Cancel
                </button>
                <button
                  onClick={async () => {
                    try {
                      await api.updateHotel(statusConfirm.hotelId, { status: statusConfirm.newStatus });
                      setStatusConfirm(null);
                      fetchHotels();
                    } catch (error) {
                      alert(error.message);
                    }
                  }}
                  style={{
                    flex: 1,
                    padding: "10px",
                    borderRadius: "10px",
                    border: "none",
                    background: "#ef4444",
                    color: "white",
                    fontWeight: "600",
                    cursor: "pointer",
                    fontSize: "14px"
                  }}
                >
                  Yes
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}