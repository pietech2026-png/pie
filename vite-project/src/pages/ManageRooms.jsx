import React, { useState, useEffect, useRef } from "react";
import { X, Plus, Save, Trash2, Bed, Maximize, Bath, Users, DollarSign, Clock, ClipboardList, ShieldCheck, Coffee, ImagePlus, Loader2, Sparkles, AlertCircle } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { api } from "../utils/api";

export default function ManageRooms({ hotel, onBack }) {
    const [rooms, setRooms] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showAddForm, setShowAddForm] = useState(false);
    const [editingRoom, setEditingRoom] = useState(null);
    const [submitting, setSubmitting] = useState(false);
    const fileInputRef = useRef(null);

    const initialFormState = {
        name: "",
        category: "Deluxe",
        size: "",
        bedsCount: 1,
        bedType: "King Bed",
        bathroomsCount: 1,
        basePrice: "",
        discountPrice: "",
        taxes: "",
        maxGuests: 2,
        amenities: [],
        cancellationPolicy: "Free Cancellation",
        mealPlan: "Breakfast only",
        details: "",
        about: "",
        planDetails: "",
        checkInTime: "14:00",
        checkOutTime: "11:00",
        images: [],
        availableCount: 1,
        status: "Available"
    };

    const [form, setForm] = useState(initialFormState);
    const [newAmenity, setNewAmenity] = useState("");

    useEffect(() => {
        fetchRooms();
    }, [hotel.id]);

    const fetchRooms = async () => {
        try {
            const data = await api.getRoomsByHotel(hotel.id);
            setRooms(data);
        } catch (error) {
            console.error("Failed to fetch rooms:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleImageUpload = (e) => {
        const files = Array.from(e.target.files);
        files.forEach(file => {
            const reader = new FileReader();
            reader.onloadend = () => {
                setForm(prev => ({
                    ...prev,
                    images: [...prev.images, reader.result]
                }));
            };
            reader.readAsDataURL(file);
        });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setSubmitting(true);
        try {
            if (editingRoom) {
                await api.updateRoom(editingRoom.id, form);
            } else {
                await api.createRoom(hotel.id, form);
            }
            setShowAddForm(false);
            setEditingRoom(null);
            setForm(initialFormState);
            fetchRooms();
        } catch (error) {
            alert(error.message);
        } finally {
            setSubmitting(false);
        }
    };

    const handleDelete = async (id) => {
        if (window.confirm("Are you sure you want to delete this room?")) {
            try {
                await api.deleteRoom(id);
                fetchRooms();
            } catch (error) {
                alert(error.message);
            }
        }
    };

    const toggleAmenity = (amenity) => {
        setForm(prev => ({
            ...prev,
            amenities: prev.amenities.includes(amenity)
                ? prev.amenities.filter(a => a !== amenity)
                : [...prev.amenities, amenity]
        }));
    };

    const addCustomAmenity = () => {
        if (newAmenity && !form.amenities.includes(newAmenity)) {
            setForm(prev => ({ ...prev, amenities: [...prev.amenities, newAmenity] }));
            setNewAmenity("");
        }
    };

    return (
        <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            style={{ 
                background: "#f8fafc", 
                position: "fixed", 
                top: 0, 
                left: 0, 
                width: "100vw", 
                height: "100vh", 
                zIndex: 9999, 
                display: "flex",
                flexDirection: "column",
                overflow: "hidden" // LOCK SCROLL
            }}
        >
            {/* Header */}
            <div style={{ background: "white", padding: "16px 40px", borderBottom: "1px solid var(--border)", display: "flex", justifyContent: "space-between", alignItems: "center", zIndex: 100 }}>
                <div style={{ display: "flex", alignItems: "center", gap: "24px" }}>
                    <button onClick={onBack} style={{ display: "flex", alignItems: "center", gap: "8px", background: "none", border: "none", color: "#64748b", fontWeight: "700", cursor: "pointer", fontSize: "15px" }}>
                        <X size={20} /> Back to Hotels
                    </button>
                    <div style={{ padding: "0 1px", height: "24px", background: "var(--border)" }} />
                    <div style={{ display: "flex", flexDirection: "column" }}>
                        <span style={{ fontSize: "16px", fontWeight: "800", color: "var(--text-primary)" }}>Manage Rooms - {hotel.name}</span>
                        <span style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{hotel.location}</span>
                    </div>
                </div>
                <button 
                    onClick={() => {
                        setShowAddForm(true);
                        setEditingRoom(null);
                        setForm(initialFormState);
                    }}
                    style={{ background: "var(--accent)", color: "white", padding: "10px 20px", border: "none", borderRadius: "10px", fontWeight: "700", display: "flex", alignItems: "center", gap: "8px" }}
                >
                    <Plus size={18} /> Add New Room
                </button>
            </div>

            {/* Content Area */}
            <div style={{ flex: 1, padding: "32px 40px", overflow: "hidden", display: "flex", gap: "24px" }}>
                
                {/* Room List (Dynamic Height) */}
                <div style={{ flex: 1, background: "white", borderRadius: "20px", border: "1px solid var(--border)", overflow: "hidden", display: "flex", flexDirection: "column" }}>
                    <div style={{ padding: "20px 24px", borderBottom: "1px solid var(--border)", background: "#f8fafc" }}>
                        <h3 style={{ fontSize: "15px", fontWeight: "800", color: "var(--text-primary)" }}>Existing Room Types ({rooms.length})</h3>
                    </div>
                    
                    <div style={{ flex: 1, overflowY: "auto", padding: "20px" }}>
                        {loading ? (
                            <div style={{ height: "100%", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: "12px", color: "var(--text-secondary)" }}>
                                <Loader2 className="animate-spin" size={32} />
                                <span style={{ fontWeight: "600" }}>Loading rooms...</span>
                            </div>
                        ) : rooms.length === 0 ? (
                            <div style={{ height: "100%", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: "12px", color: "var(--text-secondary)", opacity: 0.6 }}>
                                <Bed size={48} />
                                <span style={{ fontWeight: "600" }}>No rooms added yet. Create your first room type.</span>
                            </div>
                        ) : (
                            <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))", gap: "20px" }}>
                                {rooms.map(room => (
                                    <motion.div 
                                        key={room.id}
                                        layoutId={room.id}
                                        style={{ background: "white", borderRadius: "16px", border: "1px solid var(--border)", padding: "16px", display: "flex", gap: "16px" }}
                                    >
                                        <div style={{ width: "100px", height: "100px", borderRadius: "12px", background: "#f1f5f9", overflow: "hidden", flexShrink: 0 }}>
                                            {room.images?.[0] ? (
                                                <img src={room.images[0]} style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                                            ) : (
                                                <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", color: "#94a3b8" }}>
                                                    <ImagePlus size={24} />
                                                </div>
                                            )}
                                        </div>
                                        <div style={{ flex: 1, display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
                                            <div>
                                                <h4 style={{ fontSize: "14px", fontWeight: "800", color: "var(--text-primary)", marginBottom: "4px" }}>{room.name}</h4>
                                                <div style={{ display: "flex", gap: "8px", flexWrap: "wrap", marginBottom: "8px", alignItems: "center" }}>
                                                    <span style={{ fontSize: "10px", fontWeight: "700", background: "#f1f5f9", padding: "2px 8px", borderRadius: "6px", color: "#64748b" }}>{room.category}</span>
                                                    <span style={{ fontSize: "10px", fontWeight: "700", background: "#fdf4ff", padding: "2px 8px", borderRadius: "6px", color: "#c026d3" }}>{room.bedType}</span>
                                                    <span style={{ 
                                                        fontSize: "10px", 
                                                        fontWeight: "800", 
                                                        background: room.status === "Sold Out" ? "#f1f5f9" : (room.isSoldOut ? "#fee2e2" : "#dcfce7"), 
                                                        padding: "2px 8px", 
                                                        borderRadius: "6px", 
                                                        color: room.status === "Sold Out" ? "#64748b" : (room.isSoldOut ? "#ef4444" : "#16a34a"),
                                                        textTransform: "uppercase"
                                                    }}>
                                                        {room.status === "Sold Out" ? "Inactive" : "Active"}
                                                    </span>
                                                </div>
                                                <div style={{ fontSize: "14px", fontWeight: "800", color: "var(--accent)" }}>₹{room.basePrice} <span style={{ fontSize: "11px", fontWeight: "600", color: "var(--text-secondary)" }}>/ Night</span></div>
                                            </div>
                                            <div style={{ display: "flex", gap: "8px", marginTop: "12px" }}>
                                                <button 
                                                    onClick={() => {
                                                        setEditingRoom(room);
                                                        setForm(room);
                                                        setShowAddForm(true);
                                                    }}
                                                    style={{ flex: 1, padding: "6px", background: "var(--bg-search)", border: "1px solid var(--border)", borderRadius: "8px", fontSize: "12px", fontWeight: "700", cursor: "pointer" }}
                                                >
                                                    Edit
                                                </button>
                                                <button 
                                                    onClick={async () => {
                                                        const newStatus = room.status === "Sold Out" ? "Available" : "Sold Out";
                                                        try {
                                                            await api.updateRoom(room.id, { status: newStatus });
                                                            fetchRooms();
                                                        } catch (error) {
                                                            alert(error.message);
                                                        }
                                                    }}
                                                    style={{ 
                                                        flex: 1,
                                                        padding: "6px", 
                                                        background: room.status === "Sold Out" ? "#dcfce7" : "#f1f5f9", 
                                                        border: `1px solid ${room.status === "Sold Out" ? "#bbf7d0" : "#e2e8f0"}`, 
                                                        color: room.status === "Sold Out" ? "#16a34a" : "#64748b", 
                                                        borderRadius: "8px", 
                                                        fontSize: "12px",
                                                        fontWeight: "700",
                                                        cursor: "pointer" 
                                                    }}
                                                >
                                                    {room.status === "Sold Out" ? "Set Active" : "Set Inactive"}
                                                </button>
                                                <button 
                                                    onClick={() => handleDelete(room.id)}
                                                    style={{ padding: "6px", background: "#fee2e2", border: "1px solid #fecaca", color: "#ef4444", borderRadius: "8px", cursor: "pointer" }}
                                                >
                                                    <Trash2 size={16} />
                                                </button>
                                            </div>
                                        </div>
                                    </motion.div>
                                ))}
                            </div>
                        )}
                    </div>
                </div>

                {/* Add/Edit Form Overlay (Conditional) */}
                <AnimatePresence>
                    {showAddForm && (
                        <motion.div 
                            initial={{ x: 400, opacity: 0 }}
                            animate={{ x: 0, opacity: 1 }}
                            exit={{ x: 400, opacity: 0 }}
                            style={{ 
                                width: "900px", 
                                background: "white", 
                                borderRadius: "20px", 
                                borderLeft: "1px solid var(--border)", 
                                boxShadow: "-10px 0 30px rgba(0,0,0,0.05)",
                                display: "flex",
                                flexDirection: "column",
                                position: "relative"
                            }}
                        >
                            <div style={{ padding: "24px 32px", borderBottom: "1px solid var(--border)", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                                <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
                                    <div style={{ background: "var(--accent-light)", color: "var(--accent)", padding: "10px", borderRadius: "12px" }}>
                                        <Bed size={20} />
                                    </div>
                                    <h3 style={{ fontSize: "18px", fontWeight: "800", color: "var(--text-primary)" }}>{editingRoom ? "Edit Room Type" : "Add New Room Type"}</h3>
                                </div>
                                <button onClick={() => setShowAddForm(false)} style={{ background: "none", border: "none", color: "#94a3b8", cursor: "pointer" }}><X size={24} /></button>
                            </div>

                            <form onSubmit={handleSubmit} style={{ flex: 1, padding: "32px", overflowY: "auto" }}>
                                <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr 1fr", gap: "24px" }}>
                                    
                                    {/* Column 1: Basic Info */}
                                    <div style={{ display: "flex", flexDirection: "column", gap: "20px" }}>
                                        <div style={{ borderBottom: "2px solid #f1f5f9", paddingBottom: "10px", marginBottom: "4px" }}>
                                            <span style={{ fontSize: "11px", fontWeight: "800", color: "var(--accent)", textTransform: "uppercase", letterSpacing: "1px" }}>Basic Info</span>
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Room Name / Title</label>
                                            <input value={form.name} onChange={e => setForm({...form, name: e.target.value})} placeholder="e.g. Premium Suite with City View" required style={{ width: "100%" }} />
                                        </div>
                                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Category</label>
                                                <select value={form.category} onChange={e => setForm({...form, category: e.target.value})} style={{ width: "100%" }}>
                                                    <option>Deluxe</option>
                                                    <option>Super Deluxe</option>
                                                    <option>Premium Suite</option>
                                                    <option>Executive</option>
                                                </select>
                                            </div>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Room Size</label>
                                                <input value={form.size} onChange={e => setForm({...form, size: e.target.value})} placeholder="420 sq.ft" style={{ width: "100%" }} />
                                            </div>
                                        </div>
                                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Bed Type</label>
                                                <input value={form.bedType} onChange={e => setForm({...form, bedType: e.target.value})} placeholder="King Bed" style={{ width: "100%" }} />
                                            </div>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>No of Beds</label>
                                                <input type="number" value={form.bedsCount} onChange={e => setForm({...form, bedsCount: e.target.value})} style={{ width: "100%" }} />
                                            </div>
                                        </div>
                                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>No of Bathrooms</label>
                                                <input type="number" value={form.bathroomsCount} onChange={e => setForm({...form, bathroomsCount: e.target.value})} style={{ width: "100%" }} />
                                            </div>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Max Guests</label>
                                                <input type="number" value={form.maxGuests} onChange={e => setForm({...form, maxGuests: e.target.value})} style={{ width: "100%" }} />
                                            </div>
                                        </div>
                                    </div>

                                    {/* Column 2: Pricing & Policies */}
                                    <div style={{ display: "flex", flexDirection: "column", gap: "20px" }}>
                                        <div style={{ borderBottom: "2px solid #f1f5f9", paddingBottom: "10px", marginBottom: "4px" }}>
                                            <span style={{ fontSize: "11px", fontWeight: "800", color: "var(--accent)", textTransform: "uppercase", letterSpacing: "1px" }}>Pricing & Policies</span>
                                        </div>
                                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Base Price (₹)</label>
                                                <input type="number" value={form.basePrice} onChange={e => setForm({...form, basePrice: e.target.value})} placeholder="4353" required style={{ width: "100%" }} />
                                            </div>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Discount Price (₹)</label>
                                                <input type="number" value={form.discountPrice} onChange={e => setForm({...form, discountPrice: e.target.value})} placeholder="3999" style={{ width: "100%" }} />
                                            </div>
                                        </div>
                                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px", marginTop: "12px" }}>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Taxes (₹)</label>
                                                <input type="number" value={form.taxes} onChange={e => setForm({...form, taxes: e.target.value})} placeholder="759" style={{ width: "100%" }} />
                                            </div>
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Meal Plan</label>
                                            <select value={form.mealPlan} onChange={e => setForm({...form, mealPlan: e.target.value})} style={{ width: "100%" }}>
                                                <option>Room Only</option>
                                                <option>Breakfast only</option>
                                                <option>Breakfast + Lunch</option>
                                                <option>All Meals Included</option>
                                            </select>
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Cancellation Policy</label>
                                            <input value={form.cancellationPolicy} onChange={e => setForm({...form, cancellationPolicy: e.target.value})} placeholder="Free Cancellation till 25 Mar" style={{ width: "100%" }} />
                                        </div>
                                        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px" }}>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Check-in</label>
                                                <input type="time" value={form.checkInTime} onChange={e => setForm({...form, checkInTime: e.target.value})} style={{ width: "100%" }} />
                                            </div>
                                            <div className="input-group">
                                                <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Check-out</label>
                                                <input type="time" value={form.checkOutTime} onChange={e => setForm({...form, checkOutTime: e.target.value})} style={{ width: "100%" }} />
                                            </div>
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Extra Amenities (Airport, WiFi, etc)</label>
                                            <div style={{ display: "flex", gap: "8px", marginBottom: "8px" }}>
                                                <input value={newAmenity} onChange={e => setNewAmenity(e.target.value)} placeholder="Add amenity..." style={{ flex: 1 }} onKeyPress={e => e.key === 'Enter' && (e.preventDefault(), addCustomAmenity())} />
                                                <button type="button" onClick={addCustomAmenity} style={{ background: "var(--accent)", color: "white", padding: "8px 12px", border: "none", borderRadius: "8px" }}><Plus size={16} /></button>
                                            </div>
                                            <div style={{ display: "flex", flexWrap: "wrap", gap: "6px" }}>
                                                {form.amenities.map(a => (
                                                    <span key={a} style={{ background: "#f1f5f9", padding: "4px 10px", borderRadius: "8px", fontSize: "11px", fontWeight: "700", display: "flex", alignItems: "center", gap: "4px" }}>
                                                        {a} <X size={10} onClick={() => toggleAmenity(a)} style={{ cursor: "pointer" }} />
                                                    </span>
                                                ))}
                                            </div>
                                        </div>
                                    </div>

                                    {/* Column 3: Gallery & Details */}
                                    <div style={{ display: "flex", flexDirection: "column", gap: "20px" }}>
                                        <div style={{ borderBottom: "2px solid #f1f5f9", paddingBottom: "10px", marginBottom: "4px" }}>
                                            <span style={{ fontSize: "11px", fontWeight: "800", color: "var(--accent)", textTransform: "uppercase", letterSpacing: "1px" }}>Gallery & Details</span>
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Room Images</label>
                                            <div 
                                                onClick={() => fileInputRef.current?.click()}
                                                style={{ border: "2px dashed var(--border)", borderRadius: "16px", padding: "20px", textAlign: "center", cursor: "pointer", transition: "all 0.2s" }}
                                                onMouseOver={e => e.currentTarget.style.borderColor = "var(--accent)"}
                                                onMouseOut={e => e.currentTarget.style.borderColor = "var(--border)"}
                                            >
                                                <ImagePlus size={24} style={{ color: "var(--accent)", marginBottom: "8px" }} />
                                                <div style={{ fontSize: "12px", fontWeight: "700" }}>Upload Photos</div>
                                                <div style={{ fontSize: "10px", color: "var(--text-secondary)" }}>Drag or click here</div>
                                                <input type="file" multiple hidden ref={fileInputRef} onChange={handleImageUpload} accept="image/*" />
                                            </div>
                                            {form.images.length > 0 && (
                                                <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: "8px", marginTop: "12px" }}>
                                                    {form.images.map((img, i) => (
                                                        <div key={i} style={{ aspectRatio: "1/1", borderRadius: "8px", overflow: "hidden", position: "relative" }}>
                                                            <img src={img} style={{ width: "100%", height: "100%", objectFit: "cover" }} />
                                                            <button 
                                                                type="button"
                                                                onClick={() => setForm(prev => ({ ...prev, images: prev.images.filter((_, idx) => idx !== i) }))}
                                                                style={{ position: "absolute", top: "2px", right: "2px", background: "rgba(0,0,0,0.5)", color: "white", border: "none", borderRadius: "4px", padding: "2px" }}
                                                            >
                                                                <X size={10} />
                                                            </button>
                                                        </div>
                                                    ))}
                                                </div>
                                            )}
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>About Room Details</label>
                                            <textarea value={form.about} onChange={e => setForm({...form, about: e.target.value})} placeholder="Detailed description of the room..." rows={3} style={{ width: "100%", borderRadius: "12px", border: "1px solid var(--border)", padding: "10px", fontSize: "13px" }} />
                                        </div>
                                        <div className="input-group">
                                            <label style={{ fontSize: "12px", fontWeight: "700", color: "var(--text-secondary)", marginBottom: "8px", display: "block" }}>Plan Details</label>
                                            <textarea value={form.planDetails} onChange={e => setForm({...form, planDetails: e.target.value})} placeholder="Membership or meal plan specifics..." rows={2} style={{ width: "100%", borderRadius: "12px", border: "1px solid var(--border)", padding: "10px", fontSize: "13px" }} />
                                        </div>
                                    </div>

                                </div>

                                {/* Form Actions */}
                                <div style={{ display: "flex", gap: "16px", marginTop: "40px", borderTop: "1px solid var(--border)", paddingTop: "24px" }}>
                                    <button 
                                        type="submit" 
                                        disabled={submitting}
                                        style={{ flex: 1, background: "var(--accent)", color: "white", padding: "14px", border: "none", borderRadius: "12px", fontWeight: "800", fontSize: "14px", display: "flex", alignItems: "center", justifyContent: "center", gap: "8px" }}
                                    >
                                        {submitting ? <Loader2 className="animate-spin" size={18} /> : <Save size={18} />}
                                        {editingRoom ? "Save Room Changes" : "Confirm & Create Room Type"}
                                    </button>
                                    <button 
                                        type="button" 
                                        onClick={() => setShowAddForm(false)}
                                        style={{ background: "#f1f5f9", color: "#64748b", padding: "14px 24px", border: "none", borderRadius: "12px", fontWeight: "700" }}
                                    >
                                        Cancel
                                    </button>
                                </div>
                            </form>
                        </motion.div>
                    )}
                </AnimatePresence>

            </div>
        </motion.div>
    );
}
