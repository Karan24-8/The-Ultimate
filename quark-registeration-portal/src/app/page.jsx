"use client";
import { useState, useEffect } from "react";
import RegistrationForm from "./components/RegistrationForm";
import PaymentModal from "./components/PaymentModal";
import QueriesModal from "./components/QueriesModal";
export default function Home() {
  const [showSignInForm, setShowSignInForm] = useState(false);
  const [payHere, setPayHere] = useState(false);
  const [bgImage, setBgImage] = useState("/bgmobile.png");
  const [isQueriesOpen, setIsQueriesOpen] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const handleClick = (link) => {
    if (link) {
      window.open(link, "_blank");
    } else if (onClick) {
      onClick();
    }
  };

  useEffect(() => {
    const updateBg = () => {
      if (window.innerWidth >= 768) {
        setBgImage("/bg.png");
      } else {
        setBgImage("/bgmobile.png");
      }
    };

    updateBg();
    window.addEventListener("resize", updateBg);

    return () => window.removeEventListener("resize", updateBg);
  }, []);

  const handleImageClick = () => {
    setShowSignInForm(true);
  };

  const handleCloseForm = () => {
    setShowSignInForm(false);
  };

  const [modal, setModal] = useState(false);
  const toggleModal = () => {
    setModal(!modal);
  };

  const handlePayClick = () => {
    setPayHere(!payHere);
  };
  return (
    <div
      className="relative min-h-screen min-w-screen overflow-hidden"
      style={{
        backgroundImage: `url(${bgImage})`,
        backgroundRepeat: "no-repeat",
        backgroundSize: "100% 100%",
        backgroundPosition: "center",
      }}
    >
  {mounted && (
        <video
          autoPlay
          loop
          muted
          playsInline
          className="absolute inset-0 w-full h-full object-cover z-10 mix-blend-screen opacity-70 pointer-events-none"
        >
          <source src="/rain-green.mp4" type="video/mp4" />
        </video>
      )}
      <div
        className="hidden md:block absolute pointer-events-none anim-cycle"
        style={{
          top: "10%",
          left: "0.5%",
          width: "55%",
          height: "55%",
        }}
      ></div>

      <div className="absolute inset-0 md:hidden bg-gradient-to-b from-black/50 via-black/40 to-black/60 pointer-events-none"></div>

      <div className="md:hidden relative w-full h-full flex flex-col px-4 py-3">
        <div className="flex justify-end items-center space-x-4 mb-4">
          <p className="text-white text-right text-lg font-semibold tracking-wide leading-tight">
            20 - 22 <br /> February <br /> 2026
          </p>

          <div className="w-[10px] bg-white self-stretch rounded-sm"></div>
        </div>

        <div className="flex justify-center">
          <img src="/logo1.png" className="w-80 drop-shadow-black/50" />
        </div>

        <div className="flex flex-col items-center  space-y-2 w-full">
          <div className="flex flex-col items-center  w-full">
            <div className="grid grid-cols-2 gap-5">
              <img
                src="/queries.png"
                className="w-40 cursor-pointer hover:scale-105 transition justify-self-end"
                onClick={() => setIsQueriesOpen(true)}
              />
              <img
                src="/rulebook.png"
                className="w-40 cursor-pointer hover:scale-105 transition justify-self-end"
                onClick={() =>
                  handleClick(
                    "https://firebasestorage.googleapis.com/v0/b/quark26-a9aae.firebasestorage.app/o/RuleBook%2Fnew.pdf?alt=media&token=dcde1cc1-629b-497a-8917-4d7da6c28746"
                  )
                }
              />
            </div>
            <img
              src="/paynow.png"
              className="w-60 cursor-pointer hover:scale-110 transition"
              onClick={handlePayClick}
            />

            <img
              src="/register.png"
              className="w-60 cursor-pointer hover:scale-110 transition"
              onClick={handleImageClick}
            />
          </div>
          {showSignInForm && <RegistrationForm onClose={handleCloseForm} />}
          {payHere && <PaymentModal handlePayClick={handlePayClick} />}
          <QueriesModal isOpen={isQueriesOpen} setIsOpen={setIsQueriesOpen} />
        </div>
      </div>


      <div className="hidden md:block relative w-screen h-screen top-0 left-0 px-6">
        <div
          className="absolute flex items-center justify-center md:justify-start"
          style={{
            top: "0%",
            left: "0.5%",
            width: "55%",
            height: "55%",
          }}
        >
          <img
            src="/logo1.png"
            alt="Quark Billboard"
            className="w-full transform translate-y-[8%] rotate-[10deg] drop-shadow-[0_0_25px_#a855f7]"
          />
        </div>

        <div className="flex flex-col items-end space-y-8 w-full">
          <div className="flex justify-end items-center space-x-4 mb-4">
            <p className="text-white text-right text-lg font-semibold tracking-wide leading-tight">
              20 - 22 <br /> February <br /> 2026
            </p>

            <div className="w-[10px] bg-white self-stretch rounded-sm"></div>
          </div>
          <div className="flex flex-col items-center space-y-6 top-[50%] transform translate-y-1/2">
            <div className="grid grid-cols-2 gap-5">
              <img
                src="/queries.png"
                className="w-40 md:w-82 cursor-pointer hover:scale-105 transition justify-self-end"
                onClick={() => setIsQueriesOpen(true)}
              />
              <img
                src="/rulebook.png"
                className="w-40 md:w-80 cursor-pointer hover:scale-105 transition justify-self-end"
                onClick={() =>
                  handleClick(
                    "https://firebasestorage.googleapis.com/v0/b/quark26-a9aae.firebasestorage.app/o/RuleBook%2FQuark'26%20Official%20Rulebook.pdf?alt=media&token=47e324be-11a9-4e06-beb1-8a921efa2bae"
                  )
                }
              />
            </div>
            <img
              src="/paynow.png"
              className="w-40 md:w-80 cursor-pointer hover:scale-110 transition"
              onClick={handlePayClick}
            />

            <img
              src="/register.png"
              alt="Register Now"
              className="w-56 md:w-80 cursor-pointer hover:scale-110 transition"
              onClick={handleImageClick}
            />
          </div>
          {showSignInForm && <RegistrationForm onClose={handleCloseForm} />}
          {payHere && <PaymentModal handlePayClick={handlePayClick} />}
          <QueriesModal isOpen={isQueriesOpen} setIsOpen={setIsQueriesOpen} />
        </div>
      </div>
    </div>
  );
}
