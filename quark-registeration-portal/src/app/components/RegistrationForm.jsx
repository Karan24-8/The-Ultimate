import { useState, useEffect, useRef } from 'react'

const RegistrationForm = ({ onClose }) => {
  const [isTeam, setIsTeam] = useState(false)
  const [scale, setScale] = useState('scale-0')
  const formRef = useRef(null)

  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phoneNumber: '',
    gender: '',
    collegeName: '',
    state: '',
    city: '',
    event: '',
    Members: [{ name: '', email: '', phoneNumber: '' }]
  })

  useEffect(() => {
    setScale('scale-100')
  }, [])

  const handleClose = () => {
    setScale('scale-0')
    setTimeout(onClose, 300)
  }

  const handleInputChange = e => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: value
    }))
  }

  const handleMemberChange = (index, field, value) => {
    setFormData(prev => {
      const newMembers = [...prev.Members]
      newMembers[index] = {
        ...newMembers[index],
        [field]: value
      }
      return { ...prev, Members: newMembers }
    })
  }

  const addMember = () => {
    setFormData(prev => ({
      ...prev,
      Members: [...prev.Members, { name: '', email: '', phoneNumber: '' }]
    }))
  }

  const validateForm = () => {
    const requiredFields = [
      'fullName',
      'email',
      'phoneNumber',
      'gender',
      'collegeName',
      'state',
      'city',
      'event'
    ]

    for (let field of requiredFields) {
      if (!formData[field]) {
        alert(`Please fill out the ${field} field.`)
        return false
      }
    }

    if (isTeam) {
      for (let m of formData.Members) {
        if (!m.name || !m.email || !m.phoneNumber) {
          alert(`Please fill all team member details`)
          return false
        }
      }
    }

    return true
  }

  const handleSubmit = async e => {
    e.preventDefault()
    if (!validateForm()) return

    try {
      const tab = isTeam ? 'Team' : 'Individual'

      const memberString = isTeam
        ? formData.Members.map(
          (m, i) =>
            `Member ${i + 1}: ${m.name}, ${m.email}, ${m.phoneNumber}`
        ).join(' | ')
        : 'N/A'

      const finalData = {
        'Full Name': formData.fullName,
        'Email': formData.email,
        'Phone Number': formData.phoneNumber,
        'Gender': formData.gender,
        'College Name': formData.collegeName,
        'State': formData.state,
        'City': formData.city,
        'Event': formData.event,
        'Members': memberString
      }

      console.log('DATA SENT:', finalData)

      const response = await fetch(
        `https://sheetdb.io/api/v1/0606fauew60g9?sheet=${tab}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            data: finalData
          })
        }
      )


      if (response.ok) {
        alert('Registration Successful!')
        handleClose()
      } else {
        alert('Registration Failed!')
      }
    } catch (error) {
      console.error('Error:', error)
    }
  }

  const inputStyles =
    'w-full px-4 py-3 bg-[#05070d]/70 border border-cyan-400/40 text-cyan-200 placeholder-cyan-400/40 focus:border-yellow-400 focus:ring-1 focus:ring-yellow-400 outline-none transition duration-300 tracking-wide'

  return (
    <div
      className="fixed inset-0 flex items-center justify-center p-4 z-50"
      onMouseDown={handleClose}
    >
      <div
        ref={formRef}
        onMouseDown={e => e.stopPropagation()}
        className={`relative w-full max-w-7xl transform transition-all duration-300 ${scale}`}
        style={{
          backgroundSize: 'cover',
          backgroundRepeat: 'no-repeat',
          backgroundPosition: 'center',
          minHeight: '80vh'
        }}
      >
        <div className="absolute inset-0 bg-gradient-to-br from-cyan-500/20 via-blue-500/10 to-indigo-500/20 blur-xl"></div>

        <div
          className="relative bg-[#05070d]/80 backdrop-blur-lg border border-cyan-400/40 shadow-[0_0_25px_rgba(34,211,238,0.25)] rounded-lg overflow-hidden mx-8 my-8"
          style={{
            clipPath:
              'polygon(0 0, 100% 0, 100% 96%, 96% 100%, 0 100%, 0% 50%)'
          }}
        >
          <div className="h-1 w-full bg-gradient-to-r from-yellow-400 via-cyan-400 to-yellow-400 shadow-[0_0_12px_rgba(255,255,0,0.7)]"></div>

          <div className="p-6 flex justify-between items-center border-b border-cyan-400/40">
            <div className="flex space-x-4">
              <button
                onClick={() => setIsTeam(false)}
                className={`relative px-6 py-2 uppercase tracking-wide text-sm font-semibold
                ${!isTeam
                    ? 'bg-yellow-400 text-black shadow-[0_0_12px_rgba(255,255,0,0.7)]'
                    : 'bg-black/40 text-yellow-400 border border-yellow-400/40'
                  } transition duration-300`}
                style={{ clipPath: 'polygon(0 0, 100% 0, 90% 100%, 0% 100%)' }}
              >
                Individual
              </button>

              <button
                onClick={() => setIsTeam(true)}
                className={`relative px-6 py-2 uppercase tracking-wide text-sm font-semibold
                ${isTeam
                    ? 'bg-yellow-400 text-black shadow-[0_0_12px_rgba(255,255,0,0.7)]'
                    : 'bg-black/40 text-yellow-400 border border-yellow-400/40'
                  } transition duration-300`}
                style={{ clipPath: 'polygon(10% 0, 100% 0, 100% 100%, 0% 100%)' }}
              >
                Team
              </button>
            </div>

            <button
              className="text-cyan-300 hover:text-yellow-300 text-xl"
              onClick={handleClose}
            >
              ✕
            </button>
          </div>

          {/* FORM BODY */}
          <div className="max-h-[70vh] overflow-y-auto hide-scrollbar">
            <form onSubmit={handleSubmit} className="p-6">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                {/* LEFT */}
                <div className="space-y-4">
                  <h3 className="text-cyan-300 text-lg font-semibold tracking-wide mb-4">
                    Personal Details
                  </h3>

                  <input name="fullName" placeholder="Full Name" className={inputStyles} onChange={handleInputChange} required={!isTeam} />
                  <input name="email" placeholder="Email" className={inputStyles} onChange={handleInputChange} required={!isTeam} />
                  <input name="phoneNumber" placeholder="Phone Number" className={inputStyles} onChange={handleInputChange} required={!isTeam} />

                  <select name="gender" className={inputStyles} onChange={handleInputChange} required={!isTeam}>
                    <option value="">Gender</option>
                    <option className="bg-black" value="male">Male</option>
                    <option className="bg-black" value="female">Female</option>
                    <option className="bg-black" value="other">Other</option>
                  </select>

                  <input name="collegeName" placeholder="College Name" className={inputStyles} onChange={handleInputChange} required={!isTeam} />

                  <div className="grid grid-cols-2 gap-4">
                    <input name="state" placeholder="State" className={inputStyles} onChange={handleInputChange} required={!isTeam} />
                    <input name="city" placeholder="City" className={inputStyles} onChange={handleInputChange} required={!isTeam} />
                  </div>
                </div>

                {/* RIGHT */}
                <div className="space-y-6">
                  <div>
                    <h3 className="text-cyan-300 text-lg font-semibold tracking-wide mb-4">
                      Select Events
                    </h3>

                    <select name="event" className={inputStyles} onChange={handleInputChange} required>
                      <option value="">Select Event</option>

                      {/* SOLO EVENTS - Only show in Individual tab */}
                      {!isTeam && (
                        <>
                          {/* 🎮 MATKA (E-Sports) - Solo */}
                          <option className="bg-black">Matka - FIFA (Solo)</option>
                          {/* 🎒 SCHOOL BAG - Solo only */}
                          <option className="bg-black">School Bag (Solo only)</option>
                          {/* 💻 PROGRAMMERS INC - Solo */}
                          <option className="bg-black">Programmers Inc - CodeJam (Solo)</option>
                        </>
                      )}

                      {/* TEAM EVENTS - Only show in Team tab */}
                      {isTeam && (
                        <>
                          {/* 🧩 DESIGN & BUILD */}
                          <option className="bg-black">Design & Build - Burnout (Team)</option>
                          <option className="bg-black">Design & Build - Trailblazers (Team, min 3)</option>
                          <option className="bg-black">Design & Build - Search & Rescue (Team)</option>
                          <option className="bg-black">Design & Build - Operation Skylock / Rocketry (Team)</option>
                          {/* 🧠 ELIXIR (Quizzes) */}
                          <option className="bg-black">Elixir - Ganimatoonics (Team)</option>
                          <option className="bg-black">Elixir - Quark National Quiz / QNQ (Team)</option>
                          <option className="bg-black">Elixir - Torque & Trivia / TnT (Team)</option>
                          {/* 💼 CORPORATE */}
                          <option className="bg-black">Corporate - Regalia (Team)</option>
                          <option className="bg-black">Corporate - Case Crackdown (Team)</option>
                          <option className="bg-black">Corporate - Marketing Mayhem (Team)</option>
                          <option className="bg-black">Corporate - Fix the Product (Team)</option>
                          <option className="bg-black">Corporate - Deal Dynamics (Team, 1-3)</option>
                          {/* 🎮 MATKA (E-Sports) */}
                          <option className="bg-black">Matka - Valorant (Team)</option>
                          <option className="bg-black">Matka - BGMI (Team)</option>
                          {/* 💻 PROGRAMMERS INC */}
                          <option className="bg-black">Programmers Inc - BITS CTF (Team, 1-4)</option>
                          <option className="bg-black">Programmers Inc - Hackathon (Team)</option>
                          {/* ⚡ ELECTRIFY */}
                          <option className="bg-black">Electrify - Digilogica (Team, 1-3)</option>
                          <option className="bg-black">Electrify - Matmania (Team, 1-3)</option>
                          <option className="bg-black">Electrify - μC Mania (Team, 1-2)</option>
                          <option className="bg-black">Electrify - RTLRumble (Team, 1-2)</option>
                          {/* 🤖 ROBOFICIAL */}
                          <option className="bg-black">Roboficial - RoboClench (Team)</option>
                          <option className="bg-black">Roboficial - RoboSoccer (Team)</option>
                          <option className="bg-black">Roboficial - RoboRace (Team, max 4)</option>
                          <option className="bg-black">Roboficial - TIME Challenge (Team, max 4)</option>
                          <option className="bg-black">Roboficial - RoboSumo (Team)</option>
                          <option className="bg-black">Roboficial - RoboWars (Team, max 5)</option>
                        </>
                      )}

                      {/* BOTH SOLO & TEAM - Show in both tabs */}
                      {/* 🧪 SPECIALS */}
                      <option className="bg-black">Specials - Poster Presentation (Solo/Team)</option>
                    </select>
                  </div>

                  {isTeam && (
                    <div className="space-y-4 border-t border-cyan-400/40 pt-6">
                      <h3 className="text-cyan-300 text-lg font-semibold tracking-wide">
                        Team Members
                      </h3>

                      {formData.Members.map((_, index) => (
                        <div key={index} className="grid grid-cols-2 gap-4">
                          <input placeholder={`Member ${index + 1} Name`} className={inputStyles} onChange={e => handleMemberChange(index, 'name', e.target.value)} />
                          <input placeholder={`Member ${index + 1} Email`} className={inputStyles} onChange={e => handleMemberChange(index, 'email', e.target.value)} />
                          <input placeholder={`Member ${index + 1} Phone`} className={inputStyles} onChange={e => handleMemberChange(index, 'phoneNumber', e.target.value)} />
                        </div>
                      ))}

                      <button
                        type="button"
                        onClick={addMember}
                        className="w-full text-yellow-400 py-2 border border-yellow-400/50 rounded-lg hover:bg-yellow-400/20 transition shadow-[0_0_10px_rgba(255,255,0,0.4)]"
                      >
                        Add Member
                      </button>
                    </div>
                  )}
                </div>
              </div>

              {/* SUBMIT */}
              <div className="flex justify-center items-center w-full pt-6 mt-6 border-t border-cyan-400/40">
                <img
                  src="/register.png"
                  alt="Register"
                  className="lg:w-1/3 p-3 cursor-pointer hover:drop-shadow-[0_0_12px_rgba(255,255,0,0.8)] transform hover:scale-105 transition-all duration-300"
                  onClick={handleSubmit}
                />
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  )
}

export default RegistrationForm
