import React, { useState, useEffect } from "react";
import { Calendar, User, MapPin, Clock, MoreVertical, CheckCircle, ArrowRight, Loader2, XCircle } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { api } from "../utils/api";

export default function UpcomingBookings() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedBooking, setSelectedBooking] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState({});
  const [isSaving, setIsSaving] = useState(false);

  const fetchBookings = async () => {
    try {
      setLoading(true);
      const data = await api.getBookings();
      // Filter for upcoming/confirmed bookings
      const upcoming = (Array.isArray(data) ? data : []).filter(
        b => b.status === "Upcoming" || b.status === "Confirmed"
      );
      setBookings(upcoming);
    } catch (error) {
      console.error("Failed to fetch upcoming bookings:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
  }, []);

  const handleCancel = async (id) => {
    if (!window.confirm("Are you sure you want to cancel this booking?")) return;
    try {
      await api.cancelBooking(id);
      await fetchBookings();
    } catch (error) {
      alert("Failed to cancel booking: " + error.message);
    }
  };

  const handleEditStart = () => {
    setEditForm({
      checkIn: selectedBooking.checkIn ? selectedBooking.checkIn.substring(0, 10) : "",
      checkOut: selectedBooking.checkOut ? selectedBooking.checkOut.substring(0, 10) : "",
      totalPrice: selectedBooking.totalPrice || 0,
      guests: selectedBooking.guests || 2,
      guestName: selectedBooking.guestName || selectedBooking.user?.name || "",
      guestPhone: selectedBooking.guestPhone || selectedBooking.user?.phone || "",
      guestEmail: selectedBooking.guestEmail || selectedBooking.user?.email || "",
      specialRequests: selectedBooking.specialRequests || "",
      status: selectedBooking.status
    });
    setIsEditing(true);
  };

  const handleUpdate = async () => {
    try {
      setIsSaving(true);
      await api.updateBooking(selectedBooking._id, editForm);
      await fetchBookings();
      setSelectedBooking(prev => ({ ...prev, ...editForm }));
      setIsEditing(false);
      alert("Booking updated successfully!");
    } catch (error) {
      alert("Failed to update booking: " + error.message);
    } finally {
      setIsSaving(false);
    }
  };

  if (loading) {
    return (
      <div style={{ padding: "100px", textAlign: "center", color: "var(--text-secondary)" }}>
        <Loader2 size={40} className="animate-spin" style={{ margin: "0 auto 16px" }} />
        <p>Loading upcoming stays...</p>
      </div>
    );
  }

  return (
    <div style={{ maxWidth: "1200px", margin: "0 auto" }}>
      <div style={{ marginBottom: "32px", display: "flex", justifyContent: "space-between", alignItems: "flex-end" }}>
        <div>
          <h1 style={{ fontSize: "28px", fontWeight: "700", marginBottom: "8px" }}>Upcoming Bookings</h1>
          <p style={{ color: "var(--text-secondary)" }}>Track all confirmed stays scheduled for today and future dates</p>
        </div>
        <div style={{ fontSize: "14px", fontWeight: "600", color: "var(--accent)" }}>
          {bookings.length} Total Bookings
        </div>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "24px" }}>
        <AnimatePresence>
          {bookings.length > 0 ? bookings.map((booking, i) => (
            <motion.div
              key={booking._id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              transition={{ delay: i * 0.05 }}
              className="glass-card"
              style={{ padding: "24px", position: "relative", overflow: "hidden", background: "white", border: "1px solid var(--border)" }}
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
                {booking.status.toUpperCase()}
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
                  <h3 style={{ fontSize: "18px", fontWeight: "700", marginBottom: "4px" }}>{booking.user?.name || "Guest"}</h3>
                  <div style={{ display: "flex", alignItems: "center", gap: "6px", color: "var(--text-secondary)", fontSize: "14px", marginBottom: "16px" }}>
                    <MapPin size={14} />
                    {booking.hotel?.name || "Unknown Property"}
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
                      <p style={{ fontSize: "14px", fontWeight: "600" }}>{booking.checkIn ? new Date(booking.checkIn).toLocaleDateString() : "N/A"}</p>
                    </div>
                    <ArrowRight size={16} color="var(--text-secondary)" />
                    <div>
                      <p style={{ fontSize: "11px", color: "var(--text-secondary)", textTransform: "uppercase", fontWeight: "700", marginBottom: "4px" }}>Check Out</p>
                      <p style={{ fontSize: "14px", fontWeight: "600" }}>{booking.checkOut ? new Date(booking.checkOut).toLocaleDateString() : "N/A"}</p>
                    </div>
                  </div>

                  <div style={{ marginTop: "16px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <div style={{ display: "flex", flexDirection: "column", gap: "4px" }}>
                      <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                        <CheckCircle size={14} color="#10b981" />
                        <span style={{ fontSize: "13px", fontWeight: "600", color: "var(--text-primary)" }}>{booking.room?.type || "Standard Room"}</span>
                      </div>
                      <div style={{ fontSize: "14px", fontWeight: "700", color: "var(--accent)", marginLeft: "22px" }}>
                        ₹{booking.totalPrice?.toLocaleString()}
                      </div>
                    </div>

                    <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: "8px" }}>
                      <div style={{ 
                        padding: "4px 10px", 
                        borderRadius: "20px", 
                        fontSize: "11px", 
                        fontWeight: "700", 
                        textTransform: "uppercase",
                        background: booking.source === "admin" ? "#e0f2fe" : "#f0fdf4",
                        color: booking.source === "admin" ? "#0369a1" : "#166534",
                        border: `1px solid ${booking.source === "admin" ? "#bae6fd" : "#bbf7d0"}`
                      }}>
                        {booking.source === "admin" ? "Admin Booking" : "User App"}
                      </div>
                      <div style={{ display: "flex", gap: "12px" }}>
                        <button 
                          onClick={() => handleCancel(booking._id)}
                          style={{ background: "transparent", border: "none", color: "#ef4444", fontSize: "12px", fontWeight: "600", display: "flex", alignItems: "center", gap: "4px", padding: 0 }}
                        >
                          <XCircle size={14} />
                          Cancel
                        </button>
                        <button 
                          onClick={() => {
                            setSelectedBooking(booking);
                            setIsEditing(false);
                          }}
                          style={{ background: "transparent", border: "none", color: "var(--accent)", fontSize: "12px", fontWeight: "600", padding: 0 }}
                        >
                          View Details
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>
          )) : (
            <div style={{ gridColumn: "span 2", padding: "100px", textAlign: "center", color: "var(--text-secondary)" }}>
              <p>No upcoming bookings found.</p>
            </div>
          )}
        </AnimatePresence>
      </div>

      {/* Booking Detail Modal */}
      <AnimatePresence>
        {selectedBooking && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setSelectedBooking(null)}
              style={{
                position: "fixed",
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                background: "rgba(15, 23, 42, 0.4)",
                backdropFilter: "blur(8px)",
                zIndex: 1000,
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                padding: "20px"
              }}
            >
              <motion.div
                initial={{ opacity: 0, scale: 0.9, y: 20 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.9, y: 20 }}
                onClick={(e) => e.stopPropagation()}
                style={{
                  width: "100%",
                  maxWidth: "600px",
                  background: "white",
                  borderRadius: "24px",
                  overflow: "hidden",
                  boxShadow: "0 25px 50px -12px rgba(0, 0, 0, 0.25)"
                }}
              >
                {/* Modal Header */}
                <div style={{ 
                  padding: "24px 32px", 
                  background: "var(--bg-search)", 
                  borderBottom: "1px solid var(--border)",
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center"
                }}>
                  <div>
                    <h2 style={{ fontSize: "20px", fontWeight: "800", color: "var(--text-primary)" }}>Booking Reference</h2>
                    <p style={{ fontSize: "12px", color: "var(--text-secondary)", marginTop: "2px", fontWeight: "600" }}>
                      ID: {selectedBooking._id.toUpperCase()}
                    </p>
                  </div>
                  <div style={{ display: "flex", gap: "12px", alignItems: "center" }}>
                    {!isEditing && (
                      <button 
                        onClick={handleEditStart}
                        style={{ background: "white", border: "1px solid var(--accent)", borderRadius: "12px", padding: "8px 16px", color: "var(--accent)", fontSize: "14px", fontWeight: "700" }}
                      >
                        Edit
                      </button>
                    )}
                    <button 
                      onClick={() => {
                        setSelectedBooking(null);
                        setIsEditing(false);
                      }}
                      style={{ background: "white", border: "1px solid var(--border)", borderRadius: "12px", padding: "8px", color: "var(--text-secondary)" }}
                    >
                      <XCircle size={20} />
                    </button>
                  </div>
                </div>

                {/* Modal Content */}
                <div style={{ padding: "32px", display: "flex", flexDirection: "column", gap: "28px" }}>
                  
                  {/* Guest & Hotel Section */}
                  <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "24px" }}>
                    <div>
                      <p style={{ fontSize: "11px", fontWeight: "700", color: "var(--text-secondary)", textTransform: "uppercase", marginBottom: "8px" }}>Guest Details</p>
                      <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                        <div style={{ width: "36px", height: "36px", background: "var(--accent-light)", borderRadius: "10px", display: "flex", alignItems: "center", justifyCenter: "center", color: "var(--accent)" }}>
                           <User size={18} style={{ margin: "0 auto" }} />
                        </div>
                        <div style={{ flex: 1 }}>
                          {isEditing ? (
                            <input 
                              type="text"
                              value={editForm.guestName}
                              onChange={(e) => setEditForm({ ...editForm, guestName: e.target.value })}
                              style={{ width: "100%", padding: "4px 8px", borderRadius: "4px", border: "1px solid var(--border)", fontSize: "14px", fontWeight: "600" }}
                              placeholder="Name"
                            />
                          ) : (
                            <p style={{ fontSize: "15px", fontWeight: "700" }}>{selectedBooking.guestName || selectedBooking.user?.name || "N/A"}</p>
                          )}
                          {isEditing ? (
                            <input 
                              type="text"
                              value={editForm.guestPhone}
                              onChange={(e) => setEditForm({ ...editForm, guestPhone: e.target.value })}
                              style={{ width: "100%", padding: "4px 8px", borderRadius: "4px", border: "1px solid var(--border)", fontSize: "12px", marginTop: "4px" }}
                              placeholder="Phone"
                            />
                          ) : (
                            <p style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{selectedBooking.guestPhone || selectedBooking.user?.phone || "No Phone"}</p>
                          )}
                        </div>
                      </div>
                    </div>
                    <div>
                      <p style={{ fontSize: "11px", fontWeight: "700", color: "var(--text-secondary)", textTransform: "uppercase", marginBottom: "8px" }}>Property</p>
                      <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                        <div style={{ width: "36px", height: "36px", background: "#f0fdf4", borderRadius: "10px", display: "flex", alignItems: "center", justifyCenter: "center", color: "#166534" }}>
                           <MapPin size={18}  style={{ margin: "0 auto" }} />
                        </div>
                        <div>
                          <p style={{ fontSize: "15px", fontWeight: "700" }}>{selectedBooking.hotel?.name || "N/A"}</p>
                          <p style={{ fontSize: "12px", color: "var(--text-secondary)" }}>{selectedBooking.hotel?.location || "N/A"}</p>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Stay Details Section */}
                  <div style={{ background: "var(--bg-search)", borderRadius: "16px", padding: "20px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <div style={{ textAlign: "center", flex: 1 }}>
                      <p style={{ fontSize: "10px", fontWeight: "700", color: "var(--text-secondary)", textTransform: "uppercase", marginBottom: "4px" }}>Check In</p>
                      {isEditing ? (
                        <input 
                          type="date"
                          value={editForm.checkIn}
                          onChange={(e) => setEditForm({ ...editForm, checkIn: e.target.value })}
                          style={{ width: "100%", padding: "4px", borderRadius: "4px", border: "1px solid var(--border)", fontSize: "14px", fontWeight: "700", textAlign: "center" }}
                        />
                      ) : (
                        <p style={{ fontSize: "15px", fontWeight: "700" }}>{new Date(selectedBooking.checkIn).toLocaleDateString()}</p>
                      )}
                      <p style={{ fontSize: "11px", color: "var(--text-secondary)" }}>14:00 PM</p>
                    </div>
                    <ArrowRight size={20} color="var(--border)" />
                    <div style={{ textAlign: "center", flex: 1 }}>
                      <p style={{ fontSize: "10px", fontWeight: "700", color: "var(--text-secondary)", textTransform: "uppercase", marginBottom: "4px" }}>Check Out</p>
                      {isEditing ? (
                        <input 
                          type="date"
                          value={editForm.checkOut}
                          onChange={(e) => setEditForm({ ...editForm, checkOut: e.target.value })}
                          style={{ width: "100%", padding: "4px", borderRadius: "4px", border: "1px solid var(--border)", fontSize: "14px", fontWeight: "700", textAlign: "center" }}
                        />
                      ) : (
                        <p style={{ fontSize: "15px", fontWeight: "700" }}>{new Date(selectedBooking.checkOut).toLocaleDateString()}</p>
                      )}
                      <p style={{ fontSize: "11px", color: "var(--text-secondary)" }}>11:00 AM</p>
                    </div>
                  </div>

                  {/* Room & Payment Section */}
                  <div style={{ display: "grid", gridTemplateColumns: "1.5fr 1fr", gap: "24px" }}>
                    <div style={{ border: "1px solid var(--border)", borderRadius: "16px", padding: "16px" }}>
                       <p style={{ fontSize: "11px", fontWeight: "700", color: "var(--text-secondary)", textTransform: "uppercase", marginBottom: "12px" }}>Room Information</p>
                       <div style={{ display: "flex", justifyContent: "space-between", marginBottom: "8px" }}>
                          <span style={{ fontSize: "13px", fontWeight: "600", color: "var(--text-primary)" }}>Room Type</span>
                          <span style={{ fontSize: "13px", fontWeight: "700", color: "var(--accent)" }}>{selectedBooking.room?.type || "Standard"}</span>
                       </div>
                       <div style={{ display: "flex", justifyContent: "space-between" }}>
                          <span style={{ fontSize: "13px", fontWeight: "600", color: "var(--text-primary)" }}>Guests</span>
                          {isEditing ? (
                             <input 
                               type="number"
                               value={editForm.guests}
                               onChange={(e) => setEditForm({ ...editForm, guests: Number(e.target.value) })}
                               style={{ width: "60px", padding: "2px 6px", borderRadius: "4px", border: "1px solid var(--border)", fontSize: "13px", fontWeight: "700", color: "var(--accent)" }}
                             />
                          ) : (
                             <span style={{ fontSize: "13px", fontWeight: "700" }}>{selectedBooking.guests || 2} Persons</span>
                          )}
                       </div>
                    </div>
                    <div style={{ border: "1px solid var(--border)", borderRadius: "16px", padding: "16px", background: "var(--accent-light)" }}>
                       <p style={{ fontSize: "11px", fontWeight: "700", color: "var(--accent)", textTransform: "uppercase", marginBottom: "12px" }}>Total Amount</p>
                       {isEditing ? (
                          <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                            <span style={{ fontSize: "20px", fontWeight: "800", color: "var(--accent)" }}>₹</span>
                            <input 
                              type="number"
                              value={editForm.totalPrice}
                              onChange={(e) => setEditForm({ ...editForm, totalPrice: Number(e.target.value) })}
                              style={{ width: "100%", padding: "4px 8px", borderRadius: "6px", border: "1px solid var(--border)", fontSize: "20px", fontWeight: "800", color: "var(--accent)", background: "white" }}
                            />
                          </div>
                       ) : (
                          <h3 style={{ fontSize: "24px", fontWeight: "800", color: "var(--accent)" }}>₹{selectedBooking.totalPrice?.toLocaleString()}</h3>
                       )}
                       <p style={{ fontSize: "11px", color: "var(--accent)", fontWeight: "600", marginTop: "4px" }}>Paid via {selectedBooking.source === "admin" ? "Admin Panel" : "Mobile App"}</p>
                    </div>
                  </div>

                  {/* Special Requests */}
                  <div style={{ borderLeft: "4px solid var(--accent)", padding: "12px 16px", background: "#f8fafc" }}>
                    <p style={{ fontSize: "11px", fontWeight: "800", color: "var(--text-primary)", marginBottom: "4px", textTransform: "uppercase" }}>Special Requests / Notes</p>
                    {isEditing ? (
                       <textarea 
                         value={editForm.specialRequests}
                         onChange={(e) => setEditForm({ ...editForm, specialRequests: e.target.value })}
                         style={{ width: "100%", padding: "8px", borderRadius: "8px", border: "1px solid var(--border)", fontSize: "13px", minHeight: "60px", background: "white" }}
                         placeholder="Add special requests..."
                       />
                    ) : (
                      selectedBooking.specialRequests && <p style={{ fontSize: "13px", color: "var(--text-secondary)", fontStyle: "italic" }}>"{selectedBooking.specialRequests}"</p>
                    )}
                  </div>

                </div>

                <AnimatePresence mode="wait">
                  {isEditing ? (
                    <motion.div 
                      key="edit-actions"
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: 10 }}
                      style={{ padding: "24px 32px", borderTop: "1px solid var(--border)", display: "flex", gap: "16px" }}
                    >
                      <button 
                        onClick={() => setIsEditing(false)}
                        style={{ flex: 1, padding: "12px", borderRadius: "12px", border: "1.5px solid var(--border)", color: "var(--text-secondary)", fontWeight: "700", fontSize: "14px", background: "white" }}
                      >
                        Cancel
                      </button>
                      <button 
                        onClick={handleUpdate}
                        disabled={isSaving}
                        style={{ flex: 1, padding: "12px", borderRadius: "12px", border: "none", background: "var(--accent)", color: "white", fontWeight: "700", fontSize: "14px", boxShadow: "0 4px 12px var(--accent-light)", display: "flex", alignItems: "center", justifyContent: "center", gap: "8px" }}
                      >
                        {isSaving ? <Loader2 size={16} className="animate-spin" /> : "Save Changes"}
                      </button>
                    </motion.div>
                  ) : (
                    <motion.div 
                      key="view-actions"
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: 10 }}
                      style={{ padding: "24px 32px", borderTop: "1px solid var(--border)", display: "flex", gap: "16px" }}
                    >
                      <button 
                        onClick={() => handleCancel(selectedBooking._id)}
                        style={{ flex: 1, padding: "12px", borderRadius: "12px", border: "1.5px solid #ef4444", color: "#ef4444", fontWeight: "700", fontSize: "14px", background: "white" }}
                      >
                        Cancel Booking
                      </button>
                      <button 
                        onClick={() => setSelectedBooking(null)}
                        style={{ flex: 1, padding: "12px", borderRadius: "12px", border: "none", background: "var(--accent)", color: "white", fontWeight: "700", fontSize: "14px", boxShadow: "0 4px 12px var(--accent-light)" }}
                      >
                        Close Details
                      </button>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}
