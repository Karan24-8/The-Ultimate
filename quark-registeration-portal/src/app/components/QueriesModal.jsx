import React from "react";

const QueriesModal = ({ isOpen, setIsOpen }) => {

  const contacts = [
    {
      name: "Jehan Daftari",
      role: "Quark Events and Workshops Head",
      phone: "+91-8767844449"
    },
    {
      name: "Prakhar Singh Sengar",
      role: "Quark Convener",
      phone: "+91-6264296725"
    },
    {
      name: "Arnav Mathur",
      role: "Quark Controls Chief Coordinator",
      phone: "+91-8073921173"
    }
  ];

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-3 md:p-4 z-50">

      <div className="bg-gradient-to-br from-purple-700/20 via-purple-500/10 to-indigo-700/20 
        rounded-3xl p-[6px] w-full 
        max-w-sm sm:max-w-md md:max-w-lg lg:max-w-2xl
        shadow-[0_0_20px_rgba(168,85,247,0.35)] 
        border border-purple-500/30 md:border-purple-500/40">

        <div className="bg-[#0a0a12]/95 rounded-3xl p-5 sm:p-6 md:p-8 relative 
          border border-purple-400/30 md:border-purple-400/40 
          shadow-[0_0_25px_rgba(139,92,246,0.25)]">

          <button
            onClick={() => setIsOpen(false)}
            className="absolute top-3 right-3 w-8 h-8 sm:w-9 sm:h-9 
            bg-black/70 hover:bg-purple-500/40 text-purple-300 
            hover:text-yellow-300 rounded-full flex items-center justify-center 
            text-lg font-bold transition-all shadow-[0_0_10px_rgba(168,85,247,0.5)]"
          >
            ×
          </button>

          <div className="text-center mb-6 md:mb-10">
            <div className="bg-yellow-400 text-black rounded-full 
            px-6 py-2 sm:px-8 sm:py-3 inline-block 
            shadow-[0_0_15px_rgba(255,255,0,0.7)] border border-black/40 tracking-wide">
              <h2 className="font-bold text-lg sm:text-xl">QUERIES</h2>
            </div>
          </div>

          <div className="bg-[#0f0a18]/80 rounded-2xl p-4 sm:p-5 md:p-6 
            space-y-5 md:space-y-6 border border-purple-500/30 
            shadow-[0_0_18px_rgba(168,85,247,0.20)]">

            <div className="text-center">
              <p className="text-purple-200 text-base sm:text-lg mb-4 md:mb-6 tracking-wide">
                For queries, please contact:
              </p>
            </div>

            {contacts.map((c, index) => (
              <div
                key={index}
                className="bg-[#080612]/80 rounded-xl p-4 sm:p-5 
                border border-purple-500/30 hover:border-yellow-400 
                transition-all shadow-[0_0_14px_rgba(139,92,246,0.25)]"
              >
                <p className="text-yellow-300 font-bold text-base sm:text-lg tracking-wide">
                  {c.name}
                </p>
                <p className="text-purple-300 text-sm sm:text-base">{c.role}</p>

                <a
                  href={`tel:${c.phone}`}
                  className="text-purple-200 hover:text-yellow-300 
                  font-semibold text-base sm:text-lg block mt-2 transition-colors"
                >
                  {c.phone}
                </a>
              </div>
            ))}
          </div>

          <div className="mt-6 md:mt-10 text-center">
            <button
              onClick={() => setIsOpen(false)}
              className="bg-yellow-400 hover:bg-yellow-300 text-black font-bold 
              py-2.5 sm:py-3 px-8 sm:px-10 rounded-full text-base sm:text-lg 
              shadow-[0_0_20px_rgba(255,255,0,0.8)] transform hover:scale-105 
              transition-all border border-black/40 tracking-wide"
            >
              CLOSE
            </button>
          </div>

        </div>
      </div>
    </div>
  );
};

export default QueriesModal;
