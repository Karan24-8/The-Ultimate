import React from 'react';
import { useNavigate, Link } from 'react-router-dom';

export default function Login() {
  const navigate = useNavigate();

  const handleLogin = (e) => {
    e.preventDefault();
    localStorage.setItem("user", "true");
    navigate('/setup');
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-black text-white">
      <div className="bg-white/5 p-12 rounded-3xl w-full max-w-xl">

        <h2 className="text-4xl font-bold mb-8">Login</h2>

        <form onSubmit={handleLogin} className="space-y-6">
          <input type="email" placeholder="Email" required className="w-full p-5 bg-white/10 rounded-xl" />
          <input type="password" placeholder="Password" required className="w-full p-5 bg-white/10 rounded-xl" />

          <button className="w-full bg-indigo-600 py-5 rounded-xl text-xl">
            Login →
          </button>
        </form>

        <p className="mt-6">
          New user? <Link to="/register" className="text-indigo-400">Register</Link>
        </p>
      </div>
    </div>
  );
}