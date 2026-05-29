export default function Socials() {
  const handleNavigation = (url) => {
    window.open(url, "_blank", "noopener noreferrer");
  };

  return (
    <div className="flex flex-col justify-center items-start gap-y-6 lg:gap-y-7 px-5 w-1/5 text-white animate-slideInFromLeft">
      <img
        src="Instagram.png"
        alt="Instagram"
        onClick={() => handleNavigation("https://instagram.com/bitsquark")}
        className="w-7 cursor-pointer"
      />
      <img
        src="Twitter.png"
        alt="Twitter"
        onClick={() => handleNavigation("https://x.com/bitsquark")}
        className="w-7 cursor-pointer"
      />
      {/* <img
        src="Gmail.png"
        alt="Gmail"
        onClick={() =>
          handleNavigation(
            "https://mail.google.com/mail/?view=cm&fs=1&to=EMAILID@email.com" // please add
          )
        }
        className="w-7 cursor-pointer"
      />
      <img
        src="Whatsapp.png"
        alt="Whatsapp"
        onClick={
          () => handleNavigation("https://wa.me/phonenumber?text=Quark") // please add
        }
        className="w-7 cursor-pointer"
      /> */}
    </div>
  );
}
