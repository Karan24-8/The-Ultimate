export default function Button({ text, onClick }) {
  return (
    <button
      className="relative flex items-center justify-center bg-no-repeat bg-cover bg-center text-white font-semibold text-2xl cursor-pointer outline-none border-none play-button animate-fadeIn"
      style={{
        backgroundImage: `url('button.png')`,
        width: "280px",
        height: "48.5px",
      }}
      onClick={onClick} 
    >
      {text}
    </button>
  );
}