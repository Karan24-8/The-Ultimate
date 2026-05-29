import React from 'react';
import { Link, Outlet, useNavigate } from 'react-router-dom';

export default function MainLayout() {
  const navigate = useNavigate();

  const logout = () => {
    localStorage.removeItem("user");
    navigate('/login');
  };

  return (
    <div className="flex min-h-screen">

      {/* SIDEBAR */}
      <aside className="w-72 bg-black text-white p-8">
        <h1 className="text-3xl font-bold mb-10">VITA</h1>

        <nav className="space-y-6">
          <Link to="/planner">📅 Planner</Link>
          <Link to="/consultants">👨‍⚕️ Consultants</Link>
        </nav>

        <button onClick={logout} className="mt-10 text-red-400">
          Logout
        </button>
      </aside>

      {/* CONTENT */}
      <main className="flex-1 p-10 bg-gray-100">
        <Outlet />
      </main>

    </div>
  );
}