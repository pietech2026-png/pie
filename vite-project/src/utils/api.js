const API_URL = import.meta.env.VITE_API_URL || "http://localhost:5001/api";

const apiFetch = async (endpoint, options = {}) => {
  const response = await fetch(`${API_URL}${endpoint}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
  });

  if (!response.ok) {
    const errorText = await response.text();
    let errorMessage = "Something went wrong";
    try {
      const errorData = JSON.parse(errorText);
      errorMessage = errorData.error || errorData.message || errorMessage;
    } catch (e) {
      errorMessage = errorText || errorMessage;
    }
    throw new Error(errorMessage);
  }

  return response.json();
};

// --- Mappers ---

export const mapHotelToFrontend = (h) => ({
  id: h._id,
  name: h.name,
  location: h.location || "Unknown",
  city: h.city || "",

  roomsCount: h.roomsCount || (h.rooms ? h.rooms.length : 0),
  rooms: h.rooms || [],
  rating: h.ratingScore || 0,
  starRating: String(h.starRating || 5),
  totalReviews: String(h.totalReviews || 0),
  landmark: h.landmarks?.[0] || "",
  nearestLandmark: h.nearestTransport || "",
  status: h.status || "Active",
  isSoldOut: h.isSoldOut || false, // NEW
  badges: h.badges || [],
  image: h.images || [],
  category: h.category || "Luxury",
  price: h.price || 0,
  description: h.description || "",
  reviews: h.reviews || "",
  state: h.state || "",
  pinCode: h.pinCode || "",
});

export const mapHotelToBackend = (f) => {
  const data = {};
  if (f.name !== undefined) data.name = f.name;
  if (f.location !== undefined) data.location = f.location;
  if (f.starRating !== undefined) data.starRating = Number(f.starRating);
  if (f.rating !== undefined) data.ratingScore = Number(f.rating);
  if (f.totalReviews !== undefined) data.totalReviews = Number(f.totalReviews);
  if (f.landmark !== undefined) data.landmarks = [f.landmark];
  if (f.nearestLandmark !== undefined) data.nearestTransport = f.nearestLandmark;
  if (f.badges !== undefined) data.badges = f.badges;
  if (f.image !== undefined) data.images = Array.isArray(f.image) ? f.image : [f.image];
  if (f.status !== undefined) data.status = f.status;
  if (f.price !== undefined) data.price = Number(f.price);
  if (f.description !== undefined) data.description = f.description;
  if (f.reviews !== undefined) data.reviews = f.reviews;
  if (f.category !== undefined) data.category = f.category;
  if (f.rooms !== undefined) data.roomsCount = Number(f.rooms);
  if (f.state !== undefined) data.state = f.state;
  if (f.pinCode !== undefined) data.pinCode = f.pinCode;
  if (f.city !== undefined) data.city = f.city;
  return data;
};


export const mapRoomToFrontend = (r) => ({
  id: r._id,
  hotelId: r.hotel,
  name: r.type,
  category: r.category || "Deluxe",
  size: r.size || "",
  bedsCount: r.bedsCount || 1,
  bedType: r.bedType || "",
  bathroomsCount: r.bathroomsCount || 1,
  basePrice: r.basePrice || 0,
  discountPrice: r.discountPrice || 0,
  taxes: r.taxes || 0,
  maxGuests: r.maxGuests || 2,
  amenities: r.amenities || [],
  cancellationPolicy: r.cancellationPolicy || "",
  mealPlan: r.mealPlan || "",
  details: r.details || "",
  about: r.about || "",
  planDetails: r.planDetails || "",
  checkInTime: r.checkInTime || "14:00",
  checkOutTime: r.checkOutTime || "11:00",
  images: r.images || [],
  availableCount: r.availableCount || 1,
  status: r.status || "Available",
  isSoldOut: r.isSoldOut || false, // NEW
});

export const mapRoomToBackend = (f) => {
  const data = {};
  if (f.name !== undefined) data.type = f.name;
  if (f.category !== undefined) data.category = f.category;
  if (f.size !== undefined) data.size = f.size;
  if (f.bedsCount !== undefined) data.bedsCount = Number(f.bedsCount);
  if (f.bedType !== undefined) data.bedType = f.bedType;
  if (f.bathroomsCount !== undefined) data.bathroomsCount = Number(f.bathroomsCount);
  if (f.basePrice !== undefined) data.basePrice = Number(f.basePrice);
  if (f.discountPrice !== undefined) data.discountPrice = Number(f.discountPrice);
  if (f.taxes !== undefined) data.taxes = Number(f.taxes);
  if (f.maxGuests !== undefined) data.maxGuests = Number(f.maxGuests);
  if (f.amenities !== undefined) data.amenities = f.amenities;
  if (f.cancellationPolicy !== undefined) data.cancellationPolicy = f.cancellationPolicy;
  if (f.mealPlan !== undefined) data.mealPlan = f.mealPlan;
  if (f.details !== undefined) data.details = f.details;
  if (f.about !== undefined) data.about = f.about;
  if (f.planDetails !== undefined) data.planDetails = f.planDetails;
  if (f.checkInTime !== undefined) data.checkInTime = f.checkInTime;
  if (f.checkOutTime !== undefined) data.checkOutTime = f.checkOutTime;
  if (f.images !== undefined) data.images = Array.isArray(f.images) ? f.images : [f.images];
  if (f.availableCount !== undefined) data.availableCount = Number(f.availableCount);
  if (f.status !== undefined) data.status = f.status;
  return data;
};

// --- API Methods ---

export const api = {
  // Hotels
  getHotels: async () => {
    const data = await apiFetch("/hotels");
    return Array.isArray(data) ? data.map(mapHotelToFrontend) : [];
  },
  getHotelById: async (id) => {
    const data = await apiFetch(`/hotels/${id}`);
    return mapHotelToFrontend(data);
  },
  searchHotels: async (query) => {
    const data = await apiFetch(`/hotels/search?q=${query}`);
    return Array.isArray(data) ? data.map(mapHotelToFrontend) : [];
  },
  createHotel: async (hotelData) => {
    const backendData = mapHotelToBackend(hotelData);
    const data = await apiFetch("/hotels", {
      method: "POST",
      body: JSON.stringify(backendData),
    });
    return mapHotelToFrontend(data);
  },
  updateHotel: async (id, hotelData) => {
    const backendData = mapHotelToBackend(hotelData);
    const data = await apiFetch(`/hotels/${id}`, {
      method: "PUT",
      body: JSON.stringify(backendData),
    });
    return mapHotelToFrontend(data);
  },
  deleteHotel: async (id) => {
    return apiFetch(`/hotels/${id}`, { method: "DELETE" });
  },

  // Rooms
  createRoom: async (hotelId, roomData) => {
    const backendData = mapRoomToBackend(roomData);
    const data = await apiFetch(`/rooms/${hotelId}`, {
      method: "POST",
      body: JSON.stringify(backendData),
    });
    return mapRoomToFrontend(data);
  },
  getRoomsByHotel: async (hotelId) => {
    const data = await apiFetch(`/rooms/hotel/${hotelId}`);
    return Array.isArray(data) ? data.map(mapRoomToFrontend) : [];
  },
  updateRoom: async (id, roomData) => {
    const backendData = mapRoomToBackend(roomData);
    const data = await apiFetch(`/rooms/${id}`, {
      method: "PUT",
      body: JSON.stringify(backendData),
    });
    return mapRoomToFrontend(data);
  },
  deleteRoom: async (id) => {
    return apiFetch(`/rooms/${id}`, { method: "DELETE" });
  },

  // Bookings
  getBookings: async () => {
    return apiFetch("/bookings");
  },
  getBookingById: async (id) => {
    return apiFetch(`/bookings/${id}`);
  },
  createBooking: async (bookingData) => {
    return apiFetch("/bookings", {
      method: "POST",
      body: JSON.stringify(bookingData),
    });
  },
  updateBookingStatus: async (id, status) => {
    return apiFetch(`/bookings/${id}`, {
      method: "PUT",
      body: JSON.stringify({ status }),
    });
  },
  updateBooking: async (id, data) => {
    return apiFetch(`/bookings/${id}`, {
      method: "PUT",
      body: JSON.stringify(data),
    });
  },
  cancelBooking: async (id) => {
    return apiFetch(`/bookings/${id}/cancel`, { method: "PATCH" });
  },

  // Leads
  getLeads: async () => {
    return apiFetch("/leads");
  },
  getLeadById: async (id) => {
    return apiFetch(`/leads/${id}`);
  },
  createLead: async (leadData) => {
    return apiFetch("/leads", {
      method: "POST",
      body: JSON.stringify(leadData),
    });
  },
  updateLeadStatus: async (id, status) => {
    return apiFetch(`/leads/${id}/status`, {
      method: "PUT",
      body: JSON.stringify({ status }),
    });
  },

  // Auth
  login: async (credentials) => {
    return apiFetch("/auth/login", {
      method: "POST",
      body: JSON.stringify(credentials),
    });
  },
  getUsers: async () => {
    return apiFetch("/auth/users");
  },
  registerUser: async (userData) => {
    return apiFetch("/auth/register", {
      method: "POST",
      body: JSON.stringify(userData),
    });
  },
  findOrCreateUser: async (userData) => {
    return apiFetch("/auth/find-or-create", {
      method: "POST",
      body: JSON.stringify(userData),
    });
  },

  // Reviews
  createReview: async (reviewData) => {
    return apiFetch("/reviews", {
      method: "POST",
      body: JSON.stringify(reviewData),
    });
  },
  getReviewsByHotel: async (hotelId) => {
    return apiFetch(`/reviews/hotel/${hotelId}`);
  },

  // Offers
  getOffers: async () => {
    return apiFetch("/offers");
  },
  createOffer: async (offerData) => {
    return apiFetch("/offers", {
      method: "POST",
      body: JSON.stringify(offerData),
    });
  },
  validateOffer: async (code) => {
    return apiFetch(`/offers/validate/${code}`);
  },

  // Admin Stats
  getAdminStats: async () => {
    return apiFetch("/admin/stats");
  },
  getAdminRevenue: async () => {
    return apiFetch("/admin/revenue");
  },

  // Health
  checkHealth: async () => {
    return apiFetch("/health");
  }
};
