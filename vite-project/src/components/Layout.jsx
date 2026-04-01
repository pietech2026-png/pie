import React, { useState } from "react";
import { Outlet, NavLink, useNavigate, useLocation } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import {
  LayoutDashboard,
  CalendarCheck,
  Users as UsersIcon,
  Building2,
  ShieldCheck,
  LogOut,
  Hotel,
  ChevronDown,
  ChevronRight
} from "lucide-react";

export default function Layout() {
  const navigate = useNavigate();
  const location = useLocation();

  const [openMenu, setOpenMenu] = useState(
    location.pathname.startsWith("/bookings")
      ? "bookings"
      : location.pathname.startsWith("/hotels")
        ? "hotels"
        : null
  );

  const menuItems = [
    { name: "Dashboard", path: "/", icon: <LayoutDashboard size={20} /> },
    {
      name: "Bookings",
      key: "bookings",
      icon: <CalendarCheck size={20} />,
      subItems: [
        { name: "Booking Leads", path: "/bookings/leads" },
        { name: "Booking Search", path: "/bookings/search" },
        { name: "Create Booking", path: "/bookings/create" },
        { name: "Upcoming Bookings", path: "/bookings/upcoming" },
      ],
    },
    { name: "Guests", path: "/guests", icon: <UsersIcon size={20} /> },
    { name: "Users", path: "/users", icon: <UsersIcon size={20} /> },
    {
      name: "Hotels",
      key: "hotels",
      icon: <Building2 size={20} />,
      subItems: [
        { name: "All Hotels", path: "/hotels" },
        { name: "Add Hotel", path: "/hotels/add" },
        { name: "Upload From Docs", path: "/hotels/upload" }, // ✅ ONLY ADDED LINE
      ],
    },
    { name: "Roles", path: "/roles", icon: <ShieldCheck size={20} /> },
  ];

  const handleLogout = () => {
    navigate("/login");
  };

  return (
    <div style={{ display: "flex", minHeight: "100vh" }}>
      <aside
        style={{
          width: "280px",
          backgroundColor: "var(--bg-sidebar)",
          borderRight: "1px solid rgba(255, 255, 255, 0.1)",
          display: "flex",
          flexDirection: "column",
          position: "fixed",
          height: "100vh",
          padding: "32px 20px",
          zIndex: 50,
          boxShadow: "10px 0 30px rgba(0, 0, 0, 0.05)",
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: "14px",
            marginBottom: "48px",
            paddingLeft: "8px",
          }}
        >
          <div
            style={{
              background: "rgba(255, 255, 255, 0.2)",
              padding: "10px",
              borderRadius: "14px",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              backdropFilter: "blur(10px)",
              border: "1px solid rgba(255, 255, 255, 0.3)",
            }}
          >
            <Hotel size={24} color="#ffffff" />
          </div>
          <h2 style={{ fontSize: "24px", fontWeight: "800", color: "#ffffff", letterSpacing: "-0.5px" }}>
            Pie Admin
          </h2>
        </div>

        <nav style={{ flex: 1, display: "flex", flexDirection: "column", gap: "6px" }}>
          {menuItems.map((item) => (
            <div key={item.name}>
              {item.subItems ? (
                <>
                  <div
                    onClick={() => setOpenMenu(openMenu === item.key ? null : item.key)}
                    style={{
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "space-between",
                      gap: "12px",
                      padding: "12px 16px",
                      borderRadius: "14px",
                      fontSize: "15px",
                      fontWeight: "600",
                      cursor: "pointer",
                      transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
                      color: location.pathname.startsWith(`/${item.key}`)
                        ? "#ffffff"
                        : "rgba(255, 255, 255, 0.75)",
                      backgroundColor: location.pathname.startsWith(`/${item.key}`)
                        ? "rgba(255, 255, 255, 0.15)"
                        : "transparent",
                    }}
                    onMouseOver={(e) => {
                      if (!location.pathname.startsWith(`/${item.key}`)) {
                        e.currentTarget.style.backgroundColor = "rgba(255, 255, 255, 0.08)";
                        e.currentTarget.style.color = "#ffffff";
                      }
                    }}
                    onMouseOut={(e) => {
                      if (!location.pathname.startsWith(`/${item.key}`)) {
                        e.currentTarget.style.backgroundColor = "transparent";
                        e.currentTarget.style.color = "rgba(255, 255, 255, 0.75)";
                      }
                    }}
                  >
                    <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
                      <span style={{ display: "flex", opacity: location.pathname.startsWith(`/${item.key}`) ? 1 : 0.8 }}>
                        {item.icon}
                      </span>
                      {item.name}
                    </div>
                    {openMenu === item.key ? (
                      <ChevronDown size={14} style={{ opacity: 0.8 }} />
                    ) : (
                      <ChevronRight size={14} style={{ opacity: 0.8 }} />
                    )}
                  </div>

                  <AnimatePresence>
                    {openMenu === item.key && (
                      <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: "auto", opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        style={{
                          overflow: "hidden",
                          paddingLeft: "32px",
                          display: "flex",
                          flexDirection: "column",
                          gap: "4px",
                          marginTop: "6px",
                          marginBottom: "8px",
                        }}
                      >
                        {item.subItems.map((sub) => (
                          <NavLink
                            key={sub.path}
                            to={sub.path}
                            end={sub.path === "/hotels"}
                            style={({ isActive }) => ({
                              padding: "10px 16px",
                              borderRadius: "12px",
                              textDecoration: "none",
                              fontSize: "14px",
                              fontWeight: "500",
                              transition: "all 0.2s",
                              color: isActive ? "#ffffff" : "rgba(255, 255, 255, 0.65)",
                              backgroundColor: isActive ? "rgba(255, 255, 255, 0.1)" : "transparent",
                            })}
                          >
                            {sub.name}
                          </NavLink>
                        ))}
                      </motion.div>
                    )}
                  </AnimatePresence>
                </>
              ) : (
                <NavLink
                  to={item.path}
                  style={({ isActive }) => ({
                    display: "flex",
                    alignItems: "center",
                    gap: "12px",
                    padding: "12px 16px",
                    borderRadius: "14px",
                    textDecoration: "none",
                    fontSize: "15px",
                    fontWeight: "600",
                    transition: "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
                    color: isActive ? "#ffffff" : "rgba(255, 255, 255, 0.75)",
                    backgroundColor: isActive ? "rgba(255, 255, 255, 0.2)" : "transparent",
                  })}
                  onMouseOver={(e) => {
                    const isActive = e.currentTarget.classList.contains("active");
                    if (!isActive) {
                      e.currentTarget.style.backgroundColor = "rgba(255, 255, 255, 0.1)";
                      e.currentTarget.style.color = "#ffffff";
                    }
                  }}
                  onMouseOut={(e) => {
                    const isActive = e.currentTarget.classList.contains("active");
                    if (!isActive) {
                      e.currentTarget.style.backgroundColor = "transparent";
                      e.currentTarget.style.color = "rgba(255, 255, 255, 0.75)";
                    }
                  }}
                >
                  <span style={{ display: "flex", opacity: 0.8 }}>{item.icon}</span>
                  {item.name}
                </NavLink>
              )}
            </div>
          ))}
        </nav>

        <div
          style={{
            marginTop: "auto",
            padding: "20px",
            borderRadius: "20px",
            background: "rgba(255, 255, 255, 0.08)",
            border: "1px solid rgba(255, 255, 255, 0.1)",
            backdropFilter: "blur(10px)",
          }}
        >
          <div style={{ marginBottom: "16px" }}>
            <p style={{ fontSize: "11px", textTransform: "uppercase", letterSpacing: "1px", fontWeight: "700", color: "rgba(255, 255, 255, 0.5)", marginBottom: "6px" }}>
              Logged in as
            </p>
            <p style={{ fontSize: "14px", fontWeight: "600", color: "#ffffff", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
              rhythm.shesha@gmail.com
            </p>
          </div>
          <button
            onClick={handleLogout}
            style={{
              width: "100%",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: "8px",
              padding: "12px",
              background: "#ffffff",
              border: "none",
              borderRadius: "12px",
              color: "#ef4444",
              fontSize: "14px",
              fontWeight: "700",
              boxShadow: "0 4px 12px rgba(0, 0, 0, 0.1)",
              transition: "transform 0.2s, box-shadow 0.2s",
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.transform = "translateY(-1px)";
              e.currentTarget.style.boxShadow = "0 6px 16px rgba(0, 0, 0, 0.15)";
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.transform = "none";
              e.currentTarget.style.boxShadow = "0 4px 12px rgba(0, 0, 0, 0.1)";
            }}
          >
            <LogOut size={16} />
            Logout
          </button>
        </div>
      </aside>

      <main style={{ flex: 1, marginLeft: "280px", padding: "48px 64px", backgroundColor: "#ffffff" }}>
        <Outlet />
      </main>
    </div>
  );
}