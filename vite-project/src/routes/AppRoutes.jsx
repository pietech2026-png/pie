import { BrowserRouter, Routes, Route } from "react-router-dom";
import Layout from "../components/Layout";
import Dashboard from "../pages/Dashboard";
import Login from "../pages/Login";
import Users from "../pages/Users";
import Hotels from "../pages/Hotels";
import Roles from "../pages/Roles";
import BookingLeads from "../pages/BookingLeads";
import BookingSearch from "../pages/BookingSearch";
import CreateBooking from "../pages/CreateBooking";
import UpcomingBookings from "../pages/UpcomingBookings";

export default function AppRoutes() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Layout />}>
                    <Route index element={<Dashboard />} />
                    <Route path="users" element={<Users />} />
                    <Route path="hotels" element={<Hotels />} />
                    <Route path="hotels/add" element={<Hotels />} />
                    <Route path="roles" element={<Roles />} />
                    <Route path="bookings">
                        <Route path="leads" element={<BookingLeads />} />
                        <Route path="search" element={<BookingSearch />} />
                        <Route path="create" element={<CreateBooking />} />
                        <Route path="upcoming" element={<UpcomingBookings />} />
                    </Route>
                </Route>
                <Route path="/login" element={<Login />} />
            </Routes>
        </BrowserRouter>
    );
}