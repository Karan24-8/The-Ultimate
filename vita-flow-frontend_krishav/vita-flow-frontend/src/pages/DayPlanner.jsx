// import React, { useState } from 'react';

// const DayPlanner = () => {
//   const [water, setWater] = useState(1200); // ml
//   const waterGoal = 3000;
//   const caloriesConsumed = 1450;
//   const calorieGoal = 2200;

//   const [tasks, setTasks] = useState([
//     { id: 1, text: "High Protein Breakfast", time: "08:00 AM", done: true },
//     { id: 2, text: "Upper Body Workout", time: "10:30 AM", done: false },
//     { id: 3, text: "Meeting with Nutritionist", time: "02:00 PM", done: false },
//   ]);

//   const progressWidth = (caloriesConsumed / calorieGoal) * 100;
//   const waterHeight = (water / waterGoal) * 100;

//   return (
//     <div className="space-y-8 pb-12">
//       {/* Top Row: Hero Stats */}
//       <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
//         {/* Calorie Card */}
//         <div className="lg:col-span-2 bg-white rounded-[32px] p-8 shadow-sm border border-slate-100 flex flex-col justify-between min-h-[250px] group hover:shadow-xl transition-all duration-500">
//           <div className="flex justify-between items-start">
//             <div>
//               <p className="text-slate-400 font-bold uppercase tracking-widest text-xs">Energy Intake</p>
//               <h3 className="text-5xl font-black text-slate-900 mt-2">{caloriesConsumed} <span className="text-xl text-slate-300">/ {calorieGoal} kcal</span></h3>
//             </div>
//             <div className="bg-indigo-50 p-3 rounded-2xl text-indigo-600 font-black">
//               {Math.round(progressWidth)}%
//             </div>
//           </div>
          
//           <div className="mt-8">
//             <div className="flex justify-between mb-3 text-sm font-bold text-slate-500">
//               <span>Daily Progress</span>
//               <span>{calorieGoal - caloriesConsumed} kcal remaining</span>
//             </div>
//             <div className="w-full h-6 bg-slate-100 rounded-full overflow-hidden">
//               <div 
//                 className="h-full bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500 transition-all duration-1000 shadow-[0_0_15px_rgba(99,102,241,0.5)]"
//                 style={{ width: `${progressWidth}%` }}
//               ></div>
//             </div>
//           </div>
//         </div>

//         {/* Water Tracker Card */}
//         <div className="bg-indigo-600 rounded-[32px] p-8 text-white flex flex-col items-center justify-between relative overflow-hidden group">
//           <div className="absolute inset-0 opacity-10 pointer-events-none bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]"></div>
//           <p className="font-bold uppercase tracking-widest text-xs self-start opacity-70">Hydration</p>
          
//           <div className="relative w-24 h-40 bg-white/20 rounded-2xl border-2 border-white/30 overflow-hidden mt-4">
//             <div 
//               className="absolute bottom-0 left-0 w-full bg-cyan-400 transition-all duration-700 ease-out shadow-[0_-5px_20px_rgba(34,211,238,0.6)]"
//               style={{ height: `${waterHeight}%` }}
//             >
//               <div className="absolute top-0 left-0 w-full h-4 bg-white/20 animate-pulse"></div>
//             </div>
//           </div>

//           <div className="mt-4 text-center">
//             <h4 className="text-3xl font-black">{water} <span className="text-sm opacity-60">ml</span></h4>
//             <button 
//               onClick={() => setWater(prev => Math.min(prev + 250, waterGoal))}
//               className="mt-4 bg-white text-indigo-600 px-6 py-2 rounded-xl font-bold hover:scale-105 transition-transform active:scale-95"
//             >
//               + 250ml
//             </button>
//           </div>
//         </div>
//       </div>

//       {/* Bottom Row: Detailed Columns */}
//       <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mt-8">
        
//         {/* Schedule Column */}
//         <div className="bg-white rounded-[32px] p-8 shadow-sm border border-slate-100">
//           <div className="flex justify-between items-center mb-8">
//             <h3 className="text-2xl font-black text-slate-800">Timeline</h3>
//             <button className="text-indigo-600 font-bold hover:underline">+ Add Entry</button>
//           </div>
          
//           <div className="space-y-6">
//             {tasks.map(task => (
//               <div key={task.id} className="group flex items-center gap-6 p-4 rounded-2xl hover:bg-slate-50 transition-colors cursor-pointer">
//                 <div className="text-sm font-black text-slate-300 group-hover:text-indigo-400 transition-colors w-16">{task.time}</div>
//                 <div className={`w-1 h-10 rounded-full ${task.done ? 'bg-emerald-400' : 'bg-slate-200'}`}></div>
//                 <div className={`flex-1 font-bold ${task.done ? 'text-slate-400 line-through' : 'text-slate-700'}`}>
//                   {task.text}
//                 </div>
//                 <div className={`w-6 h-6 rounded-full border-2 flex items-center justify-center ${task.done ? 'bg-emerald-400 border-emerald-400' : 'border-slate-200'}`}>
//                   {task.done && <span className="text-white text-xs">✓</span>}
//                 </div>
//               </div>
//             ))}
//           </div>
//         </div>

//         {/* Macros Column */}
//         <div className="bg-slate-900 rounded-[32px] p-8 text-white">
//           <h3 className="text-2xl font-black mb-8 italic">Macro Breakdown</h3>
//           <div className="space-y-8">
//             <MacroBar label="Protein" value={120} goal={180} color="bg-orange-500" />
//             <MacroBar label="Carbohydrates" value={210} goal={250} color="bg-indigo-500" />
//             <MacroBar label="Fats" value={45} goal={70} color="bg-emerald-400" />
//           </div>
          
//           <div className="mt-12 p-6 bg-white/5 rounded-2xl border border-white/10">
//             <p className="text-sm text-slate-400 leading-relaxed font-medium">
//               💡 <span className="text-white font-bold">Health Tip:</span> You are 60g short of your protein goal. Consider a shake or lean chicken for dinner.
//             </p>
//           </div>
//         </div>

//       </div>
//     </div>
//   );
// };

// // Helper Component for the Macro Bars
// const MacroBar = ({ label, value, goal, color }) => (
//   <div>
//     <div className="flex justify-between mb-2 text-sm font-bold">
//       <span className="text-slate-400">{label}</span>
//       <span>{value}g <span className="text-slate-600">/ {goal}g</span></span>
//     </div>
//     <div className="w-full h-3 bg-white/10 rounded-full overflow-hidden">
//       <div 
//         className={`h-full ${color} transition-all duration-1000`} 
//         style={{ width: `${(value/goal)*100}%` }}
//       ></div>
//     </div>
//   </div>
// );

// export default DayPlanner;


import React from 'react';

export default function DayPlanner() {
  return (
    <div>
      <h1 className="text-4xl font-bold mb-6">Your Daily Planner</h1>

      <div className="bg-white p-8 rounded-2xl shadow">
        <p className="text-lg text-gray-600">
          (Backend AI planner will show here)
        </p>
      </div>
    </div>
  );
}