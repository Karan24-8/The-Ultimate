import React from 'react';
import { useNavigate, Link } from 'react-router-dom';

export default function Register() {
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    localStorage.setItem("user", "true");
    navigate('/setup');
  };

  return (
    <div className="min-h-screen bg-black text-white flex items-center justify-center p-10">
      <div className="grid lg:grid-cols-2 gap-20 w-full max-w-7xl">

        {/* LEFT */}
        <div>
          <h1 className="text-8xl font-black bg-gradient-to-r from-indigo-500 to-purple-500 bg-clip-text text-transparent">
            VITA FLOW
          </h1>
          <p className="text-2xl text-gray-400 mt-6">
            AI Powered Health & Nutrition Planner
          </p>
        </div>

        {/* RIGHT */}
        <div className="bg-white/5 p-12 rounded-3xl border border-white/10">
          <h2 className="text-4xl font-bold mb-8">Sign Up</h2>

          <form onSubmit={handleSubmit} className="space-y-6">
            <input type="email" required placeholder="Email"
              className="w-full p-5 rounded-xl bg-white/10" />

            <input type="password" required placeholder="Password"
              className="w-full p-5 rounded-xl bg-white/10" />

            <button className="w-full bg-indigo-600 py-5 rounded-xl text-xl font-bold">
              Create Account →
            </button>
          </form>

          <p className="mt-6">
            Already a user? <Link to="/login" className="text-indigo-400">Login</Link>
          </p>
        </div>
      </div>
    </div>
  );
}