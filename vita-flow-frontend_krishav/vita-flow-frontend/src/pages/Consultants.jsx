import React from 'react';

const consultants = [
  { name: "Dr. Sarah", spec: "Nutrition", rating: 4.9 },
  { name: "Marcus", spec: "Fitness", rating: 4.8 },
  { name: "Elena", spec: "Metabolism", rating: 5.0 },
];

export default function Consultants() {
  return (
    <div>
      <h1 className="text-4xl font-bold mb-10">Consultants</h1>

      <div className="grid md:grid-cols-3 gap-8">
        {consultants.map((c, i) => (
          <div key={i} className="bg-white p-8 rounded-2xl shadow">

            <h2 className="text-2xl font-bold">{c.name}</h2>
            <p className="text-indigo-500">{c.spec}</p>
            <p>⭐ {c.rating}</p>

            <button className="mt-4 bg-black text-white px-6 py-3 rounded-lg">
              Book
            </button>

          </div>
        ))}
      </div>
    </div>
  );
}