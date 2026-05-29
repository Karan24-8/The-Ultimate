// import React, { useState, useEffect } from 'react';
// import { User, Ruler, Weight, Activity, Target, AlertTriangle } from 'lucide-react';

// const Profile = () => {
//   const [formData, setFormData] = useState({
//     name: '', phone: '', age: '', gender: 'Male',
//     height_cm: '', weight_kg: '', activity_level: 'Moderate',
//     allergies: '', meal_preferences: 'Veg', deadline: '', aim_kg: ''
//   });

//   const [bmi, setBmi] = useState(0);
//   const [bmiStatus, setBmiStatus] = useState('');

//   // Calculate BMI in real-time
//   useEffect(() => {
//     if (formData.height_cm && formData.weight_kg) {
//       const heightM = formData.height_cm / 100;
//       const val = (formData.weight_kg / (heightM * heightM)).toFixed(1);
//       setBmi(val);

//       if (val < 18.5) setBmiStatus('Underweight');
//       else if (val < 25) setBmiStatus('Healthy');
//       else if (val < 30) setBmiStatus('Overweight');
//       else setBmiStatus('Obese');
//     }
//   }, [formData.height_cm, formData.weight_kg]);

//   const handleChange = (e) => setFormData({ ...formData, [e.target.name]: e.target.value });

//   return (
//     <div style={containerStyle}>
//       <div style={cardStyle}>
//         <h2 style={{ marginBottom: '20px' }}>Complete Your Health Profile</h2>
        
//         <div style={bmiBoxStyle(bmiStatus)}>
//             <h3>Your BMI: {bmi}</h3>
//             <p>Status: <strong>{bmiStatus || 'Enter details...'}</strong></p>
//         </div>

//         <form style={gridForm}>
//           <div style={inputGroup}><User size={18}/><input name="name" placeholder="Full Name" onChange={handleChange} /></div>
//           <div style={inputGroup}><Ruler size={18}/><input name="height_cm" type="number" placeholder="Height (cm)" onChange={handleChange} /></div>
//           <div style={inputGroup}><Weight size={18}/><input name="weight_kg" type="number" placeholder="Weight (kg)" onChange={handleChange} /></div>
          
//           <select name="gender" onChange={handleChange} style={selectStyle}>
//             <option value="Male">Male</option>
//             <option value="Female">Female</option>
//             <option value="Other">Other</option>
//           </select>

//           <select name="activity_level" onChange={handleChange} style={selectStyle}>
//             <option value="Sedentary">Sedentary (Little exercise)</option>
//             <option value="Moderate">Moderate (Active)</option>
//             <option value="High">Athlete (Very Active)</option>
//           </select>

//           <div style={inputGroup}><Target size={18}/><input name="aim_kg" type="number" placeholder="Goal Weight (kg)" onChange={handleChange} /></div>
//           <div style={inputGroup}><AlertTriangle size={18}/><input name="allergies" placeholder="Allergies (if any)" onChange={handleChange} /></div>
          
//           <button type="submit" style={submitBtn}>Save Profile & Generate Plan</button>
//         </form>
//       </div>
//     </div>
//   );
// };

// // --- STYLES ---
// const containerStyle = { padding: '40px', backgroundColor: '#f1f5f9', minHeight: '100vh', display: 'flex', justifyContent: 'center' };
// const cardStyle = { background: 'white', padding: '30px', borderRadius: '20px', width: '100%', maxWidth: '600px', boxShadow: '0 10px 15px -3px rgba(0,0,0,0.1)' };
// const gridForm = { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px' };
// const inputGroup = { display: 'flex', alignItems: 'center', gap: '10px', border: '1px solid #e2e8f0', padding: '10px', borderRadius: '10px' };
// const selectStyle = { padding: '10px', borderRadius: '10px', border: '1px solid #e2e8f0', background: 'white' };
// const submitBtn = { gridColumn: 'span 2', padding: '15px', background: '#2563eb', color: 'white', border: 'none', borderRadius: '10px', cursor: 'pointer', fontWeight: 'bold', marginTop: '10px' };

// const bmiBoxStyle = (status) => {
//   const colors = { Healthy: '#dcfce7', Overweight: '#fef9c3', Obese: '#fee2e2', Underweight: '#ffedd5' };
//   return {
//     padding: '15px',
//     borderRadius: '15px',
//     backgroundColor: colors[status] || '#f8fafc',
//     textAlign: 'center',
//     marginBottom: '20px',
//     border: '1px solid #e2e8f0'
//   };
// };

// export default Profile;






import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { User, Ruler, Weight, Target } from 'lucide-react';

const Profile = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({ height_cm: '', weight_kg: '' });
  const [bmi, setBmi] = useState(0);
  const [status, setStatus] = useState('');

  useEffect(() => {
    if (formData.height_cm && formData.weight_kg) {
      const h = formData.height_cm / 100;
      const val = (formData.weight_kg / (h * h)).toFixed(1);
      setBmi(val);
      if (val < 18.5) setStatus('Underweight');
      else if (val < 25) setStatus('Healthy');
      else setStatus('Overweight');
    }
  }, [formData.height_cm, formData.weight_kg]);

  const handleSave = (e) => {
    e.preventDefault();
    // After saving profile, go to the Day Planner
    navigate('/planner');
  };

  return (
    <div style={{ padding: '40px', display: 'flex', justifyContent: 'center' }}>
      <div style={formCard}>
        <h2 style={{ color: '#f8fafc', marginBottom: '20px' }}>Setup Your Profile</h2>
        <div style={bmiBadge(status)}><h3>BMI: {bmi}</h3><p>{status || 'Enter details'}</p></div>
        <form onSubmit={handleSave} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px' }}>
          <div style={inputBox}><User size={18}/><input style={input} placeholder="Name" /></div>
          <div style={inputBox}><Ruler size={18}/><input style={input} type="number" placeholder="Height (cm)" onChange={(e)=>setFormData({...formData, height_cm: e.target.value})} /></div>
          <div style={inputBox}><Weight size={18}/><input style={input} type="number" placeholder="Weight (kg)" onChange={(e)=>setFormData({...formData, weight_kg: e.target.value})} /></div>
          <div style={inputBox}><Target size={18}/><input style={input} type="number" placeholder="Goal Weight" /></div>
          <button type="submit" style={submitBtn}>Save & View My Plan</button>
        </form>
      </div>
    </div>
  );
};

const formCard = { background: '#1e293b', padding: '30px', borderRadius: '20px', width: '550px', border: '1px solid #334155' };
const inputBox = { display: 'flex', alignItems: 'center', gap: '10px', background: '#334155', padding: '12px', borderRadius: '10px' };
const input = { background: 'transparent', border: 'none', color: 'white', outline: 'none', width: '100%' };
const submitBtn = { gridColumn: 'span 2', background: '#38bdf8', color: '#0f172a', padding: '15px', border: 'none', borderRadius: '12px', fontWeight: 'bold', cursor: 'pointer', marginTop: '10px' };
const bmiBadge = (status) => ({ backgroundColor: status === 'Healthy' ? '#059669' : '#334155', padding: '15px', borderRadius: '12px', textAlign: 'center', marginBottom: '20px' });

export default Profile;