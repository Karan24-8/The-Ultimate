import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function SetupProfile() {
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    navigate('/planner');
  };

  return (
    <div className="min-h-screen bg-gray-100 p-10">
      <div className="bg-white p-16 rounded-3xl shadow-xl">

        <h2 className="text-5xl font-black mb-10">Setup Profile</h2>

        <form onSubmit={handleSubmit} className="grid lg:grid-cols-2 gap-10">

          {[
            "Name", "Age", "Weight", "Height", "Target Weight", "Activity",
            "Diet", "Water", "Sleep", "Allergies", "Supplements", "Timezone"
          ].map((item, i) => (
            <input key={i}
              placeholder={item}
              className="p-6 text-lg border rounded-2xl"
            />
          ))}

          <div className="col-span-2">
            <button className="w-full bg-black text-white py-6 text-2xl rounded-xl">
              Continue →
            </button>
          </div>

        </form>
      </div>
    </div>
  );
}